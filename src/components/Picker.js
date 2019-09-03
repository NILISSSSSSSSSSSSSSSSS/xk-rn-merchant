/**
 * picker里的方法
 */
import Picker from 'react-native-picker-xk';
import * as Address from '../const/address'

const basicSet = {
    pickerCancelBtnText: '关闭',
    pickerConfirmBtnText: '确定',
    pickerTitleText: '',
    pickerBg: [255, 255, 255, 1],
    wheelFlex: [1, 1],
    pickerCancelBtnColor: [153, 153, 153, 1],
    pickerConfirmBtnColor: [74, 144, 250, 1],
    pickerFontColor: [34, 34, 34, 1],
    pickerToolBarBg:[255,255,255,1],
    pickerToolBarFontSize: 17,
    pickerFontSize: 17
}
const fullYear = new Date().getFullYear()
const fullMonth = new Date().getMonth() + 1
const fullDay = new Date().getDate()
const fullHour = new Date().getHours()
const fullMinute = new Date().getMinutes()
function getHourAndMin(){
    let hours=[]
    for (let i = 0; i < 24; i++) {
        let _hour={}
        let minutes=[]
        for (let j = 0; j < 60; j++) {
            minutes.push((j < 10 ? '0' + j : j)+'分');
        }
        _hour[(i < 10 ? '0' + i : i)+'时']= minutes
        hours.push(_hour);
    }
    return hours

}
function _createDateData1() {
    let date = [];
    for (let i = fullYear; i < fullYear + 50; i++) {
        let month = [];
        for (let j = i == fullYear ? fullMonth : 1; j < 13; j++) {
            let day = [];
            let _day={}
            let nowDays = i == fullYear && j == fullMonth ? fullDay : 1
            if (j === 2) {
                for (let k = nowDays; k < 29; k++) {
                    day.push(k + '日');
                }
                //Leap day for years that are divisible by 4, such as 2000, 2004
                if (i % 4 === 0) {
                    day.push(29 + '日');
                }
            }
            else if (j in { 1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1 }) {
                for (let k = nowDays; k < 32; k++) {
                    day.push(k + '日');
                }
            }
            else {
                for (let k = nowDays; k < 31; k++) {
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
function _createDateData() {
    let date = [];
    let hourAndMin=getHourAndMin()
    for (let i = fullYear; i < fullYear + 2; i++) {
        let month = [];
        for (let j = i == fullYear ? fullMonth : 1; j < 13; j++) {
            let day = [];
            let nowDays = i == fullYear && j == fullMonth ? fullDay : 1
            if (j === 2) {
                for (let k = nowDays; k < 29; k++) {
                    let _day={}
                    _day[k+'日']=hourAndMin
                    day.push(_day);
                    // day.push(k + '日');
                }
                //Leap day for years that are divisible by 4, such as 2000, 2004
                if (i % 4 === 0) {
                    let _day={}
                    _day[29+'日']=hourAndMin
                    day.push(_day);
                    // day.push(29 + '日');
                }
            }
            else if (j in { 1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1 }) {
                for (let k = nowDays; k < 32; k++) {
                    let _day={}
                    _day[k+'日']=hourAndMin
                    day.push(_day);
                    // day.push(k + '日');
                }
            }
            else {
                for (let k = nowDays; k < 31; k++) {
                    let _day={}
                    _day[k+'日']=hourAndMin
                    day.push(_day);
                    // day.push(k + '日');
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
/**
 *
 * @param {Function} callback
 * @param {Function} customData
 * @param {Date} defaultDate 将选择的时间，用moment(yourSelectTime)._d 传入
 * @param {Boolean} onlyYearMonth 是否只选择年月，需要使用 customData 自定义数据 详见：screens/shop/FinancialCenter.js
 */
function _showDatePicker(callback = () => { }, customData = _createDateData1, defaultDate = '', onlyYearMonth = false) {
    let date = new Date();
    let selectedValue = []
    if (defaultDate === '') {
        selectedValue = [
            date.getFullYear() + '年',
            (date.getMonth() + 1) + '月',
            date.getDate() + '日',
        ]
    } else {
        selectedValue = [
            defaultDate.getFullYear() + '年',
            (defaultDate.getMonth() + 1) + '月',
            defaultDate.getDate() + '日',
            defaultDate.getHours(),
            defaultDate.getMinutes()
        ]
    }
    if (typeof customData !== 'function') {
        _showError('自定义时间范围参数错误，参考组件Picker的_createDateData方法')
    }
    console.log(customData())
    Picker.init({
        pickerData: customData(),
        selectedValue,
        ...basicSet,
        onPickerConfirm: (pickedValue, pickedIndex) => {
            console.log('date', pickedValue, pickedIndex);
            const year = pickedValue[0].split('年')[0]
            const month = pickedValue[1].split('月')[0].length < 2 ? '0' + pickedValue[1].split('月')[0] : pickedValue[1].split('月')[0]
            const day = !onlyYearMonth ? pickedValue[2].split('日')[0].length < 2 ? '0' + pickedValue[2].split('日')[0] : pickedValue[2].split('日')[0] : null;
            // const date = year + '-' + month + '-' + day
            const date = `${year}-${month}${!onlyYearMonth ? `-${day}` : ''}`
            if (typeof callback !== 'function') {
                _showError('_showDatePicker方法传入参数错误')
            }
            callback(date)
        },
        onPickerCancel: (pickedValue, pickedIndex) => {
            console.log('date', pickedValue, pickedIndex);
        },
        onPickerSelect: (pickedValue, pickedIndex) => {
            console.log('date', pickedValue, pickedIndex);
        }
    });
    Picker.show();
}
saveMapAreaData = (province, cityAndDistrict) => {
    let provinceMap = []
    let cityAndArea = []
    for (let pro of province) {
        provinceMap.push([pro.code, pro.name]);
    }
    for (let item of cityAndDistrict) {
        cityAndArea.push([item.code, item.name])
    }
    return {
        provinceMap, cityAndArea
    }
}
function _showAreaPicker(callback, initData = []) {
    Picker.init({
        ...basicSet,
        pickerData: Address.pickerArea.area || [],
        selectedValue: initData || [],
        onPickerConfirm: pickedValue => {
            const resultData = {
                names: pickedValue,
                codes: Address.getCodesByNames(pickedValue)
            }
            callback(resultData)
        },
        onPickerCancel: pickedValue => {
            // console.log('area', pickedValue);
        },
        onPickerSelect: pickedValue => {
            //Picker.select(['山东', '青岛', '黄岛区'])
            // console.log('area', pickedValue);
        }
    });
    Picker.show();
}

opreatSpecialTime=(witch,pickedValue)=>{ //处理选择到特殊日期
    if(witch == 'dateTime' || witch == 'date'){
        let mon=witch == 'dateTime' || witch == 'date'?1:0
        let day=witch == 'dateTime' || witch == 'date'?2:1
        let targetValue = [...pickedValue];
        if(parseInt(targetValue[mon]) === 2 && (witch == 'dateTime' || witch == 'date')){
            if(targetValue[0]%4 === 0 && targetValue[day] > 29){
                targetValue[day] = 29;
            }
            else if(targetValue[0]%4 !== 0 && targetValue[2] > 28){
                targetValue[day] = 28;
            }
        }
        else if(targetValue[mon] in {4:1, 6:1, 9:1, 11:1} && targetValue[day] > 30){
            targetValue[day] = 30;

        }
        // // forbidden some value such as some 2.29, 4.31, 6.31...
        if(JSON.stringify(targetValue) !== JSON.stringify(pickedValue)){
            // android will return String all the time，but we put Number into picker at first
            // so we need to convert them to Number again
            targetValue.map((v, k) => {
                if(k !== 3){
                    targetValue[k] = parseInt(v);
                }
            });
            Picker.select(targetValue);
            pickedValue = targetValue;
        }
    }
    return pickedValue
}

function _showTimePicker(witch, callback = (() => { }),initData='',selectedValue=[]) {
    let years = [],
        months = [],
        days = [],
        hours = [],
        minutes = [];
        secondes = []

    for (let i = 0; i < 50; i++) {
        years.push(i + fullYear);
    }
    for (let i = 1; i < 13; i++) {
        months.push(i);
    }
    for (let i = 1; i < 32; i++) {
        days.push(i);
    }

    for (let i = 0; i < 24; i++) {
        hours.push(i < 10 ? '0' + i : i);
    }
    for (let i = 0; i < 60; i++) {
        minutes.push(i < 10 ? '0' + i : i);
    }
    let pickerData = ''
    console.log('initData',initData)
    let date = initData || new Date();
    if (witch == 'dateTime') {
        pickerData = [years, months, days, hours, minutes]
        selectedValue.length>0 ?null: selectedValue = [
            date.getFullYear(),
            date.getMonth() + 1,
            date.getDate(),
            date.getHours(),
            date.getMinutes()
        ]
    }
    else if (witch == 'date') {
        pickerData = [years, months, days]
        selectedValue.length>0?null: selectedValue = [
            date.getFullYear(),
            date.getMonth() + 1,
            date.getDate(),
        ]
    }
    else {
        pickerData = [hours, minutes]
        selectedValue.length>0 ?null:selectedValue = [
            date.getHours(),
            date.getMinutes()
        ]
    }
    console.log('selectedValue',selectedValue)

    let changeDays = (pickedValue) => {
        days = [];
        var curMonthDays = new Date(parseInt(pickedValue[0]), parseInt(pickedValue[1]) ,0).getDate();
        for (let i = 1; i < curMonthDays+1; i++) {
            days.push(i);
        }
        pickerData = [years, months, days, hours, minutes]
        Picker.update({ pickerData, selectedValue: pickedValue });
    }

    let params = {
        pickerData,
        selectedValue,
        ...basicSet,
        onPickerConfirm: pickedValue => {
            console.log('area', pickedValue);
            pickedValue= opreatSpecialTime(witch,pickedValue)
            let data;
            if (witch == 'dateTime') {
                data = pickedValue[0] + '-' + pickedValue[1] + '-' + pickedValue[2] + ' ' + pickedValue[3] + ':' + pickedValue[4]
            }
            else if (witch == 'date') {
                data = pickedValue[0] + '-' + pickedValue[1] + '-' + pickedValue[2]
            }
            else {
                data = pickedValue[0] + ':' + pickedValue[1]
            }
            callback(data)
        },
        onPickerCancel: pickedValue => {
            console.log('area', pickedValue);
        },
        onPickerSelect: pickedValue => {
            pickedValue= opreatSpecialTime(witch,pickedValue)
            if(witch==="dateTime" || witch === "date") {
                changeDays(pickedValue);
            }
        }
    }

    Picker.init(params);
    Picker.show();
}
function _showError(str = '') {
    throw new Error(str)
}
export default { _showDatePicker, _showTimePicker, _createDateData, _showAreaPicker, basicSet };

// picker._showAreaPicker((data) => { console.log('选择', data) })
