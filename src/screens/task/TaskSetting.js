//验收中心/委派设置
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    TouchableOpacity,
    Platform,
    ScrollView
} from "react-native";
import { connect } from "rn-dva";

import FlatListView from "../../components/FlatListView";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
const { width, height } = Dimensions.get("window");
import DashLine from "../../components/DashLine";
import ImageView from '../../components/ImageView.js'
import ScrollableTabView from "react-native-scrollable-tab-view"
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar.js';

import * as taskRequest from "../../config/taskCenterRequest"

const tabtitle = [{ name: '委派给商户', key: 0 }, { name: '委派给员工', key: 1 }]

export default class TaskSetting extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props)
        this.state = {
            editor: false,
            currentTab: 0,
            superMerchant: [],  //上级联盟商列表
            superMerchantSelectIndex: -1,
            // employeePage: null, //员工
            employeePageSelectIndex: -1,
            hasBeeEmployees: [],  //已经委派的员工
            allEmployee: [],  //所有的员工  多选
            store:{
                refreshing: false,
                loading: false,
                hasMore: true,
            }
        };
        //已经委派设置的员工数据参数
        this.querySethasBeanEmpls = {
            page:1,
            limit:10,
        }
        this.queryAllEmployee={
            page:1,
            limit:10
        }
        this.queryemployeeDelegate = {
            limit:10,
            page:1
        }

    }
    //查询委派设置已经委派的数据
    requesthMerchantJoinTaskBatchAppointedFind = (isFirest) => {
        const {taskPosition} = this.props.navigation.state.params
        let requestList = taskRequest.fetchMerchantJoinTaskBatchAppointedFind
        //任务
        if(taskPosition === 'taskcore'){
            requestList = taskRequest.fetchMerchantJoinTaskBatchAppointedFind
        }else if(taskPosition === 'auditcore'){  //审核
            requestList = taskRequest.fetchPreAuditDelegatedPage
        }else{  //验收
            requestList = taskRequest.fetchPreCheckDelegatedPage
        }
        const {store} = this.state
        store.refreshing = true
        this.setState({
            store
        })
        if(isFirest){
            this.querySethasBeanEmpls.page = 1
        }else{
            if(!store.hasMore){
                return
            }
            this.querySethasBeanEmpls.page+=1
        }
        requestList(this.querySethasBeanEmpls).then((res) => {
            if (res) {
                let hasMore = true
                let data = res.data
                if (data.length < 10) {
                    hasMore = false
                }
                store.hasMore = hasMore
                store.refreshing = false
                store.loading = false
                if(!isFirest){
                    data = this.state.hasBeeEmployees.concat(data)
                }
                this.setState({
                    hasBeeEmployees: data,
                    store
                })
            } else {
                store.hasMore = false
                store.refreshing = false
                store.loading = false
                if(isFirest){
                    this.setState({
                        hasBeeEmployees: [],
                        store
                    })
                }else{
                    this.setState({
                        store
                    })
                }
            }
        }).catch((res) => {
            store.hasMore = false
                store.refreshing = false
                store.loading = false
                this.setState({
                    store
                })
        })
    }
    //请求所有员工  委派设置
    requestEmployeePage = (isFirst) => {
        const {store,hasBeeEmployees} = this.state
        const {taskPosition} = this.props.navigation.state.params
        let requestList = null
        if(taskPosition === 'taskcore'){
            requestList = taskRequest.fetchPreJobDelegatingPage
        }else if(taskPosition === 'auditcore'){
            requestList = taskRequest.fetchPreAuditDelegatingPage
        }else{
            requestList = taskRequest.fetchPreCheckDelegatingPage
        }
        store.refreshing = true
        this.setState({
            store
        })
        if(isFirst){
            this.queryAllEmployee.page = 1
        }else{
            if(!store.hasMore){
                return
            }
            this.queryAllEmployee.page +=1
        }
        requestList(this.queryAllEmployee).then((res) => {
            if (res) {
                let allEmployee = res.pageable.data
                let userIds = res.userIds
                if (userIds && userIds.length) {
                    allEmployee.forEach((item) => {
                        if(userIds.includes(item.id)){
                            item.select = true
                        }
                    })
                }
                let hasMore = true
                if (allEmployee.length < 10) {
                    hasMore = false
                }
                store.hasMore = hasMore
                store.refreshing = false
                store.loading = false
                if(!isFirst){
                    allEmployee = this.state.allEmployee.concat(allEmployee)
                }
                this.setState({
                    allEmployee: allEmployee,
                    store
                })
            }else{
                store.hasMore = false
                store.refreshing = false
                store.loading = false
                this.setState({
                    store
                })
            }
        }).catch((res) => {
            store.hasMore = false
            store.refreshing = false
            store.loading = false
            this.setState({
                store
            })
        })
    }
    componentDidMount() {
        //单个的委派需要已经委派的人员的接口
        const { isSingle} = this.props.navigation.state.params
        if (isSingle) {
            // let param = {
            //     merchantType: merchantType,
            //     merchantId: merchantId,
            //     taskPosition: taskPosition,
            //     taskId: taskId,
            // }
            // taskRequest.fetchMerchantJoinTaskAppointedFind(param).then((res) => {
            //     if (res) {
            //         this.setState({
            //             hasBeeEmployees: [res]
            //         })
            //     } else {
            //         this.setState({
            //             hasBeeEmployees: []
            //         })
            //     }
            // })
        } else {
         this.requesthMerchantJoinTaskBatchAppointedFind(true)
        }
    }

    selectUser = (index) => {
        let { currentTab, superMerchant, allEmployee, superMerchantSelectIndex, employeePageSelectIndex } = this.state
        let isSingle = this.props.navigation.state.params.isSingle
        if (isSingle) {
            let selecredOne = null
            if (superMerchantSelectIndex !== -1) {
                superMerchant[superMerchantSelectIndex].select = false
            } else {
                superMerchant.forEach((item) => {
                    item.select = false
                })
            }
            if (employeePageSelectIndex !== -1) {
                allEmployee[employeePageSelectIndex].select = false
            } else {
                allEmployee.forEach((item) => {
                    item.select = false
                })
            }
            if (currentTab == 0) {
                superMerchant[index].select = true
                selecredOne = superMerchant[index]
                this.setState({
                    superMerchant,
                    superMerchantSelectIndex: index
                })
            } else {
                allEmployee[index].select = true
                selecredOne = allEmployee[index]
                this.setState({
                    allEmployee,
                    employeePageSelectIndex: index
                })
            }
            this.setState({
                hasBeeEmployees: [selecredOne]
            })
        }
        else {
            allEmployee[index].select = !allEmployee[index].select
            this.setState({
                allEmployee
            })
        }
    }
    renderContent = (data, index) => {
        let item = data.item
        return (
            <Content style={[styles.content, { position: 'relative'}]} key={index}>
                {
                    this.state.editor ?
                        <TouchableOpacity style={styles.selectImage} onPress={() => this.selectUser(index)}>
                            <Image
                                source={
                                    item.select
                                        ? require("../../images/index/select.png")
                                        : require("../../images/index/unselect.png")
                                }
                            />
                        </TouchableOpacity>
                        : null
                }
                    <ImageView
                        source={{ uri: item.avatar || '' }}
                        soureWidth={52}
                        sourceHeight={52}
                        resizeMode='contain'
                    />

                <Text style={[styles.text, { marginTop: 6 }]}>{item.realName}</Text>
                <Text style={[styles.text, { color: '#BDC1C7' }]}>{item.phone}</Text>
            </Content>
        )
    }
    changeRightBtn = () => {
        const { editor, allEmployee, hasBeeEmployees } = this.state
        const { isSingle, id } = this.props.navigation.state.params
        if (isSingle) {
            if (!editor) {
                // if(hasBeeEmployees && hasBeeEmployees.length>0){
                //     Toast.show('已经委派了人员,不可再委派')
                //     return
                // }
                //上级联盟商  一个数据
                taskRequest.fetchSuperMerchant({jobId:id}).then((res) => {
                    if (res) {
                        if (hasBeeEmployees && hasBeeEmployees.length > 0){
                            hasBeeEmployees.find((item)=>{
                                if(item.id === res.id){
                                    res.select = true
                                    return true
                                }
                            })
                        }
                        this.setState({
                            superMerchant: [res]
                        })
                    }
                }).catch((err)=>{
                    console.log(err)
                  });
                this.setState({ editor: !editor, currentTab: 0 })
            } else {
                const { id,taskPosition,getnewList } = this.props.navigation.state.params
                if (hasBeeEmployees && hasBeeEmployees.length == 0) {
                    Toast.show('请选择员工')
                    return
                }
                if(taskPosition === 'taskcore'){
                    requestList = taskRequest.fetchsetJobDelegate
                }else if(taskPosition === 'auditcore'){  //审核
                    requestList = taskRequest.fetchSetAuditDelegate
                }else{  //验收
                    requestList = taskRequest.fetchsetCheckDelegate
                }
                let param = {
                    jobId: id,
                    delegateId: hasBeeEmployees[0].id,
                }
                requestList(param).then((res) => {
                    Toast.show('保存成功')
                    if(getnewList){
                        getnewList(true)
                    }
                    this.setState({ editor: !editor, currentTab: 0 })
                }).catch((err)=>{
                    console.log(err)
                  });
            }
        } else {
            //请求员工数据
            if (!editor) {
               this.requestEmployeePage(true)
               this.setState({
                editor: !editor
            })
            } else {
                const {taskPosition} = this.props.navigation.state.params
                let requestList = null
                if(taskPosition === 'taskcore'){
                    requestList = taskRequest.fetchMerchantJoinBatchAppointedSave
                }else if(taskPosition === 'auditcore'){
                    requestList = taskRequest.fetchPreAuditDelegateSetting
                }else{
                    requestList = taskRequest.fetchPreCheckDelegateSetting
                }
                let param = {
                    userIds:[],
                }
                let newdata = []
                allEmployee.forEach((item) => {
                    if (item.select) {
                        newdata.push(item)
                        param.userIds.push(item.id)
                    }
                })
                if (param.userIds.length == 0) {
                    Toast.show('请选择员工')
                    return
                }
                if(requestList){
                    requestList(param).then((res) => {
                        Toast.show('保存成功')
                        this.setState({
                            hasBeeEmployees: newdata
                        })
                        this.setState({
                            editor: !editor
                        })

                    }).catch((err)=>{
                        console.log(err)
                      });
                }
            }
        }
    }
    ListEmptyComponent = () => {
        const { store,editor } = this.state;
        const { refreshing, loading, isFirstLoad } = store;
        return (
            <View style={styles.emptyView}>
                {
                    refreshing && loading || isFirstLoad ?null:
                    <React.Fragment>
                    <Image source={require('../../images/user/empty.png')} />
                    <View style={[CommonStyles.flex_center,styles.textWrap]}>
                    {
                        editor ? (
                            <View style={{alignItems:'center'}}>
                                <Text style={{marginTop: 1,fontSize: 14,color: '#777',}}>你的账号暂无分号可用，</Text>
                                <Text style={{marginTop: 1,fontSize: 14,color: '#777',}}>请先添加分号</Text>
                            </View>
                        ) : (
                            <Text style={{marginTop: 1,fontSize: 14,color: '#777',}}>暂未委派分号</Text>
                        )
                    }
                    </View>
                </React.Fragment>
                }
            </View>
        )
    }
    //委派设置
    renderWeiPaiSheZhi = () => {
        const {editor,allEmployee,hasBeeEmployees,store} = this.state
        let alldata = []
        if (editor) {
            alldata = allEmployee
        } else {
            alldata = hasBeeEmployees
        }
            return (
                <FlatListView
                renderItem={item => this.renderContent(item,item.index)}
                style={{ height:'100%',backgroundColor:CommonStyles.globalBgColor}}
                data={alldata}
                store={store}
                ItemSeparatorComponent={()=>null}
                ListHeaderComponent={()=>null}
                numColumns={2}
                ListEmptyComponent={this.ListEmptyComponent}
                refreshData={
                    ()=>{
                        if(editor){
                            this.requestEmployeePage(true)
                        }else{
                            this.requesthMerchantJoinTaskBatchAppointedFind(true)
                        }
                    }
                }
                loadMoreData={
                    ()=>{
                        if(editor){
                            this.requestEmployeePage(false)
                        }else{
                            this.requesthMerchantJoinTaskBatchAppointedFind(false)
                        }
                    }
                }
                />
            )
    }
    requestemployeeDelegate = (isFirst) => {
        const {store} = this.state
        store.refreshing = true
        this.setState({
            store
        })
        if(isFirst){
            this.queryemployeeDelegate.page=1
        }else{
            this.queryemployeeDelegate.page += 1
        }
        taskRequest.fetchEmployeeDelegate(this.queryemployeeDelegate).then((res)=>{
            if (res) {
                let hasMore = true
                let data = res.data
                if (data.length < 10) {
                    hasMore = false
                }
                store.hasMore = hasMore
                store.refreshing = false
                store.loading = false
                if(!isFirst){
                    data = this.state.allEmployee.concat(data)
                }
                this.setState({
                    allEmployee: data,
                    store
                })
            } else {
                store.hasMore = false
                store.refreshing = false
                store.loading = false
                if(isFirst){
                    this.setState({
                        allEmployee: [],
                        store
                    })
                }else{
                    this.setState({
                        store
                    })
                }
            }
            // allEmployee
        }).catch((err)=>{
            console.log(err)
          });
    }
    render() {
        const { navigation } = this.props;
        const { editor, superMerchant, allEmployee, hasBeeEmployees,store } = this.state
        let isSingle = this.props.navigation.state.params.isSingle
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={(!isSingle && !editor) ? '委派设置' : '选择分号'}
                    rightView={
                        <TouchableOpacity style={{ width: 50 }} onPress={this.changeRightBtn}>
                            <Text style={{ color: '#fff', fontSize: 17 }}>{editor ? (!isSingle ?  (allEmployee && allEmployee.length > 0) ? '保存' : '' : '保存' )  : '编辑'}</Text>
                        </TouchableOpacity>
                    }
                />
                    {
                        isSingle ? (
                            editor ?
                            <ScrollView style={{width:width,height:height-44-CommonStyles.headerPadding}}>
                                <ScrollableTabView
                                    initialPage={0}
                                    onChangeTab={({ i }) => {
                                        if (i == 1) {
                                            if (!allEmployee || (allEmployee && !allEmployee.length)) {
                                                // this.requestEmployeePage(true)
                                                this.requestemployeeDelegate(true)
                                            }
                                        }
                                        this.setState({ currentTab: i })
                                    }}
                                    style={{ width: width, height: height - 44 - CommonStyles.headerPadding }}
                                    renderTabBar={() => (
                                        <DefaultTabBar
                                            underlineStyle={{
                                                backgroundColor: "#fff",
                                                height: 8,
                                                borderRadius: 10,
                                                marginBottom: -5,
                                                width: "14%",
                                                marginLeft: "13%"
                                            }}
                                            tabStyle={{
                                                backgroundColor: "#4A90FA",
                                                height: 44,
                                                paddingBottom: -4
                                            }}
                                            activeTextColor="#fff"
                                            inactiveTextColor="rgba(255,255,255,.5)"
                                            tabBarTextStyle={{ fontSize: 14 }}
                                            style={{
                                                backgroundColor: "#4A90FA",
                                                height: 44,
                                                borderBottomWidth: 0,
                                                overflow: "hidden"
                                            }}
                                        />
                                    )}
                                >

                                    {
                                        tabtitle.map((item, index) => {
                                            let lists = []
                                            if (index == 0) {
                                                lists = superMerchant
                                            } else if (index == 1) {
                                                lists = allEmployee
                                            }
                                            if(index === 0){
                                                return (
                                                    <View style={[styles.contentView, { marginTop: 5 }]} tabLabel={item.name} key={index}>
                                                        {
                                                            lists && lists.length >0 ? (
                                                                lists.map((item, index) => {
                                                                    let data = {item:item}
                                                                        return this.renderContent(data, index)
                                                                    })
                                                            )
                                                        : (
                                                            <View style={styles.emptyView}>
                                                            <Image source={require('../../images/user/empty.png')} />
                                                            <View style={[CommonStyles.flex_center,styles.textWrap]}>
                                                                <Text style={{marginTop: 1,fontSize: 14,color: '#777',}}>暂未委派联盟商</Text>
                                                            </View>
                                                        </View>
                                                        )
                                                        }
                                                    </View>
                                                )
                                            }else{
                                                return (
                                                    <FlatListView
                                                    key={index}
                                                    tabLabel={item.name}
                                                    renderItem={item => this.renderContent(item,item.index)}
                                                    style={{backgroundColor:'4A90FA'}}
                                                    data={lists}
                                                    store={store}
                                                    numColumns={2}
                                                    ListEmptyComponent={this.ListEmptyComponent}
                                                    refreshData={
                                                        ()=>{
                                                           this.requestemployeeDelegate(true)
                                                        }
                                                    }
                                                    loadMoreData={
                                                        ()=>{
                                                          this.requestemployeeDelegate(false)
                                                        }
                                                    }
                                                    />
                                                )
                                            }
                                        })
                                    }
                                </ScrollableTabView>
                                </ScrollView>
                                :
                                <ScrollView style={{width:width,height:height-44-CommonStyles.headerPadding}}>
                                <View>
                                    <Text style={[styles.text, { textAlign: 'center', color: CommonStyles.globalHeaderColor, marginTop: 15 }]}>请为任务分配商户或员工</Text>
                                    <View style={[styles.contentView, { marginTop: 10 }]}>
                                        {
                                            hasBeeEmployees && hasBeeEmployees.length>0 ? hasBeeEmployees.map((item, index) => {
                                                let data = {item:item}
                                                return this.renderContent(data, index)
                                            }) : (
                                                <View style={styles.emptyView}>
                                                            <Image source={require('../../images/user/empty.png')} />
                                                            <View style={[CommonStyles.flex_center,styles.textWrap]}>
                                                                <Text style={{marginTop: 1,fontSize: 14,color: '#777',}}>暂未委派联盟商</Text>
                                                            </View>
                                                        </View>
                                            )
                                        }
                                    </View>
                                </View>
                                </ScrollView>

                        ) : (
                                <View style={{width:'100%',height:height-44}}>
                                    <Text numberOfLines={3} ellipsizeMode='tail' style={[styles.text, { color: '#999',paddingVertical:0,height:44, marginTop: 15, paddingHorizontal: 15 }]}>
                                        委派员工后，系统分发给联盟商的任务会直接分配给相关员工，员工完成后需要验证，验证通过后提交审核。
                                    </Text>
                                    <View style={[styles.contentView, { flex:1,marginBottom:15}]}>
                                    {
                                        this.renderWeiPaiSheZhi()
                                    }
                                    </View>
                                </View>
                            )
                    }

            </View >
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    text: {
        color: '#222',
        fontSize: 14
    },
    content: {
        width: (width - 30) / 2,
        marginLeft: 10,
        height: 147,
        alignItems: 'center',
        justifyContent: 'center',
    },
    smallText: {
        fontSize: 13,
        color: '#999',
        marginBottom: 2
    },
    textWrap: {
        marginTop: 25,
    },
    emptyView: {
        // flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        marginTop: 50,
    },
    image: {
        borderRadius: 62,
        width: 62,
        height: 62,
        overflow: 'hidden'
    },
    contentView: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        alignItems: 'center',
    },
    selectImage: {
        position: 'absolute',
        top: 0,
        right: 0,
        padding: 10,
        width:60,
        height:60,
        alignItems:'flex-end',
        zIndex:999
    }
})
