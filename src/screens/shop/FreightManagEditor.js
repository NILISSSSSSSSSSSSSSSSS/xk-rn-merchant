
/**
 * 运费管理
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    ScrollView,
    Image,
    FlatList,
    RefreshControl,
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva'
import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import FlatListView from '../../components/FlatListView'
import * as requestApi from '../../config/requestApi'
import Content from '../../components/ContentItem'
import ImageView from '../../components/ImageView'
import TextInputView from '../../components/TextInputView';
const level1nochoose = require('../../images/mall/unchecked.png');
const level1choose = require('../../images/mall/level1choose.png');
const { width, height } = Dimensions.get('window')
import PriceInputView from "../../components/PriceInputView";
import math from '../../config/math';
function getwidth(val) {
    return width * val / 375
}
const lists=[
    {title:'按订单商品数量计算',unit:'件',shu:'数量',valuateType:'BY_NUMBER'},
    {title:'按订单商品总重计算',unit:'kg',shu:'总重',valuateType:'BY_WEIGHT'},
    {title:'按订单配送距离计算',unit:'km',shu:'距离',valuateType:'DISTANCE'},
]

export default class FreightManagEditor extends Component {
    constructor(props) {
        super(props)
        const { itemdata,callback } = this.props.navigation.state.params
        this.id = itemdata.id
        const destFee=itemdata.destFee || {}
        const valuateType=itemdata.valuateType || 'BY_NUMBER'
        let data={
            defaultNum:valuateType=='BY_NUMBER'?destFee.defaultNum:math.divide(destFee.defaultNum,1000),
            defaultFee:math.divide(Number(destFee.defaultFee || 0) ,100),
            increNum:valuateType=='BY_NUMBER'?destFee.increNum:math.divide(destFee.increNum,1000),
            increFee:math.divide(Number(destFee.increFee || 0) ,100)
        }
        this.state = {
            valuateType,
            data,
            callback
        }
    }
    changeChecked = (valuateType) => {
            let data = {
                defaultNum: '',
                defaultFee: '',
                increNum: '',
                increFee: '',
            }
            this.setState({
                valuateType,
                data
            })

    }
    checkedPonintNum = (data, name) => {
        data=data.toString() || ''
        if (/\./.test(data)) {
            let indexPoint = (data || '').indexOf('.')
            let endStr = data.substring(indexPoint + 1)
            if (endStr.length > 2) {
                Toast.show(`${name}最多两位小数`, 2000)
                return false
            }
        }
        return true
    }
    saveTHIRD = () => {
        let { valuateType, data } = this.state
        if(!valuateType){
            Toast.show('请选择运费计算方式')
            return
        }
        if (parseFloat(data.defaultNum)==0 || parseFloat(data.increNum)==0 || parseFloat(data.defaultFee)==0 || !data.defaultNum || !data.increNum || !data.defaultFee) {
            Toast.show('请填写完整的运费计算方式,且不能为0', 2000)
            return
        }
        if (valuateType === 'BY_NUMBER') {
            let defaultNum = data.defaultNum
            if (/\./.test(defaultNum)) {
                Toast.show('件数不能为小数', 2000)
                return
            }
            if (/\./.test(data.increNum)) {
                Toast.show('件数不能为小数', 2000)
                return
            }
        } else {
            if (this.checkedPonintNum(data.defaultNum, '重量')) {
                if (!this.checkedPonintNum(data.increNum, '重量')) {
                    return
                }
            } else {
                return
            }
        }
        if (Number(data.defaultFee) < 0 || Number(data.increFee) < 0) {
            Toast.show('价格为非负数', 2000)
            return
        }
        if (this.checkedPonintNum(data.defaultFee, '费用')) {
            if (!this.checkedPonintNum(data.increFee, '费用')) {
                return
            }
        } else {
            return
        }
        if (String(parseInt(data.defaultFee)).length >= 8 || String(parseInt(data.defaultNum)).length >= 8 || String(parseInt(data.increFee)).length >= 8 || String(parseInt(data.increNum)).length >= 8) {
            Toast.show('数据长度过长')
            return
        }
        let param = {
            id: this.id,
            valuateType: valuateType,
            postType:'THIRD',
            destFee: {
                defaultNum: valuateType=='BY_NUMBER'?Number(data.defaultNum):math.multiply(Number(data.defaultNum),1000) ,
                increNum: valuateType=='BY_NUMBER'?Number(data.increNum):math.multiply(Number(data.increNum),1000),
                defaultFee:math.multiply(Number(data.defaultFee),100),
                increFee: math.multiply(Number(data.increFee),100)
            }
        }
        requestApi.mUserPostFeeUpdate(param).then((res) => {
            this.state.callback()
            Toast.show('修改成功', 2000)
            this.props.navigation.goBack()
        }).catch(()=>{
          
        })
    }
    saveDate = () => {

            this.saveTHIRD()

    }
    handleData1change = (val, name) => {
        let data = this.state.data
        data[name] = val
        this.setState({
            data
        })
    }
    render() {
        const { navigation } = this.props
        const { valuateType, data} = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='运费设置'
                    rightView={
                        <TouchableOpacity
                            onPress={this.saveDate}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: '#fff' }}>保存</Text>
                        </TouchableOpacity>
                    }
                />
                <ScrollView showsVerticalScrollIndicator={false}>
                <Content style={{marginBottom:10}}>
                    <View style={styles.head}>
                        <Text style={styles.title}>请选择运费计算方式</Text>
                    </View>

                    {
                        lists.map((item,index)=>{
                            const isCurrent=valuateType === item.valuateType
                            return(
                                <View style={styles.contentItem} key={index}>
                                    <TouchableOpacity
                                        onPress={() => { this.changeChecked(item.valuateType) }}
                                        style={{flexDirection:'row',marginBottom:6,alignItems:'center'}}
                                    >
                                        <Image source={isCurrent? level1choose : level1nochoose} style={{width:getwidth(18),height:getwidth(18),marginRight:getwidth(10)}}/>
                                        <Text style={styles.c2f14}>{item.title}</Text>
                                    </TouchableOpacity>
                                    <View style={styles.editView}>
                                        {
                                            [
                                                {title:item.shu+'('+item.unit+')',key:'defaultNum'},
                                                {title:'运费(¥)',key:'defaultFee'},
                                                {title:'当'+item.shu+'增加('+item.unit+')',key:'increNum'},
                                                {title:'运费增加(¥)',key:'increFee'}

                                            ].map((item2,index2)=>{
                                                return(
                                                    <View key={index2} style={styles.editItem}>
                                                        <Text style={[styles.c9f14,{marginRight:getwidth(5)}]}>{item2.title}</Text>
                                                        <PriceInputView
                                                            style={styles.inputTxt}
                                                            placeholder={index2===0 || index2===2?'请输入':'0.00'}
                                                            editable={isCurrent}
                                                            value={isCurrent ? data[item2.key] : ''}
                                                            onChangeText={(val) => { this.handleData1change(val, item2.key) }}
                                                        />
                                                    </View>
                                                )
                                            })
                                        }
                                    </View>
                                </View>
                            )
                        })

                    }
                </Content>
                </ScrollView>
            </View >
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor
    },
    head:{
        height:46,
        borderBottomWidth:1,
        borderColor:'#f1f1f1',
        justifyContent:'center',
        paddingLeft:15,
        marginBottom:20
    },
    title:{
        fontSize:getwidth(16),
        color:'#222222',
        fontWeight:'600'
    },
    c9f14:{
        color:'#999999',
        fontSize:getwidth(14)
    },

    contentItem: {
        marginLeft:getwidth(15),
        flex:1
    },
    editView:{
        marginLeft:getwidth(28),
        flex:1,
        flexDirection:'row',
        flexWrap:'wrap',
        marginBottom:30
    },
    editItem:{
        height:54,
        alignItems:'center',
        flexDirection:'row',
        width:'50%',
        borderBottomWidth:1,
        borderColor:'#f1f1f1'

    },
    inputTxt: {
        textAlignVertical: 'bottom',
        width: getwidth(50),
        fontSize:getwidth(14)
    },
    inputView: {
        flexDirection: 'row',
        flexWrap: 'nowrap',
    }

})
