type DiscountType1 = "discount" | "discountAmount"

export const DiscountType = {
  discount: "discount",
  discountAmount: "discountAmount"
}

/**
 * 判断字符串是否是数值
 * @param text 传递需要判断的字符串
 */
export function isNumber (text?: any) : boolean
/**
 * 转换字符串为数值
 * @param text 传递需要判断的字符串
 * @param defaultValue 数值默认值
 */
export function toNumber (text?: any, defaultValue?: any) : number

/**
 * 计算折扣
 * @param realPrice 真实价格
 * @param originPrice 原始价格
 */
export function discount (realPrice: number, originPrice: number): number 
/**
 * 计算优惠金额
 * @param realPrice 真实价格
 * @param originPrice 原始价格
 */
export function discountAmount(realPrice: number, originPrice: number): number
/**
 * 计算真实价格
 * @param originPrice 原始价格
 * @param discountType 优惠类型 - 折扣/优惠金额
 * @param count 优惠数值
 */
export function realPrice(originPrice: number, discountType: DiscountType1, count: number): number

/**
 * 四舍五入保留2位小数（若第二位小数为0，则保留一位小数）
 * @param num 数值
 */
export function keepTwoDecimal(num:number|string): number

 /**
 * 四舍五入保留2位小数（若第二位小数为0，则保留一位小数）
 * @param num 数值
 */
export function keepTwoDecimalFull(num:number|string): string
/**
 * 是否含有小数点，且小数点后面有2位或者2位以下
 * @param num 数值
 */
export function hasTwoDot(num: string): boolean