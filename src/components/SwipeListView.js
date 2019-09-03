'use strict';

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
    FlatList,
    SectionList,
    Dimensions,
    Platform,
    Text,
    ViewPropTypes,
    View,
    ActivityIndicator,
    RefreshControl,
    StyleSheet,
} from 'react-native';
import ListView from 'deprecated-react-native-listview';
import CommonStyles from '../common/Styles';
const { width, height } = Dimensions.get('window');
import SwipeRow from './SwipeRowS';
import ListEmptyCom from './ListEmptyCom';
/**
 * ListView that renders SwipeRows.
 */
class SwipeListView extends Component {
    constructor(props) {
        super(props);
        this._rows = {};
        this.openCellKey = null;
        this.listViewProps = {};
        if (Platform.OS === 'ios') {
            // Keep track of scroll offset and layout changes on iOS to be able to handle
            // https://github.com/jemise111/react-native-swipe-list-view/issues/109
            this.yScrollOffset = 0;
            this.layoutHeight = 0;
            this.listViewProps = {
                onLayout: e => this.onLayout(e),
                onContentSizeChange: (w, h) => this.onContentSizeChange(w, h),
            };
        }
    }

    setScrollEnabled(enable) {
        if (this.props.scrollEnabled === false) {
            return;
        }
        // Due to multiple issues reported across different versions of RN
        // We do this in the safest way possible...
        if (this._listView && this._listView.setNativeProps) {
            this._listView.setNativeProps({ scrollEnabled: enable });
        } else if (this._listView && this._listView.getScrollResponder) {
            const scrollResponder = this._listView.getScrollResponder();
            scrollResponder.setNativeProps &&
                scrollResponder.setNativeProps({ scrollEnabled: enable });
        }
        this.props.onScrollEnabled && this.props.onScrollEnabled(enable);
    }

    safeCloseOpenRow() {
        const rowRef = this._rows[this.openCellKey];
        if (rowRef && rowRef.closeRow) {
            this._rows[this.openCellKey].closeRow();
        }
    }

    rowSwipeGestureBegan(key) {
        if (
            this.props.closeOnRowBeginSwipe &&
            this.openCellKey &&
            this.openCellKey !== key
        ) {
            this.safeCloseOpenRow();
        }

        if (this.props.swipeGestureBegan) {
            this.props.swipeGestureBegan(key);
        }
    }

    onRowOpen(key, toValue) {
        if (this.openCellKey && this.openCellKey !== key) {
            this.safeCloseOpenRow();
        }
        this.openCellKey = key;
        this.props.onRowOpen && this.props.onRowOpen(key, this._rows, toValue);
    }

    onRowPress() {
        if (this.openCellKey) {
            if (this.props.closeOnRowPress) {
                this.safeCloseOpenRow();
                this.openCellKey = null;
            }
        }
    }

    onScroll(e) {
        if (Platform.OS === 'ios') {
            this.yScrollOffset = e.nativeEvent.contentOffset.y;
        }
        if (this.openCellKey) {
            if (this.props.closeOnScroll) {
                this.safeCloseOpenRow();
                this.openCellKey = null;
            }
        }
        this.props.onScroll && this.props.onScroll(e);
    }

    onLayout(e) {
        this.layoutHeight = e.nativeEvent.layout.height;
        this.props.onLayout && this.props.onLayout(e);
    }

    // When deleting rows on iOS, the list may end up being over-scrolled,
    // which will prevent swiping any of the remaining rows. This triggers a scrollToEnd
    // when that happens, which will make sure the list is kept in bounds.
    // See: https://github.com/jemise111/react-native-swipe-list-view/issues/109
    onContentSizeChange(w, h) {
        const height = h - this.layoutHeight;
        if (this.yScrollOffset >= height && height > 0) {
            this._listView && this._listView.getScrollResponder().scrollToEnd();
        }
        this.props.onContentSizeChange && this.props.onContentSizeChange(w, h);
    }

    setRefs(ref) {
        this._listView = ref;
        this.props.listViewRef && this.props.listViewRef(ref);
    }

    renderCell(VisibleComponent, HiddenComponent, key, item, shouldPreviewRow) {
        if (!HiddenComponent) {
            return React.cloneElement(VisibleComponent, {
                ...VisibleComponent.props,
                ref: row => (this._rows[key] = row),
                onRowOpen: toValue => this.onRowOpen(key, toValue),
                onRowDidOpen: toValue =>
                    this.props.onRowDidOpen &&
                    this.props.onRowDidOpen(key, this._rows, toValue),
                onRowClose: _ =>
                    this.props.onRowClose &&
                    this.props.onRowClose(key, this._rows),
                onRowDidClose: _ =>
                    this.props.onRowDidClose &&
                    this.props.onRowDidClose(key, this._rows),
                onRowPress: _ => this.onRowPress(),
                setScrollEnabled: enable => this.setScrollEnabled(enable),
                swipeGestureBegan: _ => this.rowSwipeGestureBegan(key),
            });
        } else {
            return (
                <SwipeRow
                    ref={row => (this._rows[key] = row)}
                    key={key}
                    swipeGestureBegan={_ => this.rowSwipeGestureBegan(key)}
                    onRowOpen={toValue => this.onRowOpen(key, toValue)}
                    onRowDidOpen={toValue =>
                        this.props.onRowDidOpen &&
                        this.props.onRowDidOpen(key, this._rows, toValue)
                    }
                    onRowClose={_ =>
                        this.props.onRowClose &&
                        this.props.onRowClose(key, this._rows)
                    }
                    onRowDidClose={_ =>
                        this.props.onRowDidClose &&
                        this.props.onRowDidClose(key, this._rows)
                    }
                    onRowPress={_ => this.onRowPress(key)}
                    setScrollEnabled={enable => this.setScrollEnabled(enable)}
                    leftOpenValue={
                        item.leftOpenValue || this.props.leftOpenValue
                    }
                    rightOpenValue={
                        item.rightOpenValue || this.props.rightOpenValue
                    }
                    closeOnRowPress={
                        item.closeOnRowPress || this.props.closeOnRowPress
                    }
                    disableLeftSwipe={
                        item.disableLeftSwipe || this.props.disableLeftSwipe
                    }
                    disableRightSwipe={
                        item.disableRightSwipe || this.props.disableRightSwipe
                    }
                    stopLeftSwipe={
                        item.stopLeftSwipe || this.props.stopLeftSwipe
                    }
                    stopRightSwipe={
                        item.stopRightSwipe || this.props.stopRightSwipe
                    }
                    recalculateHiddenLayout={this.props.recalculateHiddenLayout}
                    style={this.props.swipeRowStyle}
                    preview={shouldPreviewRow}
                    previewDuration={this.props.previewDuration}
                    previewOpenDelay={this.props.previewOpenDelay}
                    previewOpenValue={this.props.previewOpenValue}
                    tension={this.props.tension}
                    friction={this.props.friction}
                    directionalDistanceChangeThreshold={
                        this.props.directionalDistanceChangeThreshold
                    }
                    swipeToOpenPercent={this.props.swipeToOpenPercent}
                    swipeToOpenVelocityContribution={
                        this.props.swipeToOpenVelocityContribution
                    }
                    swipeToClosePercent={this.props.swipeToClosePercent}
                >
                    {HiddenComponent}
                    {VisibleComponent}
                </SwipeRow>
            );
        }
    }

    renderRow(rowData, secId, rowId, rowMap) {
        const key = `${secId}${rowId}`;
        const Component = this.props.renderRow(rowData, secId, rowId, rowMap);
        const HiddenComponent =
            this.props.renderHiddenRow &&
            this.props.renderHiddenRow(rowData, secId, rowId, rowMap);
        const previewRowId =
            this.props.dataSource &&
            this.props.dataSource.getRowIDForFlatIndex(
                this.props.previewRowIndex || 0
            );
        const shouldPreviewRow =
            (this.props.previewFirstRow || this.props.previewRowIndex) &&
            rowId === previewRowId;

        return this.renderCell(
            Component,
            HiddenComponent,
            key,
            rowData,
            shouldPreviewRow
        );
    }

    renderItem(rowData, rowMap) {
        const Component = this.props.renderItem(rowData, rowMap);
        const HiddenComponent =
            this.props.renderHiddenItem &&
            this.props.renderHiddenItem(rowData, rowMap);
        let { item, index } = rowData;
        let { key } = item;
        if (!key && this.props.keyExtractor) {
            key = this.props.keyExtractor(item, index);
        }

        const shouldPreviewRow = this.props.previewRowKey === key;

        return this.renderCell(
            Component,
            HiddenComponent,
            key,
            item,
            shouldPreviewRow
        );
    }
    ListEmptyComponent = () => {
        const { store,useFlatList ,type} = this.props;
        const { refreshing, loading, isFirstLoad } = useFlatList ? store:this.props;
        console.log('/////////////',refreshing && loading || isFirstLoad);
        return (
            <View style={[styles.emptyView, this.props.emptyStyle,{width:this.props.style && this.props.style.width || width}]}>
                {
                    refreshing && loading || isFirstLoad ? null:
                    <ListEmptyCom type={type}/>
                }
            </View>
        );
    }

    ListHeaderComponent = () => {
        return <View style={[styles.separator, styles.headerView]} />;
    };

    ListFooterComponent = () => {
        const { store, data } = this.props;
        const { refreshing, hasMore, page } = store;
        // if (refreshing || data.length == 0 || page == 1) return null
        if (refreshing || data.length == 0) {return null;}

        return (
            <View style={[styles.footerView, this.props.footerStyle]}>
                <Text style={styles.footerText}>
                    {hasMore
                        ? '加载中...'
                        : data.length <= 10
                        ? ''
                        : '已经到底啦'}
                </Text>
            </View>
        );
    };

    keyExtractor = (item, index) => {
        return index.toString();
    };

    ItemSeparatorComponent = () => {
        return <View style={styles.separator} />;
    };
    // 返回顶部
    scrollToTop = () => {
        console.log('%cscrollToTop', 'background: red; color: #fff');
        this.flatListRef && this.flatListRef.scrollToOffset({ offset: 0 });
    };

    refresh = () => {
        const { refreshData } = this.props;

        if (!refreshData) {return;}

        // 刷新
        console.log('%crefreshData', 'background: red; color: #fff');
        refreshData();
    };

    loadMore = () => {
        const { store, data, loadMoreData } = this.props;
        const { refreshing, loading, hasMore } = store;
        console.log('%cloadMore-before', 'background: red; color: #fff');
        if (refreshing || loading || !hasMore || data.length == 0 || !loadMoreData) {return};

        // 请求更多
        console.log('%cloadMoreData', 'background: red; color: #fff');
        loadMoreData();
    }

    render() {
        const {
            useFlatList,
            useSectionList,
            renderListView,
            type,
            ...props
        } = this.props;
        if (renderListView) {
            return renderListView(
                props,
                this.setRefs.bind(this),
                this.onScroll.bind(this),
                useFlatList || useSectionList
                    ? this.renderItem.bind(this)
                    : this.renderRow.bind(this, this._rows)
            );
        }

        // if (useFlatList) {
        //     return (
        //         <FlatList
        //             {...props}
        //             {...this.listViewProps}
        //             ref={c => this.setRefs(c)}
        //             onScroll={e => this.onScroll(e)}
        //             renderItem={(rowData) => this.renderItem(rowData, this._rows)}
        //         />
        //     );
        // }
        if (useFlatList) {
            const {
                store,
                data,
                onScroll,
                ListEmptyComponent,
                ListHeaderComponent,
                ListFooterComponent,
                renderItem,
                ItemSeparatorComponent,
                refreshData,
                loadMoreData,
                numColumns,
            } = this.props;
            const { refreshing } = store;
            return (
                <FlatList
                    {...props}
                    {...this.listViewProps}
                    ref={c => this.setRefs(c)}
                    // ref={(e) => { this.setRefs(e); return e && (this.flatListRef = e) }}
                    style={[styles.flatList, this.props.style]}
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                    onScroll={e => {
                        this.onScroll(e);
                    }}
                    ListEmptyComponent={
                        ListEmptyComponent || this.ListEmptyComponent
                    }
                    ListHeaderComponent={
                        ListHeaderComponent || this.ListHeaderComponent
                    }
                    ListFooterComponent={
                        ListFooterComponent || this.ListFooterComponent
                    }
                    data={data}
                    initialNumToRender={10}
                    keyExtractor={this.keyExtractor}
                    renderItem={rowData => this.renderItem(rowData, this._rows)}
                    key={numColumns === 1 ? 'row' : 'column'} // 要动态改变numColumns必须设置key
                    numColumns={numColumns || 1}
                    ItemSeparatorComponent={
                        ItemSeparatorComponent || this.ItemSeparatorComponent
                    }
                    refreshControl={
                        <RefreshControl
                            colors={['#2ba09d']}
                            refreshing={refreshing}
                            onRefresh={this.refresh}
                        />
                    }
                    onEndReached={this.loadMore}
                    onEndReachedThreshold={1}
                />
            );
        }

        if (useSectionList) {
            return (
                <SectionList
                    {...props}
                    {...this.listViewProps}
                    ref={c => this.setRefs(c)}
                    onScroll={e => this.onScroll(e)}
                    renderItem={rowData => this.renderItem(rowData, this._rows)}
                />
            );
        }

        return (
            this.props.data && this.props.data.length == 0 && this.props.isFirstLoad === false ?
            <View style={[styles.emptyView]}>
                <ListEmptyCom type={type}/>
            </View>
            :
            <ListView
                {...props}
                {...this.listViewProps}
                ref={c => this.setRefs(c)}
                onScroll={e => this.onScroll(e)}
                showsHorizontalScrollIndicator={false}
                showsVerticalScrollIndicator={false}
                renderRow={(rowData, secId, rowId) =>
                    this.renderRow(rowData, secId, rowId, this._rows)
                }
            />
        );
    }
}

SwipeListView.propTypes = {
    /**
     * To render a custom ListView component, if you don't want to use ReactNative one.
     * Note: This will call `renderRow`, not `renderItem`
     */
    renderListView: PropTypes.func,
    /**
     * How to render a row in a FlatList. Should return a valid React Element.
     */
    renderItem: PropTypes.func,
    /**
     * How to render a hidden row in a FlatList (renders behind the row). Should return a valid React Element.
     * This is required unless renderItem is passing a SwipeRow.
     */
    renderHiddenItem: PropTypes.func,
    /**
     * [DEPRECATED] How to render a row in a ListView. Should return a valid React Element.
     */
    renderRow: PropTypes.func,
    /**
     * [DEPRECATED] How to render a hidden row in a ListView (renders behind the row). Should return a valid React Element.
     * This is required unless renderRow is passing a SwipeRow.
     */
    renderHiddenRow: PropTypes.func,
    /**
     * TranslateX value for opening the row to the left (positive number)
     */
    leftOpenValue: PropTypes.number,
    /**
     * TranslateX value for opening the row to the right (negative number)
     */
    rightOpenValue: PropTypes.number,
    /**
     * TranslateX value for stop the row to the left (positive number)
     */
    stopLeftSwipe: PropTypes.number,
    /**
     * TranslateX value for stop the row to the right (negative number)
     */
    stopRightSwipe: PropTypes.number,
    /**
     * Should open rows be closed when the listView begins scrolling
     */
    closeOnScroll: PropTypes.bool,
    /**
     * Should open rows be closed when a row is pressed
     */
    closeOnRowPress: PropTypes.bool,
    /**
     * Should open rows be closed when a row begins to swipe open
     */
    closeOnRowBeginSwipe: PropTypes.bool,
    /**
     * Disable ability to swipe rows left
     */
    disableLeftSwipe: PropTypes.bool,
    /**
     * Disable ability to swipe rows right
     */
    disableRightSwipe: PropTypes.bool,
    /**
     * Enable hidden row onLayout calculations to run always.
     *
     * By default, hidden row size calculations are only done on the first onLayout event
     * for performance reasons.
     * Passing ```true``` here will cause calculations to run on every onLayout event.
     * You may want to do this if your rows' sizes can change.
     * One case is a SwipeListView with rows of different heights and an options to delete rows.
     */
    recalculateHiddenLayout: PropTypes.bool,
    /**
     * Called when a swipe row is animating swipe
     */
    swipeGestureBegan: PropTypes.func,
    /**
     * Called when a swipe row is animating open
     */
    onRowOpen: PropTypes.func,
    /**
     * Called when a swipe row has animated open
     */
    onRowDidOpen: PropTypes.func,
    /**
     * Called when a swipe row is animating closed
     */
    onRowClose: PropTypes.func,
    /**
     * Called when a swipe row has animated closed
     */
    onRowDidClose: PropTypes.func,
    /**
     * Called when scrolling on the SwipeListView has been enabled/disabled
     */
    onScrollEnabled: PropTypes.func,
    /**
     * Styles for the parent wrapper View of the SwipeRow
     */
    swipeRowStyle: ViewPropTypes.style,
    /**
     * Called when the ListView (or FlatList) ref is set and passes a ref to the ListView (or FlatList)
     * e.g. listViewRef={ ref => this._swipeListViewRef = ref }
     */
    listViewRef: PropTypes.func,
    /**
     * Should the row with this key do a slide out preview to show that the list is swipeable
     */
    previewRowKey: PropTypes.string,
    /**
     * [DEPRECATED] Should the first SwipeRow do a slide out preview to show that the list is swipeable
     */
    previewFirstRow: PropTypes.bool,
    /**
     * [DEPRECATED] Should the specified rowId do a slide out preview to show that the list is swipeable
     * Note: This ID will be passed to this function to get the correct row index
     * https://facebook.github.io/react-native/docs/listviewdatasource.html#getrowidforflatindex
     */
    previewRowIndex: PropTypes.number,
    /**
     * Duration of the slide out preview animation (milliseconds)
     */
    previewDuration: PropTypes.number,
    /**
     * Delay of the slide out preview animation (milliseconds) // default 700ms
     */
    prewiewOpenDelay: PropTypes.number,
    /**
     * TranslateX value for the slide out preview animation
     * Default: 0.5 * props.rightOpenValue
     */
    previewOpenValue: PropTypes.number,
    /**
     * Friction for the open / close animation
     */
    friction: PropTypes.number,
    /**
     * Tension for the open / close animation
     */
    tension: PropTypes.number,
    /**
     * The dx value used to detect when a user has begun a swipe gesture
     */
    directionalDistanceChangeThreshold: PropTypes.number,
    /**
     * What % of the left/right openValue does the user need to swipe
     * past to trigger the row opening.
     */
    swipeToOpenPercent: PropTypes.number,
    /**
     * Describes how much the ending velocity of the gesture affects whether the swipe will result in the item being closed or open.
     * A velocity factor of 0 means that the velocity will have no bearing on whether the swipe settles on a closed or open position
     * and it'll just take into consideration the swipeToOpenPercent.
     */
    swipeToOpenVelocityContribution: PropTypes.number,
    /**
     * What % of the left/right openValue does the user need to swipe
     * past to trigger the row closing.
     */
    swipeToClosePercent: PropTypes.number,
};

SwipeListView.defaultProps = {
    leftOpenValue: 0,
    rightOpenValue: 0,
    closeOnRowBeginSwipe: false,
    closeOnScroll: true,
    closeOnRowPress: true,
    disableLeftSwipe: false,
    disableRightSwipe: false,
    recalculateHiddenLayout: false,
    previewFirstRow: false,
    directionalDistanceChangeThreshold: 2,
    swipeToOpenPercent: 50,
    swipeToOpenVelocityContribution: 0,
    swipeToClosePercent: 50,
};

export default SwipeListView;
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
    },
    flatList: {
        flex: 1,
        backgroundColor: '#fff',
    },
    emptyView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        marginTop: 50,
    },
    emptyText: {
        fontSize: 16,
        color: '#666',
    },
    headerView: {
        //
    },
    footerView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        height: 40,
        backgroundColor: CommonStyles.globalBgColor,
    },
    footerText: {
        fontSize: 14,
        color: '#666',
    },
    separator: {
        width: width,
        height: 10,
        backgroundColor: CommonStyles.globalBgColor,
    },
});
