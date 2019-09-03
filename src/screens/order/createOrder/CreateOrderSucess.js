//新增订单成功
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    BackHandler,
    Image,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../../components/Header";
import CommonStyles from "../../../common/Styles";
import ImageView from "../../../components/ImageView";
import Content from "../../../components/ContentItem";
import CommonButton from '../../../components/CommonButton';
const { width, height } = Dimensions.get("window");

class CreateOrderSucess extends PureComponent {
    _didFocusSubscription;
    _willBlurSubscription;
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
    };
    constructor(props) {
        super(props);
        this.state = {

        }
        this.listenBack()
    }
    listenBack=()=>{ //监听返回
        BackHandler.addEventListener('hardwareBackPress', this.onBackAndroid)
    }
    removeListen=()=>{
        BackHandler.removeEventListener('hardwareBackPress', this.onBackAndroid)
    }
    //触发返回键执行方法
    onBackAndroid = () => {
        this.goBack()
        return true;

    };
    componentWillUnmount(){
        this.removeListen()
    }
    goBack=()=>{
       this.removeListen()
       this.props.navigation.navigate('OrderListScreen')
    }
    goDetail=()=>{
        this.props.navigation.navigate('OfflneOrder', {
            ...this.props.navigation.getParam('orderParams') || {},
            shopId:this.props.userShop.id,
            routeIn:'CreateOrderSucess'
        })
    }

    render() {
        const { navigation } = this.props;
        const { topParams } = this.state;

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={false}
                    title="创建成功"
                    leftView={
                        <TouchableOpacity
                            style={styles.headerLeftView}
                            onPress={this.goBack}
                        >
                            <Image
                                source={require("../../../images/mall/goback.png")}
                            />
                        </TouchableOpacity>

                    }
                    rightView={
                        <TouchableOpacity style={styles.headerRightView} disabled={true} >
                            {/* <Text style={styles.headerRightView_text}> 规则说明 </Text> */}
                        </TouchableOpacity>
                    }
                    title={"创建成功"}
                />

                <View style={styles.content}>
                    <Content style={{paddingHorizontal:40,paddingVertical:30,alignItems:'center'}}>
                        <ImageView
                            source={require("../../../images/mall/pay_success.png")}
                            sourceWidth={66}
                            sourceHeight={66}
                            style={{marginBottom:12}}
                        />
                        <Text style={styles.text1}>订单创建成功</Text>
                        <View style={styles.butView}>
                            <CommonButton
                                title='返回'
                                textStyle={styles.butText}
                                style={[styles.but]}
                                onPress={this.goBack}
                            />
                             <CommonButton
                                 title='查看详情'
                                 style={[styles.but,{marginLeft:60}]}
                                 textStyle={styles.butText}
                                 onPress={this.goDetail}
                             />
                        </View>

                    </Content>

                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    content: {
        width: width - 20,
        marginHorizontal: 10,
        marginTop: 10,
    },
    whiteBlock: {
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        height: 192,
        backgroundColor: "#fff",
    },
    text1: {
        fontSize: 17,
        color: "#222",
        marginTop: 6,
    },
    butView:{
        width:width-100,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'center'
    },
    but:{
        width:'40%',
        backgroundColor:'#fff',
        height:30,
        borderRadius:4,
        marginBottom:0,
        marginTop:30
    },
    butText:{
        color:CommonStyles.globalHeaderColor,
        fontSize:14
    },
    headerLeftView: {
        width: width/3,
        alignItems: 'flex-start',
        paddingLeft: 18,
    },
    headerRightView: {
        paddingRight: 18,
        width: width /3,
        alignItems: 'flex-end'
    },
});

export default connect(
    (state) => ({ userShop: state.user.userShop || {} }),
)(CreateOrderSucess);
