/**
 * @author YASIN
 * @version [React-Native Pactera V01, 2017/9/5]
 * @date 2017/9/5
 * @description index
 */
import React, {
    Component, PropTypes,
} from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    Animated,
} from 'react-native';
const screenW = Dimensions.get('window').width;
const screenH = Dimensions.get('window').height;
import ScrollableTabBar from './ScrollableTabBar';
export default class ScrollableTab extends Component {
    static propTypes = {
        // prerenderingSiblingsNumber: PropTypes.number,//预加载的页面
    }
    static defaultProps = {
        prerenderingSiblingsNumber: 0,//不需要预加载
    }
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            containerWidth: screenW,
            currentPage: 0,//当前页面
            scrollXAnim: new Animated.Value(0),
            scrollValue: new Animated.Value(0),
            sceneKeys: this._newSceneKeys({ currentPage: 0 }),
        };
    }

    render() {
        return (
            <View
                style={[styles.container, this.props.style]}
                onLayout={this._onLayout}
            >
                {/*渲染tabview*/}
                {this._renderTabView()}
                {/*渲染主体内容*/}
                {this._renderScrollableContent()}
            </View>
        );
    }

    componentDidMount() {
        //设置scroll动画监听
        this.state.scrollXAnim.addListener(({ value }) => {
            let offset = value / this.state.containerWidth;
            this.state.scrollValue.setValue(offset);
        });
    }

    componentWillUnMount() {
        //移除动画监听
        this.state.scrollXAnim.removeAllListeners();
        this.state.scrollValue.removeAllListeners();
    }

    /**
     * 渲染tabview
     * @private
     */
    _renderTabView() {
        let tabParams = {
            tabs: this._children().map((child) => child.props.tabLabel),
            activeTab: this.state.currentPage,
            scrollValue: this.state.scrollValue,
            containerWidth: this.state.containerWidth,
            selectedTextStyle: this.props.selectedTextStyle,
            unSelectedTextStyle: this.props.unSelectedTextStyle,
            tabLineStyle: this.props.tabLineStyle
        };
        return (
            <ScrollableTabBar
                {...tabParams}
                style={[this.props.tabStyle, { width: this.state.containerWidth }]}
                onTabClick={(page) => this.goToPage(page)}
            />
        );
    }

    /**
     * 渲染主体内容
     * @private
     */
    _renderScrollableContent() {
        return (
            <Animated.ScrollView
                ref={(ref) => {
                    this._scrollView = ref;
                }}
                style={{ width: this.state.containerWidth }}
                pagingEnabled={true}
                horizontal={true}
                showsHorizontalScrollIndicator={false}
                showsVerticalScrollIndicator={false}
                onMomentumScrollBegin={this._onMomentumScrollBeginAndEnd}
                onMomentumScrollEnd={this._onMomentumScrollBeginAndEnd}
                scrollEventThrottle={15}
                onScroll={Animated.event([{
                    nativeEvent: { contentOffset: { x: this.state.scrollXAnim } }
                }], {
                        useNativeDriver: true,
                    })}
                bounces={false}
                scrollsToTop={false}
                scrollEnabled={false}
            >
                {this._renderContentView()}
            </Animated.ScrollView>
        );
    }

    /**
     * 渲染子view
     * @private
     */
    _renderContentView() {
        let scenes = [];
        this._children().forEach((child, index) => {
            const sceneKey = this._makeSceneKey(child, index);
            let scene = null;
            if (this._keyExists(this.state.sceneKeys, sceneKey)) {
                scene = (child);
            } else {
                scene = (<View tabLabel={child.tabLabel} />);
            }
            scenes.push(
                <View
                    key={child.key}
                    style={{ width: this.state.containerWidth }}
                >
                    {scene}
                </View>
            );
        });
        return scenes;
    }

    /**
     * 获取子控件数组集合
     * @param children
     * @returns {*}
     * @private
     */
    _children(children = this.props.children) {
        return React.Children.map(children, (child) => child);
    }

    /**
     * 获取控件宽度
     * @param e
     * @private
     */
    _onLayout = (e) => {
        let { width } = e.nativeEvent.layout;
        if (this.state.containerWidth !== width) {
            this.setState({
                containerWidth: width,
            });
        }
    }

    /**
     * scrollview开始跟结束滑动回调
     * @param e
     * @private
     */
    _onMomentumScrollBeginAndEnd = (e) => {
        let offsetX = e.nativeEvent.contentOffset.x;
        let page = Math.round(offsetX / this.state.containerWidth);
        if (this.state.currentPage !== page) {
            this._updateKeyScenes(page);
        }
    }

    /**
     * 更新sceneskey和当前页面
     * @param nextPage
     * @private
     */
    _updateKeyScenes(nextPage) {
        let sceneKeys = this._newSceneKeys({ previousKeys: this.state.sceneKeys, currentPage: nextPage })
        this.props.onChangeTab ? this.props.onChangeTab(nextPage) : null
        this.setState({
            currentPage: nextPage,
            sceneKeys: sceneKeys,
        });
    }

    /**
     * 滑动到指定位置
     * @param pageNum page下标
     * @param scrollAnimation 是否需要动画
     */
    goToPage(pageNum, scrollAnimation = true) {
        if (this._scrollView && this._scrollView._component && this._scrollView._component.scrollTo) {
            this._scrollView._component.scrollTo({ x: pageNum * this.state.containerWidth, scrollAnimation });
            this._updateKeyScenes(pageNum);
        }
    }

    /**
     * 生成需要渲染的页面跟渲染过的页面的集合
     * @param previousKeys 之前的集合
     * @param currentPage 当前页面
     * @param children 子控件
     * @private
     */
    _newSceneKeys({ previousKeys = [], currentPage = 0, children = this.props.children, }) {
        let newKeys = [];
        this._children().forEach((child, index) => {
            const key = this._makeSceneKey(child, index);
            //页面是否渲染过||是否需要预加载
            if (this._keyExists(previousKeys, key) || this._shouldSceneRender(index, currentPage)) {
                newKeys.push(key);
            }
        });
        return newKeys;
    }

    /**
     * 生成唯一key
     * @param child 子控件
     * @param index 下标
     * @private
     */
    _makeSceneKey(child, index) {
        return (child.props.tabLabel + '_' + index);
    }

    /**
     * 判断key是否存在
     * @param previousKeys key集合
     * @param key 当前key
     * @private
     */
    _keyExists(previousKeys, key) {
        return (previousKeys.find((sceneKey) => sceneKey === key));
    }

    /**
     * 是否需要预加载
     * @private
     */
    _shouldSceneRender(index, currentPage) {
        const siblingsNumber = this.props.prerenderingSiblingsNumber;
        //比如当前页面为1，预加载1个，也就是我们需要显示0、1、2三个页面，所[-1<x<3]
        return (index < (currentPage + siblingsNumber + 1) && index > (currentPage - siblingsNumber - 1));
    }
}
const styles = StyleSheet.create({
    container: {
        width: screenW,
        flex: 1,
    },
});
