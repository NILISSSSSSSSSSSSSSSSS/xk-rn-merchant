/** 手机号*/
export const phone = phone => /^(\+86)?1\d{10}$/.test(phone);
/** 密码*/
export const password = password => /^[a-zA-Z0-9]\w{5,19}$/.test(password);
/** 验证码*/
export const checkcode = checkcode => /^\d{3,7}$/.test(checkcode);
/** 身份证*/
export const ID = idCard =>/^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X|x)$/.test(idCard);
/** 邮箱*/
export const email = email =>/^[A-Za-z\d]+([-_.][A-Za-z\d]+)*@([A-Za-z\d]+[-.])+[A-Za-z\d]{2,4}$/.test(email);
/** 银行卡*/
export const card = card => /^([1-9]{1})(\d{11,18})$/.test(card);
export const card_public = card_public => /^([1-9]{1})(\d{0,18})$/.test(card_public);
/** 邮编*/
export const code = code => /^d{6}$/.test(code);
/** 昵称*/
export const nick = nick => /^[A-Za-z0-9_\-\u4e00-\u9fa5]+$/.test(nick);
/** 价格*/
export const price = price => /^[0-9]+([.]{1}[0-9]{1,2})?$/.test(price);
/** 输入价格 */
export const inputPrice = (price)=> {
    return /^[\d|\.]*$/gm.test(price);
}
/** 行号*/
export const bankNo = data => /[0-9](\d){11}/.test(data);

/** URL*/
export const url = url =>
    /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/.test(
        url
    );
/** 整数*/
export const intLarge = intLarge => /^\d+$/.test(intLarge);
/** 数字*/
export const number = data => /^[0-9]*$/.test(data);
/** 座机号*/
export const SeatNumber = intLarge => /0\d{2,3}-\d{5,8}/.test(intLarge);
/** 公司营业执照注册号*/
export const businessLicenseNum = d => /(^(?:(?![IOZSV])[\dA-Z]){2}\d{6}(?:(?![IOZSV])[\dA-Z]){10}$)|(^\d{15}$)/.test(d);
/** 验证m-n位的数字*/
// export const limitNumber = (number,m,n) => {
//     const reg_str = '/^\d{'+m+','+n+'}$/';
//     // console.log(/^\d{m,n}$/,(eval(reg_str)),(eval(reg_str)).test(number),/^\d{6,11}$/.test(number))
//     console.log(reg_str,new RegExp('/^\d{6,11}$/').test(number))

//     return new RegExp(reg_str).test(number)
//     // return /^\d{m,n}$/.test(number)
// };

export const formatDate = now => {
    var year = now.getFullYear();
    var month = now.getMonth() + 1;
    var date = now.getDate();
    var hour = now.getHours();
    var minute = now.getMinutes();
    var seconds = now.getSeconds();
    return ( year +  "-" + month + "-" + date + "  " + hour + ":" + minute + ":" + seconds );
}; //转换时间
