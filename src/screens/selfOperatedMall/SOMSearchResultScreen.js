/**
 * 自营商城搜索结果页
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    ScrollView,
    Text,
    TouchableOpacity,
    Image,
    Button,
    Keyboard,
    Easing,
    BackHandler
} from 'react-native';
import { connect } from 'rn-dva'
import * as nativeApi from "../../config/nativeApi";

import * as requestApi from '../../config/requestApi';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import MallGoodsFilter from '../../components/MallGoodsFilter';
import FlatListView from '../../components/FlatListView';
import TextInputView from '../../components/TextInputView';
import MallHeaderTitle from '../../components/MallHeaderTitle';
import MallGoodsPropertyTemp from '../../components/MallGoodsPropertyTemp';
import Drawer from '../../components/DrawerMenu'
import MallGoodsListItem from '../../components/MallGoodsListItem';

const { width, height } = Dimensions.get('window');

class SOMSearchResultScreen extends Component {
    static navigationOptions = {
        header: null,
    }
    searchTextInput = null
    constructor(props) {
        super(props)
        this.state = {
            goodsListsType: false,
            filterParams: null,
            listName: 'somSearchGoodsList',
            searchText: props.navigation.getParam('keyword',''),
            activeIndex: props.navigation.getParam('activeIndex', 0),
            closeDrawer: true,
            categoryAttrs: null
        }
    }
    scrollHeight = 0;
    componentDidMount() {
        this.getPropertyData();// 提交搜索的时候和第一次进入页面的时候获取属性模板
        this.getList(true,false)
        BackHandler.addEventListener("hardwareBackPress", this.onBackPress);
    }
    
    componentWillUnmount() {
        this.drawer && this.drawer.close()
        BackHandler.removeEventListener("hardwareBackPress", this.onBackPress);
    }
    
    onBackPress = () => {
        const { closeDrawer} = this.state;
        console.log('sfjladsfjlk',closeDrawer)
        if (!closeDrawer) {
            this.drawer.close()
            Keyboard.dismiss();
            this.setState({
                closeDrawer: true,
            })
            return true;
        }
        return false;
    };
    onMenuStateChaned = (status) => {
        console.log('status',status)
        if (!status) {
            Keyboard.dismiss();
        }
        this.setState({
            closeDrawer: !status
        })
    }
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }
    // 筛选后的搜索
    handleFilterSearch = (templates, price = null) => {
        console.log('templates',templates)
        console.log('price',price)
        // 价格验证
        if (price) {
            let reg = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/;
            if (!reg.test(price.low)) {
                Toast.show(`${price.placeholder_low}为保留两位小数的正整数哦！`)
                return
            }
            if (!reg.test(price.high)) {
                Toast.show(`${price.placeholder_high}为保留两位小数的正整数哦！`)
                return
            }
            if (parseFloat(price.low) > parseFloat(price.high)) {
                Toast.show(`${price.placeholder_high}不能小于${price.placeholder_low}`)
                return
            }
            if (price.low > 100000000 || price.high > 100000000) {
                Toast.show('价格超过上限！')
                return
            }
        }
        this.drawer.close();
        let categoryAttrs = { templates }
        this.setState({
            categoryAttrs: templates.length === 0 ? null : { categoryAttrs }
        }, () => { console.log(123123123,this.state.categoryAttrs);this.getList(true,false,true,false,this.state.filterParams) })
    }

    // 获取搜索结果列表
    getList = (isFirst = true, isLoadingMore = false, loading = true, refreshing = false, filterParams = this.state.filterParams, propertyFilter = this.state.categoryAttrs) => {
        let { listName, searchText } = this.state
        let { fetchList } = this.props
        let propertyFilterParams = propertyFilter ? propertyFilter : null;
        let filter = filterParams ? { sort: { ...filterParams } } : null;
        let paramsPrivate = {
            condition: {
                keyword: searchText,
            },
            ...filter,
            ...propertyFilterParams,
        };
        console.log('propertyFilterParams',propertyFilterParams)
        console.log(JSON.stringify(paramsPrivate))
        fetchList({
            witchList: listName,
            isFirst,
            isLoadingMore,
            paramsPrivate,
            api: requestApi.requestSearchGoodsList,
            callback: () => {},
            loading,
            refreshing,
            limit:10,
        })
    }
    // 获取属性模版
    getPropertyData = () => {
        const { searchText } = this.state
        this.props.getPropertyData({ keyword: searchText })
    }
    // 筛选
    handleFilterData = (filterData) => {
        console.log('筛选',filterData)
        this.setState({
            filterParams: filterData,
            activeIndex: filterData.index
        }, () => {
            this.getList()
         })
    }
    // 提交搜索
    onSubmitText = () => {
        const { searchText } = this.state
        Loading.show();
        Keyboard.dismiss();
        console.log(searchText)
        if (searchText === '') {
            Toast.show('请输入搜索内容');
            return
        }
        let regEn = /[`~!@#$%^&*()_+<>?:"{},.\\/;'[\]]/im;
        let regCn = /[·！#￥（——）：；“”‘、，|《。》？、【】[\]]/im;
        if (regEn.test(searchText) || regCn.test(searchText)) {
            Toast.show('不能包含特殊字符');
            this.setState({
                searchText: ''
            })
            return
        }
        this.setState({
            filterParams: null, // 第一次进入页面的搜索 和 在此页面 再次搜索 都不需要带筛选参数, 清空筛选参数在获取数据
            categoryAttrs: null, // 重新搜索清空属性筛选条件
            activeIndex: -1,
            clearFilter: true,
        }, () => {
            this.getPropertyData();// 提交搜索的时候和第一次进入页面的时候获取属性模板
            this.getList()
            this.props.saveSomSearchHistory({ keyword: searchText })
        })
    }
    // 每项数据
    renderItem = ({ item, index, colIndex }) => {
        const { navigation, longLists } = this.props;
        const { goodsListsType, listName } = this.state;
        let listData = longLists[listName] && longLists[listName].lists || [];
        return (
            <MallGoodsListItem
                pageName='SOMSearchResult'
                colIndex={ colIndex }
                index={index}
                item={item}
                navigation={navigation}
                data={listData}
                goodsListsType={goodsListsType}
            />
        );
    }
    // 头部操作项
    renderTopCenter = () => {
        const { navigation } = this.props;
        const { goodsListsType, searchText } = this.state;
        return (
            <View style={[styles.headerItem, styles.headerCenterView,CommonStyles.flex_1]}>
                <View style={[styles.headerCenterItem1, CommonStyles.flex_1]}>
                    <TouchableOpacity
                        activeOpacity={0.8}
                        style={styles.headerCenterItem1_textView}
                        onPress={() => {
                            // navigation.navigate('SOM')
                        }}
                    >
                        <TextInputView
                            inputView={[styles.headerItem, styles.headerCenterView]}
                            inputRef={(e) => { this.searchTextInput = e }}
                            style={styles.headerTextInput}
                            value={searchText}
                            onChangeText={(text) => { this.changeState('searchText', text); }}
                            returnKeyType={'search'}
                            onSubmitEditing={() => { this.onSubmitText(); }}
                            leftIcon={
                                <View style={[styles.headerTextInput_icon, styles.headerTextInput_search]}>
                                    <Image source={require('../../images/mall/search.png')} />
                                </View>
                            }
                        />
                    </TouchableOpacity>
                </View>
                <View style={{marginLeft: 15}}>
                    <MallHeaderTitle
                        data={[
                        {
                            icon: require('../../images/mall/messages.png'),
                            onPress: () => { nativeApi.createXKCustomerSerChat() }
                        },
                        {
                            icon: require('../../images/mall/shoppingcart.png'),
                            onPress: () => {
                                navigation.navigate("SOMShoppingCart");
                            }
                        },
                        {
                            icon: require('../../images/mall/orders.png'),
                            onPress: () => {
                                navigation.navigate("SOMOrder", { goBackRouteName: 'SOMSearchResult' });
                            }
                        },
                        {
                            icon: require('../../images/mall/fg_ling.png'),
                            onPress: () => {

                            }
                        },{
                            icon: goodsListsType ? require('../../images/mall/list2.png'):require('../../images/mall/list1.png'),
                            onPress:() => {
                                this.changeState('goodsListsType', !goodsListsType);
                                setTimeout(() => {
                                    this.flatListRef && this.flatListRef.scrollToOffset({ offset: this.scrollHeight, animated: false });
                                }, 100);
                            }
                        }]}
                    />
                </View>
            </View>
        )
    }

    render() {
        const { navigation, longLists } = this.props;
        const { goodsListsType,listName, activeIndex } = this.state;
        console.log('this.props',this.props)
        let store = { ...longLists[listName], page: longLists[listName] && longLists[listName].listsPage || 1, };
        let listData = longLists[listName] && longLists[listName].lists || [];
        return (
            // 侧滑菜单
            <Drawer
                ref={(ref) => { this.drawer = ref }}
                // menuStyle={{ backgroundColor: 'red' }}
                menu={<MallGoodsPropertyTemp onSubmit={(templates, price) => { this.handleFilterSearch(templates, price) }}/>}
                type='overlay'
                direction='right'
                onMenuStateChaned={(status) => { this.onMenuStateChaned(status) }}
                width={width - 65}
                >
                    <View style={styles.container}>
                        {/* header */}
                        <Header
                            navigation={navigation}
                            goBack={true}
                            centerView={ this.renderTopCenter() }
                            rightView={<View style={{ width: 0 }} />}
                        />
                        {/* 筛选 */}
                        <MallGoodsFilter
                            onPress={(filterData) => { console.log(filterData);this.handleFilterData(filterData) }}
                            showPropertyFilter
                            activeIndex={activeIndex}
                            drawer={this.drawer}
                        />
                        {/* 结果列表 */}
                        <FlatListView
                            openWaterFall
                            flatRef={(e) => { e && (this.flatListRef = e) }}
                            style={styles.flatList}
                            store={ store}
                            data={listData}
                            onScroll={e => {
                                let y = e.nativeEvent.contentOffset.y;
                                this.scrollHeight = y;
                            }}
                            ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
                            renderItem={this.renderItem}
                            numColumns={!goodsListsType ? 1 : 2}
                            refreshData={() => { this.getList(false, false, false, true) }}
                            loadMoreData={() => { this.getList(false, true, false, false)}}
                        />
                    </View>
            </Drawer>
            
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    headerCenterView: {
        flex: 1,
    },
    headerCenterItem1: {
        flex: 1,
        borderRadius: 15,
        backgroundColor: 'rgba(255,255,255,0.3)',
        overflow: 'hidden',
    },
    headerCenterItem1_textView: {
        ...CommonStyles.flex_start,
        ...CommonStyles.flex_center,
        height: 30,
    },
    headerCenterItem1_text: {
        fontSize: 14,
        color: '#fff',
        marginRight: 10,
    },
    headerCenterItem2: {
        width: 114,
    },
    headerCenterItem2_icon: {
        ...CommonStyles.flex_end,
        flex: 1,
        height: '100%',
    },
    headerRightView: {
        width: 50,
    },
    headerRight_line: {
        width: 1,
        height: 23,
        backgroundColor: 'rgba(255,255,255,0.23)',
    },
    headerRight_icon: {
        flex: 1,
    },
    flatList: {
        flex: 1,
        backgroundColor: CommonStyles.globalBgColor,
    },
    flatListLine: {
        height: 1,
        backgroundColor: '#F1F1F1',
    },
    headerView: {
        backgroundColor: '#fff',
    },
    headerTextInput: {
        flex: 1,
        height: '100%',
        paddingLeft: 35,
        paddingRight:11,
        paddingVertical: 0,
        borderRadius: 15,
        fontSize: 14,
        // backgroundColor: 'rgba(255,255,255,0.3)',
        color: '#fff'

    },
    headerTextInput_icon: {
        position: 'absolute',
        top: 0,
        justifyContent: 'center',
        alignItems: 'center',
        width: 40,
        height: '100%',
        zIndex: 2,
    },
    headerTextInput_search: {
        left: 0,
    },
    headerTextInput_close: {
        right: 0,
    },
    headerTextInput_close_img: {
        width: 18,
        height: 18,
    },
    headerRightView: {
        paddingLeft: 12,
        paddingRight: 23,
    },
    header_search_text: {
        fontSize: 17,
        color: '#222',
    },
});

export default connect(
    (state) => ({
        longLists:state.shop.longLists || {},
        somFilterAttrList: state.mall.somFilterAttrList || {},
        // somSearchGoodsList: state.mall.somSearchGoodsList,
    }),
    dispatch=>({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
        saveSomSearchHistory:(params={})=> dispatch({ type: "mall/saveSomSearchHistory", payload: params}),
        getPropertyData:(params={})=> dispatch({ type: "mall/getPropertyData", payload: params}),
        
    })
)(SOMSearchResultScreen);
