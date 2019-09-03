export const TASK_TYPES_DESPCRIPTION = [
  {
    name: '主播',
    merchantType: 'anchor',
  },
  {
    name: '家族长',
    merchantType: 'familyL1',
  },
  {
    name: '公会',
    merchantType: 'familyL2',
  },
  {
    name: '商户',
    merchantType: 'shops',
  },
  {
    name: '合伙人',
    merchantType: 'company',
  },
  {
    name: '个人/团队/公司',
    merchantType: 'personal',
  },
];

export const MERCHANT_TYPE_MAP_NAME = {
  anchor: '主播',
  familyL1: '家族长',
  familyL2: '公会',
  shops: '商户',
  company: '合伙人',
  personal: '个人/团队/公司',
};


export const TASK_CATEGORIES_DESPCRIPTION = [
  {
    name: '培训任务',
    type: 'TrainTask',
    key: 'unFinishJob',
  },
  {
    name: '审核任务',
    type: 'AuditTask',
    key: 'unAuditJob',
  },
];

export const TASK_CATEGORIES = {
  AuditTask: 'AuditTask',
  TrainTask: 'TrainTask',
};

export const TASK_MERCHANT_JOB_STATUS = [
  {
    name: '待完成',
    processStatus: 'un_do',
    key: 0,
    taskcore: 'taskcore',
    statisticsKey: 'unDo',
  },
  {
    name: '待验收',
    checkStatus: 'un_check',
    key: 1,
    taskcore: 'acceptancecore',
    statisticsKey: 'unCheck',
  },
  {
    name: '验收未通过',
    checkStatus: 'check_fail',
    key: 2,
    taskcore: 'taskcore',
    statisticsKey: 'checkFail',
  },
  {
    name: '审核中',
    processStatus: 'did',
    key: 3,
    taskcore: 'auditcore',
    statisticsKey: 'auditing',
  },
  {
    name: '审核未通过',
    processStatus: 're_do',
    key: 4,
    taskcore: 'auditcore',
    statisticsKey: 'auditFail',
  },
  {
    name: '审核通过',
    sysAuditStatus: 'sys_audit_success',
    key: 5,
    taskcore: 'auditcore',
    statisticsKey: 'auditSuccess',
  },
];

export const TASK_MERCHANT_AUDIT_STATUS = [
  {
    name: '待审核',
    auditStatus: 'un_audit',
    key: 0,
    taskcore: 'auditcore',
    statisticsKey: 'unAudit',
  },
  {
    name: '审核未通过',
    auditStatus: 'audit_fail',
    key: 1,
    taskcore: 'auditcore',
    statisticsKey: 'auditFail',
  },
  {
    name: '审核通过',
    auditStatus: 'audit_success',
    key: 2,
    taskcore: 'auditcore',
    statisticsKey: 'auditSuccess',
  },
];
