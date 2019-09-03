/**
 * 静态二维码
 */
import React, { PureComponent } from "react";
import {
    StyleSheet,
    View,
    Text,
    Image,
    Dimensions,
    TouchableOpacity,
    ImageBackground
} from "react-native";
import { connect } from "rn-dva";
import CommonStyles from "../../../common/Styles";
import Header from "../../../components/Header";
import QRCode from "react-native-qrcode-svg";

const { width, height } = Dimensions.get("window");
function getwidth(val) {
    return (width * val) / 375;
}

class OrderQrcode extends PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            date:new Date().getTime()/1000+30
        }
    }

    render() {
        const { navigation, userShop } = this.props
        let params = navigation.state.params || {}
        const { orderId ,initDataDidMount} = navigation.state.params
        let shopIcon = this.props.userShop.cover
        return (
            <View style={styles.container}>
                <Header
                    title={'收款码'}
                    navigation={navigation}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerItem}
                            onPress={() => {
                                if(initDataDidMount){
                                    initDataDidMount(orderId)
                                }
                                navigation.goBack();
                            }}
                        >
                            <Image
                                source={require("../../../images/mall/goback.png")}
                            />
                        </TouchableOpacity>
                    }
                />

                <ImageBackground
                    resizeMode="stretch"
                    style={styles.contentSty}
                    source={require("../../../images/qrcode/background.png")}
                >
                    <View style={styles.storeImg}>
                        <Image
                         source={
                            shopIcon ? {uri:shopIcon} :
                            require("../../../images/qrcode/store.png")
                           }
                           resizeMode='contain'
                           style={{width:getwidth(83),height:getwidth(83)}}
                        />
                    </View>
                    <Text style={styles.storeName}>{params.title || userShop.name}</Text>
                    <View style={styles.codeimg}>
                        <QRCode
                            value={`xksl://offline_receipt_order?storeId=${userShop.id}&orderId=${orderId}`}
                            size={getwidth(222)}
                        />
                    </View>
                </ImageBackground>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: "center",
        backgroundColor: "#4688ED"
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: 50,
        height: "100%"
    },
    contentSty: {
        width: getwidth(314),
        height: (415 / 667) * height,
        marginTop: getwidth(50),
        alignItems: "center"
    },
    storeImg: {
        // ...CommonStyles.shadowStyle,
        justifyContent: "center",
        alignItems: "center",
        width: getwidth(83),
        height: getwidth(83),
        marginTop: -getwidth(83) / 2,
        borderWidth: 1,
        borderColor: "#F1F1F1",
        borderRadius: getwidth(83) / 2,
        backgroundColor: "#fff",
        overflow: "hidden"
    },
    storeName: {
        fontSize: 14,
        color: "#000",
        fontWeight: "500",
        marginTop: getwidth(24)
    },
    codeimg: {
        justifyContent: "center",
        alignItems: "center",
        flex: 1,
        marginTop: getwidth(15)
    }
});

export default connect(
    (state) => ({ userShop: state.user.userShop || {} }),
)(OrderQrcode);
