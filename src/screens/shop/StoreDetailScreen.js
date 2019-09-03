/**
 * 店铺信息
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,

    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity
} from "react-native";
import math from '../../config/math.js';
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from "../../components/ImageView";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
import ModelConfirm from "../../components/Model";
import * as requestApi from "../../config/requestApi";
import {fetchmShopAuthDetail} from '../../config/taskCenterRequest'
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { NavigationPureComponent } from "../../common/NavigationComponent";
const { width, height } = Dimensions.get("window");
import {detailItems} from './storeEditor/ItemsData'
class StoreDetailScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = props.navigation.state.params || {};
        const userShop = props.userShop;
        let id
        if(params && params.shopId){
            id = params.shopId
        }else{
            id = userShop.id
        }
        this.state = {
            modelVisible: false,
            userShop,
            currentShop: {
                detail: {
                    id: id,
                    industry: []
                },
                slaveList: [] //下级店铺
            },
            propsParams: params || { shopId: userShop.id },
            callback: (params && params.callback) || (() => { }),
            page: params.page,
            showBigPicArr: [],
            showIndex: 0,
            showBigModal: false,
        };
    }

    blurState = {
        modelVisible: false,
        showBigModal: false,
    }
    componentDidMount() {
        this.initData()
    }
    getIndustryName=(res)=>{
        let detail = res.detail;
        let industryName = [];
        requestApi
            .industryLevelOneList({ limit: 0, page: 0 })
            .then(data => {
                if (data && data.length != 0) {
                        for (let item of data.data) {
                            for (itemSelect of detail.industry) {
                                if ( itemSelect.levelOneCode == item.code && industryName.indexOf( item.name ) < 0 ) {
                                    industryName.push(item.name);
                                }
                            }
                        }
                }
                detail.industryName = industryName.join(";");
                console.log('industryName',industryName,res.detail.industryName)
                this.setState({ currentShop: {...res,detail} });
            })
            .catch(() => {
                this.setState({ currentShop: res });
                Loading.hide();
            });
    }
    initData=()=>{
        const {pagee,shopId,merchantId}=this.props.navigation.state.params || {}
        Loading.show()
        let func=requestApi.shopDetails;
        let params={ id:this.state.currentShop.detail.id}
        if(pagee === 'show'){
            func=fetchmShopAuthDetail
            params={id:shopId,merchantId}
        }
        func(params).then((res)=>{
            if (res && res.detail) {
                    let industryName = [];
                    if((res.detail.industry || [])[0].levelOneName===null){
                        this.getIndustryName(res)
                    }else{
                        (res.detail.industry || []).map((item)=>{
                            industryName.push(item.levelOneName)
                        })
                    }
                res.detail.rollingPics=res.detail.rollingPics?res.detail.rollingPics.map((item)=>{
                    item=item && item.url || null;
                    return item
                }):[]
                res.detail.industryName = industryName.join(";");
                this.setState({ currentShop: res });
            }
        }).catch((err)=>{
            console.log(err)
          });
    }

    quitBind = () => {
        //取消绑定
        this.props.navigation.navigate("Bindstore", {
            shopId: this.state.currentShop.detail.id
        });
        this.setState({ modelVisible: false });
    };
    renderImage = itemLine => {
        return (
            <View style={{flexDirection: "row",flexWrap: "wrap",width:width-50,marginTop:itemLine.title?15:0}} >
                {itemLine.value.map((valueImage, index) => {
                    return (
                        <TouchableOpacity
                            key={index}
                            style={{
                                borderRadius: 4,
                                marginRight: (index + 1) % 3 === 0 ? 0 : 15,
                                marginTop: index < 3 ? 0 : 10,
                                overflow: "hidden",
                                position:'relative'
                            }}
                            onPress={()=>{
                                let temp=[]
                                itemLine.value.map((item)=>{
                                    temp.push({
                                        type: 'images',
                                        url: item
                                    })
                                })
                                this.setState({
                                    showBigPicArr: temp,
                                    showIndex: index,
                                    showBigModal: true,
                                })
                            }}
                        >
                            <ImageView
                                key={index}
                                source={{ uri: valueImage }}
                                sourceWidth={(width - 80) / 3}
                                sourceHeight={(width - 80) / 3}
                                resizeMode="cover"
                            />
                             {valueImage ==this.state.currentShop.detail.cover && itemLine.title=='展示图片'? (
                                        <View style={styles.coverImageView} >
                                            <Text style={{ color: "white", fontSize: 10 }} > 封面 </Text>
                                        </View>
                                    ) : null}
                        </TouchableOpacity>
                    );
                })}
            </View>
        );
    };
    render() {
        const { navigation } = this.props;
        const { currentShop, page,showBigPicArr,showIndex,showBigModal } = this.state;
        const detail = currentShop.detail;
        let pagee = ''
        if(navigation.state.params){
            pagee = navigation.state.params.pagee
        }
        
        //是否能解绑
        let canUnBind = false;
        if (currentShop.shopType != "MASTER" && currentShop.isSelf == 0) {
            canUnBind = true;
        }
        let  rightView= (
            <TouchableOpacity
                style={styles.headerRightView}
                onPress={() => {
                    page ? null :
                    !detail.name?Toast.show('店铺信息未加载完成'):
                        navigation.navigate(
                            "ReceiptStaticQrCodeScreen",
                            {
                                title: detail.name,
                                storeId: detail.id,
                                logo: detail.logo || detail.cover,
                                lat:detail.lat,
                                lng:detail.lng
                            }
                        )
                }}
            >
                {page ?
                    <Text style={{ color: '#fff', fontSize: 17 }}>预览店铺</Text> :
                    <Image
                        source={require("../../images/shop/qrcode.png")}
                        resizeMode={"contain"}
                    />

                }
            </TouchableOpacity>
        )
        if(pagee && pagee === 'show'){
            rightView = <View style={styles.headerRightView}></View>
        }
        return (
            <View style={styles.container}>
                <Header
                    title="店铺信息"
                    navigation={navigation}
                    goBack={true}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerLeftView}
                            onPress={() => { navigation.goBack() }}
                        >
                            <Image source={require("../../images/mall/goback.png")} />
                        </TouchableOpacity>
                    }
                    rightView={rightView}
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        {detailItems(currentShop,navigation).map((item, index) => {
                            return (
                                <Content style={styles.contentItem} key={index}>
                                    {item.map((itemLine, indexLine) => {
                                        return itemLine.visible ===
                                            false ? null : (
                                                <View style={[ styles.line, {  borderBottomWidth: indexLine == item.length - 1 ? 0 : 1 ,flexDirection:itemLine.title=='店铺介绍'?'column':'row'} ]} key={indexLine} >
                                                    {
                                                        itemLine.title?<Text style={{ color: "#222222", fontSize: 14 }} >{itemLine.title}{" "} </Text>:null
                                                    }

                                                    {
                                                        Object.prototype.toString.call( itemLine.value ) === "[object Array]"
                                                        ? this.renderImage( itemLine )
                                                        : <Text style={[{
                                                                color: itemLine.color ? itemLine.color : "#222222",
                                                                fontSize: 14,
                                                                flex: 1,
                                                                },itemLine.title=='店铺介绍'?{marginTop:15,textAlign:'left' ,}:{marginLeft: 10,textAlign:'right' ,}]}
                                                            >
                                                            {itemLine.value}
                                                        </Text>
                                                    }
                                                </View>
                                            );
                                    })}
                                </Content>
                            );
                        })}
                    </View>
                </ScrollView>
                <ShowBigPicModal
                    ImageList={showBigPicArr}
                    visible={showBigModal}
                    showImgIndex={showIndex}
                    onClose={() => {
                        this.setState({
                            showBigModal: false
                        })
                    }}
                />
                <ModelConfirm
                    title="确定取消绑定？取消后将失去对该店铺的所有权限"
                    type="confirm"
                    visible={this.state.modelVisible}
                    onShow={() => this.setState({ modelVisible: true })}
                    onConfirm={() => this.quitBind()}
                    onClose={() => this.setState({ modelVisible: false })}
                />
                {
                pagee &&  pagee === 'show' ? null: (
                        <View style={[styles.bottomView]}>
                        {
                            canUnBind ? (
                                <TouchableOpacity
                                    style={[styles.bottomItemView,{borderRightWidth: 1,borderColor: "#f1f1f1",}]}
                                    onPress={() =>
                                        this.setState({ modelVisible: true })
                                    }
                                >
                                    <Text style={styles.bottomText}>取消绑定</Text>
                                </TouchableOpacity>
                            ) : null
                        }

                                <TouchableOpacity
                                    style={[{backgroundColor:canUnBind ?'#fff':CommonStyles.globalHeaderColor,width: canUnBind ? width / 2 : width},styles.bottomItemView]}
                                    onPress={() =>
                                        navigation.navigate("StoreEditor", {
                                            callback: data => {
                                                if(data){
                                                    this.state.callback();
                                                    this.initData()
                                                }
                                            },
                                            currentShop
                                        })
                                    }
                                >
                                    <Text
                                        style={[
                                            styles.bottomText,
                                            {
                                                color:canUnBind ?CommonStyles.globalHeaderColor: "#fff",
                                                fontSize:canUnBind ?14:17,

                                            }
                                        ]}
                                    >
                                        编辑店铺信息
                                    </Text>
                                </TouchableOpacity>
                    </View>
                    )
                }
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    content: {
        alignItems: "center",
        paddingBottom: 10
    },
    contentItem: {
        backgroundColor: "#fff",
        borderRadius: 10,
        width: width - 20,
        marginTop: 10
    },
    coverImageView: {
        backgroundColor: "rgba(0, 0, 0, 0.7)",
        justifyContent: "center",
        alignItems: "center",
        width: 40,
        height: 18,
        borderRadius: 10,
        position: "absolute",
        bottom: 0,
        right: 4
    },

    line: {
        flexDirection: "row",
        paddingVertical: 18,
        paddingHorizontal: 15,
        borderColor: "#F1F1F1",
        borderBottomWidth: 1,
        flexWrap:'wrap'
    },
    headerLeftView: {
        width: width / 3,
        alignItems: 'flex-start',
        paddingLeft: 18
    },
    headerRightView: {
        paddingRight: 18,
        width: width / 3,
        alignItems: 'flex-end'
    },
    contentTopText: {
        fontSize: 14,
        color: "#222222"
    },
    itemView: {
        width: width,
        paddingHorizontal: 10,
        paddingVertical: 10
    },
    itemTitleText: {
        fontSize: 16,
        color: "#333"
    },
    bottomView: {
        width: width,
        height: 50,
        marginBottom: CommonStyles.footerPadding,
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "center",
        backgroundColor: "#fff",
        borderColor: "#f7f7f7"
    },
    bottomText: {
        fontSize: 14,
        color: "#222222",
        width: width / 2,
        textAlign: "center"
    },
    bottomItemView:{
        height:50,
        alignItems:'center',
        justifyContent:'center'
    }
});

export default connect(
    (state) => ({
        user:state.user.user || {},
        userShop:state.user.userShop || {},
        merchantData:state.user.merchantData || {},
        shops: (state.user.merchantData || {}).shops || [],
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
     }),
     (dispatch) => ({
        shopSave: (params={})=> dispatch({ type: "shop/save", payload: params}),
        userSave: (params={})=> dispatch({ type: "user/save", payload: params}),
     })
)(StoreDetailScreen);
