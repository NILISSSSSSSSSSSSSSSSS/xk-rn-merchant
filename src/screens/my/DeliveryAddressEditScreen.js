/**
 * 新增收货地址
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
    TouchableHighlight,
    TouchableOpacity,
    Platform,
    Modal,
    Keyboard,
    BackHandler,
    KeyboardAvoidingView
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from "../../components/ImageView";
import TextInputView from "../../components/TextInputView";
import * as nativeApi from "../../config/nativeApi";
import * as requestApi from "../../config/requestApi";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
import CheckButton from "../../components/CheckButton";
import * as regular from "../../config/regular";
import CommonButton from "../../components/CommonButton";
import Switch from '../../components/Switch'
import { NavigationPureComponent } from "../../common/NavigationComponent";
import * as Address from '../../const/address'

const refunds = [
    { title: "消费前可退", key: "CONSUME_BEFORE" },
    { title: "限定时间前随时可退", key: "RESERVATION_BEFORE_BYTIME" },
    { title: "预定时间前随时退", key: "RESERVATION_BEFORE" }
];
const { width, height } = Dimensions.get("window");
class poiAddressEditScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
    };

    constructor(props) {
        super(props);
        const { store } = this.props;
        const params = props.navigation.state.params;
        const currentAdress = (params && params.currentAdress) || {};
        console.log('currentAdress',currentAdress)
        this.oldRequesParams={
            receiver: currentAdress.receiver || "",
            phone: currentAdress.phone || "",
            provinceCode: currentAdress.provinceCode || "",
            cityCode: currentAdress.cityCode || "",
            districtCode: currentAdress.districtCode || "",
            street: currentAdress.street || "",
            label: currentAdress.label || "",
            poiName:currentAdress.poiName || '',
            poiAddress:currentAdress.poiAddress || "",
            lng: currentAdress.lng || '',
            lat: currentAdress.lat || '',
            isDefault: currentAdress.isDefault === 0 ? 0 : currentAdress.isDefault === 1 ? 1: 1 //是否默认(可以不传) 0：否 1：是
        }
        this.state = {
            types: [],
            requesParams: {...this.oldRequesParams},
            currentAdress: currentAdress,
            modalVisible: false,
            modalType: "area", //area地址选择，label标签选择
            selecteProvinceIndex: 0,
            selecteCityIndex: 0,
            selecteDistrictIndex: 0,
            areaName: currentAdress.provinceName? currentAdress.provinceName +"-" +currentAdress.cityName +"-" +currentAdress.districtName: "", //区县名
            areaSelectWrong: false,
            deleteAdress: params.deleteAdress || (() => {}),
            refreshList: params.refreshList || (() => {})
        };
        this._didFocusSubscription = props.navigation.addListener('didFocus', async (payload) =>{this.listenBack()})
        this._willBlurSubscription = props.navigation.addListener('willBlur', async (payload) =>{this.removeListen()})

    }
    listenBack=()=>{ //监听返回
        BackHandler.addEventListener('hardwareBackPress', this.onBackAndroid)
    }
    removeListen=()=>{
        BackHandler.removeEventListener('hardwareBackPress', this.onBackAndroid)
    }
     //触发返回键执行方法
     onBackAndroid = () => {
        this.goBack()
        return true;

    };

    componentWillUnmount() {
        super.componentWillUnmount()
        Keyboard.dismiss();
        this.removeListen()
    }
    selectArea = province => {
        const {
            selecteProvinceIndex,
            cityAndDistrict,
            selecteDistrictIndex,
            selecteCityIndex,
            requesParams
        } = this.state;
        if (
            province[selecteProvinceIndex] &&
            province[selecteProvinceIndex].code &&
            province[selecteProvinceIndex].children[selecteCityIndex] &&
            province[selecteProvinceIndex].children[selecteCityIndex].code &&
            province[selecteProvinceIndex].children[selecteCityIndex].children[selecteDistrictIndex]
        ) {
            const names=[province[selecteProvinceIndex].name,province[selecteProvinceIndex].children[selecteCityIndex].name,province[selecteProvinceIndex].children[selecteCityIndex].children[selecteDistrictIndex].name]
            const codes=[province[selecteProvinceIndex].code,province[selecteProvinceIndex].children[selecteCityIndex].code,province[selecteProvinceIndex].children[selecteCityIndex].children[selecteDistrictIndex].code]
            const districtItem=Address.pickerArea.districts.find(item=>item.code==codes[2] && item.parentCode==codes[1]) || {}
            console.log(province[selecteProvinceIndex].children[selecteCityIndex],districtItem)
            this.setState({
                modalVisible: false,
                areaName:names.join('-'),
                requesParams: {
                    ...requesParams,
                    provinceCode:codes[0],
                    cityCode:codes[1],
                    districtCode:codes[2],
                    poiName:requesParams.districtCode== codes[2]?requesParams.poiName:'',
                    poiAddress:requesParams.districtCode== codes[2]?requesParams.poiAddress:'',
                    street:requesParams.districtCode== codes[2]?requesParams.street:'',
                    lng:requesParams.districtCode== codes[2]?requesParams.lng:districtItem.longitude,
                    lat:requesParams.districtCode== codes[2]?requesParams.lat:districtItem.latitude,
                }
            });
        } else {
            this.setState({ areaSelectWrong: true });
        }
    };
    componentDidMount() {
        const id=(this.props.navigation.getParam('currentAdress') || {}).id
        id && requestApi.merchantShopAddrDetail({id}).then((data)=>{
            this.setState({
                requesParams:{
                    ...this.state.requesParams,
                    ...data
                }
            })
        }).catch(err => {
            console.log(err)
        });
    }
    saveEditor = () => {
        let params = this.state.requesParams;
        if (params.receiver.length < 2) {
            Toast.show("收货人2到10个字符");
        } else if (!regular.phone(params.phone)) {
            Toast.show("请输入正确格式的手机号");
        } else {
            let func = this.state.currentAdress.id
                ? requestApi.merchantShopAddrUpdate
                : requestApi.merchantShopAddrCreate;
            this.state.currentAdress.id
                ? (params.id = this.state.currentAdress.id)
                : null;
            Loading.show()
            func(params).then(data => {
                this.state.refreshList();
                this.props.navigation.goBack();
            }).catch(err => {
                console.log(err)
            });
        }
    };
    changeRequestParams = data => {
        const { requesParams } = this.state;
        this.setState({
            requesParams: {
                ...requesParams,
                ...data
            }
        });
    };
    deleteAdress = () => {
        this.state.deleteAdress();
        Toast.show("删除成功");
        this.props.navigation.goBack();
    };
    // 未保存的状态下，保存选择的经纬度和店铺名
    getLactionData = (data) => {
        let locationData = JSON.parse(data)
        const { title,address ,point={}} = locationData
        console.log('locationData',locationData)
        this.setState({
            requesParams:{
                ...this.state.requesParams,
                poiName:title,
                poiAddress:address,
                ...point
            }

        })
    }
    goBack=()=>{
        const { navigation, store } = this.props;
        if(JSON.stringify(this.state.requesParams) ==JSON.stringify(this.oldRequesParams)){
            navigation.goBack();
        }else{
            console.log(CustomAlert.onShow)
            CustomAlert.onShow(
                "confirm",
                "收货地址未保存，是否退出？",
                "",
                () => {
                    navigation.goBack();
                },
                () => {},
                botton1Text = "取消",
                botton2Text = "确定",
                botton1TextStyle={color:'#222'},
                botton2TextStyle={color:'#222'}
            )
        }

    }

    render() {
        const { navigation, store } = this.props;
        const {
            requesParams,
            currentAdress,
            selecteProvinceIndex,
            selecteCityIndex,
            selecteDistrictIndex,
            areaName,
            modalType,
            modalVisible,
            label,
            areaSelectWrong
        } = this.state;
        const labelLists = [
            { title: "家" },
            { title: "学校" },
            { title: "公司" },
            { title: "取消" }
        ];
        let province = Address.pickerArea.allArea;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={currentAdress.id ? "修改地址" : "新增地址"}
                    leftView={
                        <TouchableOpacity
                            style={{width:50,alignItems:'center'}}
                            onPress={this.goBack}
                        >
                            <Image tintColor={'#fff'} source={require('../../images/header/back.png')} style={{tintColor: 'white'}}/>
                        </TouchableOpacity>
                    }
                    rightView={
                        currentAdress.id ? (
                            <TouchableOpacity
                                onPress={() => this.saveEditor()}
                                style={{ width: 50 }}
                            >
                                <Text style={{ fontSize: 17, color: "#fff" }}>
                                    保存
                                </Text>
                            </TouchableOpacity>
                        ) : null
                    }
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        <Content style={{ width: width - 20,elevation:1 }}>
                            <View style={{ flexDirection: "row" }}>
                                <View style={{ flex: 1 }}>
                                    <Line
                                        title={"收货人"}
                                        type={"input"}
                                        leftStyle={{ width: 80 }}
                                        point={null}
                                        placeholder={"请输入收货人姓名"}
                                        maxLength={10}
                                        value={requesParams.receiver}
                                        onChangeText={data =>
                                            this.changeRequestParams({
                                                receiver: data
                                            })
                                        }
                                    />
                                </View>
                                <TouchableOpacity style={styles.topRight} onPress={()=>{
                                    nativeApi.openContact().then((res)=>{
                                        console.log(res)
                                        this.changeRequestParams({
                                            receiver:res.name,
                                            phone:res.phoneNumber
                                        })
                                    }).catch(err => {
                                        console.log(err)
                                    });
                                }}>
                                    <Image source={require("../../images/address/concat.png")} style={{width:24,height:25}}/>
                                </TouchableOpacity>
                            </View>
                            <Line
                                title={"联系电话"}
                                type={"input"}
                                leftStyle={{ width: 80 }}
                                point={null}
                                placeholder={"请输入收货人电话"}
                                maxLength={11}
                                value={requesParams.phone}
                                onChangeText={data =>
                                    this.changeRequestParams({
                                        phone: data
                                    })
                                }
                            />
                             <Line
                                title={"收货区域"}
                                type={"horizontal"}
                                leftStyle={{width:80}}
                                point={null}
                                rightValueStyle={{justifyContent: 'space-between'}}
                                rightTextStyle={{color:areaName?'#222':'#ccc',lineHeight:18}}
                                value={areaName || "请选择收货区域"}
                                onPress={() => {
                                    this.setState({
                                        modalVisible: true,
                                        modalType: "area"
                                    });
                                }}
                            />
                             <Line
                                title={"收货地址"}
                                type={"custom"}
                                leftStyle={{width:80}}
                                point={null}
                                rightValueStyle={{justifyContent: 'space-between'}}
                                rightTextStyle={{color:requesParams.poiAddress?'#222':'#ccc',lineHeight:18}}
                                rightView={
                                    <View style={{flex:1,flexDirection:'row',alignItems:'center',justifyContent:'space-between'}}>
                                        <View style={{flex:1,paddingLeft:10}}>
                                            {requesParams.poiName ? <Text style={{color:'#222',marginBottom:5}}>{requesParams.poiName}</Text>:null}
                                            <Text style={{color:requesParams.poiAddress?'#999':'#ccc'}}>{requesParams.poiAddress || "请输入收货地址"}</Text>
                                        </View>
                                        <Image source={require('../../images/index/expand.png')} />
                                    </View>
                                }
                                onPress={() => {
                                    if(!areaName){
                                        Toast.show('请先选择收货区域')
                                    }else{
                                        let lat=requesParams.lat
                                        let lng=requesParams.lng
                                        if(!lat || !lng){
                                            const districtItem=Address.pickerArea.districts.find(item=>item.code==requesParams.districtCode) || {}
                                            lat=districtItem.latitude
                                            lng=districtItem.longitude
                                            this.setState({
                                                requesParams:{
                                                    ...requesParams,
                                                    lat,
                                                    lng
                                                }
                                            })
                                        }

                                        navigation.navigate('AddressLocation', {
                                            headerTitle:'选择收货地址',
                                            region:areaName.split('-'),
                                            title: requesParams.poiName || '',
                                            getLactionData: this.getLactionData,
                                            lat,
                                            lng,
                                            uriValue:'storeposition'
                                        })
                                    }
                                }}
                            />
                            <Line
                                title={"详细地址"}
                                type={"custom"}
                                point={null}
                                leftStyle={{ width: 80 }}
                                style={{ alignItems: "flex-start" }}
                                rightView={
                                    <TextInputView
                                        style={{textAlignVertical: "top",color: "#222"}}
                                        inputView={[styles.inputView,{height: 90,marginTop:Platform.OS === "android"? 0: -5}]}
                                        multiline={true}
                                        placeholder="请输入详细地址信息，如道路、门牌号、小区、楼栋号、单元室等。"
                                        placeholderTextColor={"#ccc"}
                                        value={requesParams.street}
                                        onChangeText={data =>
                                            this.changeRequestParams({
                                                street: data
                                            })
                                        }
                                        maxLength={50}
                                    />
                                }
                            />
                        </Content>
                        <Content style={{ width: width - 20 ,elevation:1}}>
                            <Line
                                title={"设置默认地址"}
                                type={"custom"}
                                point={null}
                                style={{ justifyContent: "space-between" }}
                                rightView={
                                    <Switch
                                        value={requesParams.isDefault === 1? true: false}
                                        onChangeState={data =>
                                            this.changeRequestParams({
                                                isDefault: data ? 1 : 0
                                            })
                                        }
                                    />
                                }
                            />
                        </Content>
                        {currentAdress.id ? (
                            <CommonButton
                                style={{ backgroundColor: "#EE6161",borderColor: '#EE6161' }}
                                title="删除收货地址"
                                onPress={() => this.deleteAdress()}
                            />
                        ) : (
                            <CommonButton
                                title="保存"
                                onPress={() => this.saveEditor()}
                            />
                        )}
                    </View>
                </ScrollView>
                <Modal
                    animationType={"fade"}
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={() => {
                        this.setState({
                            modalVisible: false
                        });
                    }}
                    onShow={() => {}}
                >
                    {modalType == "label" ? (
                        <KeyboardAvoidingView behavior='padding' style={styles.modalOutView}>
                            <TouchableOpacity
                                style={[styles.modalInnerTopView,{
                                    position:'absolute',
                                    bottom: 0,
                                    width: width,
                                    height:height
                                }]}
                                activeOpacity={1}
                                onPress={() => {
                                    this.setState({
                                        modalVisible: false
                                    });
                                }}
                            />
                            <View
                                style={[
                                    styles.modalInnerBottomView,
                                    {
                                        position:'absolute',
                                        bottom:0
                                    }
                                ]}
                            >
                                <View
                                    style={[
                                        styles.labelLists_item,
                                        {
                                            flexDirection: "row",
                                            justifyContent: "space-between",
                                            paddingHorizontal: 25,
                                            height:61
                                        }
                                    ]}
                                >
                                    <TextInputView
                                        style={{ color: "#222" }}
                                        inputView={styles.modalInput}
                                        multiline={false}
                                        style={{height:33}}
                                        placeholder="自定义标签"
                                        placeholderTextColor={"#ccc"}
                                        value={label}
                                        onChangeText={data =>
                                            this.setState({ label: data })
                                        }
                                        maxLength={20}
                                    />
                                    <TouchableOpacity
                                        style={styles.modalButton}
                                        onPress={() =>
                                            this.setState({
                                                modalVisible: false,
                                                requesParams: {
                                                    ...requesParams,
                                                    label:
                                                        (label &&
                                                            label.replace(
                                                                /\s*/g,
                                                                ""
                                                            )) ||
                                                        ""
                                                }
                                            })
                                        }
                                    >
                                        <Text
                                            style={{
                                                color: "#fff",
                                                fontSize: 14
                                            }}
                                        >
                                            确定
                                        </Text>
                                    </TouchableOpacity>
                                </View>
                                {labelLists.map((item, index) => {
                                    let line1 = styles.labelLists_item1;
                                    let line2 =
                                        index === labelLists.length - 1
                                            ? styles.labelLists_item2
                                            : null;

                                    return (
                                        <TouchableOpacity
                                            key={index}
                                            style={[
                                                styles.labelLists_item,
                                                line1,
                                                line2
                                            ]}
                                            onPress={() => {
                                                index == labelLists.length - 1
                                                    ? this.setState({
                                                          modalVisible: false,
                                                      })
                                                    : this.setState({
                                                          requesParams: {
                                                              ...requesParams,
                                                              label: item.title
                                                          },
                                                          modalVisible: false,
                                                      });
                                            }}
                                        >
                                            <Text
                                                style={[
                                                    styles.labelLists_item_text,
                                                    {
                                                        color:
                                                            item.title ==
                                                            requesParams.label
                                                                ? CommonStyles.globalHeaderColor
                                                                : "#000"
                                                    }
                                                ]}
                                            >
                                                {item.title}
                                            </Text>
                                        </TouchableOpacity>
                                    );
                                })}
                            </View>
                        </KeyboardAvoidingView>
                    ) : (
                        <View
                            style={[
                                styles.modalOutView,
                                { position: "relative" }
                            ]}
                        >
                            {areaSelectWrong ? (
                                <TouchableOpacity
                                    activeOpacity={1}
                                    style={styles.wrongBackground}
                                    onPress={() =>
                                        this.setState({
                                            areaSelectWrong: false
                                        })
                                    }
                                >
                                    <View style={styles.alert}>
                                        <Text style={{color: "#333333",fontSize: 17 }}>
                                            请选择区/县!
                                        </Text>
                                    </View>
                                </TouchableOpacity>
                            ) : null}
                            <TouchableOpacity
                                style={styles.modalInnerTopView}
                                activeOpacity={1}
                                onPress={() => {
                                    this.setState({ modalVisible: false });
                                }}
                            />
                            <View
                                style={[
                                    styles.modalInnerBottomView,
                                    {height:height / 2 +CommonStyles.footerPadding}
                                ]}
                            >
                                <View style={[styles.modalTopView]}>
                                    <TouchableOpacity
                                        style={[styles.but,{ borderRightWidth: 1 }]}
                                        onPress={() => {
                                            this.setState({
                                                modalVisible: false
                                            });
                                        }}
                                    >
                                        <Text style={styles.butText}>取消</Text>
                                    </TouchableOpacity>
                                    <TouchableOpacity
                                        style={styles.but}
                                        onPress={() =>
                                            this.selectArea(province)
                                        }
                                    >
                                        <Text style={[styles.butText,{ color: "#4A90FA" }]}>确认</Text>
                                    </TouchableOpacity>
                                </View>
                                <View style={{flex: 1,flexDirection: "row",alignItems: "center"}}>
                                    {[
                                        province,(province[selecteProvinceIndex] &&province[selecteProvinceIndex].children) ||[],
                                        (((province[selecteProvinceIndex] &&province[selecteProvinceIndex].children) ||
                                            [])[selecteCityIndex] &&((province[selecteProvinceIndex] &&
                                                province[selecteProvinceIndex].children) ||[])[selecteCityIndex].children) ||[]
                                    ].map((item, index) => {
                                        return (
                                            <View
                                                style={styles.modalItem}
                                                key={index}
                                            >
                                                <Text style={[styles.selectTitle,{marginTop: 8,fontSize: 14}]} >
                                                    请选择{index == 0? "省": index == 1? "市": "区/县"}
                                                </Text>
                                                <ScrollView alwaysBounceVertical={false}>
                                                    <View style={{paddingBottom:CommonStyles.footerPadding}}>
                                                        {item.map(
                                                            (itemDetail,indexDetail) => {
                                                                const selected =
                                                                    (index == 0 &&
                                                                        indexDetail ==
                                                                            selecteProvinceIndex) ||
                                                                    (index == 1 &&
                                                                        indexDetail ==
                                                                            selecteCityIndex) ||
                                                                    (index == 2 &&
                                                                        indexDetail ==
                                                                            selecteDistrictIndex);
                                                                return (
                                                                    <TouchableOpacity
                                                                        style={{
                                                                            backgroundColor: selected
                                                                                ? "#DBE9FE"
                                                                                : "#fff",
                                                                            borderLeftWidth: selected
                                                                                ? 1
                                                                                : 0,
                                                                            borderColor:
                                                                                "#A7C9FD"
                                                                        }}
                                                                        key={
                                                                            indexDetail
                                                                        }
                                                                        onPress={() => {
                                                                            const params = {};
                                                                            switch (
                                                                                index
                                                                            ) {
                                                                                case 0:
                                                                                    params.selecteProvinceIndex = indexDetail;
                                                                                    break;
                                                                                case 1:
                                                                                    params.selecteCityIndex = indexDetail;
                                                                                    break;
                                                                                default:
                                                                                    params.selecteDistrictIndex = indexDetail;
                                                                                    break;
                                                                            }
                                                                            this.setState(
                                                                                {
                                                                                    ...params
                                                                                }
                                                                            );
                                                                        }}
                                                                    >
                                                                        <Text
                                                                            style={[
                                                                                styles.selectTitle,
                                                                                {
                                                                                    color: selected
                                                                                        ? "#4A90FA"
                                                                                        : "#999"
                                                                                }
                                                                            ]}
                                                                        >
                                                                            {
                                                                                itemDetail.name
                                                                            }
                                                                        </Text>
                                                                    </TouchableOpacity>
                                                                );
                                                            }
                                                        )}
                                                    </View>

                                                </ScrollView>
                                            </View>
                                        );
                                    })}
                                </View>
                            </View>
                        </View>
                    )}
                </Modal>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
        position: "relative"
    },
    content: {
        alignItems: "center",
        paddingBottom: 10
    },
    topRight: {
        width: 54,
        alignItems: "center",
        justifyContent: "center",
        borderBottomWidth: 1,
        borderColor: "#F1F1F1"
    },
    inputView: {
        flex: 1,
        marginLeft: 10,
        fontSize: 14,
        color: "#777777"
    },
    modal: {
        width: width,
        backgroundColor: "rgba(0,0,0,0.5)",
        height: height,
        position: "absolute",
        bottom: 0,
        left: 0,
        justifyContent: "flex-end",
        position: "relative"
    },
    modalContent: {
        backgroundColor: "#FFF",
        height: height / 2,
        width: width,
        position: "relative"
    },
    modalTopView: {
        height: 44,
        flexDirection: "row",
        alignItems: "center"
    },
    but: {
        width: width / 2,
        height: "100%",
        alignItems: "center",
        justifyContent: "center",
        borderBottomWidth: 1,
        borderColor: "#f1f1f1"
    },
    butText: {
        fontSize: 17,
        color: "#999999"
    },
    selectTitle: {
        color: "#222222",
        fontSize: 12,
        height: 36,
        lineHeight: 36,
        textAlign: "center"
    },
    modalItem: {
        width: width / 3
    },
    modalOutView: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center"
    },
    modalInnerTopView: {
        flex: 1,
        width: width,
        backgroundColor: "rgba(0, 0, 0, .5)"
    },
    modalInnerBottomView: {
        width: width,
        height: 255 + CommonStyles.footerPadding,
        backgroundColor: "#fff"
    },
    labelLists_item: {
        justifyContent: "center",
        alignItems: "center",
        width: width,
        height: 50
    },
    labelLists_item1: {
        borderTopWidth: 1,
        borderTopColor: "#E5E5E5"
    },
    labelLists_item2: {
        borderTopWidth: 5,
        borderTopColor: "#E5E5E5"
    },
    labelLists_item_text: {
        fontSize: 16,
        color: "#000"
    },
    modalInput: {
        borderWidth: 1,
        borderColor: "#CFCFCF",
        paddingHorizontal: 10,
        height: 33,
        width: width - 72 - 50 - 15,
        borderRadius: 6
    },
    modalButton: {
        backgroundColor: CommonStyles.globalHeaderColor,
        borderRadius: 6,
        alignItems: "center",
        justifyContent: "center",
        height: 30,
        width: 72
    },
    labelView: {
        borderColor: "#4A90FA",
        borderWidth: 1,
        borderRadius: 6,
        height: 28,
        alignItems: "center",
        justifyContent: "center"
    },
    labelText: {
        fontSize: 14,
        color: "#4A90FA",
        paddingHorizontal: 20
    },
    alert: {
        backgroundColor: "#fff",
        width: width - 140,
        height: 102,
        alignItems: "center",
        justifyContent: "center",
        borderRadius: 10,
        position: "absolute",
        left: 70,
        top: (height - 102) / 2,
        zIndex: 2
    },
    wrongBackground: {
        position: "absolute",
        width: width,
        height: height,
        backgroundColor: "rgba(0,0,0,0.5)",
        zIndex: 6
    }
});

export default connect(
    state => ({ store: state })
)(poiAddressEditScreen);
