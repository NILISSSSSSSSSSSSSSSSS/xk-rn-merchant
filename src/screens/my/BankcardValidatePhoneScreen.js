/**
 * 银行卡管理验证手机号
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
    Keyboard
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from "../../components/ImageView";
import TextInputView from "../../components/TextInputView";
import * as nativeApi from "../../config/nativeApi";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
import CommonButton from "../../components/CommonButton";
import CheckButton from "../../components/CheckButton";
import * as regular from "../../config/regular";
import * as requestApi from "../../config/requestApi";
const { width, height } = Dimensions.get("window");

class BankcardValidatePhoneScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = props.navigation.state.params || {};
        let phone = "";

        this.state = {
            callback: params.callback || (() => {}),
            code: "",
            page: params.page, //add新增，update修改，delete删除,
            phone: "",
            data: params.data || {}
        };
    }

    componentDidMount() {
    }

    componentWillUnmount() {}
    save = () => {
        Keyboard.dismiss();
        const { code, data,phone,page } = this.state;
        if (!code) {
            Toast.show("请输入验证码");
        } else if (phone != (this.props.merchantData.merchant || {}).phone) {
            Toast.show("请填写商户手机号");
        }
        else {
            Loading.show();
            requestApi.smsCodeValidate({ phone, code }).then(() => {
              let func;
              let title;
              switch (page) {
                  case "add":
                      func = requestApi.mBankCardCreate;
                      title = "新增";
                      break;
                  case "update":
                      func = requestApi.mBankCardUpdate;
                      title = "修改";
                      break;
                  default:
                      func = requestApi.mBankCardDelete;
                      title = "删除";
                      break;
              }
              func({ ...data, code })
                  .then(data => {
                      Toast.show(title + "成功");
                      this.state.callback();
                      // 返回到列表页面，在页面监听返回事件，判断是否是联盟商进入，如果是，返回联盟商页面
                      this.props.navigation.navigate("Bankcard",{routerIn: this.props.navigation.getParam('routerIn','')});
                  })
                  .catch(error => {
                      //
                  });
            }).catch((err)=>{
                console.log(err)
            });
        }
    };
    _checkBtn = () => {
        Keyboard.dismiss();
        const { page, phone } = this.state;
        if (this.refs.getCode.state.disabled) {
            return;
        } else if (phone != (this.props.merchantData.merchant || {}).phone) {
            Toast.show("请填写商户手机号");
        }
        else {
            Loading.show();
            requestApi
                .sendAuthMessage({
                    phone: phone,
                    // bizType:page == "add" ? "BIND_BANK_CARD" : "UNBIND_BANK_CARD"
                    bizType:'VALIDATE'
                })
                .then(() => this.refs.getCode.sendVerCode())
                .catch((err)=>{
                    console.log(err)
                });
        }
    };

    render() {
        const { navigation } = this.props;
        const leftStyle = { width: 64 };
        const { phone } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title="验证手机"
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        <Content>
                            <Line
                                title="手机号码"
                                type='input'
                                placeholder="请输入手机号"
                                value={phone}
                                point={null}
                                onChangeText={data => {
                                    this.setState({ phone: data });
                                }}
                                leftStyle={leftStyle}

                            />
                            <Line
                                title="验证码"
                                leftStyle={leftStyle}
                                type="custom"
                                point={null}
                                rightView={
                                    <View
                                        style={[
                                            styles.row,
                                            { position: "relative" }
                                        ]}
                                    >
                                        <TextInputView
                                            inputView={styles.inputView}
                                            placeholder="请输入验证码"
                                            style={styles.input}
                                            placeholderTextColor={"#ccc"}
                                            onChangeText={data => {
                                                this.setState({ code: data });
                                            }}
                                        />
                                        <CheckButton
                                            onClick={() => this._checkBtn()}
                                            delay={60}
                                            ref="getCode"
                                            styleBtn={styles.code}
                                            title={{
                                                color: "#4A90FA",
                                                fontSize: 12
                                            }}
                                        />
                                    </View>
                                }
                            />
                        </Content>

                        <CommonButton
                            title="提交"
                            onPress={() => this.save()}
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
        alignItems: "center",
        paddingBottom: 10
    },
    inputView: {
        flex: 1,
        marginLeft: 10
    },
    input: {
        flex: 1,
        padding: 0,
        lineHeight: 20,
        height: 20,
        color: "#222222"
    },
    row: {
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between",
        flex: 1
    },
    code: {
        backgroundColor: "#fff",
        position: "absolute",
        right: 0,
        top: 0,
        height: 22,
        alignItems: "center",
        justifyContent: "center",
        borderWidth: 1,
        borderColor: "#4A90FA",
        borderRadius: 10
    }
});

export default connect(
    (state) => ({
        merchantData:state.user.merchantData || {},
     }),
)(BankcardValidatePhoneScreen);
