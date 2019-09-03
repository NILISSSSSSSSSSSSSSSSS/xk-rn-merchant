import math from '../config/math';

export const DiscountType = {
  discount: 'discount',
  discountAmount: 'discountAmount',
};

// 判断是否是数值
export const isNumber = (text)=> {
  return !(isNaN(text)) && text !== '';
};

// 转换数值
export const toNumber = (text, defaultValue = 0) => {
  return isNumber(text) ? Number(text) : defaultValue;
};

// 计算折扣
export const discount = (realPrice, originPrice) => realPrice <= 0 ? 0 : realPrice >= originPrice ? 10 : math.divide(realPrice, originPrice, 0.1);
// 计算优惠金额
export const discountAmount = (realPrice, originPrice) => realPrice <= 0 ? 0 : realPrice >= originPrice ? 0 : math.subtract(originPrice, realPrice);
// 计算真实价格
export const realPrice = (originPrice, discountType = DiscountType.discount, _discount = 0)=> {
  switch (discountType) {
    case DiscountType.discount: return originPrice > 0 ? math.multiply(originPrice, _discount, 0.1)  : 0;
    case DiscountType.discountAmount: return originPrice > _discount ? math.subtract(originPrice, _discount) : 0;
    default:
      return 0;
  }
};

// 四舍五入保留2位小数（若第二位小数为0，则保留一位小数）
export function keepTwoDecimal(num) {
  let result = parseFloat(num);
  if (isNaN(result)) {
    console.log('传递参数错误，请检查！');
    return false;
  }
  result = Math.round(num * 100) / 100;
  return result;
}

// 四舍五入保留2位小数（不够位数，则用0替补）
export function keepTwoDecimalFull(num) {
  let result = parseFloat(num);
  if (isNaN(result)) {
    console.log('传递参数错误，请检查！');
    return false;
  }
  result = Math.round(num * 100) / 100;
  let s_x = result.toString();
  let pos_decimal = s_x.indexOf('.');
  if (pos_decimal < 0) {
    pos_decimal = s_x.length;
    s_x += '.';
  }
  while (s_x.length <= pos_decimal + 2) {
    s_x += '0';
  }
  return s_x;
}

export const hasTwoDot = (text)=> text && String(text).indexOf('.') !== -1 && String(text).length - String(text).indexOf('.') <= 3;
