/**
 * FlatList 组件
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    FlatList,
    ActivityIndicator,
    RefreshControl,
    VirtualizedList
} from 'react-native';

import CommonStyles from '../common/Styles';
import ListEmptyCom from './ListEmptyCom'
const { width, height } = Dimensions.get('window');

export default class FlatListView extends PureComponent {
    constructor(props) {
        super(props)
        this.state = {
        }
    }

    static defaultProps = {
        refreshData: ()=> {}, // 刷新数据，这里你需要更新第一页数据
        loadMoreData: ()=> {}, // 加在更多数据
        store: {
            refreshing: false, // 是否正在刷新数据
            loading: false, // 是否正在获取数据
            hasMore: false, // 是否有更多数据
        },
        data: [],
        isFirstLoad: false, // 是否初次更新数据
        renderItem: ()=> null,
        type: "default",
        openWaterFall: false, // 是否开启瀑布流
    }

    // 返回顶部
    scrollToTop = () => {
        console.log('%cscrollToTop', "background: red; color: #fff");
        this.flatListRef && this.flatListRef.scrollToOffset({ offset: 0 });
    }

    refresh = () => {
        const { refreshData } = this.props;

        if (!refreshData) return

        // 刷新
        console.log('%crefreshData', "background: red; color: #fff");
        refreshData();
    }

    loadMore = () => {
        const { store, data, loadMoreData } = this.props;
        const { refreshing, loading, hasMore } = store;
        console.log('%cloadMore-before', "background: red; color: #fff");
        if (refreshing || loading || !hasMore || data.length == 0 || !loadMoreData) return

        // 请求更多
        console.log('%cloadMoreData', "background: red; color: #fff");
        loadMoreData();
    }

    onScroll = (e) => {
        // console.log(e.nativeEvent)
        // console.log(width, height)
    }

    ListEmptyComponent = () => {
        const { store,type } = this.props;
        const { refreshing, loading, isFirstLoad } = store;
        return (
            <View style={[styles.emptyView, this.props.emptyStyle,{width:this.props.style && this.props.style.width || width}]}>
                {
                    refreshing && loading || isFirstLoad ?null:
                    <ListEmptyCom type={type}/>
                }
            </View>
        )
    }

    ListHeaderComponent = () => {
        return (
            <View style={[styles.separator, styles.headerView]}></View>
        )
    }

    ListFooterComponent = () => {
        const { store, data ,limit} = this.props;
        const { refreshing, hasMore,total } = store;
        // console.log(data.length,limit,hasMore)
        // if (refreshing || data.length == 0 || page == 1) return null
        if (refreshing || data.length == 0) return null
        return (
            <View style={[styles.footerView, this.props.footerStyle]}>
                <Text style={styles.footerText}>
                    {hasMore ? '加载中...' : data.length <= (limit || 10) ? '' : '已经到底啦'}
                </Text>
            </View>
        )
    }

    keyExtractor = (item, index) => {
        return index.toString();
    }

    ItemSeparatorComponent = () => {
        return (
            <View style={styles.separator} />
        )
    }
    // 测试瀑布流
    renderWaterFallItem = ({ item, index }) => {
        const { renderItem, ListEmptyComponent, } = this.props
        let col_1 = item.filter((citem,i) => i % 2 === 0)
        let col_2 = item.filter((citem,i) => i % 2 !== 0)
        let contentArr = [col_1, col_2];
        if(item.length === 0) return ListEmptyComponent || this.ListEmptyComponent(); // 长度为0，返回占位组件
        return (
            <View style={[CommonStyles.flex_start_noCenter, {backgroundColor: CommonStyles.globalBgColor}]} key={`wrap`}>
                {
                    contentArr.map((vItem,vIndex) => {
                        return (
                            <VirtualizedList
                                windowSize={300}
                                style={{ backgroundColor: CommonStyles.globalBgColor,flex:1 }}
                                key={vIndex}
                                getItem={(data, getItemIndex) => data[getItemIndex] }
                                getItemCount={(data) => data.length }
                                ListEmptyComponent={vItem.length === 0 ? null : ListEmptyComponent || this.ListEmptyComponent}
                                listKey={`col_${vIndex}`}
                                data={vItem}
                                renderItem={(item) => {
                                    let _item = item;
                                    _item.colIndex = vIndex // 标记当前为第几列的数据，用于外部renderItem的时候判断样式
                                    return renderItem(_item)
                                }}
                            />
                        )
                    })
                }
            </View>
        )
    }

    render() {
        const { limit,store, flatRef, contentContainerStyle,data, onScroll, ListEmptyComponent, ListHeaderComponent, ListFooterComponent, renderItem, ItemSeparatorComponent,openWaterFall, refreshData, loadMoreData, numColumns,refreshControl } = this.props;
        const { refreshing } = store;
        return (
            <FlatList
                key='FlatList'
                ref={flatRef}
                contentContainerStyle={contentContainerStyle || {}}
                style={[styles.flatList, this.props.style]}
                showsHorizontalScrollIndicator={false}
                showsVerticalScrollIndicator={false}
                onScroll={onScroll || this.onScroll}
                ListEmptyComponent={ListEmptyComponent || this.ListEmptyComponent}
                ListHeaderComponent={ListHeaderComponent || this.ListHeaderComponent}
                ListFooterComponent={ListFooterComponent || this.ListFooterComponent}
                data={openWaterFall && numColumns === 2 ? [data] : data}
                initialNumToRender={limit || 10}
                keyExtractor={this.keyExtractor}
                renderItem={openWaterFall && numColumns === 2 ? this.renderWaterFallItem : renderItem}
                key={numColumns === 1 ? 'row' : 'column'}  // 要动态改变numColumns必须设置key
                numColumns={ openWaterFall && numColumns === 2 ? 1 : numColumns || 1}
                ItemSeparatorComponent={ItemSeparatorComponent || this.ItemSeparatorComponent}
                refreshControl={
                    refreshControl ||
                    <RefreshControl
                        colors={['#2ba09d']}
                        refreshing={refreshing}
                        onRefresh={this.refresh}
                    />
                }
                onEndReached={this.loadMore}
                onEndReachedThreshold={0.1}
            />
        )
    }
};

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
