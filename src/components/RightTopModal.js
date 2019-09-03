/**
 * RightTopModal 右上角的筛选modal
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
import Line from './Line.js';
import CommonStyles from '../common/Styles';
const { width, height } = Dimensions.get("window");
function getwidth(val) {
    return width * val / 375
}
const initState={
    visible:false,
    options:[{title:'',onPress:()=>{}}],
    contentStyle:{},
    sanjiaoStyle:{},
    closeCallback:()=>{},
    modalShaixuanStyle:{}
}
export default class RightTopModal extends PureComponent {
    constructor(props) {
        super(props)
        this.state = initState
    }

    componentDidMount() {
    }
    show=(param={})=>{
        this.setState({
            visible:true,
            ...param
        })

    }
    hide=(callback)=>{
        this.state.closeCallback()
        this.setState(initState)
        callback && callback()
    }


    render() {
        const { visible,options,children,contentStyle,sanjiaoStyle,modalShaixuanStyle } = this.state
        console.log(children)
        return (
            < Modal
                    animationType={'fade'}
                    transparent={true}
                    visible={visible}
                    onRequestClose={() => { this.hide() }}
                >
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => { this.hide() }}
                        style={styles.modalView}
                    >

                         {children}
                        <View style={[styles.content,{top:Platform.OS=='ios'? 40+CommonStyles.headerPadding:40},contentStyle]}>
                            <View style={[styles.sanjiao,sanjiaoStyle]}></View>
                            <ScrollView style={[styles.modalShaixuan,modalShaixuanStyle]} showsVerticalScrollIndicator={false}>
                                {
                                    options.map((item, index) => {
                                        return (
                                            <TouchableOpacity
                                                key={index}
                                                onPress={() => {
                                                    this.hide(()=>item.onPress && item.onPress(item,index))
                                                }}
                                                style={[styles.shaixuanItem,{borderBottomWidth:index==options.length-1?0:1}]}>
                                                <Text style={{paddingHorizontal: 15,color:'#222',fontSize:14}}>{item.title}</Text>
                                            </TouchableOpacity>
                                        )
                                    })
                                }
                            </ScrollView>

                        </View>

                    </TouchableOpacity>
                </Modal >
        );
    }
}

const styles = StyleSheet.create({
    modalView: {
        flex:1,
        backgroundColor: 'rgba(0,0,0,0.5)',
        paddingTop:-CommonStyles.headerPadding
    },
    modalShaixuan: {
        position: 'absolute',
        top: 2.5,
        right: 0,
        backgroundColor: '#fff',
        borderRadius: 6,
        maxHeight: 250,
        width:126
    },
    sanjiao: {
        position: 'absolute',
        top: 0,
        right: 15,
        width: 20,
        height: 20,
        borderWidth: 1,
        backgroundColor: 'white',
        borderLeftColor: '#DDDDDD',
        borderTopColor: '#DDDDDD',
        borderRightColor: 'white',
        borderBottomColor: 'white',
        transform: [{ rotateZ: '45deg' }],
    },
    shaixuanItem: {
        height: 44,
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        justifyContent: 'center',
        alignItems: 'center'
    },
    content:{
        position: 'absolute',
        top: 40+CommonStyles.headerPadding,
        right: 10,
    },
    children:{
        // position:'absolute',
        // top:(Platform.OS=='ios'? CommonStyles.headerPadding:0)+12,
        // left:0
    }
});
