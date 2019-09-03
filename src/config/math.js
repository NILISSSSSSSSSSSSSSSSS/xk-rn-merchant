import * as math from 'mathjs';

// 配置精度
math.config({
  number: 'BigNumber',
  precision: 64,
});

/**
 * @param  add      加法
 * @param  multip   乘法
 * @param  sub      减法
 * @param  divide   除法
 */
export default {
  add() {
    try {
      let result = 0;
      for (let i = 0, len = arguments.length; i < len; i++) {
        const p = arguments[i] ? arguments[i] : 0;
        result = math.format(math.parser().eval(`${result}+${p}`));
      }
      return math.number(result);
    } catch (error) {
      return '';
    }
  },
  multiply() {
    try {
      let result = 1;
      for (let i = 0, len = arguments.length; i < len; i++) {
        const p = arguments[i] ? arguments[i] : 0;
        result = math.format(math.parser().eval(`${result}*${p}`));
      }
      return math.number(result);
    } catch (error) {
      return '';
    }
  },
  subtract() {
    let result = arguments[0];
    for (let i = 0, len = arguments.length; i < len - 1; i++) {
      const p = arguments[i + 1] !== '' || arguments[i + 1] !== void 0 || arguments[i + 1] != null ? arguments[i + 1] : 0;
      result = math.format(math.parser().eval(`${result}-${p}`));
    }
    return math.number(result);
  },
  divide() {
    try {
      let result = arguments[0];
      if (result === '' || result === undefined || result == 0 || result == null) return 0;
      for (let i = 0, len = arguments.length; i < len - 1; i++) {
        if (arguments[i + 1] == 0) {
          console.log('被除数不能为0！');
          return '';
        }
        result = math.format(math.parser().eval(`${result}/${arguments[i + 1]}`));
      }
      return math.number(result);
    } catch (error) {
      return '';
    }
  },
};

// math.divide(200,100)
