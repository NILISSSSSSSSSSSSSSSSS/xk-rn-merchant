/**
 * 财务账户/晓可币转账
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
    ImageBackground
} from "react-native";
import { connect } from "rn-dva";

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
const { width, height } = Dimensions.get("window");
import ScrollableTab from "../../components/ScrollableTab";
import FlatListView from "../../components/FlatListView";
import ImageView from "../../components/ImageView";
import Content from "../../components/ContentItem";
import TextInputView from "../../components/TextInputView";
import CommonButton from "../../components/CommonButton";
import { formatPriceStr } from '../../config/utils'
import  math from "../../config/math.js";
import * as regular from "../../config/regular";
import PriceInputView from "../../components/PriceInputView";

class FinanceQrcodeScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = props.navigation.state.params || {};
        this.state = {
            money: "",
            userId: params.userId || "",//存在是扫码过来，不存在是生成二维码
            phone:params.phone,//存在是账号转账
            allMoney:props.userFinanceInfo.userAccXkb && props.userFinanceInfo.userAccXkb.usable
        };
    }

    componentDidMount() { }

    componentWillUnmount() { }
    confirm = () => {
        const { money, userId,phone ,allMoney} = this.state
        if(!regular.price(money)){
            Toast.show('请输入正确的金额格式')
            return
        }
        else if(parseFloat(money)===0){
            Toast.show('转账金额不能为0')
            return
        }
        else if(parseFloat(money)>parseFloat(allMoney)){
            Toast.show('转账金额超出我的余额')
            return
        }
        Loading.show()
        requestApi.requestSystemTime().then((res)=>{
            let params={
                amount:math.multiply(parseFloat(money),100) ,
                authType:'fingerId',
                authValue:'543534g',
                tradeType:phone || userId?'GEN':'QR'//转账方式，GEN，账户转账，QR二维码转账
            }
            phone?params.payeePhone=phone:null
            userId?params.payeeId=userId:null
            requestApi.xkbTransfer(params).then((res)=>{
                if(phone || userId){
                    this.props.navigation.navigate("TransferSuccess",{payFailed:false,route:'FinanceMakeQrcode',...this.state})
                }else{
                    this.props.navigation.navigate("FinanceQrcode", { money,verificationSignatureId:res.qrCode,allMoney: Number(allMoney)*100,...this.state })
                }

            }).catch(err => {
                console.log(err)
            });
        }).catch(err => {
            console.log(err)
        });

    }

    render() {
        const { navigation} = this.props;
        const { money, userId ,phone,allMoney} = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={false}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerLeftView}
                            onPress={() => {
                                global.refreshFinanceData && global.refreshFinanceData()
                                navigation.navigate('FinancialAccount')
                            }}
                        >
                            <Image
                                source={require("../../images/mall/goback.png")}
                            />
                        </TouchableOpacity>
                    }
                    title={"晓可币转账"}
                />
                {/* content */}
                <TouchableOpacity activeOpacity={1} onPress={() => {
                    Keyboard.dismiss();
                }} style={styles.topView}>
                    <ImageBackground
                        source={require("../../images/caiwu/chahua.png")}
                        style={styles.backImage}
                        resizeMode="cover"
                    >
                        <View style={styles.line}>
                            <Text style={{ color: "#222222", fontSize: 14 }}>
                                转账金额:
                            </Text>
                            <PriceInputView
                                style={{ flex: 1, color: "#222",textAlign: 'right' }}
                                maxLength={50}
                                inputView={{ flex: 1, paddingHorizontal: 10 }}
                                value={money}
                                onChangeText={data =>
                                    this.setState({ money: data })
                                }
                                onBlur={() => {
                                    Keyboard.dismiss();
                                }}
                            />

                            <Text style={{ color: "#999999", fontSize: 14 }}>
                                元
                            </Text>
                        </View>
                    </ImageBackground>
                </TouchableOpacity>

                <Text style={{ color: "#555555", fontSize: 14, marginTop: 30 }}>
                    我的余额
                </Text>
                <Text style={{ color: "#222222", fontSize: 40, marginTop: 6 }}>
                    {allMoney}
                </Text>

                <CommonButton
                    title={this.state.page == "scan" ? "充值" : phone || userId?'确定':"生成二维码"}
                    onPress={() => this.confirm()}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
        alignItems: "center"
    },
    content: {
        overflow: "hidden"
    },
    line: {
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between",
        paddingHorizontal: 20,
        backgroundColor: "white",
        height: 68,
        marginTop: 15,
        borderRadius: 10
    },
    topView: {
        marginTop: 10,
        borderRadius: 10,
        overflow: "hidden",
        width: width - 10,
        height: 152
    },
    backImage: {
        flex: 1,
        paddingHorizontal: 20
    },
    headerLeftView: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%",
        width: 50
    },
});

export default connect(
    state => ({
        userFinanceInfo:state.user.userFinanceInfo || {}
     })
)(FinanceQrcodeScreen);
