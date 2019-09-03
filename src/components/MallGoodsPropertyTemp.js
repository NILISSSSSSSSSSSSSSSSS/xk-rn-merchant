/**
 * 商城排序
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  TouchableOpacity,
  ScrollView,
  Keyboard,
  Platform
} from 'react-native';
import CommonStyles from '../common/Styles';
import TextInputView from './TextInputView';
import { connect } from 'rn-dva'
const { width, height } = Dimensions.get('window');
const separatorLine = require('../images/shop/separatorLine.png')
const close_arrow_icon = require('../images/mall/close_arrow_icon.png')
const open_arrow_icon = require('../images/mall/open_arrow_icon.png')
class MallGoodsPropertyTemp extends Component {
  defaultHeight = 149.5;
  state = {
    containerHeight: new Map(),
    isGetHeight: false,
  }

  componentDidMount () {

  }
  changeState(key, value) {
    this.setState({
      [key]: value
    });
  }
  // 返回筛选数据，格式我想咋弄咋弄，但终究还是听后端的
  getFilterDataAndEmit = () => {
    // 接口文档 http://showdoc.xksquare.com/web/#/3?page_id=1165
    Keyboard.dismiss();
    const { somFilterAttrList, onSubmit } = this.props
    let templates = []
    let price = {
      low: '',
      high:'',
      placeholder_low: '',
      placeholder_high: ''
    }
    let listData = somFilterAttrList.templates && somFilterAttrList.templates.length !== 0 ? somFilterAttrList.templates : [];
    listData.map(attrItem => {
      let templatesItem = {
        name: attrItem.name,
        attributes: [],
      }
      attrItem.attributes.map(filedsItem => {
        if (filedsItem.fields.length === 2) { // 判断价格有没有填入，没有不加入提交数据
          if (filedsItem.fields[0].value !== '' && filedsItem.fields[1].value !== '') { // 填写了区间
            let pricePrams = {
              name: filedsItem.name,
              fields: []
            }
            filedsItem.fields.map(priceItem => {
              pricePrams.fields.push({ // 获取每项价格参数
                placeholder: priceItem.placeholder,
                value: priceItem.value
              })
              price.low = filedsItem.fields[0].value
              price.high = filedsItem.fields[1].value
              price.placeholder_low = filedsItem.fields[0].placeholder
              price.placeholder_high = filedsItem.fields[1].placeholder

            })
            templatesItem.attributes.push(pricePrams)
          }
        } else {
          let goodsParams = {
            name: filedsItem.name,
            fields: [],
          }
          filedsItem.fields.map(propertyItem => {
            propertyItem.items.map(item => {
              if (item.selectStatus) { // 获取每项选择的属性
                goodsParams.fields.push({
                  value: item.value
                })
              }
            })
          })
            goodsParams.fields.length !== 0 && templatesItem.attributes.push(goodsParams)
        }
      })
      templatesItem.attributes.length !== 0 && templates.push(templatesItem)
    })
    onSubmit(templates, !price.low && !price.high ? null : price)
  }

  // 选择属性
  handleSelect = (selectItem, filedsName) => {
    const { somFilterAttrList, save } = this.props
    let listData = somFilterAttrList.templates && somFilterAttrList.templates.length !== 0 ? somFilterAttrList.templates : [];
    listData.map(attrItem => {
      attrItem.attributes.map(filedsItem => {
        if (filedsItem.fields.length !== 2 && filedsName === filedsItem.name) { // 排除价格筛选, 找到当前选择的属性Items
          filedsItem.fields.map(propertyItem => {
            propertyItem.items.map(item => {
              // 设置单选
              if (selectItem.displayName === item.displayName && selectItem.value === item.value) {
                item.selectStatus = !item.selectStatus; // 设置当前项选择状态
              } else {
                item.selectStatus = false; // 其余设置为false
              }
            })
          })
        }
      })
    })
    save({ templates: listData })
  }
  // 获取真实高度，是否超过默认高度，如果超过展示默认高度和展开折叠按钮
  handleGetLayout = (event, index, attrIndex) => {
    let nowHeight = event.nativeEvent.layout && parseInt(event.nativeEvent.layout.height);
    console.log('nowHeight',nowHeight)
    // let prevHeight = this.state.containerHeight.get(`realHeight${attrIndex}${index}`)
    // let containerHeight = new Map();
    // containerHeight.set(`realHeight${attrIndex}${index}`,nowHeight)
    // containerHeight.set(`contentHeight${attrIndex}${index}`, this.defaultHeight)
    // nowHeight > this.defaultHeight && this.setState({ containerHeight, isGetHeight: true, }) // isGetHeight用于获取高度标示，如果获取了，视图更新不再次获取
  }
  // 展开，折叠
  toggleShowMoreProperty = (attrIndex, index) => {
    const { containerHeight } = this.state
    let nowHeight = containerHeight.get(`contentHeight${attrIndex}${index}`)
    let realHeight = containerHeight.get(`realHeight${attrIndex}${index}`)
    if (nowHeight === this.defaultHeight) { // 当前高度如果为默认高度，设置当前高度为 本来应该的高度（即展开所有）
      containerHeight.set(`contentHeight${attrIndex}${index}`, realHeight)
      this.setState({
        containerHeight
      })
    } else { // 如果当前高度 ！== 默认的高度，设置为默认高度
      containerHeight.set(`contentHeight${attrIndex}${index}`, this.defaultHeight)
      this.setState({
        containerHeight
      })
    }
  }
  // 根据长短排队
  handleSortDisplayName = (arr = []) => {
    return arr.sort((prev, next) => {
      return prev.displayName.length - next.displayName.length
    })
  }

  handleInputPrice = (text, propertyName = '', placeholder = '') => {
    const { somFilterAttrList, save } = this.props
    let listData = somFilterAttrList.templates && somFilterAttrList.templates.length !== 0 ? somFilterAttrList.templates : [];
    console.log('propertyName', propertyName)
    listData.map(attrItem => {
      if (propertyName === attrItem.name) { // 找到操作的是哪个模板，有可能多个模板，多个价格区间，
        attrItem.attributes.map(filedsItem => {
          if (filedsItem.fields.length === 2) { // 找到当前价格区间字段
            filedsItem.fields.map(item => {
              if (item.placeholder === placeholder) { // 找到当前输入框是最高还是最低
                item.value = text
              }
            })
          }
        })
      }
    })
    save({ templates: listData })
  }

  getPricePropertyItem = (filedsItem = [], propertyName = '',) => {
    let propertyArr = filedsItem.fields;
    if(!propertyArr || propertyArr.length === 0) return null
    return (
      <View style={[styles.priceWrap, CommonStyles.flex_between, CommonStyles.flex_1]}>
        <TextInputView
          placeholder={propertyArr[0].placeholder}
          style={styles.headerTextInput}
          value={propertyArr[0].value}
          onChangeText={(text) => { this.handleInputPrice(text, propertyName, propertyArr[0].placeholder) }}
          keyboardType='numeric'
        />
        <View style={{ backgroundColor: '#222', height: 2,width: 10,marginHorizontal: 14 }} />
        <TextInputView
          placeholder={propertyArr[1].placeholder}
          style={styles.headerTextInput}
          value={propertyArr[1].value}
          onChangeText={(text) => { this.handleInputPrice(text, propertyName, propertyArr[1].placeholder) }}
          keyboardType='numeric'
        />
      </View>
    )
  }

  getPropertyItem = (filedsItem = []) => {
    let propertyArr = filedsItem.fields;
    if(!propertyArr || propertyArr.length === 0) return null
    console.log('propertyArr',  propertyArr)
    return (
      <View style={[CommonStyles.flex_between, CommonStyles.flex_1]}>
        {
          propertyArr.map((fieldItem, fIndex) => {
            return (
              <View key={fIndex} style={[CommonStyles.flex_start_noCenter, CommonStyles.flex_1, { flexWrap: 'wrap',paddingBottom: 20 }]}>
                {
                  this.handleSortDisplayName(fieldItem.items).map((item, index) => {
                    return  (
                      <TouchableOpacity 
                        key={item.displayName} 
                        activeOpacity={0.65} 
                        style={[styles.attrItemWrap, CommonStyles.flex_center, item.selectStatus ? styles.activeStyle : null]}
                        onPress={() => { this.handleSelect(item, filedsItem.name) }}
                      >
                        <Text style={{ fontSize: 12, color: item.selectStatus ? CommonStyles.globalHeaderColor: '#222' }}>{item.displayName}</Text>
                      </TouchableOpacity>
                      )
                  })
                }
              </View>
            )
          })
        }
      </View>
    )
  }
  renderFooter = () => {
    const { somFilterAttrList, resetPropertyFilter, onSubmit } = this.props
    return (
      <View style={[CommonStyles.flex_start_noCenter, styles.footer, { backgroundColor: '#fff',paddingBottom: CommonStyles.footerPadding }]}>
      {/* <View style={[CommonStyles.flex_start_noCenter, styles.footer, { backgroundColor: '#fff', }]}> */}
        <TouchableOpacity 
          activeOpacity={0.85}
          style={[CommonStyles.flex_1,CommonStyles.flex_center,{ backgroundColor: '#6AB5FF' }]} 
          onPress={() => { resetPropertyFilter(somFilterAttrList);onSubmit([], null);Keyboard.dismiss(); }}
        >
          <Text style={{ fontSize: 15, color: '#fff' }}>重置</Text>
        </TouchableOpacity>
        <TouchableOpacity 
          activeOpacity={0.85}
          style={[CommonStyles.flex_1,CommonStyles.flex_center,{ backgroundColor: CommonStyles.globalHeaderColor }]} 
          onPress={() => { this.getFilterDataAndEmit() }}
        >
          <Text style={{ fontSize: 15, color: '#fff' }}>确定</Text>
        </TouchableOpacity>
      </View>
    )
  }
  render() {
    const { somFilterAttrList } = this.props
    const { containerHeight, isGetHeight } = this.state
    let listData = somFilterAttrList.templates && somFilterAttrList.templates.length !== 0 ? somFilterAttrList.templates : [];
    // let isFold = containerHeight > this.defaultHeight;// 是否折叠
    // let wrapFoldStyle = isFold ? { overflow: 'hidden',height: this.defaultHeight } : null; // 折叠盒子的样式设置为固定
    console.log('listData',listData)
    return (
      <React.Fragment>
          <ScrollView
          style={[CommonStyles.flex_1,styles.container, { backgroundColor: '#fff',marginBottom: 50 + CommonStyles.footerPadding}]}
          showsHorizontalScrollIndicator={false}
        >
          {
            listData.map((attr, attrIndex) => {
              return (
                <View key={attrIndex}>
                  {
                    attr.attributes.map((property, pIndex) => {
                      let isPriceProperty = property.fields.length === 2;
                      return (
                        <View key={property.name}
                        style={
                          [
                            styles.propertyWrap, 
                            { paddingTop: attrIndex === 0 && pIndex === 0 ? 20 + CommonStyles.headerPadding : 20 },
                            { paddingHorizontal: !isPriceProperty ? 5 : 15},  // 增加padding
                            containerHeight.get(`realHeight${attrIndex}${pIndex}`) > this.defaultHeight ? { overflow: 'hidden',height: containerHeight.get(`contentHeight${attrIndex}${pIndex}`) }: null
                          ]
                        } 
                        onLayout={(event) => { !isGetHeight && this.handleGetLayout(event,pIndex, attrIndex) }}
                        >
                          { (pIndex >=1 || attrIndex >= 1) ? <Image source={separatorLine} style={{ position: 'absolute', top: 0, width: width - 65}} /> : null }
                          <View style={[CommonStyles.flex_between]}>
                            <Text style={{ fontSize: 14, color: '#222', paddingLeft: !isPriceProperty ? 10 : 0}}>{ property.name }</Text>        
                            {
                              containerHeight.get(`realHeight${attrIndex}${pIndex}`) > this.defaultHeight && !isPriceProperty // 真实的高度大于了默认高度 且 第一个为价格不需要折叠
                              ? <React.Fragment>
                                  <TouchableOpacity activeOpacity={0.65} style={{ paddingHorizontal: 10,paddingVertical: 5 }} onPress={() => { this.toggleShowMoreProperty(attrIndex,pIndex) }}>
                                    {
                                      containerHeight.get(`contentHeight${attrIndex}${pIndex}`) === containerHeight.get(`realHeight${attrIndex}${pIndex}`)
                                      ? <Image source={open_arrow_icon} />
                                      : <Image source={close_arrow_icon} />
                                    }
                                  </TouchableOpacity>
                              </React.Fragment>
                              : null
                            }                  
                          </View>
                          <View style={[CommonStyles.flex_start_noCenter]}>
                          {
                            property.fields.length === 2 // 价格单独显示
                            ? this.getPricePropertyItem(property, attr.name, attrIndex)
                            : <React.Fragment>
                              {
                                this.getPropertyItem(property)
                              }
                            </React.Fragment>
                          }
                          </View>
                        </View>
                      )
                    })
                  }
                </View>
              )
            })
          }
          { 
            listData.length === 0 ? <View style={[CommonStyles.flex_center, CommonStyles.flex_1, { height: height - (50 + CommonStyles.headerPadding) }]}><Text>暂无数据</Text></View> : null
          }
        </ScrollView>
        { this.renderFooter() }
      </React.Fragment>
    )
  } 
};
const styles = StyleSheet.create({
  container: {
    // paddingTop: CommonStyles.headerPadding,
  },
  attrItemWrap: {
    backgroundColor: '#f7f7f7',
    borderWidth: 1,
    paddingVertical: 7,
    paddingHorizontal: 20,
    borderColor: '#f7f7f7',
    marginLeft: 10,
    marginTop: 15,
    borderRadius: width - 65,
  },
  headerTextInput: {
    flex: 1,
    height: 25,
    width: (width - 133) / 2,
    textAlign: 'center',
    paddingHorizontal: 10,
    borderRadius: 15,
    fontSize: 14,
    backgroundColor: '#f6f6f6',
    color: '#222'
  },
  priceWrap: { 
    paddingBottom: 20,
    paddingTop: 15,
  },
  propertyWrap: { 
    // paddingTop: 20, 
    position: 'relative', 
  },
  footer: {
    position: 'absolute',
    bottom: 0,
    // bottom: 0 + CommonStyles.footerPadding,
    left: 0,
    height: 50 + CommonStyles.footerPadding,
    // height: 50,
    width: width - 65,
  },
  activeStyle: {
    borderColor: CommonStyles.globalHeaderColor,
    borderWidth: 1,
  },
});

export default connect(
  (state) => ({
      somFilterAttrList: state.mall.somFilterAttrList || {}, // 属性模板
  }),
  dispatch=>({
    resetPropertyFilter:(data)=> dispatch({ type: "mall/resetPropertyFilter", payload: { data, }}),
    save: (data) => dispatch({ type: "mall/save", payload: { somFilterAttrList: data, }})
  })
)(MallGoodsPropertyTemp);