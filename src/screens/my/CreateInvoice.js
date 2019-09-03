/**
 * 新建发票
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  
  View,
  Text,
  Button,
  Image,
  ScrollView,
  TextInput,
  TouchableOpacity,
} from 'react-native';

import moment from 'moment';
import { connect } from 'rn-dva';
import Switch from '../../components/Switch';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import Content from '../../components/ContentItem';
import FlatListView from '../../components/FlatListView';
import ModalDemo from '../../components/Model';
import * as requestApi from '../../config/requestApi';
import { changeData } from '../../action/invoiceAction';
import CommonButton from '../../components/CommonButton';
import { NavigationComponent } from '../../common/NavigationComponent';


const { width, height } = Dimensions.get('window');
function getwidth(val) {
  return width * val / 375;
}

const FormTitle = ({ title, required }) => (
  <React.Fragment>
    <View style={styles.xingBox}>
      <Text style={styles.xing}>{required ? '*' : ''}</Text>
    </View>
    <Text style={styles.titleTxt}>{title}</Text>
  </React.Fragment>
);

const TextInputFormItem = ({
  maxLength, placeholder, value, onBlur, onChangeText,
}) => (
  <TextInput
    placeholder={placeholder}
    onBlur={() => onBlur && onBlur()}
    style={styles.textinput}
    placeholderTextColor="#ccc"
    maxLength={maxLength}
    onChangeText={val => onChangeText && onChangeText(val)}
    value={value}
    returnKeyLabel="确定"
    returnKeyType="done"
  />
);

class CreateInvoice extends NavigationComponent {
  constructor(props) {
    super(props);
    const params = this.props.navigation.state.params;
    if (params) {
      const param = params.data;
      const invoiceType = param.type;
      if (invoiceType === 'PERSONAL') {
        this.state = {
          choosedata: 1,
          gerenDefault: param.isDefault === 1 ? true : false,
          invoiceTitle: param.head,
          alertVisible: false,
        };
      } else {
        this.state = {
          choosedata: 2,
          qiyeInvoiceTitle: param.head,
          taxNum: param.taxNo,
          qiYeAdress: param.address,
          qiYePhone: param.phone,
          bankName: param.bankName,
          bankNum: param.bankAccount,
          alertVisible: false,
          riyeDeafult: param.isDefault === 1 ? true : false,
        };
      }
    } else {
      this.state = {
        choosedata: 1, // 个人  2 企业
        gerenDefault: true,
        invoiceTitle: '', // 发票抬头
        qiyeInvoiceTitle: '', // 企业发票抬头
        taxNum: '', // 企业税号
        qiYeAdress: '', // 企业地址
        qiYePhone: '', // 电话号码
        bankNum: '', // 银行账号
        bankName: '', // 开户银行
        riyeDeafult: true,
        alertVisible: false,
      };
    }
  }


    blurState = {
      alertVisible: false,
    }

    changeChooseState = (val) => {
      this.setState({
        choosedata: val,
      });
    }

    changeinvoiceTitle = (val, index) => {
      let name = 'invoiceTitle';
      if (index === 2) {
        name = 'qiyeInvoiceTitle';
      }
      this.setState({
        [name]: val,
      });
    }

    changeState = (val, name) => {
      this.setState({
        [name]: val,
      });
    }

    checkedAllDate = () => {
      const { choosedata } = this.state;
      if (choosedata === 1) {
        return this.yanzheng('invoiceTitle');
      }
      if (!this.yanzheng('qiyeInvoiceTitle')) {
        if (!this.yanzheng('taxNum')) {
          if (!this.yanzheng('qiYeAdress')) {
            if (!this.yanzheng('qiYePhone')) {
              if (!this.yanzheng('bankNum')) {
                if (!this.yanzheng('bankName')) {
                  return false;
                }
              }
            }
          }
        }
      }
      return true;
    }

    yanzheng = (name) => {
      const val = this.state[name];
      switch (name) {
        case 'invoiceTitle':
          if (val === '') {
            Toast.show('发票抬头必填');
            return true;
          }
          if (val.length < 2 || val.length > 30) {
            Toast.show('发票抬头字数应该在2-30之间');
            return true;
          }
          break;
        case 'qiyeInvoiceTitle':
          if (val === '') {
            Toast.show('发票抬头必填');
            return true;
          }
          if (val.length < 10 || val.length > 30) {
            Toast.show('发票抬头字数应该在10-30之间');
            return true;
          }
          break;
        case 'taxNum':
          if (val === '') {
            Toast.show('企业税号必填');
            return true;
          }
          if (val.length < 15 || val.length > 20) {
            Toast.show('企业税号字数应该在15-20之间');
            return true;
          }
          break;
        case 'qiYeAdress':
          if (val && val.length > 100) {
            Toast.show('企业税号字数应该在100以内');
            return true;
          }
          break;
        case 'qiYePhone':
          if (val && val.length > 11) {
            Toast.show('电话号码不得超过11个数字');
            return true;
          }
          break;
        case 'bankName':
          if (val && val.length > 40) {
            Toast.show('开户银行不得超过40个字');
            return true;
          }
          break;
        case 'bankNum':
          if (val && val.length > 19) {
            Toast.show('银行账号不得超过19个数字');
            return true;
          }
          break;
      }
      return false;
    }

    renderComponent = () => {
      const {
        choosedata, invoiceTitle, qiyeInvoiceTitle, taxNum, qiYeAdress, qiYePhone, bankNum, bankName, gerenDefault, riyeDeafult,
      } = this.state;
      if (choosedata === 1) {
        return (
          <View>
            <View style={styles.listItem}>
              <FormTitle title="发票抬头" required />
              <TextInputFormItem placeholder="请输入" onBlur={() => this.yanzheng('invoiceTitle')} maxLength={30} onChangeText={val => this.changeinvoiceTitle(val, 1)} value={invoiceTitle} />
            </View>
            <View style={styles.listItem}>
              <FormTitle title="默认发票" required />
              <View style={styles.mr10}>
                <Switch value={gerenDefault} onChangeState={val => this.changeState(val, 'gerenDefault')} />
              </View>
            </View>
          </View>
        );
      }
      return (
        <View>
          <View style={styles.listItem}>
            <FormTitle title="发票抬头" required />
            <TextInputFormItem
                placeholder="请输入企业全称"
                onBlur={() => this.yanzheng('qiyeInvoiceTitle')}
                maxLength={30}
                onChangeText={val => this.changeinvoiceTitle(val, 2)}
                value={qiyeInvoiceTitle}
            />
          </View>
          <View style={styles.listItem}>
            <FormTitle title="企业税号" required />
            <TextInputFormItem maxLength={20} placeholder="请输入企业税号" onBlur={() => this.yanzheng('taxNum')} onChangeText={val => this.changeState(val, 'taxNum')} value={taxNum} />
          </View>
          <View style={styles.listItem}>
            <FormTitle title="企业地址" required={false} />
            <TextInputFormItem placeholder="请输入企业注册地址" maxLength={100} onBlur={() => this.yanzheng('qiYeAdress')} onChangeText={val => this.changeState(val, 'qiYeAdress')} value={qiYeAdress} />
          </View>
          <View style={styles.listItem}>
            <FormTitle title="电话号码" required={false} />
            <TextInputFormItem placeholder="请输入企业电话号码" maxLength={11} onBlur={() => this.yanzheng('qiYePhone')} onChangeText={val => this.changeState(val, 'qiYePhone')} value={qiYePhone} />
          </View>
          <View style={styles.listItem}>
            <FormTitle title="开户银行" required={false} />
            <TextInputFormItem placeholder="请输入企业开户银行" maxLength={40} onBlur={() => this.yanzheng('bankName')} onChangeText={val => this.changeState(val, 'bankName')} value={bankName} />
          </View>
          <View style={styles.listItem}>
            <FormTitle title="银行账号" required={false} />
            <TextInputFormItem placeholder="请输入企业银行账号" maxLength={19} onBlur={() => this.yanzheng('bankNum')} onChangeText={val => this.changeState(val, 'bankNum')} value={bankNum} />
          </View>
          <View style={styles.listItem}>
            <FormTitle title="默认发票" required />
            <View style={styles.mr10}>
              <Switch value={riyeDeafult} onChangeState={val => this.changeState(val, 'riyeDeafult')} />
            </View>
          </View>
        </View>
      );
    }

    saveData = () => {
      const res = this.checkedAllDate();
      if (res) {
        return;
      }
      const param = {};
      const { choosedata } = this.state;
      if (choosedata === 1) {
        // 个人
        const { invoiceTitle, gerenDefault } = this.state;
        param.invoiceType = 'PERSONAL';
        param.head = invoiceTitle;
        param.isDefault = gerenDefault === true ? 1 : 0;
      } else {
        const {
          qiyeInvoiceTitle, taxNum, qiYeAdress, qiYePhone, bankName, bankNum, riyeDeafult,
        } = this.state;
        param.invoiceType = 'ENTERPRISE';
        param.head = qiyeInvoiceTitle;
        param.taxNo = taxNum;
        param.address = qiYeAdress;
        param.phone = qiYePhone;
        param.bankName = bankName;
        param.bankAccount = bankNum;
        param.isDefault = riyeDeafult === true ? 1 : 0;
      }
      const editorData = this.props.navigation.state.params;
      const callback = this.props.navigation.getParam('callback');
      if (editorData) {
        const item = editorData.data.id;
        param.id = item;
        requestApi.merchantInvoiceUpdate(param).then(() => {
          Toast.show('修改成功');
          this.props.navigation.goBack();
        }).catch((res) => {
          Toast.show(res.message);
        });
      } else {
        requestApi.merchantInvoiceCreate(param).then(() => {
          Toast.show('创建成功');
          this.props.navigation.goBack();
        }).catch((res) => {
          Toast.show(res.message);
        });
      }
    }

    delete = () => {
      const id = this.props.navigation.state.params.data.id;
      this.setState({
        alertVisible: false,
      });
      Loading.show();
      requestApi.merchantInvoiceDelete({ id }).then(() => {
        Toast.show('删除成功');
        
        requestApi.merchantInvoiceQPage({ page: 1, limit: 10 }).then((res) => {
          if (res) {
            this.props.dispatch(changeData(res.data));
          } else {
            this.props.dispatch(changeData([]));
          }
          this.props.navigation.goBack();
        }).catch(err => {
          console.log(err)
        });
      }).catch((res) => {
        Toast.show(res.message);
      });
    }

    render() {
      const { navigation } = this.props;
      const { choosedata, alertVisible } = this.state;
      let gerenstyle = styles.dataBox;
      let gerenTextColor = styles.textColor;
      let qiye = styles.dataBox;
      let qiyeTextColor = styles.textColor;
      if (choosedata === 1) {
        gerenstyle = styles.chooseDataBox;
        gerenTextColor = styles.choosetextColor;
      }
      if (choosedata === 2) {
        qiye = styles.chooseDataBox;
        qiyeTextColor = styles.choosetextColor;
      }
      let rightView = null;
      if (this.props.navigation.state.params) {
        rightView = (
          <TouchableOpacity
                    onPress={() => {
                      this.setState({
                        alertVisible: true,
                      });
                    }}
          >
            <Text style={{
              fontSize: 17,
              color: '#fff',
              marginRight: 10,
            }}
            >
删除

            </Text>
          </TouchableOpacity>
        );
      }
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="发票信息管理"
            rightView={
                rightView
            }
          />
          <ModalDemo
            title="确定删除?"
            visible={alertVisible}
            onConfirm={this.delete}
            onClose={() => { this.setState({ alertVisible: false }); }}
            type="confirm"
          />
          <ScrollView style={styles.mainview}>
            <Content style={styles.content}>
              <View style={styles.listItem}>
                <FormTitle title="发票类型" required />
                <TouchableOpacity
                    onPress={
                        () => this.changeChooseState(1)
                    }
                    style={gerenstyle}
                >
                  <Text style={gerenTextColor}>个人</Text>
                </TouchableOpacity>
                <TouchableOpacity
                    onPress={
                        () => this.changeChooseState(2)
                    }
                    style={qiye}
                >
                  <Text style={qiyeTextColor}>企业</Text>
                </TouchableOpacity>
              </View>
              {
                this.renderComponent()
              }
            </Content>
            <View style={styles.contentText}>
              <View><Text style={styles.tishiInfo}>温馨提示</Text></View>
              <View style={{ marginTop: 3 }}>
                <Text style={styles.tishiInfo}>1、选择抬头类型：企业/个人，企业抬头必须要填写合法的企业税号</Text>
                <Text style={styles.tishiInfo}>2、勾选是否默认抬头，下单申请发票时，会自动使用默认抬头</Text>
              </View>
            </View>
            <CommonButton title="保存并使用" onPress={this.saveData} style={{ width: getwidth(355), marginTop: 11 }} />
          </ScrollView>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  mainview: {
    // marginTop: 10
  },
  content: {
    width: getwidth(355),
    overflow: 'hidden',
  },
  listItem: {
    width: getwidth(355),
    height: 46,
    backgroundColor: '#fff',
    paddingHorizontal: 15,
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 13,
    borderBottomColor: '#F1F1F1',
    borderBottomWidth: 1,
  },
  contentText: {
    width: getwidth(355),
    height: 94,
    marginTop: 13,
    paddingHorizontal: 15,
  },
  titleTxt: {
    color: '#222222',
    fontSize: 14,
    marginLeft: 4,
  },
  xing: {
    color: '#EE6161',
    fontSize: 17,
  },
  xingBox: {
    height: 46,
    width: 8,
    justifyContent: 'center',
  },
  chooseDataBox: {
    width: getwidth(70),
    height: 22,
    borderColor: '#4A90FA',
    borderRadius: 14,
    borderWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: 10,
  },
  dataBox: {
    width: getwidth(70),
    height: 22,
    borderColor: '#E5E5E5',
    borderRadius: 14,
    borderWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: 14,
  },
  choosetextColor: {
    color: '#4A90FA',
  },
  textColor: {
    color: '#777777',
  },
  mr10: {
    position: 'absolute',
    right: 15,
  },
  textinput: {
    flex: 1,
    height: 46,
    color: '#222',
    fontSize: 14,
    marginLeft: 12,
  },
  tishiInfo: {
    color: '#777777',
    fontSize: 12,
    lineHeight: 18,
  },
});

export default connect(
  state => ({ data: state.invoiceReducer.data }),
)(CreateInvoice);
