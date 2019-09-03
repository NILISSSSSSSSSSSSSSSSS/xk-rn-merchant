/**
 * 财务中心/转账二维码
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
    ImageBackground
} from "react-native";
import { connect } from "rn-dva";
import moment from "moment";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
const { width, height } = Dimensions.get("window");
import {  formatPriceStr } from '../../config/utils'
import  math from "../../config/math.js";
import ScrollableTab from "../../components/ScrollableTab";
import FlatListView from "../../components/FlatListView";
import ImageView from "../../components/ImageView";
import Content from "../../components/ContentItem";
import * as scanConfig from "../../config/scanConfig";
import config from "../../config/config";
import QRCode from "react-native-qrcode-svg";

function getwidth(val) {
    return width * val / 375
}

class FinanceQrcodeScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = props.navigation.state.params || {}
        this.state = {
            money: params.money || 0,
            verificationSignatureId:params.verificationSignatureId,
            allMoney:params.allMoney,
            expireTime:moment().add(10, 'minutes').format('x')
        };
    }

    componentDidMount() {
        Loading.show()
        requestApi.requestSystemTime().then((res)=>{
            if(res){
                this.setState({expireTime:moment(res.systemTime).add(10, 'minutes').format('x')})
            }else{
                Toast.show('获取当前时间戳失败')
            }

        }).catch(()=>{
          
        })
     }

    componentWillUnmount() { }

    render() {
        const { navigation, user} = this.props;
        const { money ,verificationSignatureId,allMoney,expireTime} = this.state
        let userImg=user.avatar
        console.log('aaaa',scanConfig.qrCodeValue('sales_xiaoke_currency', {
            verificationSignatureId,
            expireTime
        }))
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"转账二维码"}
                />
                {/* content */}
                <View style={styles.background}>
                    <View style={styles.modal}>
                        <Text style={{ fontSize: 14, color: "#555555" }}>
                            我的余额
                        </Text>
                        <Text
                            style={{
                                fontSize: 40,
                                color: "#222222",
                                marginTop: 6,
                                marginBottom: 18
                            }}
                        >
                        ￥{allMoney}
                        </Text>
                        <QRCode
                            value={scanConfig.qrCodeValue('sales_xiaoke_currency', {
                                verificationSignatureId,
                                expireTime
                            })}
                            size={getwidth(222)}
                            logo={
                                userImg==(config.netHeader+'://gc.xksquare.com/FgbxxWwWCxqHiTiD_2YBgfSlYmau') || !userImg?
                                require('../../images/default/user.png')
                                :{ uri: userImg }
                            }
                            logoSize={50}
                        />
                        <Text
                            style={{
                                fontSize: 14,
                                color: "#555555",
                                marginTop: 18
                            }}
                        >
                            该二维码有效期10分钟
                        </Text>
                    </View>
                </View>
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
    background: {
        backgroundColor: "rgba(0,0,0,0.50)",
        flex: 1,
        width: width,
        alignItems: "center",
        justifyContent: "center"
    },
    modal: {
        backgroundColor: "white",
        width: width - 70,
        borderRadius: 6,
        alignItems: "center",
        paddingVertical: 23
    }
});

export default connect(
    state => ({
        user:state.user.user || {}
     }),
)(FinanceQrcodeScreen);
