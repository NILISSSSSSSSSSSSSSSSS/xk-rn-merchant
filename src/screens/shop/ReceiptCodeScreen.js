/**
 * 收款码
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    View,
    Text,
    Image,
    Dimensions,
    Alert,
    TouchableOpacity,
    ImageBackground
} from "react-native";
import { connect } from "rn-dva";
import QRCode from "react-native-qrcode-svg";
import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import ImageView from "../../components/ImageView";
import DashLine from "../../components/DashLine";
import ModalDemo from "../../components/Model";
import * as scanConfig from "../../config/scanConfig";
import moment from "moment";
import * as requestApi from '../../config/requestApi';
import { NavigationPureComponent } from "../../common/NavigationComponent";
const { width, height } = Dimensions.get("window");
function getwidth(val) {
    return (width * val) / 375;
}

class ReceiptCodeScreen extends NavigationPureComponent {
    constructor(props){
        super(props)
        const data = props.navigation.state.params.receiptQrCode || {};
        this.state={
            alertVisible: false,
            data,
            expireTime:data.systemTime && moment(global.requestTime.systemTime).add(10, 'minutes').format('x') || moment().add(10, 'minutes').format('x'),

        }
    }

    blurState = {
        alertVisible: false,
    }

    goBack = () => {
        const { navigation } = this.props;
        this.setState({
            alertVisible: true
        });
    };
    componentDidMount() {

    }

    render() {
        const { navigation,user,userShop } = this.props;
        const { alertVisible,expireTime,data } = this.state;
        let textName = "";
        let danwnei = "";
        let textVal = "";
        if (data.checkValue === "2") {
            textName = "优惠金额";
            danwnei = "元";
            textVal = data.discountAmount;
        } else if (data.checkValue === "3") {
            textName = "折扣";
            danwnei = "折";
            textVal = data.discount;
        } else {
            textName = "优惠";
            danwnei = "不使用优惠";
        }
        let shoName = userShop.name;
        const qrValue={
            userId: user.id,
            storeId: userShop.id,
            merchantId:user.merchantId,
            offerType:data.checkValue ,
            originalPrice:data.paymentAmount,
            actualAmount:data.nowval,
            offerValue:textVal || 0,
            expireTime
        }
        console.log('fdgdfgd',qrValue,scanConfig.qrCodeValue('store_receipt', qrValue))
        let shopIcon = userShop.logo
        return (
            <View style={styles.container}>
                <Header
                    title="收款码"
                    navigation={navigation}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerItem}
                            onPress={this.goBack}
                        >
                            <Image
                                source={require("../../images/mall/goback.png")}
                            />
                        </TouchableOpacity>
                    }
                />
                <ModalDemo
                    title="退出后收款码立即失效"
                    visible={alertVisible}
                    onConfirm={() => {
                        this.setState({ alertVisible: false });
                        navigation.goBack();
                    }}
                    onClose={() => {
                        this.setState({ alertVisible: false });
                    }}
                    type="confirm"
                />
                <ImageBackground
                    resizeMode="stretch"
                    style={styles.contentSty}
                    source={require("../../images/qrcode/background2.png")}
                >
                    <View style={styles.storeImg}>
                        <Image
                           source={
                            shopIcon ? {uri:shopIcon} :
                            require("../../images/qrcode/store2.png")
                           }
                           resizeMode='cover'
                           style={{width:getwidth(83),height:getwidth(83)}}
                        />
                    </View>
                    <Text style={styles.storeName}>
                        {shoName}
                        <Text style={styles.receCodeName}>【收款码】</Text>
                    </Text>
                    <View style={styles.lineView}>
                        <DashLine />
                    </View>
                    <View style={styles.codeimg}>
                        <QRCode
                            value={scanConfig.qrCodeValue('store_receipt', qrValue)}
                            size={getwidth(222)}
                        />
                    </View>

                    <View style={styles.priceView}>
                        <Text style={styles.jiatxt}>
                            原价：{data.paymentAmount}元
                        </Text>
                        <Text style={styles.jiatxt2}>
                            {textName}：{textVal}
                            {danwnei}
                        </Text>
                        <Text style={styles.jiatxt2}>
                            现价：
                            <Text style={styles.nowjia}>{data.nowval}元</Text>
                        </Text>
                    </View>
                </ImageBackground>

                <Text style={styles.footerTxt}>收款码有效时间：10分钟</Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        flexDirection: "column",
        alignItems: "center"
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: 50,
        height: "100%"
    },
    contentSty: {
        marginTop: 44,
        width: getwidth(314),
        // height: 485 / 667 * height,
        alignItems: "center"
    },
    storeName: {
        fontSize: 14,
        color: "#000",
        marginTop: getwidth(10)
    },
    receCodeName: {
        color: "#4A90FA"
    },
    lineView: {
        width: getwidth(290),
        height: 0.5,
        marginTop: getwidth(18),
        overflow: "hidden"
    },
    storeImg: {
        // ...CommonStyles.shadowStyle,
        justifyContent: "center",
        alignItems: "center",
        width: getwidth(83),
        height: getwidth(83),
        marginTop: -getwidth(83) / 2+21,
        borderWidth: 1,
        borderColor: "#F1F1F1",
        borderRadius: getwidth(83) / 2,
        backgroundColor: "#fff",
        overflow: "hidden"
    },
    codeimg: {
        width: getwidth(222),
        height: getwidth(222),
        marginTop: getwidth(30),
        alignItems: "center"
    },
    priceView: {
        marginTop: getwidth(20),
        marginBottom: getwidth(20)
    },
    jiatxt: {
        fontSize: 14,
        color: "#555"
    },
    jiatxt2: {
        fontSize: 14,
        color: "#555",
        marginTop: 8
    },
    nowjia: {
        color: "#EE6161"
    },
    footerTxt: {
        fontSize: 14,
        color: "#999",
        marginTop: 10
    }
});
export default connect(
    state => ({
        user:state.user.user || {},
        userShop:state.user.userShop || {},
     }),
)(ReceiptCodeScreen);
