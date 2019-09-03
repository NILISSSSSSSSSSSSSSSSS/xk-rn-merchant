
/**
 * 结算详情
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    DeviceInfo,
    View,
    Text,
    Button,
    Image,
    Platform,
    ScrollView,
    TouchableOpacity,
    ImageBackground
} from 'react-native'
import { connect } from 'rn-dva'
import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import moment from 'moment'

import { shopOrderSettleDetail } from '../../config/requestApi'
const { width, height } = Dimensions.get('window')
import {  formatPriceStr, keepTwoDecimalFull } from '../../config/utils'
import  math from "../../config/math.js";
import XKText from "../../components/XKText";
import ActionSheet from "../../components/Actionsheet";
const separatorLine = require('../../images/shop/separatorLine.png')

import { NavigationComponent } from '../../common/NavigationComponent';

class FinancialOrderDetail extends NavigationComponent {
    constructor(props){
        super(props)
        this.state = {
            details: {
                actualPaidPrice: 0, // 实际支付价格
                originalTotalPrice: 0, // 原始订单金额
                deductedAmount: 0, // 扣税金额
                settleAmount: 0, // 最终结算金额
                platformRakeAmount: 0, // 平台抽成金额
                settleTime: '', // 结算时间
                organization: '', // 结算机构
            }
        }
    }
    componentDidMount(){
        this.getDetail()
    }

    getDetail = () => {
        const { navigation } = this.props
        let orderId = navigation.getParam('orderId', '')
        let incomeSource = navigation.getParam('incomeSource', '')
        let params = {
            orderNo: orderId,
            incomeSource,
        }
        shopOrderSettleDetail(params).then(res => {
            console.log('detail',res)
            this.setState({
                details: res
            })
        }).catch(()=>{
          
        })
    }

    renderTopSection = () => {
        const { navigation } = this.props
        const { startTime } = this.state
        const { details } = this.state
        let nickName = navigation.getParam('nickName', '')
        return (
            <ImageBackground source={require('../../images/shop/financialCenter_topBg.png')} style={{width,height: 106}}>
                <View style={[CommonStyles.flex_center, { paddingTop: 20}]}>
                    <Text style={{ fontSize: 14, color: '#fff' }}>{ nickName || '晓可用户' }</Text>
                    <XKText fontFamily="Oswald-Regular" style={{ fontSize: 32, color: '#fff', paddingTop: 5 }}>{ formatPriceStr(keepTwoDecimalFull(details.settleAmount)) }</XKText>
                </View>
            </ImageBackground>
        )
    }
    renderDetailList = () => {
        const { details } = this.state
        const { navigation } = this.props
        let orderId = navigation.getParam('orderId', '')
        return (
            <View style={styles.detailWrap}>
                <View style={[CommonStyles.flex_between, styles.paddingHor, {  paddingBottom: 15}]}>
                    <Text style={styles.color777}>订单号：</Text>
                    <Text style={[styles.color222, { fontSize: 17 }]}>{ orderId }</Text>
                </View>
                <Image source={separatorLine} style={{ width: width - 20 }}/>
                <View style={[CommonStyles.flex_between, styles.paddingHor, { paddingVertical: 15 }]}>
                    <Text style={styles.color777}>订单金额：</Text>
                    <XKText fontFamily="Oswald-Regular" style={[styles.color777]}>
                    { formatPriceStr(keepTwoDecimalFull(details.originalTotalPrice || 0)) }
                    </XKText>
                </View>
                <View style={[CommonStyles.flex_between, styles.paddingHor, { paddingVertical: 15 }]}>
                    <Text style={styles.color777}>实际支付：</Text>
                    <XKText fontFamily="Oswald-Regular" style={[styles.color777]}>
                    { formatPriceStr(keepTwoDecimalFull(details.actualPaidPrice || 0)) }
                    </XKText>
                </View>
                <View style={[CommonStyles.flex_between, styles.paddingHor, { paddingTop: 5,paddingBottom: 15 }]}>
                    <Text style={styles.color777}>扣税金额：</Text>
                    <XKText fontFamily="Oswald-Regular" style={[styles.color777]}>
                    { formatPriceStr(keepTwoDecimalFull(details.deductedAmount || 0)) }
                    </XKText>
                </View>
                <View style={[CommonStyles.flex_between, styles.paddingHor, { paddingTop: 5,paddingBottom: 15 }]}>
                    <Text style={styles.color777}>平台抽成：</Text>
                    <XKText fontFamily="Oswald-Regular" style={[styles.color777]}>
                    { formatPriceStr(keepTwoDecimalFull(details.platformRakeAmount || 0)) }
                    </XKText>
                </View>
                <View style={[CommonStyles.flex_between, styles.paddingHor, { paddingTop: 5,paddingBottom: 15 }]}>
                    <Text style={styles.color777}>最终结算：</Text>
                    <XKText fontFamily="Oswald-Regular" style={[styles.color222]}>
                    { formatPriceStr(keepTwoDecimalFull(details.settleAmount || 0)) }
                    </XKText>
                </View>
                <Image source={separatorLine} style={{ width: width - 20 }}/>
                <View style={[CommonStyles.flex_between, styles.paddingHor, {  paddingBottom: 15, paddingTop: 15}]}>
                    <Text style={styles.color777}>结算时间：</Text>
                    <Text style={[styles.color222]}>
                    {
                        details.settleTime
                        ? moment(details.settleTime * 1000).format('YYYY-MM-DD HH:mm:ss')
                        : moment().format('YYYY-MM-DD HH:mm:ss')
                    }
                    </Text>
                </View>
                <View style={[CommonStyles.flex_between, styles.paddingHor, { paddingTop: 5}]}>
                    <Text style={styles.color777}>结算机构：</Text>
                    <Text style={[styles.color222]}>{details.organization}</Text>
                </View>
            </View>
        )
    }
    render() {
        const { navigation } = this.props
        return (
            <View style={styles.container} >
                <Header navigation={navigation} goBack={true} title='结算详情' />
                { this.renderTopSection() }
                { this.renderDetailList() }
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
    },
    detailWrap: {
        backgroundColor: '#fff',
        borderRadius: 8,
        margin: 10,
        paddingVertical: 15,
    },
    paddingHor: {
        paddingHorizontal: 15,
    },
    color777: {
        color: '#777',
        fontSize: 14,
    },

    color222: {
        color: '#222',
        fontSize: 14,
    },
})


export default connect(null,null
)(FinancialOrderDetail);
