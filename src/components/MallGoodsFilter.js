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
  Platform,
  Easing
} from 'react-native';
import CommonStyles from '../common/Styles';

export default class MallGoodsFilter extends PureComponent {
  constructor(props) {
    super(props)
    this.state = {
      data: [
        {
          title: '销量',
          type: 'saleQ',
          isDesc: 0,
          clickTime: 0,
        },
        {
          title: '价格',
          type: 'price',
          isDesc: 0,
          clickTime: 0,
        }
      ],
    }
  }

  componentWillReceiveProps (props) {
    if (props.clearFilter) {
      this.setState({
        data: [
          {
            title: '销量',
            type: 'saleQ',
            isDesc: 0,
            clickTime: 0,
          },
          {
            title: '价格',
            type: 'price',
            isDesc: 0,
            clickTime: 0,
          }
        ],
      })
    }
  }

  handleSort = (item,index) => {
    const {  onPress, canCancel } = this.props;
    const { data } = this.state
    let selectItem = JSON.parse(JSON.stringify(data[index]))
    if (canCancel) {// 如果是可取消选项, 连续点击3次则取消，中间切换则重新为0
      let unSelectItem = data.filter((dataItem, i) => i !== index);
      unSelectItem.map(unSelect => { unSelect.clickTime = 0;})
      selectItem.clickTime = selectItem.clickTime + 1;
      // console.log('selectItem',selectItem)
      // 重置升降序
      selectItem.isDesc = selectItem.clickTime % 3 === 0 ? selectItem.isDesc = 0 : item.isDesc === 0 ? 1 : 0;
      // console.log('item.isDesc',item)
      // console.log('selectItemsdfa',selectItem)
      this.setState({ data: [ ...unSelectItem, ...[selectItem] ] }, () => {
        selectItem.clickTime % 3 === 0 ? onPress(null, true) : onPress({ type: item.type, isDesc: selectItem.isDesc, index })
      })
      return
    }
    selectItem.isDesc = item.isDesc === 0 ? 1 : 0;
    data[index] = selectItem
    this.setState({ data }, () => { onPress({ type: item.type, isDesc: selectItem.isDesc, index });})
    
  }

  handleSelect = (item,index) => {
    const {  onPress, canCancel } = this.props;
    const { data } = this.state
    if (index === 0) {
      if (canCancel) { // 如果是可取消选项
        let selectItem = JSON.parse(JSON.stringify(data[index]))
        let unSelectItem = data.filter((dataItem, i) => i !== index);
         // 清空其他的选项次数
        unSelectItem.map(unSelect => { unSelect.clickTime = 0 })
        selectItem.clickTime = selectItem.clickTime + 1;
        console.log('see',selectItem.clickTime)
        console.log('see',selectItem)
        this.setState({ data: [ ...[selectItem], ...unSelectItem] }, () => {
          console.log('thisstat', this.state)
          selectItem.clickTime % 2 === 0 ? onPress(null, true) : onPress({ type: item.type, isDesc: 1, index });
        })
        return
      }
      onPress({ type: item.type, isDesc: 1, index });
      return
    }
    this.handleSort(item,index)
  }

  // 是否显示属性筛选模版
  getPropertyTemplate = () => {
    const { showPropertyFilter, drawer } = this.props
    if(showPropertyFilter) {
      return (
        <React.Fragment>
          <TouchableOpacity activeOpacity={0.65} style={[CommonStyles.flex_start]} onPress={() => { drawer && drawer.open() }}>
            <Text style={{ fontSize:14,color: '#222',marginRight: 3, }}>筛选</Text>
            <Image style={{ marginTop: 1 }} source={require('../images/mall/property_icon.png')}/>
          </TouchableOpacity>
        </React.Fragment>
      )
    }
    return null
  }

  render() {
    const {  onPress, style, activeIndex } = this.props;
    const { data } = this.state;
    return (
      <View style={[styles.filterView, style]}>
        {
          data.map((item, index) => {
            return (
              <TouchableOpacity
                key={index}
                style={styles.filterItem}
                onPress={() => { this.handleSelect(item,index) }}
              >
                <Text style={[styles.filterItem_text, activeIndex === index ? styles.filterItem_text_active : null]}>{item.title}</Text>
                {
                    index !== 0
                    ? <View style={styles.triangle}>
                        <View style={[styles.triangleTop, activeIndex === index && item.isDesc === 0 ? styles.triangleTop_active : null]} />
                        <View style={[styles.triangleBottom, activeIndex === index && item.isDesc === 1 ? styles.triangleBottom_active : null]} />
                      </View>
                    : null
                }
              </TouchableOpacity>
            );
          })
        }
        { this.getPropertyTemplate() }
      </View>
    );
  }
};

MallGoodsFilter.defaultProps = {
  canCancel: false, // 如果只有一个筛选条件点击相同的筛选条件，则取消， 如果有升降排序的，则第三次取消
  showPropertyFilter: false, // 是否显示属性筛选
  drawer: null,
  clearFilter: false, // 是否清空筛选
  activeIndex: 0, // 默认筛选条件,
  onPress: () => { },
  style: {},
}

const { width, height } = Dimensions.get('window');
const styles = StyleSheet.create({
  filterView: {
    // 以下是阴影属性：
    // shadowOffset: { width: 0, height: 4 },
    // shadowOpacity: 0.5,
    // shadowRadius: 8,
    // shadowColor: '#D7D7D7',
    // 注意：这一句是可以让安卓拥有灰色阴影
    // elevation: 0.8,
    zIndex: Platform.OS === 'ios' ? 1 : 0,
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    width: width,
    height: 44,
    backgroundColor: '#fff',
  },
  filterItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    paddingHorizontal: 15,
  },
  filterItem_text: {
    fontSize: 14,
    color: '#222',
  },
  filterItem_text_active: {
    color: '#4A90FA',
  },
  triangle: {
    flexDirection: 'column',
    justifyContent: 'center',
    marginLeft: 8,
  },
  triangleTop: {
    width: 0,
    height: 0,
    borderWidth: 5.5,
    borderColor: '#fff',
    borderBottomColor: '#ccc'
  },
  triangleTop_active: {
    borderBottomColor: '#4A90FA',
  },
  triangleBottom: {
    width: 0,
    height: 0,
    borderWidth: 5.5,
    borderColor: '#fff',
    borderTopColor: '#ccc',
    marginTop: 3,
  },
  triangleBottom_active: {
    borderTopColor: '#4A90FA',
  },
  drawerContainer: {
    flex:1,
    backgroundColor: 'red'
  },
});
