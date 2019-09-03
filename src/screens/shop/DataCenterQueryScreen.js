/**
 * 数据中心=>选择时间查询
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
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import PickerOld from 'react-native-picker-xk';
import Picker from '../../components/Picker';
import moment from 'moment'

const { width, height } = Dimensions.get("window");
const date = new Date()
const fullYear = date.getFullYear()
const fullMonth = date.getMonth() + 1
const fullDay = date.getDate()

export default class DataCenterQueryScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const {sTime,eTime,chooseShop} = this.props.navigation.state.params
        this.state = {
            sTime: sTime,
            eTime: eTime,
            chooseShop:chooseShop || {}
        }
    }

    componentWillUnmount() {
        PickerOld.hide()
    }
    handleSelectData = (type) => {
        const { sTime, eTime } = this.state

        Picker._showDatePicker((data) => {
            if (type === 'sTime') {
                if (moment(eTime).isBefore(data)) {
                    Toast.show('开始时间不能大于结束时间')
                    return
                }
            }
            if (type === 'eTime') {
                if (moment(data).isBefore(sTime)) {
                    Toast.show('结束时间不能小于开始时间')
                    return
                }
            }
            this.handleChangeState(type, data)
        }, this._createDateData,moment(type === 'sTime'?sTime:eTime)._d)
    }
    handleChangeState = (key, value) => {
        this.setState({
            [key]: value
        })
    }
    handleGoBack = () => {
        const { navigation } = this.props
        // const callback = navigation.getParam('callback', () => { })
        // callback(this.state)
        // navigation.goBack()
        navigation.navigate('DataCenterFiter',this.state)
    }
    _createDateData = () => {
        let date = [];
        for (let i = fullYear - 10; i <= fullYear; i++) {
            let month = [];
            for (let j = 1; j < (i === fullYear ? fullMonth + 1 : 13); j++) {
                let day = [];
                let nowDays = 1 // 默认开始的天数为 1 号
                let endDay = (i === fullYear) && (j === fullMonth) ? fullDay : 31 // 如果时间为当前 年 ，当前 月 ，则结束时间为当前 日 ， 否则结束日为 31 天
                if (j === 2) {
                    for (let k = nowDays; k < 29; k++) {
                        day.push(k + '日');
                    }
                    if (i % 4 === 0) {
                        day.push(29 + '日');
                    }
                }
                else if (j in { 1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1 }) {
                    for (let k = nowDays; k <= endDay; k++) {
                        day.push(k + '日');
                    }
                }
                else {
                    for (let k = nowDays; k < endDay; k++) {
                        day.push(k + '日');
                    }
                }
                let _month = {};
                _month[j + '月'] = day;
                month.push(_month);
            }
            let _date = {};
            _date[i + '年'] = month;
            date.push(_date);
        }
        return date;
    }
    render() {
        const { navigation } = this.props;
        const { sTime, eTime } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"选择时间段"}
                    rightView={
                        <TouchableOpacity onPress={() => { this.handleGoBack() }}>
                            <Text style={styles.headerBtn}>确定</Text>
                        </TouchableOpacity>
                    }
                />
                <View style={styles.container_view}>
                    <TouchableOpacity onPress={() => { this.handleSelectData('sTime') }}>
                        <View style={styles.itemWrap}>
                            <View style={styles.itemWrapLeft}>
                                <View style={styles.itemWrapIcon_s} />
                                <Text style={styles.itemWrapText} >开始时间</Text>
                            </View>
                            <View style={styles.itemWrapRight}>
                                <Text style={styles.itemWrapRightText}>{sTime}</Text>
                                <Image source={require('../../images/index/expand.png')} />
                            </View>
                        </View>
                    </TouchableOpacity>
                    <TouchableOpacity onPress={() => { this.handleSelectData('eTime') }}>
                        <View style={[styles.itemWrap]}>
                            <View style={styles.itemWrapLeft}>
                                <View style={styles.itemWrapIcon_e} />
                                <Text style={styles.itemWrapText} >结束时间</Text>
                            </View>
                            <View style={styles.itemWrapRight}>
                                <Text style={styles.itemWrapRightText}>{eTime}</Text>
                                <Image source={require('../../images/index/expand.png')} />
                            </View>
                        </View>
                    </TouchableOpacity>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    headerBtn: {
        fontSize: 17,
        color: '#fff',
        paddingRight: 24,
    },
    container_view: {
        marginHorizontal: 10,
    },
    itemWrap: {
        marginTop: 10,
        height: 50,
        borderRadius: 8,
        backgroundColor: '#fff',
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingLeft: 20,
        paddingRight: 20
    },
    itemOtherStyle: {
        marginTop: 5
    },
    itemWrapLeft: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center'
    },
    itemWrapImg: {
        height: 6,
        width: 6,
        marginRight: 14
    },
    itemWrapIcon_s: {
        height: 6,
        width: 6,
        borderRadius: 2,
        backgroundColor: '#EC6FB4',
        marginRight: 14
    },
    itemWrapIcon_e: {
        height: 6,
        width: 6,
        borderRadius: 2,
        backgroundColor: '#7A77E8',
        marginRight: 14
    },
    itemWrapText: {
        fontSize: 14,
        color: '#222'
    },
    itemWrapRight: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center'
    },
    itemWrapRightText: {
        fontSize: 14,
        color: '#222',
        marginRight: 23
    }
});
