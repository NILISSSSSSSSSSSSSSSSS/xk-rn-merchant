export const JOIN_AUDIT_STATUS = {
  /** 入驻成功，已激活 */
  success: 'active',
  /** 入驻成功，已激活 */
  active: 'active',
  /** 待激活 */
  un_active: 'un_active',
  /** 审核失败 */
  audit_fail: 'audit_fail',
  /** 审核失败 */
  fail: 'audit_fail',
};

export const JOIN_AUDIT_STATUS_DESCRIBE = {
  active: {
    name: '已激活',
  },
  un_active: {
    name: '待激活',
  },
};
export const TIME_ITEMS = [ // 店铺营业时间
  {
    title: '星期一',
    key: 'mon',
  },
  {
    title: '星期二',
    key: 'tue',
  },
  {
    title: '星期三',
    key: 'wed',
  },
  {
    title: '星期四',
    key: 'thu',
  },
  {
    title: '星期五',
    key: 'fri',
  },
  {
    title: '星期六',
    key: 'sat',
  },
  {
    title: '星期日',
    key: 'sun',
  },
];


/** 入驻资料 */

// 性别
export const sex = {
  male: '男', // 男
  female: '女', // 女
  unknown: '保密',// 未知
};
// 公司类型
export const companyType = {
  online: '线上',
  offline: '线下',
};
// 商户性质
export const companyNature = {
  STATE_OWNED: '国有',
  COLLECTIVE: '集体',
  PRIVATELY_OPERATED: '民营',
  JOINT_VENTURE: '合资',
  SHAREHOLDING_SYSTEM: '股份制',
  PERSONAL: '个人',
  OTHER: '其他',
};
// 商户类别
export const companyCategory = {
  company: '公司',
  personal: '个人',
};
// 账号选择
export const accountCreationType = {
  create: '创建账号',
  bind: '绑定账号',
};
