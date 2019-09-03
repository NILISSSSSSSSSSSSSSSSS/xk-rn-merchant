/**
 * 晓可物流
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
    ImageBackground,
    Dimensions,
} from "react-native";
import * as requestApi from '../../config/requestApi';

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import { NavigationPureComponent } from "../../common/NavigationComponent";
import { ListItem, List, Splitter } from "../../components/List";
import Icon from "../../components/Icon";
import Button from '../../components/Button';
import XKText from "../../components/XKText";


const { width, height } = Dimensions.get("window");
function getwidth(val) {
    return (width * val) / 375;
}

export default class XKLogisticsScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };

    state = {
        bindRiderCount: 0, //	绑定骑手数量
        payTotal: 0, //	支付金额
        doneCount: 0, //	累计使用
        runningCount: 0, //	配送订单
    }

    screenDidFocus = ()=> {
        super.screenDidFocus()
        Loading.show();
        this.merchantCount()
    }

    merchantCount = () => {
        requestApi.merchantCount().then(res => {
            console.log('统计数据',res)
            if (res) {
                this.setState({
                    ...res
                })
            }
        }).catch(err => {
            console.log(err)
        })
    }

    render() {
        const { doneCount,bindRiderCount,payTotal,runningCount } = this.state
        const { navigation } = this.props;
        return (
            <View style={styles.container}>
                <ImageBackground source={require("../../images/home/bg.png")} style={styles.headerBack}>
                    <Header goBack={true} title={"晓可物流"} />
                    <View style={[CommonStyles.flex_center, { flexDirection: 'row', flex: 1, width, }]}>
                        <View style={[CommonStyles.flex_center, CommonStyles.flex_1]}>
                            <XKText styleName="cff14">累计使用</XKText>
                            <XKText styleName="cff14" style={{ marginTop: 7,}}>
                                <XKText fontFamily="Oswald" styleName="cff22">{doneCount}</XKText> 次
                            </XKText>
                        </View>
                        <View style={styles.divider}></View>
                        <View style={[CommonStyles.flex_center, CommonStyles.flex_1]}>
                            <XKText styleName="cff14">累计支付金额</XKText>
                            <XKText styleName="cff14" style={{ marginTop: 7,}}>
                                <XKText fontFamily="Oswald" styleName="cff22">{payTotal}</XKText> 元
                            </XKText>
                        </View>
                    </View>
                    <View style={{ height: 57, width, overflow: 'visible',}}>
                        <ImageBackground
                            source={require("../../images/my/card-bg.png")}
                            resizeMode="cover"
                            style={styles.headerCard}
                        >
                                <Button type="link" style={{ flex: 1}} onPress={()=> navigation.navigate('XKRiderList')}>
                                    <Icon source={require("../../images/home/xkwl_order.png")} title="我的骑手" titleStyle={{ marginTop: 10 }} />
                                </Button>
                                <View style={styles.divider}></View>
                                <Button type="link" style={{ flex: 1}} onPress={()=> navigation.navigate('LogisticsOrder')}>
                                    <Icon source={require("../../images/home/xkwl_rider.png")} title="物流订单" titleStyle={{ marginTop: 10 }} />
                                </Button>
                        </ImageBackground>
                    </View>
                </ImageBackground>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    divider: {
        height: 30,
        width: 1,
        backgroundColor: "#EEE",
    },
    headerBack: {
        height: getwidth(203),
        justifyContent: 'flex-end',
        marginBottom: getwidth(64),
    },
    headerCard: {
        height: getwidth(128),
        width,
        paddingHorizontal: getwidth(15),
        flexDirection: "row",
        justifyContent: 'center',
        alignItems: 'center',
    }
});
