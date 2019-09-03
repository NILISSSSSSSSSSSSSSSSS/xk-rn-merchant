/**
 * 商品管理
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    TouchableOpacity,
    Platform,
    ScrollView
} from "react-native";
import { connect } from "rn-dva";
import math from '../../config/math.js';
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
const { width, height } = Dimensions.get("window");
import FlatListView from "../../components/FlatListView";
import ImageView from "../../components/ImageView";
const refundsList = [
    { title: "消费前随时退", key: "CONSUME_BEFORE" },
    { title: "预约时间前指定时间内可退", key: "RESERVATION_BEFORE_BYTIME" },
    { title: "预定时间前随时退", key: "RESERVATION_BEFORE" }
];
import ScrollableTabView from "react-native-scrollable-tab-view";
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar'
import { NavigationPureComponent } from "../../common/NavigationComponent";
import { getPreviewImage } from "../../config/utils";
const unchecked = require("../../images/index/unselect.png");
const checked = require("../../images/index/select.png");
class GoodsScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            page:0,
            categoryId: 0,
            userShop: props.userShop,
            currentTab: props.serviceCatalogList[0] || {},
            currentShop: props.userShop, //选择的店铺
            visible: false,
            deleteMany:false,//是否打开批量删除
            listName: 'goods' + ( props.serviceCatalogList[0] && props.serviceCatalogList[0].code || ''),
            discountParams:{
                shopdDiscount: props.userShop.discount || 0,
                shopDiscountType:props.userShop.discountType || 'THE_CUSTOM_DISCOUNT',
            }
        };

        // this._didFocusSubscription = props.navigation.addListener('didFocus', async (payload) =>{
        //     this.getList(true, false);
        // });
    }

    blurState = {
        visible: false,
    }
    componentDidMount(){
        this.getList(true, false);
    }
    getShopDetail=()=>{
        requestApi.shopDetails({ id: this.state.currentShop.id }).then((res) => {
            // 获取店铺折扣
            res && res.detail?
            this.setState({
                discountParams:{
                    shopdDiscount:res.detail.discount || 0,
                    shopDiscountType:res.detail.discountType || 'THE_CUSTOM_DISCOUNT',
                }
            })
            : null;
          });
    }

    getList = (isFirst = false, isLoadingMore = false,loading=true,refreshing=true) => {
        const { currentTab, currentShop } = this.state;
        this.props.fetchList({
            witchList:'goods' + currentTab.code,
            isFirst,
            isLoadingMore,
            paramsPrivate : {
                goodsCategoryId: currentTab.code,
                shopId: currentShop.id
            },
            api:requestApi.goodsQList,
            loading,
            refreshing
        })
    };

    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this.selectGoods(2)
        RightTopModal.hide()
    }
    goDetail=(item)=>{
        this.props.navigation.navigate("GoodsDetail", {
            id: item.goodsId,
            currentShop: this.state.currentShop,
            refundsList,
            discountParams:this.state.discountParams,
            canEdit: true,
            callback: (page) => {
                if(page || page===0){
                    const { serviceCatalogList } = this.props;
                    this.setState({
                        page,
                        currentTab: serviceCatalogList[page],
                        listName: 'goods' + serviceCatalogList[page].code
                    }, () => {
                        this.getList(true, false)
                    })
                }
            }
        })
    }
    selectGoods=(all,index)=>{ //all=0:单选，all=1，全选，all=2，全不选
        const {listName}=this.state
        const {longLists}=this.props
        let lists=longLists[listName] &&longLists[listName].lists || []
        if(all){
            lists.map((item)=>all==1?item.checked=true:item.checked=false)
        }else{
            lists[index].checked= lists[index].checked?false:true
        }
        this.props.shopSave({
            longLists:{
                ...longLists,
                [listName]:{
                    ...longLists[listName],
                    lists
                }
            }
        })
    }
    renderItem = ({ item, index }) => {
        const listsLong=this.props.longLists['goods' + this.state.currentTab.code]
        let length = listsLong && listsLong.lists && listsLong.lists.length || 0
        const viewStyle = {
            borderTopLeftRadius: index == 0 ? 8 : 0,
            borderTopRightRadius: index == 0 ? 8 : 0,
            borderBottomLeftRadius:index == length - 1 ? 8 : 0,
            borderBottomRightRadius:index == length - 1 ? 8 : 0
        };
        // goodsStatus	String	否	商品上下架状态，上架UP下架DOWN系统下架SYS_DOWN
        switch (item.goodsStatus) {
            case "UP":item.goodsStatus1 = "上架";break;
            case "DOWN":item.goodsStatus1 = "下架";break;
            case "SYS_DOWN":item.goodsStatus1 = "系统下架";break;
        }
        let mainPic = item.mainPic ? item.mainPic.replace(" ", "") : ""
        return (
            <TouchableOpacity
                style={[styles.itemContent, viewStyle,{paddingLeft:this.state.deleteMany?3:15}]}
                key={index}
                onPress={() =>this.goDetail(item)}
                disabled={this.state.deleteMany}
            >
                {/* <View style={styles.itemContentLeft}> */}
                {
                    this.state.deleteMany?
                    <TouchableOpacity style={{padding:12}} onPress={()=>this.selectGoods(0,index)}>
                        <Image source={item.checked?checked:unchecked}/>
                    </TouchableOpacity>:null
                }
                <View
                    style={{
                        borderRadius: 10,
                        overflow: "hidden",
                        width: 100,
                        height: 100
                    }}
                >
                    <ImageView
                        source={{
                            uri: getPreviewImage(mainPic),
                            cache: "force-cache"
                        }}
                        resizeMode="cover"
                        sourceWidth={100}
                        sourceHeight={100}
                    />
                </View>

                {/* </View> */}
                <View style={styles.itemContentRight}>
                    <Text
                        style={{
                            color: "#222222",
                            fontSize: 14,
                            lineHeight: 18,
                            marginBottom: 4
                        }}
                    >
                        {item.goodsName}
                    </Text>
                    <Text style={styles.smallText}>
                        类型: {this.state.currentTab.name}
                    </Text>
                    <Text style={styles.smallText}>
                        价格:{" "}
                        <Text style={{ color: "#FF545B" }}>
                            ￥{math.divide(item.discountPrice, 100)}
                        </Text>{" "}
                    </Text>
                    <Text style={styles.smallText}>
                        状态: {item.goodsStatus1}{" "}
                    </Text>
                </View>
            </TouchableOpacity>
        );
    };
    changeTab = (page,itemTab) => {
        const { longLists } = this.props;
        this.selectGoods(2)
        this.setState({
            page,
            currentTab: itemTab,
            listName: 'goods' + itemTab.code
        }, () => {
            const {listName}=this.state
            const isExist=longLists[listName] && longLists[listName].lists && longLists[listName].lists.length>0
            this.getList(false, false,true,!isExist);
        });
    };
    addGoods=()=>{
        const { navigation, serviceCatalogList } = this.props;
        const {  currentShop,discountParams } = this.state;
        navigation.navigate("GoodsEditor", {
            callback: (page) => {
                if(page || page===0){
                    this.setState({
                        page,
                        currentTab:serviceCatalogList[page],
                        listName: 'goods' + serviceCatalogList[page].code
                    }, () => {
                        this.getList(true, false)
                    })
                }
            },
            currentShop: currentShop,
            refundsList,
            discountParams
        });
    }
    deleteMany=()=>{
        this.setState({deleteMany:true,visible:false})
    }
    deleteGoods=()=>{
        console.log(CustomAlert.onShow)
        const {listName}=this.state
        let lists=this.props.longLists[listName] && this.props.longLists[listName].lists || []
        let goodIds=[]
        lists.map((item)=>{item.checked?goodIds.push(item.goodsId):null})
        if(goodIds.length>0){
            CustomAlert.onShow(
                "confirm",
                "商品删除后不可恢复，只能重新添加",
                "确定删除所选商品吗？",
                () => {
                    Loading.show()
                    requestApi.xkShopGoodsDelete({goodIds}).then(()=>{
                        this.setState({ deleteMany:false})
                        this.getList(false, false)
                    }).catch(()=>{
          
                    });
                },
                () => {},
                botton1Text = "取消",
                botton2Text = "确定",
                botton1TextStyle={color:'#222'}
            )
        }else{
            Toast.show('请先选择要删除的商品')
        }

    }
    renderFlast=(name)=>{
        const { navigation, longLists} = this.props;
        const {  listName } = this.state;
        const lists=longLists[listName] && longLists[listName].lists || []
        return(
            <FlatListView
                type='SHRZ_goodsManage'
                style={styles.flatListView}
                renderItem={data => this.renderItem(data)}
                tabLabel={name}
                ItemSeparatorComponent={() => (
                    <View style={styles.flatListLine} />
                )}
                key={name}
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
            />
        )
    }
    showPopover(modalType) {
        this.setState({modalType})
        let options=[]
        if(modalType=='selectShop'){
            options=[...this.props.juniorShops]
            options.map(item=>{
                item.title=item.name
                item.onPress=()=>{
                    this.setState({currentShop:item},()=>{
                        this.getList( false, false )
                        this.getShopDetail()
                    })
                }
            })
        }else{
            options=[
                {title:'新增商品',onPress:this.addGoods},
                {title:'批量删除',onPress:this.deleteMany},
            ]
        }
        RightTopModal.show({
           options,
            children:<View style={{position:'absolute',top:Platform.OS=='ios'? 0:-CommonStyles.headerPadding}}>{this.renderHeader()}</View>,
            sanjiaoStyle:{right:modalType=='selectShop'?50:5}
        })
    }
    renderHeader=()=>{
        const { navigation } = this.props;
        const {deleteMany}=this.state
        return(
            <Header
            navigation={navigation}
            goBack={true}
            title={deleteMany?'商品管理':null}
            centerView={deleteMany?null:
                <View
                    style={{
                        position: "relative",
                        flex: 1,
                        alignItems: "center"
                    }}
                >
                    <Text style={{ fontSize: 17, color: "#fff" }}>
                        商品管理
                    </Text>
                    <TouchableOpacity
                        onPress={() => this.showPopover('selectShop')}
                        style={{ width: 50, alignItems: 'flex-end', position: 'absolute', right: 0, top: 0, }}
                    >
                        <Text style={{ fontSize: 17, color: "#fff" }}>
                            筛选
                        </Text>
                    </TouchableOpacity>
                </View>
            }
            rightView={
                <TouchableOpacity
                    onPress={() => {
                        if(deleteMany){
                            this.setState({deleteMany:false})
                            this.selectGoods(2)
                        }else{
                            this.showPopover('selectAdd')
                        }
                    }}
                    style={{ width: 50, alignItems: 'center',marginRight:deleteMany?17:0  }}
                >
                {
                    deleteMany?<Text style={{color:'#fff',fontSize:17}}>返回</Text>:
                    <Image source={require('../../images/caiwu/add.png')} />
                }
                </TouchableOpacity>

            }
        />

        )
    }

    render() {
        const { navigation, serviceCatalogList,longLists } = this.props;
        const {  currentTab, listName,deleteMany } = this.state;
        const lists=longLists[listName] && longLists[listName].lists || []
        return (
            <View style={styles.container}>
                {this.renderHeader()}
                {
                    serviceCatalogList.length>0 ?
                    deleteMany?
                    <View style={{flex:1}}>
                        <View style={[styles.topTabView,{paddingLeft:25,flexDirection:'row',overflow:'hidden',paddingBottom:0,height:38}]}>
                            <View>
                                <Text style={{fontSize: 14,color:'#fff',fontWeight:'bold',marginTop:12}}>{currentTab.name}</Text>
                                <View style={[styles.underlineStyle,{marginBottom:0,marginTop:9}]}></View>
                            </View>
                        </View>
                        {this.renderFlast(0)}
                    </View>
                    :
                    <ScrollableTabView
                        initialPage={0}
                        page={this.state.page}
                        onChangeTab={({ i }) => {
                            this.changeTab(i,serviceCatalogList[i]);
                        }}
                        renderTabBar={() => (
                            <DefaultTabBar
                                underlineStyle={styles.underlineStyle}
                                activeTextColor="#fff"
                                inactiveTextColor={"rgba(255,255,255,.5)"}
                                tabBarTextStyle={{fontSize: 14}}
                                tabStyle={styles.topTabView}
                                style={{height:38,overflow:'hidden',backgroundColor: CommonStyles.globalHeaderColor}}
                            />
                        )}
                    >
                        {
                            serviceCatalogList.map(
                            (itemTab, index) => {
                                return this.renderFlast(itemTab.name)
                            }
                        )}
                    </ScrollableTabView>:null
                }
                {
                    deleteMany?
                    <View style={styles.bottomView}>
                        <TouchableOpacity
                            style={[styles.bottomViewItem,{paddingHorizontal:15,marginLeft:10}]}
                            onPress={()=>{
                                this.selectGoods(lists.find(item=>!item.checked) ?1:2)
                            }}
                        >
                            <Image source={lists.find(item=>!item.checked) || lists.length==0?unchecked :checked} />
                            <Text style={{color:'#222',marginLeft:10}}>全选</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={[styles.bottomViewItem,{backgroundColor:lists.find((item)=>item.checked)? CommonStyles.globalRedColor:'#DFDFDF',width:100}]}
                            onPress={this.deleteGoods}
                        >
                            <Text style={{color:'#fff',fontSize:15}}>删除</Text>
                        </TouchableOpacity>
                    </View>:
                    null
                }
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    bottomView:{
        height:50+CommonStyles.headerPadding,
        justifyContent:'space-between',
        flexDirection:'row',
        backgroundColor:'#fff'
    },
    bottomViewItem:{
        flexDirection:'row',
        alignItems:'center',
        height:50,
        justifyContent:'center'
    },
    topTabView:{
        backgroundColor: "#4A90FA",
        height: 38
    },
    modal: {
        width: width,
        height: height - 44 - CommonStyles.headerPadding,
        marginTop: 44 + CommonStyles.headerPadding,
        alignItems: "flex-end",
        backgroundColor: "rgba(0,0,0,0.5)",
        position: "absolute",
        top: 0,
        left: 0
    },
    underlineStyle:{
        backgroundColor: "#fff",
        height: 8,
        borderRadius: 10,
        marginBottom: -6,
    },
    header: {
        width: width,
        height: 44 + CommonStyles.headerPadding,
        paddingTop: CommonStyles.headerPadding,
        overflow: "hidden"
    },
    headerView: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center",
        width: width,
        height: 44 + CommonStyles.headerPadding,
        paddingTop: CommonStyles.headerPadding,
        backgroundColor: CommonStyles.globalHeaderColor
    },
    flatListLine: {
        height: 1,
        backgroundColor: CommonStyles.globalBgColor
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%"
    },
    left: {
        width: 50
    },
    center: {
        flex: 1
    },
    titleText: {
        fontSize: 17,
        color: "#fff"
    },
    flatListView: {
        backgroundColor: CommonStyles.globalBgColor,
        marginBottom: 10,
        flex: 1,
        width: width
    },
    itemContent: {
        flexDirection: "row",
        alignItems: "center",
        padding: 15,
        width: width - 20,
        marginLeft: 10,
        backgroundColor: "#fff"
        // ...CommonStyles.shadowStyle
    },
    itemContentRight: {
        flex: 1,
        marginLeft: 15
    },
    smallText: {
        color: "#999999",
        fontSize: 12,
        marginTop: 3
    },
    itemBottom: {
        flexDirection: "row",
        alignItems: "center",
        height: 40,
        justifyContent: "flex-end",
        paddingHorizontal: 14
    },
    bottomText: {
        marginLeft: 14,
        fontSize: 12
    },
    payBottom: {
        borderColor: "#EE6161",
        borderWidth: 1,
        paddingHorizontal: 18,
        paddingVertical: 3,
        marginLeft: 20,
        borderRadius: 12
    },
    transView: {
        backgroundColor: "#F6F6F6",
        // opacity:0.65,
        padding: 9,
        marginTop: 12
    },
    row: {
        flexDirection: "row",
        alignItems: "center"
    },
    separator: {
        width: width,
        height: 1,
        backgroundColor: CommonStyles.globalBgColor
    },
    modalView: {
        width: 168,
        borderColor: "#DDDDDD",
        borderBottomLeftRadius: 10,
        marginLeft: 25,
        overflow: "hidden",
        position:'relative',
        backgroundColor: "white",
        maxHeight: 250,
        overflow:'hidden'
    },
    line: {
        padding: 15,
        borderBottomWidth: 1,
        borderColor: "#F1F1F1"
    },
    shopNameView: {
        backgroundColor: CommonStyles.globalHeaderColor,
        borderRadius: 10,
        alignItems: "center",
        padding: 6,
        width: 100,
        marginVertical: 10,
        marginLeft: 25
    }
});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
        serviceCatalogList:state.shop.serviceCatalogList || [],
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
     }),
    (dispatch) => ({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
        shopSave: (params={})=> dispatch({ type: "shop/save", payload: params}),
     })
)(GoodsScreen);
