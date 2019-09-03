/**
 * -编辑菜单
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    ScrollView,
    SectionList,
    Image,
    Modal,
    TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import FlatListView from '../../../components/FlatListView'
import * as orderRequestApi from '../../../config/Apis/order'
import  math from "../../../config/math.js";
import { NavigationComponent } from "../../../common/NavigationComponent";
import { keepTwoDecimal ,getPreviewImage} from "../../../config/utils";
import ImageView from "../../../components/ImageView";
const service = require('../../../images/shopOrder/service.png')
const close = require('../../../images/shopOrder/close.png')
const add = require('../../../images/shopOrder/add.png')
const jian = require('../../../images/shopOrder/jian.png')
const { width, height } = Dimensions.get("window")
function getwidth(val) {
    return width * val / 375
}
let queryParam = {
    goodsClassificationId: '',
    shopId: '',
    limit: 10,
    page: 1,
}
// purchased === 1  可以加购
class EditorMenu extends NavigationComponent {
    constructor(props) {
        super(props)
        const { serviceCatalogCode, shopId, serviceData, purchased,callback } = this.props.navigation.state.params
        let canAddGoods = 3   //非服务类型
        if (serviceCatalogCode === '1001' && purchased === -1) {   //选择的服务的数据的筛选，是否是可以加购的服务
            canAddGoods = -1
        }
        if (serviceCatalogCode === '1001' && purchased === 1) {
            canAddGoods = 1
        }
        this.state = {
            store: {
                refreshing: false,
                loading: false,
                hasMore: true,
                isFirstLoad: true
            },
            guogeModal: false,
            orderVisible: false,
            orderBtnVisible: true,
            typeData: [],
            selectedId: '',
            orderData: [],
            skuData: {},
            skuAttrValue: [],  //寻找价格
            skuprice: '',
            chooseItemskuCode: '',
            chooseGoodsItem: '',
            isService: '',  //是否是服务，是服务类型不可以增加服务数据，
            canAddGoods: canAddGoods,
            callback:callback || (()=>{}),
        }
    }


    blurState = {
        guogeModal: false,
    }
    getList = (isFirst = false, isLoadingMore = false,loading=true,refreshing=true) => {
        const { selectedId,listName } = this.state;
        listName?
        this.props.fetchList({
            witchList:listName,
            isFirst,
            isLoadingMore,
            paramsPrivate : {
                goodsClassificationId :selectedId,
                shopId: this.props.navigation.state.params.shopId
            },
            api:orderRequestApi.fetchshopGoodsClassificationQList,
            loading,
            refreshing
        }):null
    };
    componentDidMount() {
        const { serviceCatalogCode, shopId } = this.props.navigation.state.params
        let isService = false
        if (serviceCatalogCode === '1001' || serviceCatalogCode === '1003') {
            isService = true
        }
        let param = {
            shopId: shopId,
            serviceCatalogCode: serviceCatalogCode
        }
        this.setState({
            isService,
        })
        Loading.show()
        orderRequestApi.fetchQListByServiceCatalogCode(param).then((res) => {
            if (res && res.length) {
                let typeData = []
                res.forEach((item, index) => {
                    typeData.push({
                        id: item.id,
                        name: item.name,
                        data: []
                    })
                })
                this.setState({
                    typeData,
                    selectedId:typeData[0] && typeData[0].id,
                    listName:typeData[0] && typeData[0].id?('menu'+typeData[0] && typeData[0].id):''
                },()=>{
                    typeData[0] && typeData[0].id?this.getList(true, false):null
                })
            }
        }).catch(err => {
            console.log(err)
        });
    }
    chooseTypedata = (data) => {
        //请求分类下的数据
        this.setState({
            selectedId: data.id,
            listName:'menu'+data.id
        },()=>{
            this.getList(false, false);
        })
    }
    renderLeftView = () => {
        const { typeData, selectedId } = this.state
        return typeData.map((item, index) => {
            let chooseLeftItem = null
            if (item.id === selectedId) {
                chooseLeftItem = styles.chooseLeftItem
            }
            return (
                <TouchableOpacity
                    onPress={() => {
                        this.chooseTypedata(item)
                    }}
                    key={index}
                    style={[styles.leftItem, chooseLeftItem]}>
                    <View style={styles.leftItemContent}>
                        <Text>{item.name}</Text>
                    </View>
                </TouchableOpacity>
            )
        })
    }
    renderSeparator = () => {
        return <View style={styles.separator} />
    }
    addGoodsData = (item) => {
        let param = {
            goodsId: item.goodsId,
            shopId: this.props.navigation.state.params.shopId,
        }
        orderRequestApi.fetchShopGoodsSkuQList(param).then((res) => {
            if (res) {
                let skuAttr = res.skuAttr.attrList
                let skuAttrValue = res.skuAttrValue  //搜索价格的
                skuAttr.forEach((item) => {
                    if (item.attrValues) {
                        item.attrValues.forEach((skuItem) => {
                            skuItem.isSelected = false
                        })
                    }
                })
                let skuData = {
                    num: 1,   //当前商品的所有规格，默认数量是1个
                    skuAttr: skuAttr,
                }
                this.setState({
                    chooseGoodsItem: item,   //当前点击的商品
                    skuData,   //当前商品的所有规格
                    skuAttrValue,   //sku规格选择好以后，根据sku得到价格
                    skuGoodsName: item.goodsName  //当前商品的名称
                })
            }
            this.setState({ guogeModal: true })
        }).catch(err => {
            console.log(err)
        });
    }
    renderItem = (data) => {
        let item = data.item
        const {canAddGoods}=this.state
        let isVisible=false
        if (canAddGoods === -1 && item.purchased === 0 && item.goodsStatus == 'UP' && item.auditStatus == 'VERIFIED') {
            isVisible=true
        } else if (canAddGoods === 1 && item.purchased === 1 && item.goodsStatus == 'UP' && item.auditStatus == 'VERIFIED') {
            isVisible=true
        }else if(canAddGoods==3){
            isVisible=true
        }
        return isVisible?(
            <View style={styles.listItem} key={data.index}>
                <View style={styles.listImg}>
                    <ImageView
                        source={{
                            uri: getPreviewImage(item.mainPic),
                            cache: "force-cache"
                        }}
                        resizeMode="cover"
                        sourceWidth={getwidth(86)}
                        sourceHeight={getwidth(86)}
                    />
                </View>
                <View style={styles.lietItemRight}>
                    <View>
                        <Text style={styles.c2f14}>{item.goodsName}</Text>
                    </View>
                    <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
                        <View>
                            <Text style={styles.crf18}>￥ {keepTwoDecimal(item.discountPrice / 100)}</Text>
                        </View>
                        <TouchableOpacity
                            onPress={() => {
                                this.addGoodsData(item)
                            }}
                            style={{ width: 56, height: 56, justifyContent: 'center', alignItems: 'center' }}>
                            <Image source={add} />
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        ):null
    }
    getPriceskuAttrValue = (skuData) => {
        const { skuAttrValue, chooseGoodsItem } = this.state
        let needNum = skuData.skuAttr && skuData.skuAttr.length || 0
        let hasCode = []
        skuData.skuAttr.forEach((item) => {
            item.attrValues.forEach((valItem) => {
                if (valItem.isSelected) {
                    hasCode.push(valItem.code)
                }
            })
        })
        let price = ''
        let chooseItemskuCode = ''
        let skuName = ''
        if (hasCode.length === needNum) {
            skuAttrValue.find((item) => {
                let skuCode = item.skuCode
                let sum = 0
                hasCode.forEach((codeItem) => {
                    let index = skuCode.indexOf(codeItem)
                    if (index !== -1) {
                        sum += 1
                    }
                })
                if (sum === needNum) {
                    chooseItemskuCode = item.skuCode
                    chooseGoodsItem.platformShopPrice = item.discountPrice
                    price = item.discountPrice
                    skuName = item.skuName
                }
            })
        }
        this.setState({
            skuprice: price,
            skuName:skuName,
            chooseItemskuCode
        })
    }
    chooseSkuItem = (key, code) => {
        const { skuData } = this.state
        skuData.skuAttr.find((item) => {
            if (item.key === key) {
                item.attrValues.forEach((valItem) => {
                    if (valItem.code === code) {
                        valItem.isSelected = true
                    } else {
                        valItem.isSelected = false
                    }
                })
                return true
            }
        })
        this.getPriceskuAttrValue(skuData)
        this.setState({
            skuData
        })
    }
    renderGuige = () => {
        const { skuData } = this.state
        if (skuData.skuAttr && skuData.skuAttr.length) {
            return skuData.skuAttr.map((item, index) => {
                return (
                    <View style={{ width: getwidth(270) }} key={index}>
                        <View><Text>{item.name}</Text></View>
                        <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                            {
                                item.attrValues.map((chooseItem,index2) => {
                                    let chooseBorderColor = styles.nochooseBorderColor
                                    let chooseText = styles.nochooseText
                                    if (chooseItem.isSelected) {
                                        chooseBorderColor = styles.chooseBorderColor
                                        chooseText = styles.chooseText
                                    }
                                    return (
                                        <TouchableOpacity
                                            key={index2}
                                            onPress={() => { this.chooseSkuItem(item.key, chooseItem.code) }}
                                            style={[chooseBorderColor, { width: getwidth(66), marginLeft: 10, marginTop: 10, height: 26, justifyContent: 'center', alignItems: 'center', borderWidth: 0.5, borderRadius: 10 }]}>
                                            <Text style={chooseText}>{chooseItem.name}</Text>
                                        </TouchableOpacity>
                                    )
                                })
                            }
                        </View>
                    </View>
                )
            })
        }
    }
    getDataAndSum = (data) => {
        let resData = []
        data.forEach((item) => {
            let flag = false
            resData.find((oneItem) => {
                if (item.goodsSkuCode === oneItem.goodsSkuCode && item.goodsId === oneItem.goodsId) {
                    flag = true
                    oneItem.sum = oneItem.sum + 1
                }
            })
            if (!flag) {
                let newone = { sum: 1, ...item }
                newone.discountPrice = item.platformShopPrice
                resData.push(newone)
            }
        })

        return resData
    }
    changeChoosedItemSum = (data, flag) => {
        let { orderData } = this.state
        let indexOf = -1
        orderData.find((item, index) => {
            if (item.goodsSkuCode === data.goodsSkuCode && item.goodsId === data.goodsId) {
                item.sum += flag
                if (item.sum === 0) {
                    indexOf = index
                }
                return true
            }
        })
        if (indexOf !== -1) {
            orderData.splice(indexOf, 1)
        }
        this.setState({
            orderData
        })
    }
    renderChooseItem = () => {
        let { orderData } = this.state
        return orderData.map((item,index) => {
            let price = item.skuprice || item.discountPrice
            return (
                <View style={{ width: width, height: 66, paddingHorizontal: 10 }} key={index}>
                    <View style={{ width: width - 20, height: 66, borderBottomColor: '#F1F1F1', borderBottomWidth: 1, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
                        <View style={{ width: (width - 20) / 3 * 2, height: 66, alignItems: 'center', justifyContent: 'space-between', flexDirection: 'row', paddingLeft: 10 }}>
                            <View>
                                <Text style={styles.c2f14}>{item.goodsName}</Text>
                                <Text style={styles.c9f12}>{item.skuName}</Text>
                            </View>
                            <Text style={styles.crf18}>￥ {keepTwoDecimal(price * item.sum / 100)}</Text>
                        </View>
                        <View style={{ width: (width - 20) / 3, flexDirection: 'row', height: 66, alignItems: 'center', paddingRight: 15 }}>
                            <TouchableOpacity
                                onPress={() => {
                                    this.changeChoosedItemSum(item, -1)
                                }}
                                style={{ marginRight: 10, width: getwidth(44), height: getwidth(44), justifyContent: 'center', alignItems: 'flex-end' }}><Image source={jian} /></TouchableOpacity>
                            <View style={{ marginRight: 10, justifyContent: 'center', }}><Text>{item.sum}</Text></View>
                            <TouchableOpacity
                                onPress={() => {
                                    this.changeChoosedItemSum(item, +1)
                                }}
                                style={{ width: getwidth(44), height: getwidth(44), justifyContent: 'center' }}><Image source={add} /></TouchableOpacity>
                        </View>
                    </View>
                </View>
            )
        })
    }
    addSkuChooseGoods = (skuprice) => {
        let { orderData, skuData, chooseItemskuCode, chooseGoodsItem, isService,skuName} = this.state
        let flag = false
        orderData.find((item) => {
            if (item.goodsSkuCode === chooseItemskuCode && item.goodsId === chooseGoodsItem.goodsId) {
                item.sum += skuData.num
                flag = true
                return true
            }
        })
        if (isService) {
            const param={skuName:skuName, skuprice: skuprice, sum: skuData.num, goodsSkuCode: chooseItemskuCode, ...chooseGoodsItem }
            if (!flag) {
                // orderData = []
                orderData.push(param)
            }
        } else {
            if (!flag) {
                orderData = orderData.concat({skuName:skuName, skuprice: skuprice, sum: skuData.num, goodsSkuCode: chooseItemskuCode, ...chooseGoodsItem })
            }
        }
        this.setState({
            orderData,
            guogeModal: false,
            chooseItemskuCode: '',
            chooseGoodsItem: '',
            skuprice: '',
        })
    }
    savedata = () => {
        const { orderData } = this.state
        const { navigation } = this.props
        const {  serviceData= [],addsServiceGoodsData ,addGoodsSeat,addsServiceGoodsDataShop} = navigation.state.params
        let needFetch = navigation.state.params.needFetch
        if (needFetch) {
            let param = {
                itemId: navigation.state.params.itemId,
                orderId: navigation.state.params.orderId,
                shopId: navigation.state.params.shopId,
                goods: []
            }
            orderData.forEach((item) => {
                if (item.sum > 1) {
                    while (item.sum) {
                        param.goods.push({
                            goodsId: item.goodsId,
                            goodsSkuCode: item.goodsSkuCode
                        })
                        item.sum--
                    }
                } else {
                    param.goods.push({
                        goodsId: item.goodsId,
                        goodsSkuCode: item.goodsSkuCode
                    })
                }
            })
            orderRequestApi.fetchShopPurchaseOrderMUserCreate(param).then((res) => {
                let initDataDidMount = navigation.state.params.initDataDidMount
                if (initDataDidMount) {
                    initDataDidMount(navigation.state.params.orderId)
                }
                this.state.callback()
                navigation.goBack()
            }).catch(err => {
                console.log(err)
            });
            return
        }
        // if (addsServiceGoodsData && addGoodsSeat) {
        //     addsServiceGoodsData(addGoodsSeat, orderData)
        // } 
       if (addsServiceGoodsData) {
            let neworderData = JSON.parse(JSON.stringify(orderData))
            addsServiceGoodsData(neworderData)
        } else if (addsServiceGoodsDataShop) {
            addsServiceGoodsDataShop(orderData)
        }
        this.state.callback()
        navigation.goBack()
    }
    closeOrderListModal=()=>{
        this.setState({
            orderVisible: false,
            orderBtnVisible: true
        })
    }
    render() {
        const { navigation,longLists } = this.props
        const { orderData,chooseItemskuCode,store, guogeModal, orderVisible, orderBtnVisible, typeData, selectedId, skuData, skuGoodsName, skuprice } = this.state
        let goodsData = []
        typeData.forEach((item) => {
            if (item.id === selectedId) {
                goodsData = item.data
            }
        })
        console.log('orderData',orderData)
        const {  listName } = this.state;
        const lists=longLists[listName] && longLists[listName].lists || []
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='编辑菜单'
                    rightView={
                        <TouchableOpacity
                            onPress={this.savedata}
                            style={styles.rightSave}>
                            <Text style={styles.cff17}>保存</Text>
                        </TouchableOpacity>
                    }
                />
                <Modal
                    visible={guogeModal}
                    transparent={true}
                    onRequestClose={() => {
                        this.setState({
                            guogeModal: false,
                            skuprice: '',
                            chooseItemskuCode: '',
                            chooseGoodsItem: '',
                        })
                    }}
                >
                    <View style={{ position: 'absolute', width: width, height: height, backgroundColor: '#000', opacity: 0.5, justifyContent: 'center', alignItems: 'center' }}>
                    </View>
                    <View style={styles.modalChoose}>
                        <View style={{ flexDirection: 'row' }}>
                            <View style={{ height: 54, width: getwidth(270 - 88), marginLeft: getwidth(44), justifyContent: 'center', alignItems: 'center' }}>
                                <Text style={{ color: '#030303', fontSize: 17 }}>{skuGoodsName}</Text>
                            </View>
                            <TouchableOpacity
                                onPress={() => {
                                    this.setState({
                                        guogeModal: false,
                                        skuprice: '',
                                        chooseItemskuCode: '',
                                        chooseGoodsItem: ''
                                    })
                                }}
                                style={{ width: getwidth(44), height: getwidth(44), justifyContent: 'center', alignItems: 'center', marginRight: 0 }}
                            >
                                <Image source={close} />
                            </TouchableOpacity>
                        </View>
                        <View style={{ width: getwidth(270), flexDirection: 'row', paddingHorizontal: 15, flexWrap: 'wrap' }}>
                            {
                                this.renderGuige()
                            }
                        </View>
                        <View style={{ flexDirection: 'row', width: getwidth(270), height: 26, justifyContent: 'flex-end', alignItems: 'center', paddingHorizontal: 15, marginTop: 18 }}>
                            <TouchableOpacity
                                onPress={() => {
                                    if (skuData.num === 1) {
                                        Toast.show('数量不能少于一个哦')
                                        return
                                    }
                                    skuData.num -= 1
                                    this.setState({ skuData })
                                }}
                                style={{ marginRight: 10, width: getwidth(44), height: getwidth(44), justifyContent: 'center', alignItems: 'center' }}><Image source={jian} /></TouchableOpacity>
                            <View style={{ marginRight: 10, justifyContent: 'center', alignItems: 'center' }}><Text>{skuData.num}</Text></View>
                            <TouchableOpacity
                                onPress={() => {
                                    skuData.num += 1
                                    this.setState({ skuData })
                                }}
                                style={{ width: getwidth(44), height: getwidth(44), justifyContent: 'center', alignItems: 'center' }}><Image source={add} /></TouchableOpacity>
                        </View>
                        <View style={{ marginTop: 16, height: 45, borderBottomLeftRadius: 10, borderBottomRightRadius: 10, backgroundColor: '#E5E5E5', flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
                            <View style={{ marginLeft: 15 }}>
                                <Text style={{ color: '#EE6161', fontSize: 18 }}>{chooseItemskuCode ? `￥${math.multiply(math.divide(skuprice, 100),skuData.num) }` : '请选择规格'}</Text>
                            </View>
                            <TouchableOpacity
                                disabled={chooseItemskuCode?false:true}
                                onPress={() => { this.addSkuChooseGoods(skuprice) }}
                                style={{ marginRight: 15, width: getwidth(60), height: 45, justifyContent: 'center', alignItems: 'center' }}>
                                <Text style={{ color: chooseItemskuCode?'#007AFF':'#ccc', fontSize: 17 }}>添加</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
                <View style={styles.mainview}>
                    <View style={styles.leftView}>
                        <ScrollView showsVerticalScrollIndicator={false}>
                            {
                                this.renderLeftView()
                            }
                        </ScrollView>
                    </View>
                    <View style={styles.rightView}>
                        <View style={styles.titleView}>
                            <Text style={styles.c2f14}>热销</Text>
                        </View>
                        <FlatListView
                            style={styles.flatList}
                            renderItem={data => this.renderItem(data)}
                            ItemSeparatorComponent={this.renderSeparator}
                            store={{
                                ...(longLists[listName] || {}),
                                page:longLists[listName] &&longLists[listName].listsPage || 1
                            }}
                            data={lists}
                            numColumns={1}
                            refreshData={() =>
                                this.getList(false, false)
                            }
                            loadMoreData={() =>
                                this.getList(false, true)
                            }
                            footerStyle={{ backgroundColor: '#fff' }}
                        />
                    </View>
                </View>
                <Modal
                    animationType={'fade'}
                    transparent={true}
                    visible={orderVisible}
                    onRequestClose={() => { this.setState({ orderVisible: false }) }}
                >
                    <TouchableOpacity 
                        activeOpacity={1}
                        style={{flex:1,backgroundColor:'rgba(0,0,0,0.5)'}} 
                        onPress={this.closeOrderListModal}
                    />
                    <View style={{ width: width, height: 250+CommonStyles.footerPadding, backgroundColor: '#fff', paddingBottom:CommonStyles.footerPadding }}>
                        <View style={{ width: width, height: 47, flexDirection: 'row', borderBottomColor: '#F1F1F1', borderBottomWidth: 1 }}>
                            <View
                                style={{ width: width - getwidth(94), marginLeft: getwidth(47), height: 47, justifyContent: 'center', alignItems: 'center' }}
                            ><Text style={{ color: '#000000', fontSize: 17 }}>收起订单</Text></View>
                            <TouchableOpacity
                                onPress={this.closeOrderListModal}
                                style={{ width: getwidth(47), height: getwidth(47), justifyContent: 'center' }}
                            >
                                <Image source={close} />
                            </TouchableOpacity>
                        </View>
                        <ScrollView showsVerticalScrollIndicator={false}>
                            {
                                this.renderChooseItem()
                            }
                        </ScrollView>
                    </View>
                </Modal>
                {
                    orderBtnVisible && (
                        <TouchableOpacity
                            onPress={() => { this.setState({ orderVisible: true, orderBtnVisible: false }) }}
                            style={styles.openOrder} activeOpacity={0.8}>
                            <Text style={{ color: '#000000', fontSize: 17 }}>展开订单</Text>
                        </TouchableOpacity>

                    )
                }
            </View>
        )
    }
}
export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
     }),
    (dispatch) => ({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
        shopSave: (params={})=> dispatch({ type: "shop/save", payload: params}),
     })
)(EditorMenu);
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    rightSave: {
        width: getwidth(50),
        height: '100%',
        justifyContent: 'center'
    },
    separator: {
        borderColor: '#F1F1F1',
        width: width,
        height: 0,
        borderWidth: 0.5
    },
    cff17: {
        color: '#FFFFFF',
        fontSize: 17
    },
    c2f14: {
        color: '#222222',
        fontSize: 14
    },
    c7f14: {
        color: '#777777',
        fontSize: 14
    },
    crf18: {
        color: '#EE6161',
        fontSize: 18
    },
    c9f12: {
        color: '#999999',
        fontSize: 12
    },
    mainview: {
        width: width,
        flex: 1,
        flexDirection: 'row',
    },
    leftView: {
        width: getwidth(114),
        height: height - 44 - CommonStyles.headerPadding,
    },
    leftItem: {
        width: getwidth(114),
        height: 45,
        paddingHorizontal: 15,
        backgroundColor: '#F1F1F1'
    },
    chooseLeftItem: {
        borderLeftColor: '#EE6161',
        borderLeftWidth: 2
    },
    leftItemContent: {
        width: getwidth(84),
        height: 45,
        borderBottomColor: '#E5E5E5',
        borderBottomWidth: 1,
        justifyContent: 'center',
        alignItems: 'center'
    },
    rightView: {
        width: width - getwidth(114),
        height: height - 44 - CommonStyles.headerPadding,
        backgroundColor: '#fff'
    },
    titleView: {
        width: '100%',
        height: 33,
        justifyContent: 'center',
        paddingLeft: 15,
        backgroundColor: '#fff'
    },
    flatList: {
        width: width - getwidth(114),
        height: '100%',
    },
    listItem: {
        width: width - getwidth(114),
        height: 110,
        paddingHorizontal: 15,
        flexDirection: 'row'
    },
    listImg: {
        width: getwidth(86),
        height: 110,
        marginLeft: 6,
        justifyContent: 'center',
        alignItems: 'center'
    },
    lietItemRight: {
        width: width - getwidth(114 + 116),
        paddingVertical: 15,
        paddingLeft: 15,
        justifyContent: 'space-between'
    },
    modalChoose: {
        position: 'absolute',
        top: height / 2 - 120,
        left: (width - getwidth(270)) / 2,
        width: getwidth(270),
        backgroundColor: '#fff',
        borderColor: '#E5E5E5',
        borderWidth: 1,
        borderRadius: 12
    },
    chooseBorderColor: {
        borderColor: '#4A90FA'
    },
    chooseText: {
        color: '#4A90FA',
        fontSize: 14
    },
    nochooseBorderColor: {
        borderColor: '#CCCCCC'
    },
    nochooseText: {
        color: '#999999',
        fontSize: 14
    },
    openOrder: {
        width: width,
        height: 51+CommonStyles.footerPadding,
        justifyContent: 'center',
        alignItems: 'center',
        paddingBottom: 0+CommonStyles.footerPadding,
        backgroundColor: '#fff'
    }
})
