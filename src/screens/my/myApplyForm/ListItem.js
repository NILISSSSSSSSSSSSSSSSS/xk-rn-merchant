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
  Keyboard,
  Platform,
} from "react-native";
import { connect } from "rn-dva";
import moment from "moment";
import Video from 'react-native-video';
import * as utils from "../../../config/utils";
import Radio from "../../../components/Radio";
import CommonStyles from "../../../common/Styles";
import * as requestApi from "../../../config/requestApi";
import * as regular from "../../../config/regular";
import ImageView from "../../../components/ImageView";
import Line from "../../../components/Line";
import picker from "../../../components/Picker";
import TextInputView from "../../../components/TextInputView";
const { width, height } = Dimensions.get("window");
import SwipeRow from "../../../components/SwipeRow";
import CheckButton from "../../../components/CheckButton";
import { NavigationComponent } from "../../../common/NavigationComponent";
import * as Address from '../../../const/address'
import * as constUser from '../../../const/user'
import {TakeTypeEnum, PickTypeEnum } from "../../../const/application";
const addressItems=['districtCode','companyAddress','registerAddress','businessAddress']
class ListItem extends NavigationComponent {
  renderPushCity = (item) => {
    const { userInfo: user, state } = this.props
    const { isEditorble, auditStatus, merchantType, name, familyUp } = state;
    let canEdit= isEditorble && item.canChange
    let canAdd=canEdit
    if ((auditStatus != 'active' || (merchantType == 'familyL1' && (name == '公会' || familyUp))) && item.value && item.value.length == 1 && canEdit) {
      canAdd = false //入驻时只能填写一个主推城市，入驻成功后可以修改多个
    }
    return (
      <Line
        type="custom"
        style={styles.pushCityLine}
        placeholder="精确到地级市、区或县"
        leftView={
          <Text style={[styles.contentTopText, { color: item.wrong ? CommonStyles.globalRedColor : '#222' }]}>
            <Text style={{ color: CommonStyles.globalRedColor, opacity: item.required ? 1 : 0 }}>*</Text>
            {item.name}{" "}
            <Text style={{ color: "#ccc" }}>(精确到地级市、区或县)</Text>
          </Text>
        }
        rightView={
          <View style={{ width: width - 50, marginTop: 10 }}>
            {item.value && item.value.map((item1, index) => {
              return (
                canAdd ?
                  <SwipeRow
                    style={{ backgroundColor: "white" }}
                    key={index}
                  >
                    <TouchableOpacity
                      style={styles.delTextContainer}
                      onPress={() => {
                        const oldCodes = [...(item.value || [])]
                        oldCodes.splice(index, 1)
                        this.props.changeFormData(item, oldCodes)
                      }}
                    >
                      <Text style={styles.deleteTextStyle} >  删除 </Text>
                    </TouchableOpacity>
                    <Line
                      title={item1 && Address.getAddressByDistrictCode(item1)}
                      style={{ backgroundColor: '#fff', borderBottomWidth: (item.value.length == 0 || index == item.value.length - 1) && !canEdit ? 0 : 1 }}
                      leftStyle={{ width: width - 50, textAlign: "center", color: "#222" }}
                      activeOpacity={1}
                      onPress={canEdit?()=>this.selectPushCity(item,index):null}
                      point={null}
                    />

                  </SwipeRow> :
                  <Line
                    key={index}
                    title={item1 && Address.getAddressByDistrictCode(item1)}
                    style={{ backgroundColor: '#fff', borderBottomWidth: item.value.length == 0 || index == item.value.length - 1 ? 0 : 1 }}
                    leftStyle={{ width: width - 50, textAlign: "center", color: "#222" }}
                    point={null}
                    onPress={canEdit?()=>this.selectPushCity(item,index):null}
                  />

              );
            })}
            {
              canAdd ?
                <Line
                  title={"新增"}
                  type={"custom"}
                  style={{ justifyContent: "center", borderBottomWidth: 0, width: width - 50, marginLeft: 15 }}
                  leftStyle={{ textAlign: "center", color: CommonStyles.globalHeaderColor }}
                  onPress={() => this.selectPushCity(item)}
                  point={null}
                  rightView={
                    <Image source={require('../../../images/user/add.png')} style={{ width: 18, height: 18, marginLeft: 5 }} />
                  }
                /> : null
            }
          </View>
        }
      />
    );
  };
  selectPushCity=(item,index)=>{
    const isUpdate=index!=undefined
    picker._showAreaPicker(data => {
      let isExist = item.value && item.value.filter(
        (item ,index0)=> item == data.codes[2] && index!=index0
      ) || [];
      if (isExist.length == 0) {
        let value=item.value || []
        if(isUpdate){
          value[index]=data.codes[2]
        }else{
          value=[...value, data.codes[2]]
        }
        this.props.changeFormData(item, value)
      }else{
        Toast.show('该地区已存在')
      }
    }, isUpdate?
    Address.getNamesByDistrictCode(item.value[index]):
    item.value && item.value.length != 0 ? Address.getNamesByDistrictCode(item.value[item.value.length - 1]) : []);
  }
  deleteImg = (oldImage, data, deleteIndex) => {
    oldImage.splice(deleteIndex, 1)
    this.props.changeFormData(data, data == 1 ? '' : oldImage)
  };
  addImage = (oldImages, data) => {
    this.props.setState({
      selectOptions: ['拍摄', '相册', '取消'],
      oprateData: data,
      oprateCallback: (func = 'pick') => {
        const maxLen = data.length || 1
        const isVideo = data.media == 'video';
        const params = {
          func,
          type: isVideo ? PickTypeEnum[func + 'Video'] || TakeTypeEnum[func + 'Video'] : PickTypeEnum[func + 'Image'] || TakeTypeEnum[func + 'Image'],
          totalNum: maxLen - oldImages.length,
          limit: isVideo ? 50 * 1024 : 0
        }
        this.props.takeOrPickImageAndVideo(
          params,
          (res) => {
            oldImages = oldImages.concat(res.map(item => item.url));
            this.props.changeFormData(data, maxLen == 1 ? oldImages[0] : oldImages)
          }
        )
      }
    }, () => {
      this.props.showActionSheet()
    })
  };
  renderImgPic = (data) => {
    const maxLen = data.length || 1
    const { isEditorble } = this.props.state
    let items = [];
    if (data.value) {
      if (!Array.isArray(data.value)) {
        data.value ? items = [data.value] : null
      }
      else {
        items = data.value
      }
    }
    let addpic = require('../../../images/xiwei/add.png')
    if (!isEditorble || !data.canChange) {
      addpic = null
    }
    return (
      <View style={styles.imageLine} >
        {items.map((valueImage, indexImage) => {
          return (
            <TouchableOpacity
              style={[styles.imageViewTouch, { marginRight: (indexImage + 1) % 4 == 0 ? 0 : 10 }]}
              key={indexImage}
              onPress={() => {
                let temp = []
                items.map((item) => {
                  temp.push({
                    type: data.media == 'video' ? 'video' : 'images',
                    url: item
                  })
                })
                this.props.setState({
                  showBigPicArr: temp,
                  showIndex: indexImage,
                  showBigModal: true,
                })
              }}
            >
              <View style={[styles.imageViewTouch, { paddingTop: 4, position: "relative" }]}>
                <View style={styles.imageItem}  >
                  {
                    Platform.OS === 'ios' && data.media == 'video' ?
                      <Video source={{ uri: valueImage }}   // Can be a URL or a local file.
                        ref={(ref) => { this.player = ref }}
                        rate={0}        // Store reference,设为0安卓会报错
                        resizeMode="cover"
                        style={{ width: (width - 88) / 4 - 7, height: (width - 88) / 4 - 7 }}
                      /> :
                      <ImageView
                        resizeMode="cover"
                        source={{ uri: data.media == 'video' ? valueImage + '?vframe/jpg/offset/0' : utils.getPreviewImage(valueImage) }}
                        sourceWidth={(width - 88) / 4 - 7}
                        sourceHeight={(width - 88) / 4 - 7}
                      />
                  }

                </View>
                {
                  addpic ?
                    <TouchableOpacity
                      disabled={!isEditorble || !data.canChange}
                      onPress={() => this.deleteImg(items, data, indexImage)}
                      style={{ position: "absolute", top: 0, right: 0 }}
                    >
                      <Image source={require("../../../images/index/delete.png")} style={{ width: 18, height: 18 }} />
                    </TouchableOpacity> : null
                }

              </View>
            </TouchableOpacity>
          );
        })}

        {items.length == maxLen || !addpic ? null : (
          <TouchableOpacity
            disabled={!isEditorble || !data.canChange}
            style={styles.imageViewTouch}
            onPress={() => this.addImage(items, data)}
          >
            <View style={[styles.imageViewTouch, { paddingTop: 4 }]}  >
              <ImageView
                source={addpic}
                sourceWidth={(width - 88) / 4 - 7 + 1}
                sourceHeight={(width - 88) / 4 - 7 + 1}
              />
            </View>
          </TouchableOpacity>
        )}
      </View>
    );
  };
  showSelect = (data) => {
    console.log(data)
    const { isEditorble, lists ,oldParentCode} = this.props.state
    if (!isEditorble) {
      return
    }
    if (addressItems.includes(data.key)) {
      picker._showAreaPicker(area => {
        this.props.state[data.key] = area.names.join('-')
        this.props.changeFormData(data, area.codes[2])
      }, data.value ? Address.getNamesByDistrictCode(data.value) : []);
    } else if (data.component == 'date') {
      picker._showDatePicker(data1 => {
        this.props.changeFormData(data, moment(data1).valueOf() / 1000)
      }, undefined, data.value && moment(parseInt(data.value) * 1000)._d || '')
    }
    else if(data.key=='firstIndustry' || data.key=='workType'){ //一级行业分类
      if(!this.props.state[data.key+'Source']){
        this.props.getSource(data,'',()=>this.showSelectMany(data))
      }else{
        this.showSelectMany(data)
      }
    }else if(data.parentkey){
      const parentItem=lists[data.indexGroup].column.find(itemF=>itemF.key==data.parentkey) || {}
      if(parentItem.value){
        this.props.setState({oldParentCode:parentItem.value})
        if(data.key=='specialIndustry' && (!this.props.state[data.key+'Source'] || oldParentCode!=parentItem.value)){ //特约行业分类
          this.props.getSource(data,parentItem.value,()=>this.showSelectMany(data))
        }else{
          this.showSelectMany(data)
        }
      }else{
        Toast.show('请先选择'+parentItem.name)
      }
    }
    else {
      this.showSelectMany(data)
    }
  }
  showSelectMany = (data) => {
    let selectOptions = []
    for (let key in (this.props.state[data.key+'Source'] || {})) {
      selectOptions.push(this.props.state[data.key+'Source'][key])
    }
    this.props.setState({
      selectOptions: selectOptions.concat(['取消']),
      oprateData: data
    }, () => {
      this.props.showActionSheet()
    })
  }
  //获取验证码
  _checkBtn = (item) => {
    console.log(item,this.props.state.lists)
    Keyboard.dismiss();
    if (this.refs.getCode.state.disabled) {
      return;
    }
    let group = this.props.state.lists[item.indexGroup].column || []
    const accountCreationType=group.find(item => item.key == 'accountCreationType') || {}
    const phone = (group.find(item => item.key == 'account' && item.showByKey==accountCreationType.value) || {}).value || ''
    const accountType = (group.find(item => item.key == 'accountCreationType') || {}).value || ''
    if (!phone) {
      Toast.show("请输入晓可账号");
      return;
    }
    if (!regular.phone(phone)) {
      Toast.show("请输入正确格式的晓可账号");
    } else if (!accountType) {
      Toast.show("请选择账号");
    }
    else {
      Loading.show();
      requestApi.sendAuthMessage({ phone, bizType: accountType == 'bind' ? 'BIND_XK_USER' : 'CREATE_XK_USER' }).then(() => {
        this.refs.getCode.sendVerCode();
      }).catch((err)=>{
                    
      });
    }
  };
  onBlur = (item, text) => {
    console.log('item', item)
    if (item.key == 'esCode' && item.value && !item.wrong) {
      if (isNaN(Number(item.value))) {
        Toast.show("安全码格式不对");
        this.props.scrollToItem(item)
        return
      }
      if (item.value <= 9999) {
        Toast.show("请输入正确的安全码");
        this.props.scrollToItem(item)
        return
      }
      requestApi.verifySecurityCode({ securityCode: item.value })
        .then(() => { })
        .catch((res) => {
          console.log(res)
          if (res && res.message == "安全码不存在") {
            this.props.scrollToItem(item)
          }else{
            this.props.changeFormData(item,item.value,0)
          }
        })
        return
    }
    // if(item.key=='verifyCode' && !item.wrong){
    //   let group = this.props.state.lists[item.indexGroup].column || []
    //   const phone=(group.find(item => item.key == 'account') || {} ).value
    //   const accountCreationType=(group.find(item => item.key == 'accountCreationType') || {} ).value
    //   const types={
    //     'create':'CREATE_XK_USER',
    //     'bind':'BIND_XK_USER'
    //   }
    //   requestApi.smsCodeValidateUserAccount({
    //     phone,
    //     code:item.value,
    //     smsAuthBizType:types[accountCreationType]
    //   }).then(() => {
        
    //   }).catch((err)=>{
    //     console.log(err)
    //     this.props.scrollToItem(item)
    //   })
    // }
  }
  render() {
    const { state, item } = this.props
    const { isEditorble, lists } = state
    let isEditorbleAll = isEditorble && item.canChange
    rightView = null
    let huanhang = false
    if (item.media == 'picture' || item.media == 'video') { //添加图片
      rightView = this.renderImgPic(item)
      huanhang = true
    }
    else if (item.component == 'radio' && isEditorbleAll) { //radio
      let options = []
      const opt=item.options || constUser[item.key]
      for (key in opt) {
        options.push({
          title:item.options?constUser[item.key] ? constUser[item.key][opt[key]]:'' :opt[key],
          value:item.options?opt[key]: key
        })
      }
      rightView = (<Radio
        contentstyle={{ flex: 1, justifyContent: 'flex-end', flexWrap: 'wrap' }}
        item0Style={{ marginBottom: options[0] && (options[0].title.length > 7 || options[1].title.length > 8) ? 10 : 0 }}
        textStyle={{ color: '#222' }}
        change={v => {
          if (item.key == 'accountCreationType' && v == 'create') {
            CustomAlert.onShow(
              "alert",
              "当新建的晓可账号创建成功后，初始密码为12345678",
              "说明"
            );
          }
          this.props.changeFormData(item, v)
        }
        }
        value={item.value}
        options={options}
        disabled={!isEditorbleAll}
      />)
    }
    else if (item.component == 'text') {
      huanhang = true
      rightView = (
        isEditorbleAll?
        <TextInputView
          editable={isEditorbleAll}
          placeholder={item.key == 'advantage' ? "合作推广优势，请从渠道和人才两方面描述" : '请输入' + item.name}
          placeholderTextColor={"#ccc"}
          style={styles.textArea}
          maxLength={item.maxLength || item.length}
          keyboardType={item.keyboardType}
          inputView={{ height: 50, marginTop: 10 }}
          multiline={true}
          value={item.value && item.value.toString() || ''}
          onChangeText={v => this.props.changeFormData(item, v)}
        />:
        <Text style={{color:'#222',paddingTop:10,paddingLeft:6}}>{item.value}</Text>
      )
    }
    else if (!isEditorbleAll && (item.component == 'select' || item.component == 'radio')) {
      item.component = 'select'
    }
    let lineType = ''
    if (isEditorbleAll) {
      if (item.component == 'input' || item.component == 'password' || (item.media == 'text' && item.component == 'file')) {
        lineType = 'input'
      } else {
        lineType = 'horizontal'
      }
    }
    if (rightView) {
      lineType = 'custom'
    }
    let value = item.value || ''
    if (lineType == 'horizontal' || item.component == 'select') {
        value = (this.props.state[item.key + 'Source'] || {})[item.value]
    }
    if(item.showByKey){
      const parentItem=lists[item.indexGroup].column.find(itemF=>itemF.key==item.parentkey) || {}
      parentItem.value!=item.showByKey?item.display=0:item.display=1
    }
    if ((!isEditorbleAll && (item.key == 'accountCreationType' || item.name == '验证码')) || item.key==='industrySelect') {
      //绑定的晓可账号不能更改】
      item.display = 0
    }
    return (
      !item.display ? null :
        item.key == 'mainCities' ? this.renderPushCity(item) :
          <Line
            styleInput={{ textAlign: 'right', color: '#222' }}
            style={huanhang ? { alignItems: "flex-start", flexWrap: "wrap", paddingBottom: 10 } : {}}
            leftView={
              <View style={{ width: huanhang ? '100%' : '40%', flexDirection: 'row', alignItems: 'center' }}>
                <Text style={{ color: CommonStyles.globalRedColor, opacity: item.required ? 1 : 0 }}>*</Text>
                <Text style={{ color: item.wrong ? CommonStyles.globalRedColor : '#222' }}>
                  {item.name || '请上传作品'}
                </Text>
              </View>
            }
            rightTextStyle={{ flex: 1, color: '#222', textAlign: 'right' }}
            placeholder={isEditorbleAll ? "请输入" + item.name : ''}
            type={lineType}
            secureTextEntry={item.component == 'password' ? true : false}
            editable={isEditorbleAll}
            onChangeText={v => this.props.changeFormData(item, v)}
            maxLength={item.warningMessage && item.warningMessage.indexOf('中文字符') > 0 ? null : (item.maxLength || item.length)}
            value={
              addressItems.includes(item.key)? item.value && Address.getAddressByDistrictCode(item.value) || '' :
                item.component == 'date' && item.value ? moment(item.value * 1000).format("YYYY-MM-DD") :
                  lineType == 'horizontal' || item.component == 'select' ? value : item.value
            }
            point={null}
            keyboardType={item.keyboardType}
            rightView={rightView}
            onPress={lineType == 'horizontal' ? () => this.showSelect(item) : null}
            onBlur={(text) => this.onBlur(item, text)}
          >
            {
              item.name == '验证码' ?
                <CheckButton
                  ref="getCode"
                  delay={60}
                  styleBtn={{ paddingRight: 0 }}
                  title={styles.code_text}
                  onClick={() => this._checkBtn(item)}

                /> : null
            }
          </Line>

    )
  }
}

const styles = StyleSheet.create({
  imageViewTouch: {
    width: (width - 88) / 4,
    height: (width - 88) / 4
  },
  imageLine: {
    flexDirection: "row",
    width: width - 58,
    marginTop: 10,
    flexWrap: "wrap",
    marginLeft: 7,
    paddingBottom: 5,
  },
  imageItem: {
    width: (width - 88) / 4 - 7,
    height: (width - 88) / 4 - 7,
    borderRadius: 5,
    overflow: "hidden"
  },
  pushCityLine: {
    alignItems: "flex-start",
    flexWrap: "wrap",
    backgroundColor: "#fff",
    borderTopWidth: 1,
    borderColor: "#f1f1f1",
    paddingBottom: 0
  },
  delTextContainer: {
    width: 84,
    backgroundColor: "#EE6161",
    alignItems: "center",
    justifyContent: "center"
  },
  deleteTextStyle: {
    color: "#fff",
    fontSize: 14
  },
  code_text: {
    fontSize: 14,
    marginTop: -1,
    color: CommonStyles.globalHeaderColor
  },
  textArea:{
    textAlign: "left",
    width: width - 50,
    textAlignVertical: "top",
    color: "#222",
    flexWrap: 'wrap',
    position: 'relative',
    paddingLeft: 6
  }
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
    merchant: state.user.merchant || []
  }), {
    navPage: (routeName, params = {}) => ({ type: 'system/navPage', payload: { routeName, params } }),
    takeOrPickImageAndVideo: (options, callback) => ({ type: "application/takeOrPickImageAndVideo", payload: { options, callback } }),
  }
)(ListItem);
