/**
 * 下级店铺列表
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,

    View,
    Text,
    Button,
    RefreshControl,
    Image,
    ScrollView,
    Platform,
    Modal,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from "../../components/ImageView";
import * as nativeApi from "../../config/nativeApi";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
import FlatListView from "../../components/FlatListView";
import ListEmptyCom from '../../components/ListEmptyCom';
const { width, height } = Dimensions.get("window");
import * as requestApi from "../../config/requestApi";
import { NavigationPureComponent } from "../../common/NavigationComponent";

class StoreManageScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            visiblePopover: false,
            buttonRect: {},
            refreshing:false,
        };
    }

    blurState = {
        visiblePopover: false
    }
    componentWillUnmount() {
        super.componentWillUnmount()
        RightTopModal.hide()
    }
    renderItem = ({ item, index }) => {
        let items=[
            {title:"店铺编号",value:item.code},
            {title:"店铺名称",value:item.name},
            {title:"与本店关系",value:item.shopType == "SHOP_IN_SHOP"? "店中店": item.shopType == "MASTER"? "本店": "分店"},
            {title:"店铺地址",value:item.address},
            {title:"联系电话",value:item.contactPhones && item.contactPhones.join(" ") || ''},
        ]
        return (
            <Content
                key={index}
                onPress={() => {
                    this.props.navigation.navigate("StoreDetail", {
                        shopId: item.id
                    });
                }}
            >
                {
                    items.map((item,index)=>{
                        return(
                            <Line
                                key={index}
                                title={item.title}
                                value={item.value}
                                type={item.rightView?'custom':''}
                                rightView={item.rightView}
                                point={null}
                                rightValueStyle={{textAlign:'right'}}
                            />
                        )
                    })
                }
            </Content>
        );
    };
    showPopover() {
      const {navigation}=this.props
        RightTopModal.show({
           options: [
                { title: '新增店铺',onPress:()=>navigation.navigate('StoreEditor')},
                { title: '绑定店铺', onPress:()=>navigation.navigate('Bindstore')},
            ],
            children:<View style={{position:'absolute',top:Platform.OS=='ios'? 0:-CommonStyles.headerPadding}}>{this.renderHeader()}</View>
        })
    }
    closePopover = () => {
        this.setState({
            visiblePopover: false
        });
    }
    renderHeader=(modal)=>{
        return(
            <Header
            navigation={this.props.navigation}
            goBack={true}
            title='店铺管理'
            rightView={
                <TouchableOpacity
                    // ref={'popoverDetail'}
                    onPress={() => this.showPopover()}
                    style={{ width: 50, alignItems: 'center', }}
                >
                    <View style={styles.cercle} />
                    <View style={styles.cercle} />
                    <View style={styles.cercle} />

                </TouchableOpacity>
            }
        />

        )
    }
    render() {
        const { juniorShops,getMerchantHome } = this.props;
        return (
            <View style={styles.container}>
               {this.renderHeader()}
                <ScrollView 
                    style={{ width: width }} 
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                    refreshControl={(
                        <RefreshControl
                        refreshing={this.state.refreshing}
                        onRefresh={() => {
                            this.setState({refreshing:true})
                            getMerchantHome({
                                successCallback: res => this.setState({refreshing:false}),
                            })
                        }}
                        />
                    )}
                >
                    <View style={{ alignItems: "center",paddingBottom:10+CommonStyles.footerPadding }}>
                        {juniorShops.length == 0 ? (
                            <ListEmptyCom type='G7_store'/>
                        ) : (
                               juniorShops.map((item, index) => {
                                    return this.renderItem({ item, index });
                                })
                            )}
                    </View>
                </ScrollView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    cercle: {
        width: 6,
        height: 6,
        marginTop: 2,
        backgroundColor: '#fff',
        borderRadius: 10
    },
    up: {
        borderRadius: 10,
        width: 60,
        height: 22,
        alignItems: "center",
        justifyContent: "center",
        marginLeft: 15,
        borderWidth: 1,
        borderColor: "#EE6161"
    },
    rightView: {
        flex: 1,
        marginLeft: 10,
        flexDirection: "row",
        alignItems: "center",
        justifyContent:'flex-end'
    },
    emptyView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        marginTop: 50,
    },
    btn: {
        width: "50%",
        height: 44.5,
        justifyContent:'center',
        alignItems:'center'
    },
    button: {
        backgroundColor: "#4A90FA",
        borderRadius: 8,
        width: "80%",
        marginBottom: 20,

    },
    btn_text: {
        color: "#4A90FA",
        fontSize: 17,
    },
    text:{
        color:'#222',
        fontSize:14,
    },
    row:{
        flexDirection:'row',
        alignItems:'center'
    },
    modalSelect:{
        flex: 1,
        justifyContent: "center",
        padding: 53,
        backgroundColor:'rgba(0,0,0,0.5)'
    },
    innerContainer:{
        borderRadius: 10,
        // alignItems: "center",
        backgroundColor:'#EFEFEF'
    },
    selfSelect:{
        marginRight:12,
        width:15,
        height:15
    }
});

export default connect(
    state => ({
        userShop:state.user.userShop || {},
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
    }),
    {
        shopSave: (params={})=> ({ type: "shop/save", payload: params}),
        getMerchantHome: (payload = {}) => ({ type: 'user/getMerchantHome', payload }),
    }
)(StoreManageScreen);
