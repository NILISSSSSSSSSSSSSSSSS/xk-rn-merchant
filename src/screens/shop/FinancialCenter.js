
/**
 * 财务中心
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,

    View,
    Text,
    Button,
    Image,
    Platform,
    ScrollView,
    TouchableOpacity,
    ImageBackground,
    BackHandler,
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import moment from 'moment';
import Content from '../../components/ContentItem';
import FlatListView from '../../components/FlatListView';
import Picker from '../../components/Picker';
import PickerOld from 'react-native-picker-xk';
import { fetchshopOrderDataQPage } from '../../config/requestApi';
const { width, height } = Dimensions.get('window');
import {  formatPriceStr, keepTwoDecimalFull } from '../../config/utils';
import  math from '../../config/math.js';
import XKText from '../../components/XKText';
import ActionSheet from '../../components/Actionsheet';

import { NavigationComponent } from '../../common/NavigationComponent';
const downIcon = require('../../images/shop/down_icon.png');
const separatorLine = require('../../images/shop/separatorLine.png');
const endYear = moment().year(); // 截止年份
const endMonth = moment().month() + 1; // 截止月份

const startYear = moment().subtract(3, 'y').year(); // 开始年份
const startMonth = moment().subtract(3, 'y').month() + 1; // 开始月份


const MONTH_FORMAT = 'YYYY-MM';
const DATE_FORMAT = 'YYYY-MM-DD';
const DATETIME_FORMAT = 'YYYY-MM-DD HH:mm:ss';

class FinancialCenter extends NavigationComponent {
    constructor(props){
        super(props);
        this.state = {
            startTime: '',
            endTime: '',
            settlementType: 'online', // online  订单结算 underline  收款结算
            dateRange: this.getTimeRange(),
        };
    }
    componentDidMount(){
        let now_year = moment().year();
        let now_mon = moment().month() + 1;
        let timeObj = this.handleGetStartAndEndTime(`${now_year}-${now_mon}`);
        this.setState({
            startTime: timeObj.startTime,
            endTime: timeObj.endTime,
        }, () => {
            this.getList(1,true);
        });
    }
    componentWillUnmount() {
        super.componentWillUnmount();
        PickerOld.hide();
        RightTopModal.hide();
    }
    // 获取数据
    getList = (page = 1) => {
        const {
            startTime, endTime, settlementType,
        } = this.state;
        const { userShop } = this.props;
        Loading.show();
        let paramsPrivate = {
            startTime,
            endTime,
            incomeSource: settlementType,
            shopId: userShop.id,
            limit: 10,
            page,
        };
        this.props.getDataList(paramsPrivate);
    };
    handleFilterSettlementType = (settlementType = 'underline') => {
        this.setState({ settlementType }, () => { this.getList(1, false); });
    }

    // 显示时间选择弹窗
    handleSelectTime = () => {
        Picker._showDatePicker(
            (data) => {
                let timeObj = this.handleGetStartAndEndTime(data);
                this.setState({
                    startTime: timeObj.startTime,
                    endTime: timeObj.endTime,
                }, () => {
                    this.getList(1,false);
                });
            },
            this._createDateData, // 自定义的时间
            moment(this.state.startTime * 1000)._d, // 默认选择的时间
            true, // 不显示日期
        );
    }
    // 设置选择的日期范围 3年内
    _createDateData = () => {
        let date = [];
        for (let i = startYear; i <= endYear; i++) {
            let month = [];
            for (let j = 1; j <= 12; j++) {
                if (i === startYear && j >= startMonth) {
                    month.push(`${j}月`);
                }
                if (i === endYear && j <= endMonth) {
                    month.push(`${j}月`);
                }
                if (i !== startYear && i !== endYear) {
                    month.push(`${j}月`);
                }

            }
            let _date = {};
            _date[i + '年'] = month;
            date.push(_date);
        }
        console.log('date',date);
        return date;
    }
    // 对选择对时间进行边界处理
    handleGetStartAndEndTime = (data = moment().format(MONTH_FORMAT)) => {
        console.log('data',data);
        let data_arr = data.split('-');
        let select_year = parseInt(data_arr[0], 10);
        let select_mon = parseInt(data_arr[1], 10);
        let now_year = moment().year();
        let now_mon = moment().month() + 1;
        let startTime, endTime;
        const getPrevTime = () => {
            startTime = moment(`${select_year}-${select_mon}-01`, DATE_FORMAT).valueOf();
            endTime = moment(`${select_year}-${select_mon}-${this.getEndDay(select_year, select_mon) || moment()} 23:59:59`, DATETIME_FORMAT).valueOf();
        };
        if (select_year === now_year) {
            if (select_mon === now_mon) { // 选择时间为本年本月时，处理时间边界
                startTime = moment(`${now_year}-${now_mon}-01`, DATE_FORMAT).valueOf(); // 开始时间 时间戳
                endTime = moment().valueOf(); // 结束时间 时间戳
            } else { // 否则起始时间为当前选择年月的 1号 至 31/30/28/29 日
                getPrevTime();
            }
        } else {
            getPrevTime();
        }

        console.log('startTime',startTime);
        console.log('endTime',endTime);
        console.log('startTime',moment(startTime));
        console.log('endTime',moment(endTime));
        return {
            startTime: parseInt(startTime / 1000, 10),
            endTime: parseInt(endTime / 1000, 10),
        };
    }
    // 获取指定时间（3年内）范围的 年月日数据
    getTimeRange = () => {
        let now_mon = moment().month() + 1;
        let now_day = moment().date();
        let date = new Map();
        for (let i = startYear; i <= endYear; i++) {
            let month = new Map();
            for (let j = 1; j < (i === endYear ? now_mon : 13); j++) {
                let day = []; // 判断了闰年，大小月的日期数据
                let nowDays = 1; // 默认开始的天数为 1 号
                let endDay = (i === endYear) && (j === now_mon) ? now_day : 31; // 如果时间为当前 年 ，当前 月 ，则结束时间为当前 日 ， 否则结束日为 31 天
                if (j === 2) { // 2月判断闰年
                    for (let k = nowDays; k < 29; k++) {
                        day.push(k);
                    }
                    if (i % 4 === 0) {
                        day.push(29);
                    }
                } // 判断大小月
                else if (j in { 1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1 }) {
                    for (let k = nowDays; k <= endDay; k++) {
                        day.push(k);
                    }
                }
                else {
                    for (let k = nowDays; k < endDay; k++) {
                        day.push(k);
                    }
                }
                month.set(j,day);
            }
            date.set(i, month);
        }
        return date;
    }
    getEndDay = (select_year, select_mon) => {
        const { dateRange } = this.state;
        let select_mon_daysArr  = dateRange.get(select_year).get(select_mon);
        return select_mon_daysArr[select_mon_daysArr.length - 1];
    }
    goItemDetail = (orderId, nickName) => {
        const { navigation } = this.props;
        const { settlementType } = this.state
        navigation.navigate('FinancialOrderDetail', { orderId, nickName, incomeSource: settlementType, });
    }
    renderTopSection = () => {
        const { startTime,settlementType } = this.state;
        const { settleMoneySum } = this.props;
        console.log('start',startTime);
        return (
            <ImageBackground source={require('../../images/shop/financialCenter_topBg.png')} style={{width,height: 138}}>
                <View style={[styles.topFilterWrap, CommonStyles.flex_between]}>
                    <TouchableOpacity activeOpacity={0.65} style={[CommonStyles.flex_start]} onPress={this.handleSelectTime}>
                        <Text style={{ fontSize: 16, color: '#fff' }}>{!startTime ? moment().format(MONTH_FORMAT) : moment(startTime * 1000).format(MONTH_FORMAT)}</Text>
                        <Image source={downIcon} style={{ marginLeft: 3 }}/>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={0.65} style={[CommonStyles.flex_start]} onPress={() => { this.ActionSheet.show(); }}>
                        <Text style={{ fontSize: 16, color: '#fff' }}>{ (settlementType === 'online') ? '订单结算' : '收款结算' }</Text>
                        <Image source={downIcon} style={{ marginLeft: 3 }}/>
                    </TouchableOpacity>
                </View>
                <View style={[CommonStyles.flex_center]}>
                    <Text style={{ fontSize: 14, color: 'rgba(255,255,255,.5)' }}>累计结算(元)</Text>
                    <XKText fontFamily="Oswald-Regular" style={{ fontSize: 32, color: '#fff', paddingTop: 5 }}>{ formatPriceStr(keepTwoDecimalFull(settleMoneySum)) }</XKText>
                </View>
            </ImageBackground>
        );
    }
    renderItem = ({ item, index }) => {
        const { financialList } = this.props;
        let len = financialList.data.length;
        let topBorderRadisu = index === 0 ? styles.topBorderRadius : null;
        let bottomBorderRadius = index === len - 1 ? styles.bottomBorderRadius : null;
        return (
            <TouchableOpacity activeOpacity={0.65} style={[styles.itemWrap, topBorderRadisu, bottomBorderRadius]} onPress={() => { this.goItemDetail(item.orderId || '', item.nickName); }}>
                <Text style={{ fontSize: 14, color: '#777' }}>结算时间：{ moment(item.settleTime * 1000).format(DATETIME_FORMAT) }</Text>
                <View style={[CommonStyles.flex_between]}>
                    <Text style={{ fontSize: 15, color: '#222',paddingTop: 15 }}>{ item.nickName || '晓可用户' }</Text>
                    <XKText fontFamily="Oswald-Regular" style={{ fontSize: 15, color: '#EE6161',marginTop: 10}}><Text style={{ fontSize: 20, color: '#EE6161' }}>+</Text>
                    { formatPriceStr(keepTwoDecimalFull(item.settleMoney)) }
                    </XKText>
                </View>
                {
                    index !== len - 1 && <Image source={separatorLine} style={{ position: 'absolute',bottom: 0,left: 15,right: 15,width: width - 50 }}/>
                }
            </TouchableOpacity>
        );
    }
    render() {
        const { navigation, financialList } = this.props;
        console.log('financialList', financialList);
        return (
            <View style={styles.container} >
                <Header navigation={navigation} goBack={true} title="财务中心" />
                { this.renderTopSection() }
                <FlatListView
                    type="R1_financial_Base"
                    data={financialList.data || []}
                    style={{ flex: 1, backgroundColor: CommonStyles.globalBgColor,marginTop:10 }}
                    renderItem={this.renderItem}
                    store={financialList.params}
                    ItemSeparatorComponent={() => null}
                    footerStyle={{  backgroundColor: CommonStyles.globalBgColor,marginBottom:CommonStyles.footerPadding}}
                    ListHeaderComponent={<View />}
                    refreshData={() => this.getList(1,false)
                    }
                    loadMoreData={() => this.getList(financialList.params.page + 1)
                    }
                />
                <ActionSheet
                    ref={ref => (this.ActionSheet = ref)}
                    options={['订单结算','收款结算','取消']}
                    cancelButtonIndex={2}
                    onPress={index => {
                        index !== 2 && this.handleFilterSettlementType(!index ? 'online' : 'underline');
                    }}
                />
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    topFilterWrap: {
        paddingTop: 15,
        paddingBottom: 15,
        paddingHorizontal: 40,
    },
    itemWrap: {
        marginHorizontal: 10,
        paddingHorizontal: 15,
        paddingVertical: 20,
        backgroundColor: '#fff',
        position: 'relative',
    },
    topBorderRadius: {
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
    },
    bottomBorderRadius: {
        borderBottomRightRadius: 8,
        borderBottomLeftRadius: 8,
    },
});


export default connect(
    (state) => ({
        settleMoneySum: state.shop.settleMoneySum, // 累计金额
        financialList: state.shop.financialList, // lists
        userShop:state.user.userShop || {},
     }),
     {
        getDataList: (params)=> ({ type: 'shop/getFinancialCenterList', payload: { params }}),
     }
)(FinancialCenter);
