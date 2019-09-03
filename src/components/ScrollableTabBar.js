/**
 * @author YASIN
 * @version [React-Native Pactera V01, 2017/9/7]
 * @date 17/2/23
 * @description ScrollableTabBar
 */
import React, {
    Component
} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Dimensions,
    TouchableOpacity,
    ScrollView,
    Animated,
} from 'react-native';
const screenW = Dimensions.get('window').width;
const screenH = Dimensions.get('window').height;
export default class ScrollableTabBar extends Component {
    // 构造
    constructor(props) {
        super(props);
        this._tabsMeasurements = []
        this._containerMeasure = {
            width: screenW
        }
        this._tabContainerMeasure = {
            width: 0
        }
        // 初始状态
        this.state = {
            _leftTabUnderline: new Animated.Value(0),
            _widthTabUnderline: new Animated.Value(0),
        };
    }

    render() {
        let { containerWidth, tabs, scrollValue } = this.props;
        //给传过来的动画一个插值器
        let tabStyle = {
            width: this.state._widthTabUnderline,
            position: 'absolute',
            bottom: 0,
            left: this.state._leftTabUnderline
        };
        return (
            <View
                style={[styles.container, this.props.style]}
                //获取tabbarview的宽度
                onLayout={(e) => this._measureContainer(e)}
            >
                <ScrollView
                    automaticallyAdjustContentInsets={false}
                    ref={(scrollView) => {
                        this._scrollView = scrollView;
                    }}
                    horizontal={true}
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                    directionalLockEnabled={true}
                    bounces={false}
                    scrollsToTop={false}
                    pagingEnabled={true}
                    snapToInterval={screenW}
                >
                    <View
                        style={styles.tabContainer}
                        //获取tab到底有多宽
                        onLayout={(e) => this._measureTabContainer(e)}
                    >
                        {tabs.map((tab, index) => {
                            return this._renderTab(tab, index, index === this.props.activeTab);
                        })}
                        <Animated.View
                            style={[styles.tabLineStyle, this.props.tabLineStyle, tabStyle]}
                        />
                    </View>
                </ScrollView>
            </View>
        );
    }
    /**
     * 测量内容view
     * @param event
     * @private
     */
    _measureContainer(event) {
        this._containerMeasure = event.nativeEvent.layout;
        this._updateView({ value: this.props.scrollValue._value });
    }

    /**
     * 测量tab内容view
     * @param event
     * @private
     */
    _measureTabContainer(event) {
        this._tabContainerMeasure = event.nativeEvent.layout;
        if (this.state._tabContainerWidth !== this._tabContainerMeasure.width) {
            this.setState({
                _tabContainerWidth: this._tabContainerMeasure.width,
            }, () => {
                this._updateView({ value: this.props.scrollValue._value });
            });
        }
    }
    componentDidMount() {
        this.props.scrollValue.addListener(this._updateView);
    }
    /**
    * 根据scrollview的滑动改变底部线条的宽度跟left
    * @param value
    * @private
    */
    _updateView = ({ value = 0 }) => {
        //因为value 的值是[0-1-2-3-4]变换
        const position = Math.floor(value);
        //取小数部分
        const offset = value % 1;
        const tabCount = this.props.tabs.length;
        const lastTabPosition = tabCount - 1;
        //如果没有tab||（有bounce效果）直接return
        if (tabCount === 0 || value < 0 || value > lastTabPosition) {
            return;
        }
        if (this._necessarilyMeasurementsCompleted(position, position === tabCount - 1)) {
            this._updateTabLine(position, offset);
            //控制pannel的移动（也就是tab外部的scrollview的滚动）
            this._updateTabPanel(position, offset);
        }
    }
    /**
    * 修改tab内容view的scroll在y轴的偏移量
    * @private
    */
    _updateTabPanel(position, pageOffset) {
        //父控件的宽度
        const containerWidth = this._containerMeasure.width;// width
        //获取当前选中tab的宽度
        const tabWidth = this._tabsMeasurements[position].width;
        //获取选中tab的下一个tab的测量值
        const nextTabMeasurements = this._tabsMeasurements[position + 1];
        //获取选中tab的下一个tab的宽度
        const nextTabWidth = nextTabMeasurements && nextTabMeasurements.width || 0;
        //当前选中tab的x坐标
        const tabOffset = this._tabsMeasurements[position].left;
        //当前选中tab距离下一个tab的偏移量（也就是底部线条还停留在当前tab的宽度）
        const absolutePageOffset = pageOffset * tabWidth;
        //所以当前tab实际偏移量=（当前tab的x轴坐标+当前tab的底部线条偏移量）
        let newScrollX = tabOffset + absolutePageOffset;

        //计算当前tab显示在控件中央位置需要在（当前scrollview偏移量的基础上再偏移多少）
        newScrollX -= (containerWidth - (1 - pageOffset) * tabWidth - pageOffset * nextTabWidth) / 2;
        //因为tabcontainer里面内容最大宽度=（最大scrollx+控件自身的宽度），
        //所以最大scrollx=tabcontainer里面内容最大宽度-控件自身的宽度
        const rightBoundScroll = this._tabContainerMeasure.width - (this._containerMeasure.width);
        //求出scrollview x轴偏移临界值【0，rightBoundScroll】
        newScrollX = newScrollX >= 0 ? (newScrollX > rightBoundScroll ? rightBoundScroll : newScrollX) : 0;
        // ios数量小于3个，点击最后一个bug
        if (this.props.tabs.length < 4) {
            return
        }
        this._scrollView.scrollTo({ x: newScrollX, y: 0, animated: false, });
    }
    /**
     * 更新底部线view的left跟width
     * @param position
     * @param offset
     * @private
     */
    _updateTabLine(position, offset) {
        //当前tab的测量值
        const currMeasure = this._tabsMeasurements[position];
        //position+1的tab的测量值
        const nextMeasure = this._tabsMeasurements[position + 1];
        let width = currMeasure.width * (1 - offset);
        let left = currMeasure.left;
        if (nextMeasure) {
            width += nextMeasure.width * offset;
            left += nextMeasure.width * offset;
        }
        this.state._leftTabUnderline.setValue(left);
        this.state._widthTabUnderline.setValue(width);
    }
    /**
   * 判断是否需要跟新的条件是否初始化
   * @param position
   * @param isLast 是否是最后一个
   * @private
   */
    _necessarilyMeasurementsCompleted(position, isLast) {
        return (
            this._tabsMeasurements[position] &&
            (isLast || this._tabsMeasurements[position + 1])
        );
    }

    /**
     * 渲染tab
     * @param name 名字
     * @param page 下标
     * @param isTabActive 是否是选中的tab
     * @private
     */
    _renderTab(name, page, isTabActive) {
        let tabTextStyle = null;
        //如果被选中的style
        if (isTabActive) {
            tabTextStyle = this.props.selectedTextStyle;
        } else {
            tabTextStyle = this.props.unSelectedTextStyle;
        }
        let self = this;
        return (
            <TouchableOpacity
                key={name + page}
                style={[styles.tabStyle]}
                onPress={() => this.props.onTabClick(page)}
                onLayout={(event) => this._onMeasureTab(page, event)}
            >
                <Text style={[tabTextStyle, { lineHeight: 20 }]}>{name}</Text>
            </TouchableOpacity>
        );
    }
    /**
     * 测量tabview
     * @param page 页面下标
     * @param event 事件
     * @private
     */
    _onMeasureTab(page, event) {
        let { nativeEvent: { layout: { x, width } } } = event;
        this._tabsMeasurements[page] = { left: x, right: width + x, width: width };
        this._updateView({ value: this.props.scrollValue._value })
    }
}
const styles = StyleSheet.create({
    container: {
        width: screenW,
        // height: 41,
        // paddingBottom:12
    },
    tabContainer: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    tabLineStyle: {
        height: 1,
        backgroundColor: 'navy',
    },
    tabStyle: {
        // height: 41,
        paddingBottom: 12,
        paddingTop: 6,
        alignItems: 'center',
        justifyContent: 'center',
        paddingHorizontal: 20,
    },
});
