/**
 * 银行卡设置
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    StatusBar,
    Image,
    TouchableOpacity,
    ImageBackground,
    RefreshControl,
} from 'react-native';
import ListView from 'deprecated-react-native-listview';
import Header from '../../components/Header';
import Content from '../../components/ContentItem';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
const { width, height } = Dimensions.get('window');
import Model from '../../components/Model';
import SwipeListView from '../../components/SwipeListView';
import ActionSheet from '../../components/Actionsheet';
import { NavigationPureComponent } from '../../common/NavigationComponent';
import ImageView from '../../components/ImageView';
export default class BankcardScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
    };
    constructor(props) {
        super(props);
        this.ds = new ListView.DataSource({
            rowHasChanged: (r1, r2) => r1 !== r2,
        });
        const params = props.navigation.state.params || {};
        this.state = {
            modelVisible: false,
            lists0: [], // 列表
            lists1: [], // 列表
            deleteIndex: 0, //要删除的项
            rowMap: {},
            rowKey: '',
            firstLoad: true,
            refreshing: false,
            page: params.page,
            callback: params.callback,
            rightPrivate:0,
        };
    }

    screenWillBlur () {
        StatusBar.setBarStyle('light-content');
    }
    screenWillFocus () {
        StatusBar.setBarStyle('dark-content');
    }
    getList = () => {
        requestApi.mBankCardPage({
            limit: 0,
            page: 0 ,
            rightPublic:this.state.rightPrivate == 1 ? 0:1,
            })
            .then(data => {
                let lists = data ? data.data : [];
                // lists.sort(utils.compareNumber('updatedAt'))//按操作时间倒叙排列
                Loading.hide();
                const params = {
                    firstLoad: false,
                    refreshing: false,
                };
                this.state.rightPrivate ? params.lists1 = lists:params.lists0 = lists;
                this.setState(params);
            })
            .catch(error => {
                Loading.hide();
            });
    };

    componentDidMount() {
        Loading.show();
        this.getList();
    }
    componentWillUnmount() { }
    closeRow() {
        const { rowMap, rowKey } = this.state;
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }
    }
    refresh = () => {
        this.setState({ refreshing: true });
        this.getList();
    };
    delete = () => {
        const { navigation } = this.props;
        const {rightPrivate,lists0,lists1,deleteIndex} = this.state;
        const lists = rightPrivate == 0 ? lists0 : lists1;
        this.setState({ modelVisible: false });
        this.closeRow();
        navigation.navigate('BankcardValidatePhone', {
            page: 'delete',
            data: lists[deleteIndex],
            callback: () => this.refresh(),
        });
    };
    edit = (page, rightPrivate, item) => {
        this.closeRow();
        this.props.navigation.navigate('BankcardEdit', {
            title: page,
            data: item,
            rightPrivate,
            routerIn: this.props.navigation.getParam('routerIn',''),
            callback: () => this.refresh(),
        });
    };
    setDefault = (item) => {
        CustomAlert.onShow(
            'confirm',
            '将该卡设为默认银行卡',
            null,
            () => {
                Loading.show();
                requestApi
                    .mBankCardUpdateDefault({ id:item.id })
                    .then(data => {
                        Loading.hide();
                        Toast.show('设置成功');
                        this.getList();
                        this.selectCallback(item);
                    })
                    .catch(error => {
                        Loading.hide();
                        //
                    });
            },
            ()=>{},
            '取消',
            '确定',
            {color:'#222'}
        );

    };
    selectCallback=(data = {},selectCallback = ()=>{})=>{
        const { page, callback } = this.state;
        if (this.props.navigation.getParam('routerIn','') == 'Profit'){
            CustomAlert.onShow(
                'confirm',
                '申请将钱款汇入' + data.bankName + '(' + data.cardNumber.substring(data.cardNumber.length - 4,data.cardNumber.length) + ')？',
                '',
                () => {
                    callback && callback({
                        ...data,
                        bank: data.bankName,
                        cardNo: data.cardNumber,
                    });
                    selectCallback();
                }
            );
        } else{
            callback && callback({
                ...data,
                bank: data.bankName,
                cardNo: data.cardNumber,
            });
            selectCallback();
        }
    }
    selectItem = (data) => {
       this.selectCallback(data,()=>this.props.navigation.goBack());
    }
    renderItem = (item, index) => {
        // console.log(item, index)
        return (
            <View style={{ alignItems: 'center' }}>
                <Content style={[ {width: width - 20, marginTop: 10 ,overflow:'hidden'}]} onPress={(this.state.page || this.props.navigation.getParam('routerIn','')) && (() => this.selectItem(item))} activeOpacity={1}>
                    <ImageBackground
                        source={require('../../images/my/blue_bg.png')}
                        style={{padding:25,paddingRight:15,position:'relative'}}
                        resizeMode="cover"
                    >
                    <View  style={{flexDirection:'row',justifyContent:'space-between'}}>
                        <View style={styles.iconView}>
                            <ImageView
                                source={{ uri: item.logo || '' }}
                                sourceWidth={20}

                            />
                        </View>
                        <View style={{flex:1}}>
                            <View style={{flexDirection:'row',justifyContent:'space-between'}}>
                                <Text style={[styles.title,{fontSize:17,flex:1,marginRight:10}]}>{item.bankName}</Text>
                                {
                                    !item.isDefault ?
                                    <TouchableOpacity
                                        onPress={() => this.setDefault(item)}
                                    >
                                        <Text style={{fontSize:12,color:'#fff'}}>设为默认</Text>
                                    </TouchableOpacity>:null
                                }

                            </View>
                            <Text  style={[ styles.title, { fontSize: 12 ,marginTop:8}  ]} >
                                {item.rightPrivate || '借记卡'}
                            </Text>
                        </View>
                    </View>
                    <View style={[styles.line, styles.numberLine]}>
                        {[1, 2, 3].map((item, index) => {
                            return (
                                <View
                                    style={[styles.line, { marginRight: 20,height:17 }]}
                                    key={index}
                                >
                                    <Text style={{color:'#fff',fontSize:17}}>****</Text>
                                </View>
                            );
                        })}
                        <Text style={[styles.title, { fontSize: 17 }]}>
                            {item.cardNumber.substring(
                                item.cardNumber.length - 4,
                                item.cardNumber.length
                            )}
                        </Text>
                    </View>
                    {
                        item.isDefault
                        ? <Image
                            source={require('../../images/my/default.png')}
                            style={{position:'absolute',top:0,right:0,width:45,height:18}}
                        />
                        :null
                    }
                    </ImageBackground>
                </Content>
            </View>
        );
    };
    deleteRow(rowId, id, rowMap, rowKey) {
        console.log(rowId, id);
        this.closeRow();
        this.setState({
            modelVisible: true,
            deleteIndex: parseInt(rowId),
            deleteId: id,
            rowMap,
            rowKey,
        });
    }
    onRowDidOpen = (rowKey, rowMap) => {
        console.log('This row opened', rowKey);
        this.setState({ rowMap, rowKey });
    };
    renderHiddenItem = (data, secId, rowId, rowMap) => {
        return (
            <View style={styles.rightContainer}>
                <TouchableOpacity
                    style={[
                        styles.delTextContainer,
                        { backgroundColor: '#91BAF9' },
                    ]}
                    onPress={() =>
                        this.edit(
                            '修改',
                            this.state.rightPrivate,
                            data
                        )
                    }
                >
                    <Text style={styles.deleteTextStyle}>
                        修改
                    </Text>
                </TouchableOpacity>
                <TouchableOpacity
                    style={[
                        styles.delTextContainer,
                        { backgroundColor: '#EE6161' },
                    ]}
                    onPress={() =>
                        this.deleteRow(
                            rowId,
                            data.id,
                            rowMap,
                            `${secId}${rowId}`
                        )
                    }
                >
                    <Text style={styles.deleteTextStyle}>
                        删除
                    </Text>
                </TouchableOpacity>
            </View>
        );
    }
    changeTab=(rightPrivate)=>{
        rightPrivate == 0 && this.state.lists0.length == 0 || rightPrivate == 1 && this.state.lists1.length == 0 ? Loading.show():null;
        this.setState({rightPrivate},()=>{this.getList();});
    }

    render() {
        const { navigation} = this.props;
        const {rightPrivate,lists0,lists1,page} = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    headerStyle={{backgroundColor:'#fff'}}
                    backStyle={{tintColor:'#222'}}
                    titleTextStyle={{color:'#222'}}
                    title={page || navigation.getParam('routerIn','') ? '选择银行卡':'银行卡管理'}
                    rightView={
                        <TouchableOpacity
                            onPress={() =>  {
                                // navigation.getParam('routerIn', '')?this.edit('新增',0):
                                this.ActionSheet.show();
                            }}
                            style={{ width: 50, alignItems: 'center' }}
                        >
                            <Image
                                source={require('../../images/my/add.png')}
                                style={{ width: 16, height: 16}}
                            />
                        </TouchableOpacity>
                    }
                />
                {/* {
                    navigation.getParam('routerIn', '')?null: */}
                    <View style={styles.tabsView}>
                    {['对公银行卡', '对私银行卡'].map(
                           (itemTab, index) => {
                               return (
                                       <TouchableOpacity style={styles.tab} onPress={()=>this.changeTab(index)} key={index}>
                                           <Text style={[styles.tabText,{color:rightPrivate == index ? CommonStyles.globalHeaderColor:'#777'}]}>{itemTab}</Text>
                                           <View style={[styles.tabLine,{backgroundColor:rightPrivate == index ? CommonStyles.globalHeaderColor:'#fff'}]} />
                                       </TouchableOpacity>
                               );
                           }
                       )}
                    </View>
                {/* } */}


                <SwipeListView
                    type="K9_bankCardManage"
                    dataSource={this.ds.cloneWithRows(rightPrivate == 0 ? lists0:lists1)}
                    data={rightPrivate == 0 ? lists0:lists1}
                    isFirstLoad={this.state.firstLoad}
                    style={{ width: width ,flex:1}}
                    renderRow={(data, secId, rowId, rowMap) =>
                        this.renderItem(data, rowId)
                    }
                    enableEmptySections={() => <View />}
                    renderHiddenRow={(data, secId, rowId, rowMap)=>this.renderHiddenItem(data, secId, rowId, rowMap)}
                    leftOpenValue={0}
                    rightOpenValue={-150}
                    refreshControl={
                        <RefreshControl
                            colors={['#2ba09d']}
                            refreshing={this.state.refreshing}
                            onRefresh={this.refresh}
                        />
                    }
                />
                <ActionSheet
                        ref={o => (this.ActionSheet = o)}
                        // title={'Which one do you like ?'}
                        options={['绑定对公银行卡','绑定对私银行卡','取消']}
                        cancelButtonIndex={2}
                        // destructiveButtonIndex={2}
                        onPress={index => {
                            if (index != 2){
                                this.setState({rightPrivate:index});
                                this.edit('新增',index);
                            }
                        }}
                    />
                <Model
                    type={'confirm'}
                    title={'确定要删除？'}
                    confirmText="删除银行卡后无法恢复"
                    visible={this.state.modelVisible}
                    onShow={() => this.setState({ modelVisible: true })}
                    onConfirm={() => this.delete()}
                    onClose={() => this.setState({ modelVisible: false })}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        flexDirection: 'column',
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    flatList: {
        backgroundColor: CommonStyles.globalBgColor,
    },
    tabsView:{
        backgroundColor:'#fff',
        height:38,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'space-around',
        width:width,
    },

    tabText:{
        fontSize:14,
        color:'#fff',
    },
    tab:{
        position:'relative',
        height:'100%',
        justifyContent:'center',
        overflow:'hidden',
    },
    tabLine:{
        position:'absolute',
        height:8,
        backgroundColor:'#fff',
        bottom:-5,
        width:70,
        borderRadius:8,
    },
    header: {
        width: width,
        height: 44 + CommonStyles.headerPadding,
        paddingTop: CommonStyles.headerPadding,
        overflow: 'hidden',
    },
    iconView:{
        width:34,
        height:34,
        borderRadius:34,
        alignItems:'center',
        justifyContent:'center',
        backgroundColor:'#fff',
    },
    rightContainer: {
        flexDirection: 'row',
        backgroundColor: CommonStyles.globalBgColor,
        alignItems: 'center',
        justifyContent: 'flex-end',
        flex: 1,
        marginRight: 10,
    },
    delTextContainer: {
        width: 60,
        height: 60,
        borderRadius: 60,
        backgroundColor: 'red',
        alignItems: 'center',
        justifyContent: 'center',
        marginLeft: 10,
    },
    deleteTextStyle: {
        color: '#fff',
        fontSize: 16,
    },
    line: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    title: {
        fontSize: 14,
        color: '#fff',
        marginLeft: 10,
    },
    point: {
        width: 6,
        height: 6,
        backgroundColor: '#CCCCCC',
        borderRadius: 6,
        marginRight: 5,
    },
    numberLine: {
        justifyContent: 'flex-start',
        marginTop: 30,
        marginLeft: 44,
    },
    swipe: {
        width: width - 20,
        backgroundColor: CommonStyles.globalBgColor,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        // position: 'absolute'
    },
    left: {
        width: 50,
    },
});
