import React, { Component } from 'react';
import {
  Text, View, StyleSheet, ImageBackground, Image,
} from 'react-native';
import { connect } from 'rn-dva';
import Steps from '../../../../components/Steps';
import {
  BackThirdColor, YellowColor, TextSecondColor, WhiteColor, BackSecondColor, SmallMargin, BorderColor, WindowWidth, RowCenter, RowStart, TextThirdColor,
} from '../../../../components/theme';
import List, { ListItem } from '../../../../components/List';
import TextInputView from '../../../../components/TextInputView';
import { FormControl, createFormControl, CreatedForm } from '../../../../components/form';
import Radio from '../../../../components/Radio';
import Button from '../../../../components/Button';
import formMap from '../components/formMap';
import ActionSheet from '../../../../components/Actionsheet';
import ShowBigPicModal from '../../../../components/ShowBigPicModal';
import * as requestApi from '../../../../config/requestApi';
import Icon from '../../../../components/Icon';
import { filterValue } from '../../../../services/userActive';


function getWidth(val) {
  return WindowWidth * val / 375;
}

const iconStep = require('../../../../images/my/icon-step.png');
const iconStep1 = require('../../../../images/my/icon-step1.png');
const iconStep2 = require('../../../../images/my/icon-step2.png');
const btnBack = require('../../../../images/my/btn-back.png');
const btnPrev = require('../../../../images/my/icon-prev.png');

const filterIcon = (index, curIndex) => (index > curIndex ? iconStep2 : index === curIndex ? iconStep1 : iconStep);
const filterTitleColor = (index, curIndex) => (index > curIndex ? TextSecondColor : index === curIndex ? YellowColor : BackThirdColor);
const filterSize = (index, curIndex) => (index === curIndex ? 38 : 32);
const filterTitleStyle = (index, curIndex) => ({
  color: filterTitleColor(index, curIndex),
  fontSize: 12,
  marginTop: index === curIndex ? 2 : 5,
});

const filterIconStyle = (index, curIndex) => ({
  marginTop: index === curIndex ? -3 : 0,
});

class ActiveShopEdit extends Component {
  state = {
    index: 0,
    selectOptions: [],
  }
  componentDidMount() {
    this.props.fetchShopActiveInfo();
    this.props.fetchAccountShopStatus();
  }
  handleNext = () => {
    this.form.props.onSubmit();
  }
  handlePrev = () => {
    const { index } = this.state;
    if (index !== 0) {
      this.setState({
        index: index - 1,
      });
    }
  }
  handleChange = (fD) => {
    this.props.changeShopActiveForm(fD);
  }

  showCodeMap = (field, formData, callback) => {
    const { navPage } = this.props;
    switch (field) {
      case 'openBankCodeMap':
        if (!formData.bankCode) {
          Toast.show('请先选择银行编码');
          return;
        }
        navPage('MySearchBankAddress', {
          code: formData.openBankCode,
          parentCode: formData.bankCode,
          api: requestApi.dataPageTfBankDotPage,
          callback,
        });
        break;
      case 'bankCodeMap':
        navPage('MySearchBankAddress', {
          code: formData.bankCode,
          api: requestApi.dataPageTfBankQPage,
          callback,
        });
        break;
      default:
        break;
    }
  };

  showBigImages = (_data, _showIndex) => {
    console.log('查看大图', _data, _showIndex);
    const state = {
      showIndex: _showIndex,
      showBigPicArr: _data.map(d => ({ type: 'images', url: d })),
    };
    this.props.onShowBigModal(state.showBigPicArr, state.showIndex);
  }

  showActions = (handler, options, field, formData) => {
    if (field === 'secondIndustry' && formData.firstIndustry == null) {
      Toast.show('请先选择一级行业类目');
      return;
    }
    this.ActionSheet.show(handler);
    this.setState({
      selectOptions: options.map(opt => opt.title),
    });
  }

  handleSubmit = (fD) => {
    console.log(fD);
    const { index } = this.state;
    if (index !== 2) {
      this.setState({
        index: index + 1,
      });
    } else {
      this.props.submitShopActiveInfo(fD);
    }
  }

  render() {
    const {
      index, selectOptions,
    } = this.state;
    const { activeShopInfo, shopInfo } = this.props;
    const { formInfoList = [] } = activeShopInfo || {};
    const { optionsMap = {}, formData } = shopInfo || {};
    let allRules = [];
    formInfoList.forEach((item) => {
      allRules = allRules.concat(item.rules);
    });

    const formInfo = formInfoList[index] || {};

    const fields = (formInfo.fields || []).map(item => ({
      field: item.field, // 字段名称
      visible: item.visible, // 是否展示字段
      props: {
        ...item,
        options: item.options || optionsMap[item.field],
        showBigImages: this.showBigImages, // 查看大图
        showActions: this.showActions, // 显示下拉选项
        showCodeMap: this.showCodeMap, // 显示银行选择页面
        takeOrPickImageAndVideo: this.props.takeOrPickImageAndVideo, // 图片选择
      },
      control: formMap[item.type], // 组件
    }));

    // 最后一步校验所有数据，其它步骤只需校验所填写内容
    const rulesMap = (index === 2 ? allRules : formInfo.rules) || [];
    let rules = [];
    rulesMap.forEach(rs => {
      rules = rules.concat(rs);
    });
    // 图标
    const icons = formInfoList.map(item => item.title);

    return (
      <View>
        <View style={styles.card}>
          <Steps
            index={index}
            tintColor={null}
            defaultColor={null}
            icons={
              icons.map((title, i) => ({
                source: filterIcon(index, i), title, titleStyle: filterTitleStyle(index, i), size: filterSize(index, i), iconStyle: filterIconStyle(index, i),
              }))
            }
            onIndexChange={value => this.setState({ index: value })}
            lineStyle={{ marginTop: -2 }}
          />
        </View>
        <List style={styles.form}>
          <CreatedForm
            formRef={form => this.form = form}
            formData={formData}
            fields={fields}
            rules={rules}
            onValueChange={filterValue}
            onChange={this.handleChange}
            onSubmit={this.handleSubmit}
            onError={(validateResult) => {
              console.log(validateResult);
              Toast.show(validateResult.msg);
            }}
          />
        </List>
        <Button style={{ marginTop: 15 }} onPress={() => this.handleNext()}>
          <ImageBackground source={btnBack} style={[styles.btnBack, RowCenter]}>
            <Text style={styles.btnNextText}>下一步</Text>
          </ImageBackground>
        </Button>
        <Button type="link" style={[RowStart, { paddingHorizontal: 10, display: index === 0 ? 'none' : 'flex' }]} onPress={() => this.handlePrev()}>
          <Image source={btnPrev} style={{ width: 7, height: 12 }} />
          <Text style={{ marginLeft: 10, color: TextThirdColor, fontSize: 14 }}>返回上一步</Text>
        </Button>
        <ActionSheet
          ref={o => (this.ActionSheet = o)}
          options={selectOptions}
          cancelButtonIndex={selectOptions.length - 1}
          onPress={() => {}}
        />
      </View>
    );
  }
}

export default connect(state => ({
  activeShopInfo: state.userActive.activeShopInfo || {},
  shopInfo: state.userActive.shopInfo || {},
}), {
  takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
  fetchShopActiveInfo: () => ({ type: 'userActive/fetchShopActiveInfo' }), // 获取表单模版数据
  fetchAccountShopStatus: () => ({ type: 'userActive/fetchAccountShopStatus' }), // 获取表单数据
  submitShopActiveInfo: formData => ({ type: 'userActive/submitShopActiveInfo', payload: formData }),
  navPage: (routeName, params = {}) => ({ type: 'system/navPage', payload: { routeName, params } }),
  changeShopActiveForm: formData => ({ type: 'userActive/changeShopActiveForm', payload: formData }),
})(ActiveShopEdit);

const styles = StyleSheet.create({
  card: {
    backgroundColor: WhiteColor,
    borderRadius: 6,
    paddingVertical: 20,
    paddingHorizontal: 18,
    marginHorizontal: getWidth(10),
    marginTop: getWidth(10),
  },
  form: {
    backgroundColor: WhiteColor,
    borderRadius: 6,
    marginHorizontal: getWidth(10),
    marginTop: getWidth(10),
  },
  btnBack: {
    width: WindowWidth - getWidth(6),
    height: getWidth(58),
    paddingHorizontal: getWidth(7),
    paddingTop: getWidth(5),
    paddingBottom: getWidth(9),
  },
  btnNextText: {
    color: '#fff',
    fontSize: 17,
  },
});
