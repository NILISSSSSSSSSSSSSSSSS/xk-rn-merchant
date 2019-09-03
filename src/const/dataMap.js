export default {
  accountType: [{ title: '对公账户', value: 'PRIVATE' }, { title: '对私账户', value: 'PUBLIC' }],
  merchantType: [{ title: '线上', value: 'ON_LINE' }, { title: '线下', value: 'UNDER_LINE' }],
  merchantNature: [
    { title: '国有', value: 'STATE_OWNED' },
    { title: '集体', value: 'COLLECTIVE' },
    { title: '民营', value: 'PRIVATELY_OPERATED' },
    { title: '合资', value: 'JOINT_VENTURE' },
    { title: '股份制', value: 'SHAREHOLDING_SYSTEM' },
    { title: '个人', value: 'PERSONAL' },
    { title: '其他', value: 'OTHER' },
  ],
  merchantCategory: [
    { title: '公司', value: 'company' },
    { title: '个人', value: 'personal' },
  ],
  channel: [
    { title: '天府银行', value: 'tfb' },
    { title: '银联', value: 'union_pay' },
  ],
  group: [
    { title: '结算账户信息', value: 'account' },
    { title: '公司信息', value: 'company' },
    { title: '法人信息', value: 'legal_person' },
  ],
  settleCycle: [
    { title: 'T_1 （次工作日）', value: 'T_1' },
    { title: 'D_1 （当日+1）', value: 'D_1' },
  ],
  netBizName: [
    { title: '备案号', value: 'RECORD_NO' },
    { title: '证书号', value: 'CERT_NO' },
  ],
};
