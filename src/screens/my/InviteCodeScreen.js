/**
 * 我的安全码
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as scanConfig from "../../config/scanConfig";
import QRCode from "react-native-qrcode-svg";
import config from '../../config/config';
import * as Address from '../../const/address';
function getwidth(val) {
  return (width * val) / 375;
}
const { width, height } = Dimensions.get("window");

class InviteCodeScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };
    render() {
        const { navigation, merchantData,userInfo } = this.props;
        let avatar=userInfo.avatar ==(config.netHeader+'://gc.xksquare.com/FgbxxWwWCxqHiTiD_2YBgfSlYmau') ||
                   !userInfo.avatar?
                    require('../../images/default/user.png')
                    :{ uri: userInfo.avatar }
        let qrValue=scanConfig.qrCodeValue('business_card', {
            userId: userInfo.id,
            securityCode: userInfo.securityCode
        })
        const _name=userInfo.isAdmin === 1 ? merchantData.merchant.name : userInfo.realName || userInfo.nickName
        const _code=userInfo.securityCode

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title= "我的安全码"
                />

                <View style={styles.content}>
                    <View style={[styles.card]}>
                        <View style={styles.infoView_left}>
                            <Image
                                style={styles.infoView_left_img}
                                source={avatar}
                            />
                            <View>
                                <Text style={styles.infoView_left_text1}>
                                    {_name}
                                </Text>
                                <Text style={styles.infoView_left_text2}>
                                    {Address.getDistrictNameByCode(userInfo.districtCode) || '未知'}
                                </Text>
                            </View>
                        </View>

                        <View style={styles.codeView}>
                            <QRCode
                                value={qrValue}
                                size={getwidth(210)}
                                logo={avatar}
                                logoSize={50}
                            />
                        </View>

                        <View style={styles.textView}>
                            <Text style={styles.textView_text1}>安全码：{_code}</Text>
                            <Text style={styles.infoView_left_text2}>加好友或获取推荐码请扫我！</Text>
                        </View>
                    </View>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    content: {
        // flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        flex: 1,
        backgroundColor: "rgba(0,0,0,.5)",
        paddingBottom:CommonStyles.footerPadding
    },
    card: {
        width: getwidth(306),
        height: getwidth(393),
        borderRadius: 6,
        backgroundColor: "#fff"
    },
    infoView_left: {
        flexDirection: "row",
        alignItems: "center",
        padding: getwidth(15),
        paddingBottom:getwidth(25)
    },
    infoView_left_img: {
        width: 50,
        height: 50,
        borderRadius: 8,
        marginRight: 8
    },
    infoView_left_text1: {
        fontSize: 17,
        color: "#222"
    },
    infoView_left_text2: {
        fontSize: 14,
        color: "#777",
        marginTop: getwidth(10)
    },
    codeView: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        // flex: 1,
        height: getwidth(210),
    },
    textView: {
        justifyContent: "center",
        alignItems: "center",
        paddingTop: getwidth(15),
        paddingBottom:getwidth(30),
    },
    textView_text1: {
        fontSize: 17,
        color: "#000"
    }
});

export default connect(
    state => ({
      merchantData:state.user.merchantData || {},
      userInfo:state.user.user || {}
    })
)(InviteCodeScreen);
