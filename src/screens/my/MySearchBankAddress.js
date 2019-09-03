/**
 * 选择银行名称
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    Platform,
    StatusBar,
    View,
    Text,
    Keyboard,
    TouchableOpacity,
    Image,
    Button,
    ScrollView,
} from 'react-native';
import { connect } from 'rn-dva';

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import TextInputView from '../../components/TextInputView';
import SecurityKeyboard from '../../components/SecurityKeyboard';
import ModalDemo from "../../components/Model";
import { NavigationComponent } from '../../common/NavigationComponent';
import Content from "../../components/ContentItem";
const { width, height } = Dimensions.get('window');
const unchecked = require("../../images/index/unselect.png");
const checked = require("../../images/index/select.png");

class MySearchBankAddress extends NavigationComponent {
    static navigationOptions = {
        header: null,
    }
    constructor(props) {
        super(props)
        const {callback=()=>{},code,parentCode,api}=props.navigation.state.params || {}
        this.state = {
            listName:'bankList',
            code,
            callback,
            parentCode,
            selectedItem:{},
            api
        }
    }
    componentWillUnmount(){
        Keyboard.dismiss();
    }

    componentDidMount() {
        this.props.shopSave({
            longLists:{
                ...this.props.longLists,
                [this.state.listName]:null
            }
        })
        this.getList(true, false);
    }
    getList = (isFirst = false, isLoadingMore = false,loading=true,refreshing=true) => {
        const { listName ,code,parentCode,searchValue,api} = this.state;
        this.props.fetchList({
            witchList:listName,
            isFirst,
            isLoadingMore,
            paramsPrivate : {
                parentCode,
                name:searchValue
            },
            api,
            loading,
            refreshing
        })
    };
    selectItem=(data)=>{
        this.setState({
            selectedItem:data
        })
    }
    renderItem = ({ item, index }) => {
        return (
            <TouchableOpacity
                style={[styles.itemContent]}
                disabled={true}
            >
                <Text style={{color:'#222',fontSize:14,flex:1}}>{item.name}</Text>
                <TouchableOpacity style={{padding:15}} onPress={() =>this.selectItem(item)}>
                    <Image source={item.code==(this.state.selectedItem.code || this.state.code)?checked:unchecked}/>
                </TouchableOpacity>

            </TouchableOpacity>
        );
    };
    confirm=()=>{
        const { searchValue,listName,selectedItem ,callback,code} = this.state;
        if(selectedItem.code || code){
            selectedItem.code && callback(selectedItem)
            this.props.navigation.goBack()
        }else{
            Toast.show('请选择')
        }
    }
    render() {
        const { navigation ,longLists} = this.props;
        const { searchValue,listName,selectedItem ,callback} = this.state;
        const lists=longLists[listName] && longLists[listName].lists || []
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={'选择银行名称'}
                />
                <Content style={styles.content}>
                    <TextInputView
                        inputView={styles.inputView}
                        style={styles.textInput}
                        value={searchValue}
                        placeholder={'请输入开户银行名称进行搜索'}
                        placeholderTextColor={"#ccc"}
                        onChangeText={text => {
                            this.setState({
                                searchValue:text
                            },()=>{
                                this.getList(false,false)
                            })
                        }}
                        // onSubmitEditing={()=>{
                        //     this.getList(false,false)
                        // }}
                        leftIcon={
                            <View style={styles.IconView}>
                                <Image source={require('../../images/my/search.png')} style={styles.searchIcon}/>
                            </View>
                        }
                    />
                    <FlatListView
                        style={styles.flatListView}
                        renderItem={data => this.renderItem(data)}
                        ItemSeparatorComponent={() => (
                            <View style={styles.flatListLine} />
                        )}
                        store={{
                            ...(longLists[listName] || {}),
                            page: longLists[listName] && longLists[listName].listsPage || 1
                        }}
                        data={lists}
                        numColumns={1}
                        refreshData={() =>
                            this.getList(false, false)
                        }
                        loadMoreData={() =>
                            this.getList(false, true)
                        }
                        footerStyle={{
                            backgroundColor:'#fff',
                            width:width-20
                        }}
                        ListHeaderComponent={()=>(
                            <View style={styles.flatListLine} />
                        )}
                        contentContainerStyle={{paddingBottom:16}}
                    />
                </Content>
                <View style={styles.bottomView}>
                    {
                        selectedItem.name && <Text style={{color:'#777',fontSize:14,flex:1,textAlign:'right'}}>已选：{selectedItem.name}</Text>
                    }
                    <TouchableOpacity style={styles.confirmBut} onPress={this.confirm}>
                        <Text style={styles.confirmButText}>确定</Text>
                    </TouchableOpacity>
                </View>

            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems:'center'
    },
    content:{
        backgroundColor:'#fff',
        flex:1
    },
    searchIcon:{
        width:16,
        height:16,
    },
    inputView: {
        flexDirection: "row",
        height:36,
        borderRadius:8,
        marginTop:20,
        borderWidth:1,
        borderColor:'#f1f1f1',
        width:width-50,
        marginLeft:15
    },
    textInput: {
        flex: 1,
        height: "100%",
        paddingVertical: 0,
        fontSize: 14,
        color: "#222",
        backgroundColor: "#fff",

    },
    IconView: {
        justifyContent: "center",
        height: "100%",
        width:35,
        alignItems:'center'
    },
    flatListView: {
        backgroundColor:'#fff',
        flex: 1,
        width: width - 20,
        marginTop:16
    },
    itemContent:{
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'space-between',
        flexWrap:'wrap',
        width: width - 20,
        paddingLeft:15,
        height:46
    },
    flatListLine: {
        height:0
    },
    bottomView:{
        height:50,
        width:width,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'flex-end',
        backgroundColor:'#fff',
        borderTopWidth:1,
        borderColor:'#f1f1f1',
        marginBottom:CommonStyles.footerPadding,
        flexWrap:'wrap',
        paddingLeft:15
    },
    confirmBut:{
        height:'100%',
        width:100,
        backgroundColor:CommonStyles.globalHeaderColor,
        alignItems:'center',
        justifyContent:'center',
        marginLeft:20
    },
    confirmButText:{
        color:'#fff',
        fontSize:15
    }
});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
        serviceCatalogList:state.shop.serviceCatalogList || [],
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
     }),
    (dispatch) => ({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
        shopSave: (params={})=> dispatch({ type: "shop/save", payload: params}),
     })
)(MySearchBankAddress);
