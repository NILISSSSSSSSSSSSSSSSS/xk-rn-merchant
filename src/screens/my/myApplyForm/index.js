/**
 * 填写注册资料
 */
import React, { Component, PureComponent } from "react";
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  TouchableOpacity,
  ScrollView,
  Keyboard,
  RefreshControl,
  Platform,
  BackHandler
} from "react-native";
import { connect } from "rn-dva";
import SplashScreen from "react-native-splash-screen";
import Header from "../../../components/Header";
import CommonStyles from "../../../common/Styles";
import CommonButton from '../../../components/CommonButton';
import * as requestApi from "../../../config/requestApi";
import * as regular from "../../../config/regular";
import Content from "../../../components/ContentItem";
const { width, height } = Dimensions.get("window");
import ActionSheet from "../../../components/Actionsheet";
import PickerOld from "react-native-picker-xk";
import * as taskRequest from "../../../config/taskCenterRequest"
import ShowBigPicModal from '../../../components/ShowBigPicModal';
import { NavigationComponent } from "../../../common/NavigationComponent";
import ListItem from './ListItem.js';
import * as constUser from '../../../const/user'
import {sortLists} from '../../../config/utils';
const nochooseIcon = require('../../../images/user/nochooseIcon.png')
const chooseIcon = require('../../../images/user/chooseIcon.png')
const needGetSourceKeys=['firstIndustry','workType','specialIndustry']
class MyApplyFormScreen extends NavigationComponent {
  static navigationOptions = {
    header: null,
    gesturesEnabled: false, // 禁用ios左滑返回
  };
  constructor(props) {
    super(props);
    const { userInfo: user,navigation } = props
    const params = navigation.state.params || {}
    let isEditorble = false
    const auditStatus = params.auditStatus || 'unSubmit'
    if (params.page!='task' && (auditStatus == 'unSubmit' || auditStatus == 'audit_fail' || params.updateAuditStatus == 'un_pass' || !user.auditStatus)) {
      isEditorble = true
    }
    this.state = {
      discount: '', // 折扣上限
      name: params.name,
      page: params.page,
      visible: false,
      largeImage: '',
      updateAuditStatus: params.updateAuditStatus,
      familyUp: params.familyUp || 0,
      merchantType: params.familyUp?'familyL1':params.merchantType,
      selectOptions: ['取消'],
      isEditorble: isEditorble,   //是否能编辑
      auditStatus,
      remark: '',//审核失败原因
      route: params.route,
      lists: [],//重组列表
      oldLists: [],//服务器获取下来的列表
      loadData: false,//0还未获取数据列表或获取失败，1获取成功
      callback: params.callback || (() => { }),
      showBigPicArr: [],
      showIndex: 0,
      showBigModal: false,
      hasDidTask: params.hasDidTask || true,
      agress: false,//是否同意协议,
      refreshing:false,//刷新
    };
  }
  blurState = {
    showBigModal: false,
    visible: false,
  }
  screenDidFocus = (payload) => {
    super.screenDidFocus(payload)
    const params = this.props.navigation.state.params || {}
    if (params.page == 'login' || params.page == 'register') {
      BackHandler.addEventListener('hardwareBackPress', this.onBackAndroid)
    }
  }

  screenWillBlur = (payload) => {
    super.screenWillBlur(payload)
    this.removeEventListener()
  }
  removeEventListener = () => {
    BackHandler.removeEventListener('hardwareBackPress', this.onBackAndroid)
  }
  //触发返回键执行方法
  onBackAndroid = () => {
    this.goBack()
    return true;
  };
  componentWillUnmount() {
    super.componentWillUnmount()
    PickerOld.hide();
    clearTimeout(this.timer)
    this.removeEventListener()
  }
  upgrade = () => {
    this.getDataDetail(requestApi.upFamilyFieldTemplateList, (res) => {
      this.setState({
        isEditorble: true,
        name: '公会'
      }, () => { this.oprateData(res.fieldInfos || res.identity || res) })
    })
  }
  regularItem = (item2) => { //字段验证
    if(item2.component != "input"){
      return item2
    }
    if (item2.name.indexOf('注册资本') != -1) {
      item2.regular = regular.price
      item2.warningMessage = '请填写正确格式的注册资本，金额格式'
    }
    if (item2.name.indexOf('邮箱') != -1) {
      item2.regular = regular.email
      item2.warningMessage = '请输入正确格式的邮箱'
      item2.keyboardType = 'email-address'
    }
    if (item2.key == 'cardNumber') {
      item2.regular = regular.card
      item2.warningMessage = '请输入正确格式的银行卡账号'
      item2.keyboardType = 'numeric'
    }
    if (item2.name.indexOf('手机号') != -1) {
      item2.regular = regular.phone
      item2.warningMessage = '请输入正确格式的手机号，11位数字'
      item2.keyboardType = 'numeric'
    }
    if (item2.name.indexOf('身份证号') != -1 || item2.key == 'legalPersonIdCard') {
      item2.regular = regular.ID
      item2.warningMessage = '请输入正确格式的身份证号，18位'
    }
    if (item2.key == 'bankInstNo' || item2.name.indexOf('安全码') != -1) {
      item2.regular = regular.number
      item2.warningMessage = '只能填写数字'
    }
    return item2

  }
  addItemCondition=(item,i)=>{
    const { userInfo: user } = this.props
    const { auditStatus, isEditorble, page,familyUp } = this.state
    item.canChange = true
    item.indexGroup = i
    if (item.key == 'phone' && page !== 'task') {
      item.value=global.loginInfo && global.loginInfo.phone || null
      item.canChange = false
    }
    if (item.key == 'verifyCode' && (auditStatus == 'audit_fail')) {
      item.value = null
    }
    if((auditStatus=='active' || familyUp) && ['accountCreationType' ,'nickname','account'].includes(item.key)){
      item.canChange = false
    }
    if ((item.key == 'familySecurityCode' || item.key == 'verifyCode')&& item.value) {
      item.canChange = false
    }
    else {
      if (item.group == 'base' && item.value && isEditorble && user.auditStatus != 'audit_fail') {//入驻成功后或审核中基本资料不能修改 //入驻成功后修改资料后查看
        item.canChange = false
      } else {
        // item.value=null //继续入驻数据要回显
      }
    }
    if(constUser[item.key]){
      this.setState({[item.key+'Source']:constUser[item.key]})
    }
    return this.regularItem(item)
  }
  oprateData = (res) => {//处理返回的数据列表
    const { merchantType } = this.state
    if (!res) {
      return
    }
    let lists = [
      { name: '基本资料', key: 'base', column: [] },
      { name: merchantType == 'anchor' || merchantType == 'familyL1' || merchantType == 'personal' ? '个人资料' : '公司资料', key: 'company', column: [] },
      { name: '自定义资料', key: 'custom', column: [] },
    ]
    res=sortLists(res)
    for (let i = 0; i < lists.length; i++) {
      let item1 = lists[i]
      for (let j = 0; j < res.length; j++) {
        let item2 = res[j]
        if(needGetSourceKeys.includes(item2.key) && item2.value){
          this.getSource(item2)
        }
        if (item2.group == item1.key) {
          item2 = this.addItemCondition(item2,i),
          item1.column.push(item2)
          item1.column[item1.column.length - 1] ?item1.column[item1.column.length - 1] .index = item1.column.length - 1:null
          if(item2.options && item2.showBy){ //如果有子集
            let arr=sortLists(item2.key=='industrySelect'?item2.showBy.select || [] : [])
            if(item2.options && item2.showBy && item2.key!='industrySelect'){
              item2.options.map(itemOption=>{
                let secondArrs=sortLists(item2.showBy[itemOption] || [])
                secondArrs.map(item=>item.showByKey=itemOption)
                arr=arr.concat(secondArrs)
              })
            }
            for(let item3 of arr){
              item3 = this.addItemCondition(item3,i)
              if(item2.key=='industrySelect'){
                item2.component="input"
                item2.value='select'
                item3.key=='specialIndustry'?item3.parentkey='firstIndustry':null
              }else{
                item3.parentkey=item2.key
              }
              if(needGetSourceKeys.includes(item3.key) && item3.value){
                this.getSource(item3,item2.value)
              }
              item1.column.push(item3)
              item1.column[item1.column.length - 1].index = item1.column.length - 1
            }
          }
        }
      }
    }
    this.setState({
      lists, loadData: 1, oldLists: res
    })
  }
  getSource = async (data,parentCode,callback=()=>{}) => { //获取行业分类
    try{
      callback?Loading.show():null
      let func=data.key=='workType'?requestApi.getWorkType:requestApi.getIndustry
      const res=await func({parentCode,page:1,limit:100})
      if(res && res.data){
        let source={}
        res.data.map(item=>source[item.code]=item.name)
        this.setState({
          [data.key+'Source']:source
        },callback)
        return
      }
      Toast.show('分类查询数据为空')
      this.setState({
        [data.key+'Source']:''
      })
    }catch(error){
      console.log('error',error)
    }
  }
  getDataDetail = (propsFunc, callback = () => { }) => {
    const { userInfo: user, navigation, merchant } = this.props
    const { page, joinMerchantId, updateAuditStatus, familyUp } = navigation.state.params
    let func;
    let params = {}
    const { auditStatus,merchantType } = this.state
    if (page === 'task') {
      func = taskRequest.fetchjobMerchantDetail
      params.joinMerchantId = joinMerchantId
      params.joinMerchantType = merchantType
      func(params).then((res) => {
        this.oprateData(res.fieldInfos || res.identity || res)
      }).catch(err => {
        console.log(err)
      });
    } else {
      if (propsFunc) { //
        func = propsFunc
      }
      else if (!user.createdMerchant) {//首次入驻
        func = requestApi.fieldTemplateList
        params = { merchantType }
      }
      else if (['un_audit','audit_fail'].includes(user.auditStatus)) {//首次入驻没走完，继续入驻 或首次入驻审核失败
        func = requestApi.keepEnterMerchantDetail
      }
      else if (familyUp == 1) { //继续升级
        func = requestApi.merchantKeepEnterUpFamilyMerchantDetail
      }
      else if (auditStatus == 'unSubmit') {//扩展身份
        func = requestApi.merchantExtendDetail
        params = { merchantType }
      }
      else {//审核中查看
        func = requestApi.merchantIdentityDetailForUpdate
        params = { merchantType }
      }
      func(params).then((res) => {
        if (propsFunc) {
          callback(res)
        } else {
          this.oprateData(res.fieldInfos || res.identity || res)
          const currentMerchantType = merchantType || res.merchantType
          let currentMerchant = merchant.filter(item => item.merchantType == currentMerchantType)[0]
          if (auditStatus === 'audit_fail' || updateAuditStatus == 'un_pass') {
            requestApi.auditFailReason({ merchantType: currentMerchantType }).then((error) => {//查询失败原因
              this.setState({ remark: error.auditFailReason })
            }).catch(err => {
              console.log(err)
            });
          }
          this.setState({
            name: currentMerchant && currentMerchant.name || '',
            merchantType: currentMerchantType,
            refreshing:false
          })
        }
      }).catch((error)=>{
        console.log('error',error)
          this.setState({refreshing:false})
      })
    }
  }
  componentDidMount() {
    this.timer = setTimeout(() => {
      SplashScreen.hide();
    }, 100)
    Loading.show()
    this._onRefresh(false)
  }
  _onRefresh=(refreshing)=>{
    this.setState({refreshing})
    this.getDataDetail();
    this.getMerchantHome();
  }
  gobackOprate = () => {
    const { userInfo: user, navigation, resetPage, navPage } = this.props
    this.removeEventListener()
    if (user.auditStatus == 'audit_fail' && this.state.page == 'login') {
      resetPage("Index")
    } else {
      if (this.state.page == 'login') {
        resetPage("Login")
      } else {
        navigation.goBack()
      }
    }
  }

  goBack = () => {
    let auditStatus = this.getAuditStatus()
    let page = this.props.navigation.getParam("page", '');
    if ((page == 'login' || page == 'register') && this.state.oldLists.length > 0) {
      if (auditStatus == 'unSubmit' || auditStatus == 'audit_fail' || (auditStatus == 'active' && this.state.isEditorble)) {
        CustomAlert.onShow(
          "confirm",
          "确定后需要重新填写资料？",
          "是否放弃编辑",
          () => this.gobackOprate()
        )
      } else {
        this.gobackOprate()
      }
    } else {
      this.props.navigation.goBack()
    }
  };
  changeFormData = (item, value, wrong = 0) => {
    let lists = this.state.lists;
    // const isWrong=wrong?wrong:((item.regular && !item.regular(item.value)) || 0)
    console.log('value',item.key,value)
    lists[item.indexGroup].column[item.index] = {
      ...item,
      value,
      wrong
    }
    console.log(lists[item.indexGroup].column[item.index].value)
    this.setState({ lists: [...lists] })
  }
  scrollToItem = (item1, wrong = 1) => {
    wrong && this.changeFormData(item1, item1.value, 1)
    const itemLayout = (this[item1.key + 'layout'+item1.index] || 0) + (this[this.state.lists[item1.indexGroup].name + 'layout'] || 0)
    this.myScrollView.scrollTo({ x: 0, y: itemLayout, animated: true })
  }

  getMerchantHome = () => {
    this.props.userInfo.createdMerchant == 1 ? this.props.getMerchantHome({
      successCallback:()=>this.getAuditStatus()
    }) : null
  }
  getAuditStatus = () => {
    const { userInfo: user, navigation ,merchantData} = this.props;
    const {merchantType,familyUp}=this.state
    let { identityStatuses = [] } = merchantData.merchant || {};
    let auditStatus
    let updateAuditStatus=null
    if (user.createdMerchant === 1) {
      let findItem = identityStatuses.find(item => familyUp? item.merchantType ==='familyL2':item.merchantType== merchantType);
      if (findItem && findItem.auditStatus) {
        auditStatus = findItem.auditStatus;
        updateAuditStatus=findItem.updateAuditStatus
      }
    }
    this.setState({auditStatus:auditStatus || 'unSubmit',updateAuditStatus,isEditorble:this.state.page!='task' && (auditStatus == 'audit_fail' || updateAuditStatus == 'un_pass')?true:this.state.isEditorble})
    return auditStatus || 'unSubmit';
  }
  submitNextFunc = (navigation, navigateParam) => {
    this.removeEventListener()
    Toast.show('提交审核成功')
    navigation.replace('ApplyFormDone', navigateParam);
  }

  judgeFun = (func, params, navigateParam, navigation = this.props.navigation) => {
    const auditStatus = this.getAuditStatus();
    Loading.show()
    func(params).then((res) => {
      this.state.callback()
      const { userInfo: user, userSave, getMerchantHome, navPage } = this.props;
      if ((res && res.token) || user.auditStatus == "audit_fail") {
        global.loginInfo = {
          ...global.loginInfo,
          token: (res && res.token) || user.token,
          createdMerchant: 1,
          merchantId: (res && res.merchantId) || user.merchantId,
          auditStatus: 'un_audit',
          isAdmin: 1
        }
        userSave({ user: loginInfo })
      }
      if (auditStatus == 'active') {
        if (this.state.merchantType == 'familyL1' && (this.state.name == '公会' || this.state.familyUp)) { //家族长升级
          this.submitNextFunc(navigation, navigateParam)
        } else {
          Toast.show('修改成功，请等待审核')
          getMerchantHome();
          navPage(this.state.route || 'RegisterList')
        }
      }
      else {
        this.submitNextFunc(navigation, navigateParam)
      }
    }).catch((error) => {
      console.log('error', error)
      if (error) {
        let errorKey = ''
        switch (error.message) {
          case '邮箱已被使用！': errorKey = 'companyEmail'; break;
          case '邀请码不存在': errorKey = 'esCode'; break;
          // case '短信验证码不存在': errorKey = 'verifyCode'; break;
          case '家族邀请码不存在': errorKey = 'familySecurityCode'; break;
        }
        const { lists } = this.state
        let errorItem;
        for (let item of lists) {
          errorItem = item.column.find(item2 => item2.key == errorKey);
          if (errorItem) break;
        }
        console.log('errorItem', errorItem)
        errorItem && this.scrollToItem(errorItem)
      }
    })
  }

  submit = oprate => {
    Keyboard.dismiss();
    const { name, lists, merchantType, auditStatus, page, route, familyUp, updateAuditStatus, isEditorble ,oldLists} = this.state;
    let merchant = {}
    let verifyCodeItem={}
    for (let j = 0; j < lists.length; j++) {
      let item = lists[j]
      if (item.column) {
        for (let i = 0; i < item.column.length; i++) {
          let item1 = item.column[i]
          if (isEditorble) { //如果编辑了资料需验证
            if(item1.wrong){
              this.scrollToItem(item1)
              return
            }
            if (item1.display && item1.canChange) {
              let length = item1.maxLength || item1.length
              if (length && item1.value && item1.value.length > length && item1.component == "input") {
                Toast.show(item1.name + '最多' + length + '位字符')
                this.scrollToItem(item1)
                return
              }
              if (item1.value && item1.regular && !item1.regular(item1.value)) {
                Toast.show(item1.warningMessage || ('请输入正确格式的' + item1.name))
                this.scrollToItem(item1)
                return
              }
            }
            if (item1.required == 1 && item1.display == 1 && item1.canChange) {
              if (!item1.value || item1.value.length === 0) {
                Toast.show(item1.name ? '请完善' + item1.name : '请上传作品');
                this.scrollToItem(item1)
                return;
              }
              if ((item1.key == 'bankNo' || item1.key == 'openBank') && !this.state[item1.key + 'Name']) { //兼容旧版本
                Toast.show('请选择开户行及行号')
                this.scrollToItem(item1)
                return;
              }
            }
          }
          let itemSubmit=1
          if(item1.showByKey){
            const parentItem=lists[item1.indexGroup].column.find(itemF=>itemF.key==item1.parentkey) || {}
            parentItem.value!=item1.showByKey?itemSubmit=0:null
          }
          if(item1.key=='verifyCode' && itemSubmit){
            verifyCodeItem=item1
          }
          itemSubmit?
          merchant[item1.key] = {
            name: item1.name,
            media: item1.media,
            value: item1.value,
            group: item1.group,
            length: item1.length
          }:null
        }
      }
    }
    const { userInfo: user, getMerchantHome } = this.props;
    let params = {
      merchantType,
      merchant
    }
    let navigateParam = {
      name,
      route: route,
      merchantType,
      auditStatus: this.getAuditStatus(),
      familyUp,
      page,
      callback: () => {
        getMerchantHome();
      }
    }
    let func;
    if (!user.createdMerchant) {
      func = requestApi.merchantEnter //首次入驻
    } else if (familyUp) { //家族长继续升级
      func = requestApi.merchantKeepEnterUpFamilyUpdateMerchant
    }
    else if (auditStatus == 'active') { //商户入驻成功，修改资料
      if (merchantType == 'familyL1' && name == '公会') {
        func = requestApi.upFamilySave //家族长升级
      }
      else {
        func = requestApi.merchantIdentityUpdate //修改入驻资料
      }
    }
    else if (user.auditStatus == 'audit_fail') {//首次入驻没走完，继续入驻
      func = requestApi.merchantUpdateEnter //修改入驻资料
    } else if (auditStatus == 'audit_fail') {//扩展身份，继续入驻
      func = requestApi.merchantUpdateReExtend //修改入驻资料
    } else if (user.auditStatus == 'active' && auditStatus === 'unSubmit') {//扩展身份，首次入驻
      func = requestApi.merchantExtend //扩展身份，首次入驻
    }
    else { //审核中，不需要做处理
      Toast.show('资料审核中')
    }
    const nextStype=()=>{
      if (navigateParam.auditStatus == 'audit_fail' || navigateParam.auditStatus == 'active' || updateAuditStatus == 'un_pass') { //判断是否是修改资料，修改资料需要验证手机号
        this.removeEventListener()
        this.props.navigation.navigate('VerifyPhone', {
          phone: global.loginInfo && global.loginInfo.phone,
          editable: false,
          bizType: 'VALIDATE',
          onConfirm: (phone, code, navigation) => {
            Loading.show()
            requestApi.smsCodeValidate({ phone, code }).then(() => {
              this.judgeFun(func, params, navigateParam, navigation)
            }).catch(err => {
              console.log(err)
            });
          }
        })
      } else {
        this.judgeFun(func, params, navigateParam)
      }
    }
    if(verifyCodeItem.canChange && isEditorble){ //验证验证码
      requestApi.smsCodeValidateUserAccount({
        phone:merchant['account'].value,
        code:merchant['verifyCode'].value,
        smsAuthBizType:merchant['accountCreationType'].value=='create'?'CREATE_XK_USER':'BIND_XK_USER'
      }).then(() => {
        nextStype()
      }).catch(()=>{
          this.scrollToItem(verifyCodeItem)
        })
      return
    }
    nextStype()
  }
  merchantJoinTaskAudit = () => {
    const { navigation } = this.props
    const { taskId, callback, listcallBack } = navigation.state.params
    taskRequest.fetchMerchantJoinTaskAudit({ jobId: taskId }).then(() => {
      Toast.show('审核通过')
      if (callback) {
        callback(1)
      }
      if (listcallBack) {
        listcallBack(1)
      }
      navigation.goBack()
    }).catch(err => {
      console.log(err)
    });
  }
  auditTask = (isPass) => {
    const { navigation } = this.props
    const { taskId, callback, merchantTaskNode, listcallBack, cantAudit } = navigation.state.params
    if (isPass) {
      if (cantAudit) {
        CustomAlert.onShow(
          "confirm",
          cantAudit,
          "提示",
          () => { },
          () => { navigation.goBack() },
          botton1Text = "确定",
          botton2Text = "取消",
        )
      } else {
        CustomAlert.onShow(
          "confirm",
          "确定通过审核？",
          "提示",
          () => { },
          () => { this.merchantJoinTaskAudit() },
          botton1Text = "通过",
          botton2Text = "取消",
        )
      }

    } else {
      this.props.navigation.navigate('CancelTaskAudit', {
        listcallBack: listcallBack,
        merchantTaskNode: merchantTaskNode,
        taskcore: 'auditcore',
        taskId: taskId,
        callback: callback
      })
    }
  }
  actionOperate = (index) => {
    let { oprateData, oprateCallback = () => { },selectOptions } = this.state
    if(index== selectOptions.length - 1){
      return
    }
    if (oprateData.component == "file") {
        oprateCallback(index === 0 ? 'take' : 'pick')
        return
    }
    let selectedCode;
    for(let key in this.state[oprateData.key + 'Source']){
      this.state[oprateData.key + 'Source'][key]==selectOptions[index]?selectedCode=key:null
    }
    console.log('selectedCode && oprateData.value',selectedCode , oprateData.value)
    if (selectedCode && oprateData.value != selectedCode) {
      this.changeFormData(this.state.oprateData, selectedCode)
      if (oprateData.key=='firstIndustry') {
        const secondList = this.state.lists[oprateData.indexGroup].column.find((itemF) => itemF.parentkey === oprateData.key)
        secondList && this.changeFormData(secondList, '')
      }
    }
  }
  renderRightView = (headerWidth) => {
    const { oldLists, page, isEditorble, auditStatus, lists, updateAuditStatus } = this.state;
    let headerRightValue = ''
    let onPress = (() => { })
    if ((auditStatus == 'active' || auditStatus == 'audit_fail') && page != 'task') {
      if (isEditorble) {
        if (auditStatus == 'audit_fail' || updateAuditStatus == 'un_pass') {
          headerRightValue = '重新提交'
        } else {
          headerRightValue = '保存'
        }
      } else {
        auditStatus == 'active' && updateAuditStatus!='un_audit'? headerRightValue = '修改':null
      }
      onPress = (() => {
        if (isEditorble) {
          this.submit()
        } else { //修改资料
          this.setState({
            isEditorble: true
          },
            () => {
              lists[1] && lists[1].column && lists[1].column[0] && this.scrollToItem(lists[1].column[0], 0)
              this.oprateData(oldLists, 0)
            })
        }
      })
    }
    return (
      headerRightValue ?
        <TouchableOpacity style={[styles.headerRightView, { width: headerWidth }]} onPress={() => onPress()} >
          <Text style={styles.headerRightView_text}> {headerRightValue} </Text>
        </TouchableOpacity> :
        <TouchableOpacity style={[styles.headerRightView, { width: headerWidth }]} />
    )
  }
  renderNextButtonSubmit = () => { //下一步
    const { navigation } = this.props;
    const { auditStatus, loadData, agress ,merchantType, name,page} = this.state
    return loadData && auditStatus == 'unSubmit' && page!='task'? (
      <View>
        <TouchableOpacity
          onPress={() => {
            this.setState({
              agress: !agress
            })
          }}
          style={{ marginTop: 15, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}
        >
          <Image source={agress ? chooseIcon : nochooseIcon} style={{ marginRight: 8 }} />
          <Text style={styles.c9f12}>我已阅读并同意</Text>
          <TouchableOpacity
            onPress={() => {
              navigation.navigate('Contract', { merchantType, name })
            }}
          ><Text style={styles.cbf14}>《联盟商加盟合同》</Text></TouchableOpacity>
          <Text style={styles.c9f12}>及</Text>
          <TouchableOpacity
            onPress={() => {
              navigation.navigate('Appoint', { merchantType, name })
            }}
          ><Text style={styles.cbf14}>《特别约定》</Text></TouchableOpacity>
        </TouchableOpacity>

        <CommonButton
          style={{ marginBottom: 20 + CommonStyles.footerPadding }}
          title='下一步'
          onPress={() => {
            if (!agress) {
              Toast.show('请先阅读联盟商加盟合同和特别约定')
              return
            }
            CustomAlert.onShow(
              "confirm",
              "请确认提交的资料填写无误，资料提交后必须完成系统审核才能修改",
              "提示",
              () => { console.log('取消') },
              () => { this.submit() },
              botton1Text = "确定",
              botton2Text = "取消"
            )
          }}
        />
      </View>
    ) : null
  }
  render() {
    const { navigation, userInfo: user,canUpgrade } = this.props;
    const { refreshing,merchantType, selectOptions, isEditorble, auditStatus, remark, lists, updateAuditStatus, showBigPicArr, showIndex, showBigModal } = this.state;
    const { hasBtn, page } = navigation.state.params
    console.log(this.state.route)
    let headerName = '入驻资料'
    let headerWidth = 100
    if (auditStatus == 'unSubmit' && page != 'task') {
      headerName = '入驻资料(' + '未提交' + ')'
      headerWidth = 50
    }
    console.log('lists',lists)
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack={false}
          title={headerName}
          leftView={
            <TouchableOpacity
              style={[styles.headerLeftView, { width: headerWidth }]}
              onPress={() => { this.goBack(); }}
            >
              <Image source={require("../../../images/mall/goback.png")} />
            </TouchableOpacity>
          }
          rightView={this.renderRightView(headerWidth)}
        />
        {
          page!='task' && (auditStatus == 'audit_fail' || updateAuditStatus == 'un_pass') ?
            <View style={styles.autfailView}>
              <View style={styles.failicon}><Text style={{ fontSize: 17, color: '#FFC125' }}>!</Text></View>
              <Text style={styles.autfailViewText}>审核不通过原因：{remark}</Text>
            </View>
            : null
        }

        <ScrollView
          style={{ flex: 1, paddingBottom: 20 }}
          ref={(view) => { this.myScrollView = view; }}
          refreshControl={(
            <RefreshControl
                  refreshing={refreshing}
                  onRefresh={()=>this._onRefresh(true)}
            />
          )}
        >
          <View style={{ alignItems: 'center', paddingBottom: CommonStyles.footerPadding + 20 }}>
            {
              lists.map((item1, index0) => {
                return (item1.column && item1.column.length != 0 && item1.column.filter((item) => item.display === 1).length > 0 ?
                  <View key={index0} onLayout={event => { this[item1.name + 'layout'] = event.nativeEvent.layout.y }}>
                    {
                      canUpgrade && merchantType == 'familyL1' && item1.key == 'base' && !isEditorble ? (
                        <View style={styles.familyUp}>
                          <Text style={styles.title_text}>{item1.name}</Text>
                          <TouchableOpacity
                            onPress={this.upgrade}
                          >
                            <Text style={[styles.title_text, { color: CommonStyles.globalRedColor }]}>升级为公会 >></Text>
                          </TouchableOpacity>
                        </View>
                      ) : (
                          <Text style={styles.title_text}>{item1.name}</Text>
                        )
                    }
                    <Content style={styles.itemsBlock}>
                      {
                        item1.column && item1.column.map((item, index1) => {
                          return (
                            <View key={index1} onLayout={event => { this[item.key + 'layout'+index1] = event.nativeEvent.layout.y }} key={item.key + item.index}>
                              <ListItem
                                state={this.state}
                                showActionSheet={() => this.ActionSheet.show()}
                                setState={(data, callback = () => { }) => this.setState(data, () => callback())}
                                item={item}
                                scrollToItem={this.scrollToItem}
                                changeFormData={this.changeFormData}
                                getSource={this.getSource}
                              />
                            </View>
                          )
                        })
                      }
                    </Content>
                  </View> : null
                )
              })
            }

            {this.renderNextButtonSubmit()}
          </View>
        </ScrollView>
        <ActionSheet
          ref={o => (this.ActionSheet = o)}
          options={selectOptions}
          cancelButtonIndex={selectOptions.length - 1}
          onPress={index => this.actionOperate(index)}
        />
        <ShowBigPicModal
          ImageList={showBigPicArr}
          visible={showBigModal}
          showImgIndex={showIndex}
          onClose={() => {
            this.setState({
              showBigModal: false
            })
          }}
        />
        {
          hasBtn && (
            <View>
              <CommonButton
                title='审核通过'
                style={[styles.botton, { marginBottom: 0 }]}
                onPress={() => this.auditTask(true)}
              />
              <CommonButton
                onPress={() => this.auditTask(false)}
                title='审核不通过'
                style={[styles.botton, styles.botton2]}
                textStyle={{ color: CommonStyles.globalHeaderColor }}
              />
            </View>
          )
        }
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding
  },
  headerLeftView: {
    width: width / 3,
    alignItems: 'flex-start',
    paddingLeft: 18,
  },
  headerRightView: {
    paddingRight: 18,
    width: width / 3,
    alignItems: 'flex-end'
  },
  headerRightView_text: {
    fontSize: 17,
    color: "#fff",
  },
  autfailView: {
    backgroundColor: '#FFEBCD',
    paddingHorizontal: 15,
    paddingVertical: 10,
    flexDirection: 'row',
    alignItems: 'center'
  },
  autfailViewText: {
    fontSize: 14,
    color: CommonStyles.globalRedColor
  },
  c9f12: {
    color: '#999999',
    fontSize: 12
  },
  cbf14: {
    color: '#4A90FA',
    fontSize: 12
  },
  itemsBlock: {
    width: width - 20,
    overflow: 'hidden',
    marginTop: 15

  },
  title_text: {
    fontSize: 14,
    color: "#777",
    marginLeft: 15,
    marginTop: 15
  },
  botton: {
    marginLeft: 10,
  },
  botton2: {
    backgroundColor: '#fff',
    marginBottom: 20 + CommonStyles.footerPadding
  },
  failicon: {
    borderColor: '#FFC125',
    borderWidth: 2,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
    width: 24,
    height: 24,
    marginRight: 10
  },
  familyUp: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    justifyContent: 'space-between',
    paddingRight: 8
  }
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
    canUpgrade:state.user.canUpgrade,
    merchantData:state.user.merchantData || {},
    shop: state.shop || {},
    merchant: state.user.merchant || []
  }), {
    resetPage: (routeName) => ({ type: 'system/resetPage', payload: { routeName } }),
    navPage: (routeName, params = {}) => ({ type: 'system/navPage', payload: { routeName, params } }),
    replacePage: (routeName, params = {}) => ({ type: 'system/replacePage', payload: { routeName, params } }),
    backPage: (routeName, params = {}) => ({ type: 'system/back', payload: { routeName, params } }),
    getMerchantHome: (payload = {}) => ({ type: 'user/getMerchantHome', payload }),
    userSave: (payload = {}) => ({ type: 'user/save', payload }),
    updateUser: (payload = {}) => ({ type: 'user/updateUser', payload }),
  }
)(MyApplyFormScreen);
