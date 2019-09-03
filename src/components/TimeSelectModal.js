/**
 * 订单选择预约时间段
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    View,
    Text,
    TouchableOpacity,
    Dimensions,
    Modal,
    ScrollView,
    Platform
} from "react-native";
import CommonStyles from '../common/Styles';
const { width, height } = Dimensions.get("window");
import moment from 'moment'
import Label from "./Label";
const date=[
    {name:'今天'+moment().format('MM-DD'),value:moment().format('YYYY-MM-DD')},
    {name:'明天'+moment().add(1,'days').format('MM-DD'),value:moment().add(1,'days').format('YYYY-MM-DD')},
    {name:'后天'+moment().add(2,'days').format('MM-DD'),value:moment().add(2,'days').format('YYYY-MM-DD')},
]
let times=[]
for(let i=0;i<24;i++){
    times.push(i+':00-'+(i+1)+':00')
}
export default class TimeSelectModal extends Component {
    confirm=()=>{
        const { selectedDateIndex,selectedTimeIndex } = this.getPropTime()
        let dayStr = date[selectedDateIndex].value;
        let timeStr = times[selectedTimeIndex].split("-")[1];
        const disabled = moment(dayStr + " " + timeStr, "YYYY-MM-DD hh:mm").valueOf() < Date.now();
        if(disabled) {
            Toast.show("你选择的时间段不能小于当前时间，请选择合理的时间段");
            this.props.onClose && this.props.onClose();
            return
        }
        this.props.onConfirm && this.props.onConfirm(date[selectedDateIndex].value,times[selectedTimeIndex]);
        this.props.onClose && this.props.onClose();
    }
    getPropTime=()=>{
        const {time}=this.props || {}
        const propDate=this.props.date
        let selectedDateIndex=0
        let selectedTimeIndex=0
        for(let i in date){
            date[i].value==propDate?selectedDateIndex=i:null
        }
        for(let i in times){
            times[i]==time?selectedTimeIndex=i:null
        }
        return{
            selectedDateIndex,
            selectedTimeIndex,
            time,
            propDate
        }
    }

    render() {
        const { selectedDateIndex,selectedTimeIndex, time, propDate } = this.getPropTime()
        return (
            < Modal
                    animationType={'fade'}
                    transparent={true}
                    visible={this.props.visible || false}
                    onRequestClose={() => { this.props.onClose() }}
                >
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => { this.props.onClose() }}
                        style={styles.modalView}
                    >
                    </TouchableOpacity>
                        <View style={[styles.content]}>
                            <Text style={styles.title}>预定时间</Text>
                            <View style={styles.center}>
                                <Text style={styles.seconedTitle}>日期</Text>
                                <View style={styles.itemsView}>
                                    {
                                        date.map((item,index)=>{
                                            return <Label style={styles.label} key={index} title={item.name} checked={index==selectedDateIndex} onPress={()=> this.props.onChange({ date: item.value, time })} />
                                        })
                                    }
                                </View>
                                <Text style={styles.seconedTitle}>时间</Text>
                                <ScrollView showsVerticalScrollIndicator={false} style={{flex:1}} contentContainerStyle={{paddingBottom:10}}>
                                    <View style={styles.itemsView}>
                                        {
                                            times.map((item, index) => {
                                                const disabled = moment(propDate + " " + item.split("-")[1], "YYYY-MM-DD hh:mm").valueOf() < Date.now();
                                                return (
                                                    <Label style={styles.label} disabled={disabled} key={index} title={item} checked={index==selectedTimeIndex}  onPress={()=> this.props.onChange({ date: propDate, time: item })} />
                                                )
                                            })
                                        }
                                    </View>
                                </ScrollView>
                            </View>
                            <TouchableOpacity style={styles.btn} onPress={this.confirm}>
                                <Text style={{color:'#fff',fontSize:17}}>确定</Text>
                            </TouchableOpacity>
                        </View>

                </Modal >
        );
    }
}

const styles = StyleSheet.create({
    modalView: {
        backgroundColor: 'rgba(0,0,0,0.5)',
        flex:1
    },
    title:{
        fontSize:17,
        color:'#222',
        marginVertical:18,
        textAlign:'center',
    },
    center:{
        borderTopColor:'#f1f1f1',
        borderTopWidth:1,
        paddingHorizontal:10,
        flex:1
    },
    seconedTitle:{
        fontSize:14,
        color:'#222',
        margin:15
    },
    itemsView:{
        flexDirection:'row',
        alignItems:'center',
        flexWrap:'wrap',
        justifyContent: 'flex-start',
        width,
    },
    content:{
        backgroundColor:'#fff',
        height:height/2,
        position:'absolute',
        bottom:0,
        paddingBottom:CommonStyles.footerPadding
    },
    label:{
        marginRight:15,
        marginBottom:6
    },
    btn:{
        height:50,
        width:width,
        backgroundColor:CommonStyles.globalHeaderColor,
        alignItems:'center',
        justifyContent:'center'
    }
});
