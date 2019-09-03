import dataMap from '../const/dataMap';
import * as Address from '../const/address';
import * as customPay from '../config/customPay';
import * as Regular from '../config/regular';

export const pay = (rule, res) => new Promise((resolve, reject) => {
  const payChannel = rule.channel.channelKey;
  if (payChannel.indexOf('alipay') !== -1) {
    customPay.alipay({ param: res.otherParams.next.channelPrams.aliPayStr, successCallBack: () => resolve(true), faildCallBack: () => { Toast.show('支付失败'); resolve(false); } });
  } else {
    customPay.wechatPay({
      param: res.otherParams.next.channelPrams,
      successCallBack: () => resolve(true),
      faildCallBack: () => {
        Toast.show('支付失败');
        console.log('支付失败');
        resolve(false);
      },
    });
  }
});

export const filterValue = (field, value, formData) => {
  switch (field) {
    case 'openBankCodeMap':
      formData.openBankCode = value.code;
      break;
    case 'bankCodeMap':
      formData.bankCode = value.code;
      // 银行编码重新选择后需要清空开户网点号
      formData.openBankCode = '';
      formData.openBankCodeMap = null;
      break;
    case 'registerDistrictCode':
      {
        const [registerProvinceCode, registerCityCode, registerDistrictCode] = Address.getCodesByDistrictCode(value);
        formData.registerProvinceCode = registerProvinceCode;
        formData.registerCityCode = registerCityCode;
        formData.registerDistrictCode = registerDistrictCode;
      }
      break;
    case 'districtCode':
      {
        const [provinceCode, cityCode, districtCode] = Address.getCodesByDistrictCode(value);
        formData.provinceCode = provinceCode;
        formData.cityCode = cityCode;
        formData.districtCode = districtCode;
      }
      break;
    default:
      break;
  }
};

export const filterField = (item) => {
  const isTextInputComponent = item.component === 'text' || item.component === 'input' || item.component === 'password';
  const isImageComponent = item.component === 'file' && item.media === 'picture';
  const newItem = {
    title: item.name,
    type: item.component,
    field: item.key,
    options: dataMap[item.key],
    placeholder: isTextInputComponent ? `请输入${item.name}` : '请选择',
    length: item.length, // 输入长度限制
  };

  if (isImageComponent) {
    newItem.type = 'image';
  }
  if (isTextInputComponent) {
    newItem.type = 'text';
    newItem.secureTextEntry = item.component === 'password';
  }

  if (['settleAccount', 'legalPersonCertificateNo'].includes(item.key)) {
    newItem.keyboardType = 'numeric';
  }

  if (['phone', 'settlePhone'].includes(item.key)) {
    newItem.keyboardType = 'phone-pad';
  }

  if (['capital'].includes(item.key)) {
    newItem.keyboardType = 'decimal-pad';
  }

  if (['email'].includes(item.key)) {
    newItem.keyboardType = 'email-address';
    newItem.tips = '邮箱不能多次提交使用；天府银行是用邮箱作为登录账号；必须唯一。';
  }

  if (['openBankCode', 'bankCode'].includes(item.key)) {
    newItem.type = 'code';
    newItem.field = `${item.key}Map`;
  }

  if (['registerProvinceCode', 'registerCityCode', 'registerDistrictCode'].includes(item.key)) {
    if (item.key !== 'registerDistrictCode') {return null;}
    newItem.type = 'address';
    newItem.title = '注册地址';
    newItem.field = 'registerDistrictCode';
  }

  if (['provinceCode', 'cityCode', 'districtCode'].includes(item.key)) {
    if (item.key !== 'districtCode') {return null;}
    newItem.type = 'address';
    newItem.title = '营业地址';
    newItem.field = 'districtCode';
  }

  if (item.relyKey && item.relyValue) {
    newItem.visible = ({ formData }) => formData[item.relyKey] === item.relyValue;
  }

  return newItem;
};

export const filterRules = (item) => {
  const rules = [];
  if (item.relyKey && item.relyValue) {
    item.required = true;
  }

  switch (item.component) {
    case 'text':
    case 'input':
    case 'password':
      if (item.length) {rules.push({ field: item.key, max: item.length, msg: `输入的内容超过${item.length}字数` });}
      if (item.required) {rules.push({ field: item.key, required: true, msg: `请输入${item.name}` });}
      break;
    default:
      if (item.required) {rules.push({ field: item.key, required: true, msg: `请选择${item.name}` });}
      break;
  }

  if (['email'].includes(item.key)) {
    // 校验邮件
    rules.push({ field: item.key, custom: (rule, formData) => Regular.email(formData[rule.field]), msg: `${item.name}格式输入错误，请输入正确的邮箱` });
  }

  if (['legalPersonCertificateNo'].includes(item.key)) {
    rules.push({ field: item.key, custom: (rule, formData) => Regular.ID(formData[rule.field]), msg: `${item.name}格式输入错误，请输入正确的18位身份证号码` });
  }

  if (['phone', 'settlePhone'].includes(item.key)) {
    rules.push({ field: item.key, custom: (rule, formData) => Regular.phone(formData[rule.field]), msg: `${item.name}格式输入错误，请输入正确11位电话号码` });
  }

  if (['capital'].includes(item.key)) {
    rules.push({ field: item.key, custom: (rule, formData) => Regular.number(formData[rule.field]), msg: `${item.name}格式输入错误，请输入正确整数数值` });
  }

  if (['password'].includes(item.key)) {
    rules.push({ field: item.key, custom: (rule, formData) => Regular.number(formData[rule.field]), msg: `${item.name}格式输入错误，请输入正确的密码` });
  }

  if (['settleAccount'].includes(item.key)) {
    rules.push({ field: item.key, custom: (rule, formData) => Regular.card_public(formData[rule.field]), msg: `${item.name}格式输入错误，请输入正确的银行卡号` });
  }

  // 根据不同key判断加入其它规则
  return rules;
};
