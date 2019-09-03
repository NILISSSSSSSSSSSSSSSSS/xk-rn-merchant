/**
 * 福利商城，开奖算法
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
    StatusBar,
    TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva";

import moment from 'moment'
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ListEmptyCom from '../../components/ListEmptyCom'

const { width, height } = Dimensions.get("window");

export default class WMLotteryAlgorithm extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
        }
    }

    componentDidMount() {
    }
    componentWillUnmount() {
    }
    getTitleText = (text) => {
        return <Text style={styles.titleText}>{text}</Text>
    }
    render() {
        const { navigation } = this.props;
        let lotteryData = navigation.getParam('lotteryData', {})
        console.log('lotteryData',lotteryData)
        let gzDataList = [
            {
                label:'重庆时时彩开奖日期：',
                value: moment(lotteryData.thirdWinningTime * 1000).format('YYYY-MM-DD')
            },
            {
                label:'重庆时时彩开奖期数：',
                value: lotteryData.thirdWinningNo || 0
            },
            {
                label:'重庆时时彩开奖号码：',
                value: lotteryData.thirdWinningNumber || 0
            },
        ]
        return (
            <View style={[styles.container, (lotteryData.userBuyRecord === 0) ? { } : CommonStyles.flex_1]}>
                <Header
                    goBack={true}
                    navigation={navigation}
                    title={"开奖算法"}
                />
                {
                    (lotteryData.userBuyRecord === 0)
                    ? <View style={{marginBottom: 140,flex:1}}>
                        <ListEmptyCom style={{paddingTop:0}} type='WMLotteryAlgorithm'/>
                    </View>
                    : <ScrollView
                        showsVerticalScrollIndicator={false}
                        showsHorizontalScrollIndicator={false}
                    >
                        <View style={[styles.containerWrap,{marginTop:10}]}>
                            { this.getTitleText('算法公式') }
                            <Text style={[styles.labelText,{marginTop: 5}]}>中奖编号=【<Text style={{color: '#FF7E00'}}>数值A/数值B</Text>】取余数+1</Text>
                        </View>
                        <View style={styles.containerWrap}>
                            <View style={[CommonStyles.flex_between]}>
                                { this.getTitleText('数值A') }
                                <Text style={{color:'#EE6161',fontSize: 12}}>注：数据来源于重庆时时彩</Text>
                            </View>
                            <Text style={[styles.labelText,{marginTop: 5}]}>=重庆时时彩开奖号码</Text>
                            <Text style={[styles.labelText]}>{ `=${lotteryData.thirdWinningNumber}` }</Text>
                        </View>
                        <View style={styles.containerWrap}>
                            <View style={[CommonStyles.flex_between]}>
                                { this.getTitleText('数值B') }
                                <TouchableOpacity onPress={() => {
                                    navigation.navigate('WMPartakeDetail', { sequenceId: lotteryData.termNumber })
                                }}>
                                <Text style={{color:'#4A90FA',fontSize: 14}}>参与详情</Text>
                                </TouchableOpacity>
                            </View>
                            <Text style={[styles.labelText,{marginTop: 5}]}>=本期参与注数</Text>
                            <Text style={[styles.labelText]}>{ `=${lotteryData.userBuyRecord}` }</Text>
                        </View>
                        <View style={styles.containerWrap}>
                            { this.getTitleText('本期计算结果') }
                            <Text style={[styles.labelText,{marginTop: 5}]}>{ `计算结果=【${lotteryData.thirdWinningNumber.replace(/\s+/g,"")}/${lotteryData.userBuyRecord}】取余数+1` }</Text>
                            <Text style={[styles.labelText]}>={parseInt(lotteryData.thirdWinningNumber.replace(/\s+/g,"")) % lotteryData.userBuyRecord} + 1</Text>
                            <Text style={[styles.labelText]}>{`中奖编号=${lotteryData.lotteryNumber}`}</Text>
                        </View>
                        <View style={styles.containerWrap}>
                            { this.getTitleText('时时彩数据') }
                            {
                                gzDataList.map((item,index) => {
                                    let paddingBottom = index === gzDataList.length - 1 ? null : {paddingBottom: 0} ;
                                    return (
                                        <View style={[CommonStyles.flex_start,{paddingVertical: 10,paddingRight: 10},paddingBottom]} key={index}>
                                            <Text style={styles.btmLabel}>{item.label}</Text>
                                            <Text style={[styles.btmLabel,(index === 1)? styles.redColor : null]}>{item.value}</Text>
                                        </View>
                                    )
                                })
                            }
                        </View>
                    </ScrollView>
                }

            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
    },
    containerWrap: {
        marginBottom: 10,
        marginHorizontal: 10,
        padding: 15,
        backgroundColor: '#fff',
        borderRadius: 8,
    },
    titleText: {
        fontSize: 16,
        color: CommonStyles.globalHeaderColor
    },
    labelText: {
        fontSize: 14,
        color: '#555',
        paddingTop: 15,
    },
    btmLabel: {
        fontSize: 14,
        color: '#555',
    },
    redColor: {
        color: '#EE6161'
    },
});

