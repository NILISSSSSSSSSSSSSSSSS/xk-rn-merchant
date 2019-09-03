/**
 * 修改银行卡/新增/修改银行卡
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
    TouchableOpacity,
    Switch
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from "../../components/ImageView";
import TextInputView from "../../components/TextInputView";
import * as nativeApi from "../../config/nativeApi";
import * as requestApi from "../../config/requestApi";
import * as regular from "../../config/regular";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
import CommonButton from "../../components/CommonButton";
const refunds = [
    { title: "消费前可退", key: "CONSUME_BEFORE" },
    { title: "限定时间前随时可退", key: "RESERVATION_BEFORE_BYTIME" },
    { title: "预定时间前随时退", key: "RESERVATION_BEFORE" }
];
const { width, height } = Dimensions.get("window");

export default class BankcardEditScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = props.navigation.state.params || {};
        this.state = {
            requesParams: {
                bankName: params.data ? params.data.bankName : "",
                id: params.data ? params.data.id : "",
                cardNumber: params.data ? params.data.cardNumber : "",
                realName: params.data ? params.data.realName : "",
                idCardNum: params.data ? params.data.idCardNum : "",
                cardType: params.data && params.data.cardType? params.data.cardType : "借记卡",
                logo:  params.data ? params.data.logo : "",
                openBank:params.data ? params.data.openBank : "",
                rightPublic:params.rightPrivate==0?1:0,
                bankNo:params.data ? params.data.bankNo : "",
            },
            types: [],
            data: params.data,
            callback: params.callback || (() => {}),
            rightPrivate:params.rightPrivate || 0
        };
    }

    componentWillUnmount() {}
    getCardMessage = binNum => {
        requestApi
            .bankCardBinDetail({ binNum: binNum })
            .then(data => {
                console.log("返回", data);
                if (data) {
                    this.setState({
                        requesParams: {
                            ...this.state.requesParams,
                            ...data,
                            id:this.state.requesParams.id
                        }
                    });
                } else {
                    this.setState({
                        requesParams: {
                            ...this.state.requesParams,
                            bankName: "请输入正确的银行卡号"
                        }
                    });
                }
            })
            .catch(error => {
                //
            });
    };
    saveEditor = () => {
        const { requesParams: params } = this.state;
        console.log(params)
        if (params.bankName == "请输入正确的银行卡号" || !params.bankName) {
            Toast.show("请输入正确的银行卡号");
            return
        }
        else if (!params.rightPublic && !regular.card(params.cardNumber)) {
            Toast.show("请输入正确格式的银行卡账号");
            return
        }
        else if (params.rightPublic && !regular.card_public(params.cardNumber)){ // 对公添加新的验证
            Toast.show("请输入正确格式的银行卡账号");
            return
        }
        else if (!params.openBank) {
            Toast.show("请输入开户行");
            return
        }
        else if (params.cardType != '借记卡') {
            Toast.show('当前只支持借记卡')
            return
        }else if(!params.realName){
            Toast.show("请完善资料");
            return
        }
        else if(!params.logo){
            Toast.show("找不到该银行，请更换银行卡");
            return
        }
        if(params.rightPublic){ // 对公 行号非必填
            // if(!params.bankNo){
            //     Toast.show("请完善资料");
            //     return
            // }
        }else{
            if (!regular.ID(params.idCardNum)) {
                Toast.show("请输入正确格式的开户人身份证号码");
                return
            }
        }

            this.props.navigation.navigate("BankcardValidatePhone", {
                page: this.props.navigation.state.params.data
                    ? "update"
                    : "add",
                data: params,
                routerIn: this.props.navigation.getParam('routerIn', ''), // 如果是从联盟商进入的，验证手机号成功后，返回联盟商的webview
                callback: this.state.callback
            });

    };

    changeRequestParams = data => {
        for (key in data) {
            if (key == "cardNumber") {
                if (data[key].length == 6) {
                    this.getCardMessage(data[key]);
                }
            }
        }

        this.setState({
            requesParams: {
                ...this.state.requesParams,
                ...data
            }
        });
    };
    _checkBtn = () => {};

    render() {
        const { navigation} = this.props;
        const { requesParams,rightPrivate } = this.state;
        const items0 = [ //对公
            [
                {
                    title: "银行卡号",
                    placeholder: "请输入银行卡号",
                    value: requesParams.cardNumber,
                    key: "cardNumber",
                    maxLength:19
                },
                {
                    title: "开户行",
                    placeholder: "请输入开户行名称",
                    value: requesParams.openBank,
                    key: "openBank"
                },
                {
                    title: "行号",
                    placeholder: "请输入银行行号",
                    value: requesParams.bankNo,
                    key: "bankNo"
                },
                {
                    title: "户名",
                    placeholder: "请输入公司账户名",
                    value: requesParams.realName,
                    key: "realName"
                },
            ]
        ];
        const items1 = [ //对私
            [
                {
                    title: "银行卡号",
                    placeholder: "请输入银行卡号",
                    value: requesParams.cardNumber,
                    key: "cardNumber",
                    maxLength:19
                },
                {
                    title: "开户行",
                    placeholder: "请输入开户行名称",
                    value: requesParams.openBank,
                    key: "openBank"
                },
            ],
            [
                {
                    title: "持卡人姓名",
                    placeholder: "请输入名字",
                    value: requesParams.realName,
                    key: "realName",
                    maxLength: 5
                },
                {
                    title: "身份证号码",
                    placeholder: "请输入身份证号码",
                    value: requesParams.idCardNum,
                    key: "idCardNum",
                    maxLength:18
                }
            ]
        ];
        const items=rightPrivate==0?items0:items1

        return (
            <View style={styles.container}>
                <Header
                    title={navigation.state.params.title + "银行卡"}
                    navigation={navigation}
                    goBack={true}
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        {items.map((item, index) => {
                            return (
                                <View key={index}>
                                    <Content>
                                        {item.map((item, index) => {
                                            return (
                                                <View style={{ position: "relative"  }} key={index}  >
                                                    <Line
                                                        title={item.title}
                                                        type={"input"}
                                                        leftStyle={{ width: 72 }}
                                                        styleInput={{textAlign:'right'}}
                                                        maxLength={ item.maxLength || 19 }
                                                        point={null}
                                                        placeholder={ item.placeholder  }
                                                        value={item.value}
                                                        onPress={
                                                            item.onPress ? () => item.onPress() : null
                                                        }
                                                        onChangeText={data =>
                                                            this.changeRequestParams( { [item.key]: data } )
                                                        }
                                                    />
                                                </View>
                                            );
                                        })}
                                    </Content>
                                    {index === 0 && requesParams.bankName? (
                                        <Text style={styles.name}>
                                            {requesParams.bankName}
                                        </Text>
                                    ) : null}
                                </View>
                            );
                        })}

                        <CommonButton
                            title="保存"
                            onPress={() => this.saveEditor()}
                        />
                    </View>
                </ScrollView>
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
        alignItems: "center"
    },
    name: {
        color: "#999999",
        fontSize: 14,
        textAlign: "right",
        width: width - 20,
        paddingRight: 10,
        marginTop: 10
    }
});

