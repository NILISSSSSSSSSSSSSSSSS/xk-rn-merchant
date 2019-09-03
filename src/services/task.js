import { MERCHANT_TYPE_MAP_NAME } from '../const/task';

export const filterLog = (item) => {
  item.fromMerchantTypeName = !item.fromMerchantType ? '' : MERCHANT_TYPE_MAP_NAME[item.fromMerchantType];
  item.toMerchantTypeName = !item.toMerchantType ? '' : MERCHANT_TYPE_MAP_NAME[item.toMerchantType];

  item.fromRoleName = item.fromIsMaster === 1 ? item.fromMerchantType === null ? '管理员' : (item.fromMerchantTypeName || '') : '分号';
  item.toRoleName = item.toIsMaster === 1 ? item.toMerchantType === null ? '管理员' : (item.toMerchantTypeName || '') : '分号';

  item.fromMerchantName = (item.fromRoleName ? `（${item.fromRoleName}）` : '') + item.fromUserName;
  item.toMerchantName = (item.toRoleName ? `（${item.toRoleName}）` : '') + item.toUserName;

  switch (item.event) {
    case 'init':
      return '系统生成任务';
    case 'did':
      return `任务由${item.fromMerchantName}完成，待${item.toMerchantName}验收`;
    case 'job_delegate':
      return `任务由${item.fromMerchantName}指派给${item.toMerchantName},待${item.toMerchantName}完成`;
    case 'check_delegate':
      return `任务验收由${item.fromMerchantName}指派给${item.toMerchantName}，待${item.toMerchantName}验收`;
    case 'check_success':
      if (item.toUserName) {
        return `任务由${item.fromMerchantName}验收通过，待${item.toMerchantName}审核`;
      }
      return `任务由${item.fromMerchantName}验收通过`;
    case 'check_fail':
      return `任务由${item.fromMerchantName}验收不通过，需重新提交`;
    case 'audit_delegate':
      return `任务审核由${item.fromMerchantName}指派给${item.toMerchantName}，待${item.toMerchantName}审核`;
    case 'audit_success':
      if (item.toUserName) {
        return `任务由${item.fromMerchantName}审核通过，待${item.toMerchantName}验收`;
      }
      return `任务由${item.fromMerchantName}审核通过`;

    case 'audit_fail':
      return `任务由${item.fromMerchantName}审核不通过，需重新提交`;
  }
  return '';
};

export const filterNameByStatus = (item) => {
  const { auditStatus, canProcess, canAudit, processStatus } = item;
  if (canProcess === 1 && (processStatus === 're_do' || processStatus === 'un_do')) {
    //  完成状态
    switch (processStatus) {
      case 'un_do':
        return '未完成';
      case 're_do':
        return '待重做';
    }
  }
  if (canAudit === 1 && auditStatus === 'un_audit') {
    // 审核状态
    return '未审核';
  }
  switch (auditStatus) {
    case 'un_audit':
      return '未审核';
    case 'audit_fail':
      return '审核失败';
    case 'audit_success':
      return '审核成功';
  }
  switch (processStatus) {
    case 'un_do':
      return '未完成';
    case 're_do':
      return '待重做';
    case 'did':
      return '已完成';
  }
  // if(processStatus == 'did'){
  //     return '已完成'
  // }
}
