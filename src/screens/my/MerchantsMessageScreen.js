//我的商户信息MerchantsMessageScreen
/**
 * 选择注册申请的类型
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
    Keyboard,
    ScrollView
} from "react-native";
import { connect } from "rn-dva";
import * as utils from "../../config/utils";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";

const { width, height } = Dimensions.get("window");

class MerchantsMessageScreen extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {

        };
    }

    componentDidMount() {
        this.getPayPwdStatus();
        this.props.getMerchantHome();
    }

    componentWillUnmount() { }
    getPayPwdStatus = () => {
        // 获取设置支付密码状态
        requestApi.merchantPayPasswordIsSet().then(res => {
            this.props.userSave({setPayPwdStatus:res})
            console.log("获取设置支付密码状态", res);
        }).catch(err => {
            console.log(err)
        });
    };

    render() {
        const { navigation, merchantData,setPayPwdStatus,userInfo:userParam} = this.props;
        let payPswRouter = (setPayPwdStatus && setPayPwdStatus.result === 1) ? 'MerchantSetPswValidate' : 'MerchantSetPswValidate'
        let paypswParam = (setPayPwdStatus && setPayPwdStatus.result === 1) ? 'MerchantsMessage' : 'MerchantsMessage'
        const {merchant={}}=merchantData
        const lists = [
            {
                title: "基本信息",
                lists: [
                    {
                        name: "联盟商账号",
                        value: merchant.phone,
                        next: null
                    },
                    {
                        name: "商户号",
                        value: merchant.code,
                        next: null
                    },
                    { name: "姓名", value: merchant.name, next: null },
                    { name: "联盟商名称", value: merchant.merchantName, next: null },
                    { name: "手机号码", value: merchant.phone, next: null },
                    {
                        name: "性别",
                        value: merchant.sex == "male" ? "男" :  merchant.sex == "female" ?"女":'保密',
                        next: null
                    },
                    { name: "身份证号码", value: merchant.idCardNo, next: null },
                    {
                        name: "入驻日期",
                        value: merchant.createdAt ?utils.formatDate(new Date( merchant.createdAt * 1000),"yyyy-MM-dd"): "",
                        next: null
                    }
                ]
            },
            {
                title: "联盟商身份",
                lists: [
                    {
                      name: "已入驻"+(merchant.identityStatuses && merchant.identityStatuses.filter((item)=>item.auditStatus=='active').length || 0)+"种",
                      value: "",
                      route: "RegisterList",
                      params: { route: navigation.state.routeName }
                    }
                ]
            },
            {
                title: "其他信息",
                lists: [
                    {
                        name: "分号管理",
                        route: "Account",
                    },
                    {
                        name: "银行卡管理",
                        route: "Bankcard"
                    },
                    { name: "支付密码", value: "", route: payPswRouter, params: { goBackRouter: paypswParam } },
                    { name: "收货地址", value: "", route: "DeliveryAddress" },
                    {
                        name: "发票信息管理",
                        value: "",
                        route: "InvoiceInfonManage"
                    },
                    // {
                    //     name: "单品优惠券",
                    //     value: "",
                    //     route: "GoodsTickets"
                    // }
                ]
            }
        ];
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title="联盟商信息"
                />
                <ScrollView>
                    {lists && lists.map((item1, indexContent) => {
                        return (
                            <View style={{ marginBottom: indexContent === lists.length - 1  ? 20 : 0 }} key={indexContent} >
                                {item1.title ? (
                                    <Text style={{
                                            fontSize: 14,
                                            color: "#999",
                                            marginLeft: 25,
                                            marginVertical: 15
                                        }}
                                    >
                                        {item1.title}
                                    </Text>
                                ) : (
                                        <View style={{ height: 10 }} />
                                    )}

                                <View style={styles.contentView}>
                                    {item1.lists && item1.lists.map((item, index) => {
                                        let borderBottomStyle = index === item1.lists.length - 1 ? null  : styles.itemLine;
                                        return (
                                            <TouchableOpacity
                                                key={index}
                                                disabled={item.route?false:true}
                                                style={[ styles.itemView, borderBottomStyle ]}
                                                onPress={() => {
                                                    indexContent==lists.length-1 && userParam.auditStatus!='active'?Toast.show('联盟商还未成功入驻或在审核中'):
                                                    item.route ?
                                                    navigation.navigate( item.route, item.params && item.params || {} )
                                                        : item.next === null
                                                        ? null
                                                        : Toast.show( "暂未开放" )
                                                }}
                                            >
                                                <View style={[ styles.item_box, styles.item_left ]} >
                                                    <Text style={ styles.item_textname } > {item.name}  </Text>
                                                </View>
                                                <View style={[ styles.item_box, styles.item_right ]}  >
                                                    <Text style={ styles.item_text } numberOfLines={1}> {item.value} </Text>
                                                    {item.next === null ? null : (
                                                            <Image
                                                                source={require("../../images/mall/goto_gray.png")}
                                                            />
                                                        )}
                                                </View>
                                            </TouchableOpacity>
                                        );
                                    })}
                                </View>
                            </View>
                        );
                    })}
                </ScrollView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    contentView: {
        // ...CommonStyles.shadowStyle,
        width: width - 20,
        marginHorizontal: 10,
        marginBottom: 0,
        borderRadius: 6,
        backgroundColor: "#fff",
    },
    itemView: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center",
        width: "100%",
        height: 50,
        paddingHorizontal: 14
    },
    itemLine: {
        borderBottomWidth: 1,
        borderBottomColor: "#F1F1F1"
    },
    item_box: {
        flexDirection: "row",
        alignItems: "center",
        height: "100%"
    },
    item_left: {
        flex: 1
    },
    item_right: {
        flex: 1,
        justifyContent: "flex-end"
    },
    item_text: {
        fontSize: 14,
        color: "#222",
    },
    item_textname: {
        color: "#222222",
        fontSize: 14
    }
});

export default connect(
    state => ({
        userInfo:state.user.user || {},
        merchantData:state.user.merchantData || {},
        setPayPwdStatus:state.user.setPayPwdStatus || {},
    }),{
        resetPage:(routeName)=>({type:'system/resetPage', payload:{ routeName }}),
        navPage:(routeName,params={})=>({type:'system/navPage', payload:{ routeName ,params}}),
        replacePage:(routeName,params={})=>({type:'system/replacePage', payload:{ routeName ,params}}),
        getMerchantHome:(payload={})=>({type: 'user/getMerchantHome', payload }),
        userSave: (payload={})=>({type: 'user/save', payload }),
    }
)(MerchantsMessageScreen);
