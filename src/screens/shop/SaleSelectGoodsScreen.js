/**
 * 促销管理/选择商品或品类
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    TouchableOpacity,
    ScrollView
} from 'react-native';
import { connect } from 'rn-dva';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
const { width, height } = Dimensions.get('window');
import Content from '../../components/ContentItem';
import CommonButton from '../../components/CommonButton';
import FlatListView from '../../components/FlatListView';
import ImageView from '../../components/ImageView';
import ScrollableTabView from "react-native-scrollable-tab-view";
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar'
import ListEmptyCom from '../../components/ListEmptyCom';
class SaleSelectGoods extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        const { fanwei, callback, selectedItems, currentShop } = props.navigation.state.params
        let lists = []
        for (let item of props.serviceCatalogList) {
            lists.push([])
        }
        this.state = {
            categoryId: 0,
            userShop: props.userShop,
            fanwei,
            currentTab: props.serviceCatalogList[0] || {},
            selectedItems: selectedItems || [],
            callback: callback ? callback : () => { },
            lists,
            currentShop: currentShop,
            selectTabIndex: 0,
            isFirst: true
        }
    }

    getList = () => {
        isFirst ? Loading.show() : null
        const { fanwei, currentTab, selectTabIndex, currentShop, lists, isFirst } = this.state
        let params = {}
        let func
        if (fanwei == '品类') {
            func = requestApi.shopOBMQListBcleGoodsCode
            params = {
                shopId: currentShop.id,
                code: currentTab.code,
            }
        }
        else {
            func = requestApi.shopOBMQListBcleGoods
            params = {
                shopId: currentShop.id,
                goodsTypeId: currentTab.code
            }
        }

        func(params).then((data) => {
            data = data ? fanwei == '品类' ? data.coodes : data.bcleGoods : []
            let newLists = [...lists]
            newLists[selectTabIndex] = []
            for (let item of data) {
                item.select = false
                for (itemSelect of this.state.selectedItems) {
                    if (fanwei == '品类') {
                        itemSelect.code2 == item.code2 ? item.select = true : null
                    }
                    else {
                        itemSelect.goodsCode == item.goodsCode ? item.select = true : null
                    }
                }
                newLists[selectTabIndex].push(item)
            }
            this.setState({
                lists: newLists,
                isFirst: false
            })
            Loading.hide()
        }).catch(() => {
            Loading.hide()
        })
    }

    componentDidMount() {
        this.getList(true, false)
    }

    componentWillUnmount() {


    }
    confirm = () => {
        this.props.navigation.goBack()
        this.state.callback(this.state.selectedItems)
    }
    selectItem = (index) => {
        const { selectTabIndex } = this.state
        const { lists } = this.state
        let newLists = [...lists]
        newLists[selectTabIndex][index].select = !newLists[selectTabIndex][index].select
        let newSelectedItems = [...this.state.selectedItems]
        if (newLists[selectTabIndex][index].select) {
            newSelectedItems.push(newLists[selectTabIndex][index])
        }
        else {
            for (let i = 0; i < newSelectedItems.length; i++) {
                if (newSelectedItems[i].code2 == newLists[selectTabIndex][index].code2) {
                    newSelectedItems.splice(i, 1)
                }
            }
        }
        this.setState({
            selectedItems: newSelectedItems,
            lists: newLists
        })
    }
    renderItem = ({ item, index }) => {
        return this.state.fanwei == '单品' ? (
            <TouchableOpacity onPress={() => this.selectItem(index)} style={[styles.item, { backgroundColor: index % 2 == 0 ? '#FAFAFA' : '#fff' }]} key={index}>
                <View>
                    <Text style={[styles.title, { marginBottom: 8 }]}>商品编号{item.goodsCode}</Text>
                    <View style={styles.fanweiItem}>
                        <ImageView
                            source={{ uri: item.pic }}
                            sourceWidth={60}
                            sourceHeight={60}
                            style={{ marginRight: 10, borderRadius: 8 }}
                        />
                        <View style={{ flex: 1 }}>
                            <Text style={[styles.title, { fontSize: 12 }]}>{item.goodsName}</Text>
                            <Text style={[styles.title, { fontSize: 10, marginTop: 3 }]}>二级分类：{item.name2}</Text>
                        </View>
                    </View>
                </View>

                <View>
                    <Image
                        source={item.select ? require('../../images/index/select.png') : require('../../images/index/unselect.png')}
                        style={{ width: 14, height: 14, marginLeft: 11 }}
                    />
                </View>

            </TouchableOpacity>

        ) : (
                <TouchableOpacity key={index} style={[styles.cateItem, {
                    backgroundColor: item.select ? '#8FB8F8' : '#fff',
                    borderWidth: 1,
                    borderColor: item.select ? '#8FB8F8' : '#999999',
                    marginRight: (index + 1) % 3 === 0 ? 0 : 30
                }]} onPress={() => this.selectItem(index)}>
                    <Text style={{
                        color: item.select ? '#fff' : '#999999',
                        fontSize: 14
                    }}>
                        {item.name2}
                    </Text>
                </TouchableOpacity>
            )

    }
    changeTab = (itemTab, index) => {
        this.setState({ currentTab: itemTab, selectTabIndex: index }, () => {
            this.getList()
        })
    }


    render() {
        const { navigation,serviceCatalogList } = this.props;
        const { fanwei, lists, selectTabIndex, isFirst } = this.state;
        const styleView = {
            flexDirection: 'row',
            alignItems: 'center',
            flexWrap: 'wrap',
            paddingHorizontal: 20,
            paddingTop: 20,
            paddingBottom: 5
        }

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={fanwei === '单品' ? '选择商品' : '选择品类'}
                />
                <ScrollableTabView
                    initialPage={0}
                    onChangeTab={({ i }) => this.changeTab(serviceCatalogList[i], i)}
                    renderTabBar={() => (
                        <DefaultTabBar
                            underlineStyle={{
                                backgroundColor: "#fff",
                                height: 8,
                                borderRadius: 10,
                                marginBottom: -5,
                                // width: "25%",
                                // marginLeft: "10%"
                            }}
                            tabStyle={{
                                backgroundColor: "#4A90FA",
                                height: 44,
                                paddingBottom: -4
                            }}
                            activeTextColor="#fff"
                            inactiveTextColor="rgba(255,255,255,.5)"
                            tabBarTextStyle={{ fontSize: 14 }}
                            style={{
                                backgroundColor: "#4A90FA",
                                height: 44,
                                borderBottomWidth: 0,
                                overflow: "hidden"
                            }}
                        />
                    )}
                >
                    {serviceCatalogList.map((itemTab, index) => {
                        return (
                            <ScrollView alwaysBounceVertical={false} tabLabel={itemTab.name} style={{ width: width }} key={index}>
                                <View style={{ alignItems: 'center' }}>
                                    {
                                        !lists[selectTabIndex] || (lists[selectTabIndex] && lists[selectTabIndex].length == 0 && !isFirst) ?
                                        <ListEmptyCom /> :
                                        <Content style={[fanwei == '单品' ? {} : styleView, { width: width - 20 }]}>
                                            {
                                                lists[selectTabIndex].map((item, index) => {
                                                    return this.renderItem({ item, index, lists: lists[selectTabIndex] })
                                                })
                                            }
                                        </Content>
                                    }

                                    <CommonButton title='确定' onPress={() => this.confirm()} style={{ marginBottom: 20 }} />
                                </View>

                            </ScrollView>
                        );
                    })}
                </ScrollableTabView>

            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
    },
    header: {
        width: width,
        height: 44 + CommonStyles.headerPadding,
        paddingTop: CommonStyles.headerPadding,
        overflow: 'hidden',
    },
    headerView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        width: width,
        height: 44 + CommonStyles.headerPadding,
        paddingTop: CommonStyles.headerPadding,
        backgroundColor: CommonStyles.globalHeaderColor,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    left: {
        width: 50,
    },
    center: {
        flex: 1,
    },
    titleText: {
        fontSize: 17,
        color: '#fff',
    },
    flatListView: {
        backgroundColor: '#F6F6F6',
        marginBottom: 10,
        flex: 1,
        width: width - 20,
        marginLeft: 10
    },
    itemContent: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: 15,
        backgroundColor: '#fff',
        // ...CommonStyles.shadowStyle
    },
    itemContentRight: {
        flex: 1,
        marginLeft: 15
    },
    smallText: {
        color: '#999999',
        fontSize: 12,
        marginTop: 3
    },
    itemBottom: {
        flexDirection: 'row',
        alignItems: 'center',
        height: 40,
        justifyContent: 'flex-end',
        paddingHorizontal: 14
    },
    bottomText: {
        marginLeft: 14,
        fontSize: 12
    },
    payBottom: {
        borderColor: '#EE6161',
        borderWidth: 1,
        paddingHorizontal: 18,
        paddingVertical: 3,
        marginLeft: 20,
        borderRadius: 12
    },
    transView: {
        backgroundColor: '#F6F6F6',
        // opacity:0.65,
        padding: 9,
        marginTop: 12
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    tabView: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        height: 36,
        backgroundColor: CommonStyles.globalHeaderColor,
        paddingHorizontal: 34,
        width: width
    },
    tab: {
        height: '100%',
        borderColor: '#fff',
        borderRadius: 1,
        alignItems: 'center',
        justifyContent: 'center',
        width: 50,
        overflow: 'hidden'

    },
    separator: {
        width: width,
        height: 1,
        backgroundColor: CommonStyles.globalBgColor,
    },
    item: {
        paddingVertical: 10,
        paddingHorizontal: 15,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        // flex: 1

    },
    title: {
        color: '#222222',
        fontSize: 14
    },
    fanweiItem: {
        flexDirection: 'row',
        alignItems: 'center',
        width: width - 100

    },
    flatListLine: {
        height: 1,
        backgroundColor: CommonStyles.globalBgColor,
    },
    cateItem: {
        borderRadius: 10,
        minWidth: (width - 120) / 3,
        paddingVertical: 10,
        alignItems: 'center',
        marginBottom: 15
    }

});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        serviceCatalogList:state.shop.serviceCatalogList || []
     })
)(SaleSelectGoods);
