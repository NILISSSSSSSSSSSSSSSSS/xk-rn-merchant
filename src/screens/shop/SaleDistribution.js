/**
 * 首页/促销管理/卡券分配
 */


import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    Modal,
    ScrollView,
    TouchableOpacity
} from 'react-native';
import { connect } from 'rn-dva';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import * as nativeApi from '../../config/nativeApi';
import FlatListView from '../../components/FlatListView';
import * as requestApi from '../../config/requestApi';
import * as utils from '../../config/utils';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import CommonButton from '../../components/CommonButton';
import * as regular from "../../config/regular";
import TextInputView from "../../components/TextInputView";
import { NavigationPureComponent } from '../../common/NavigationComponent';
import { Number } from 'core-js';
const { width, height } = Dimensions.get('window');


export default class SaleDistribution extends NavigationPureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        const {callback,anchors,totalNum} = this.props.navigation.state.params || {}
        this.state = {
            lists:anchors || [],
            visible: false,
            nickname:'',
            phone:'',// 13927791851
            num:'',
            anchorUserId:'',
            callback:callback || (()=>{}),
            error:'',
            avatar:'',
            totalNum,
        }
    }

    blurState = {
        visible: false,
    }

    componentWillUnmount() {
        super.componentWillUnmount()
        this.state.callback(this.state.lists)
    }
    add=()=>{
        const {phone,nickname,num,anchorUserId,error,avatar,lists,totalNum}=this.state
        let districtTotalNum=0
        lists.map(item=>districtTotalNum=districtTotalNum+ parseInt(item.anchorNum) )
        console.log(districtTotalNum+parseInt(num),totalNum)
        if (!regular.phone(phone)) {
            this.setState({error:"请输入正确格式的主播号"})
        }
        else if(!regular.intLarge(num) || num<0 || num==0){
            this.setState({error:"请输入正确格式的数量"})
        }
        else if(!anchorUserId){
            this.setState({error:"没有匹配到相应的主播"})
        }else if(lists.find(item=>item.anchorUserId==anchorUserId)){
            this.setState({error:"该主播已存在"})
        }else if(districtTotalNum+parseInt(num)>parseInt(totalNum)){
            this.setState({error:"分配数量已大于总数量"})
        }
        else {
            let newLists=[...this.state.lists]
            newLists.push(
                {
                    anchorNum:num,
                    anchorUserId,
                    phone,
                    nickname,
                    avatar
                }
            )
            this.setState({visible:false,lists:newLists})
        }
    }
    delete=(index)=>{
        let lists=[...this.state.lists]
        lists.splice(index,1)
        this.setState({lists})
    }
    showModal=()=>{
        this.setState({
            visible: true,
            avatar:'',
            anchorUserId:'',
            nickname:'',
            error:''
        });
    }
    render() {
        const { navigation } = this.props;
        const { lists,visible} = this.state
        return (
            <View style={styles.container}>
                <Header
                    title='卡券分配'
                    navigation={navigation}
                    goBack={true}
                    rightView={
                        lists.length==0?null:
                        <TouchableOpacity
                            onPress={this.showModal}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                                新增
                            </Text>
                        </TouchableOpacity>
                    }

                />
                <ScrollView>
                    {
                        lists.length==0?
                        <View style={{alignItems:'center',marginTop:70}}>
                            <ImageView
                                source={require('../../images/shop/distribution.png')}
                                sourceWidth={140}
                                sourceHeight={165}
                            />
                            <Text style={[styles.rightText]}>您还没分配卡券</Text>
                            <Text style={[styles.rightText,{marginTop:4}]}>请点击”新增”按钮将卡券分配给主播</Text>
                            <CommonButton style={{width:150,marginTop:40}} title='新增' onPress={this.showModal}/>


                        </View>:
                        <Content style={styles.content}>
                        {
                            lists.map((item,index)=>{
                                let br = null
                                if(index === 0){
                                    br ={
                                        borderTopRightRadius:10,
                                        borderTopLeftRadius:10
                                    }
                                }
                                if(index === lists.length - 1){
                                    br = {
                                        borderBottomRightRadius:10,
                                        borderBottomLeftRadius:10
                                    }
                                }
                                if(lists.length === 1){
                                    br = {
                                        borderTopRightRadius:10,
                                        borderTopLeftRadius:10,
                                        borderBottomRightRadius:10,
                                        borderBottomLeftRadius:10
                                    }
                                }
                                return(
                                    <View style={[styles.item,br]} key={index}>
                                        <View style={{flexDirection:'row',width:'50%'}}>
                                            <ImageView
                                                source={{uri:item.avatar || ''}}
                                                sourceWidth={40}
                                                sourceHeight={40}
                                                resizeMode='cover'
                                                style={{ marginRight: 10, borderRadius: 20 }}
                                            />
                                            <View style={{ justifyContent: 'center' }}>
                                               <View style={{width:100}}><Text style={{ color: '#222222', fontSize: 14 }} numberOfLines={1} ellipsizeMode='tail'>{item.nickname || '昵称'}</Text></View>
                                                <Text style={{ color: '#555555', fontSize: 10, marginTop: 6 }}>{item.phone}</Text>
                                            </View>
                                        </View>

                                        <Text style={[styles.rightText,{width:'30%'}]}>分配：{item.anchorNum}</Text>
                                        <TouchableOpacity style={styles.but} onPress={()=>this.delete(index)}>
                                            <Text style={[styles.rightText,{color:'#fff',fontSize:12}]}>删除</Text>
                                        </TouchableOpacity>
                                    </View>
                                )
                            })
                        }

                        </Content>

                    }


                </ScrollView>
                <Modal
                    animationType={'fade'}
                    transparent={true}
                    visible={ visible}
                    onRequestClose={() => { }}
                >
                    <View style={[styles.containerModal, { backgroundColor: 'rgba(0, 0, 0, 0.5)' }]} >
                        <View style={[styles.innerContainer, { backgroundColor: '#EFEFEF', paddingTop: 20 }]}>
                        <View style={{paddingHorizontal:16}}>
                            <Text style={styles.title}>新增主播</Text>
                                <TextInputView
                                    inputView={styles.inputView}
                                    placeholder='主播账号'
                                    placeholderTextColor={'#ccc'}
                                    style={styles.modalInput}
                                    maxLength={11}
                                    onChangeText={(data) => {
                                        this.setState({ phone: data,error:'' })
                                        data.length==11?
                                        requestApi.anchorDetail({phone:data}).then((res)=>{
                                            console.log('主播',res)
                                            if(res){
                                                this.setState({
                                                    avatar:res.avatar,
                                                    anchorUserId:res.id,
                                                    nickname:res.nickname
                                                })
                                            }else{
                                                this.setState({
                                                    avatar:'',
                                                    anchorUserId:'',
                                                    nickname:''
                                                })
                                            }

                                        }).catch(()=>{
                                            this.setState({
                                                avatar:'',
                                                anchorUserId:'',
                                                nickname:''
                                            })
                                        }):null
                                    }}
                                />
                                <Text style={styles.name}>昵称：{this.state.nickname}</Text>
                                <TextInputView
                                    inputView={[styles.inputView,{marginTop:15}]}
                                    placeholder='分配数量'
                                    placeholderTextColor={'#ccc'}
                                    style={styles.modalInput}
                                    maxLength={11}
                                    onChangeText={(data) => { this.setState({ num: data,error:'' }) }}
                                />
                                {
                                    this.state.error?
                                    <Text style={[styles.name,{color:CommonStyles.globalRedColor}]}>{this.state.error}</Text>:null
                                }
                        </View>


                            <View style={styles.row}>
                                <TouchableOpacity style={styles.btn}>
                                    <Text onPress={() => this.setState({ visible: false, nickname: '',num:'',phone:'',anchorUserId:'' })} style={styles.btn_text}>取消</Text>
                                </TouchableOpacity>
                                <TouchableOpacity style={[styles.btn, { borderColor: '#DDD', borderLeftWidth: 1 }]}>
                                    <Text onPress={() => this.add()} style={styles.btn_text}>确定</Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                    </View>
                </Modal>
            </View>
        );
    }
};
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    content:{
        width:width-20,
        marginLeft:10,
    },
    item: {
        borderBottomWidth: 1,
        borderColor: '#F1F1F1',
        paddingHorizontal: 15,
        paddingVertical: 10,
        flexDirection: 'row',
        alignItems: 'center',
        width: width - 20,
        backgroundColor: '#fff',
        justifyContent:'space-between'
    },
    rightText: {
        color: '#777777',
        fontSize: 14
    },
    but:{
        backgroundColor:'#EE6161',
        borderRadius:6,
        width:50,
        height:20,
        alignItems:'center',
        justifyContent:'center'
    },
    containerModal: {
        flex: 1,
        justifyContent: 'center',
        alignItems:'center'
    },
    innerContainer: {
        width:270,
        borderRadius: 10,
    },
    title: {
        color: '#030303',
        fontSize: 17,
        textAlign:'center'
    },
    inputView:{
        marginTop:20,
        height:24,
        width:'100%'
    },
    modalInput: {
        borderWidth: 1,
        borderColor: '#DDD',
        backgroundColor: 'white',
        paddingLeft: 5,

    },
    btn: {
        width: '50%',
        height: '100%'
    },
    button: {
        backgroundColor: '#4A90FA',
        borderRadius: 8,
        width: '80%',
        marginBottom: 20
    },
    btn_text: {
        textAlign: 'center',
        color: '#4A90FA',
        fontSize: 17,
        lineHeight: 50
    },
    name:{
        marginTop:10,
        color:'#222222',
        fontSize:12
    },
    row: {
        alignItems: 'center',
        width: '100%',
        flexDirection: 'row',
        marginTop: 20,
        borderColor: '#DDD',
        borderTopWidth: 1
    },



});

