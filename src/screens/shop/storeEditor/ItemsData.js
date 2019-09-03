import CommonStyles from '../../../common/Styles';
import math from '../../../config/math.js';
const logoView ={
  alignItems: 'flex-start',
  flexWrap: 'wrap',
  paddingLeft: 0,
  paddingRight: 0,
  paddingBottom: 10,
  marginTop: 0,
}
export const items=(shops,currentShop,state)=>{
  const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
  const topItems = [
    {
      title: '店铺地址', key: 'address', type: 'horizontal', value:detail.address,
    },
    {
      title: '店铺分类', key: 'industryName', type: 'horizontal', value: detail.industryName,
    },
    {
      title: '店铺名称', key: 'name', maxLength: 20, placeholder: '请输入店铺名字', type: 'input', value: detail.name,
    },
    { title: '优惠方式', key: 'discountType', style: logoView, leftStyle: { paddingLeft: 15 }},
    { title: '宣传语', key: 'xuanchuanyu' },
    {
      title: '联系电话', key: 'contactPhones', style: { alignItems: 'flex-start' },
    },
    {
      title: '营业时间', key: 'newBusinessTime', type: 'horizontal', value: detail.newBusinessTime && detail.newBusinessTime.startAt && detail.newBusinessTime.endAt ?(detail.newBusinessTime.startAt+'-'+detail.newBusinessTime.endAt):''
    },
    { title: '人均消费', key: 'avgConsumption', type:'input',unit:'元',value:state.avgConsumption, placeholder:'请输入金额' },
    {
      title: '当前店铺状态', key: 'onLine', type: 'radio', items: [{ title: '上线', value: 1 }, { title: '下线', value: 0 }],
    },
    {
      title: '当前是否接单', key: 'isBusiness', type: 'radio', items: [{ title: '接单中', value: 1 }, { title: '不接单', value: 0 }],
    },
    {
      title: '是否自动接单', key: 'automatic', type: 'radio', items: [{ title: '是', value: 1 }, { title: '否', value: 0 }],
    },
  ];
  !detail.id && shops.length>0?
  topItems.splice(1, 0,
      {
        title: '店铺类型', key:'shopType',type: 'horizontal', value: detail.shopType == 'SHOP_IN_SHOP' ? '店中店' : detail.shopType == 'BRANCH' ? '分店' : '',
      })
    : null;
  currentShop.shopType == 'SHOP_IN_SHOP' && detail.id ? topItems.unshift({
    title: '上级店铺', key: 'masterMShopName', value: currentShop.masterMShopName || '暂无',
  }) : null;
  const items = [
    topItems,
    [
      {
        title: '顶部滚动图片', key: 'rollingPics', style: logoView, leftStyle: { paddingLeft: 15 },
      },
    ],
    [
      {
        title: '店铺logo', key: 'logo', style:logoView, leftStyle: { paddingLeft: 15 },
      },
    ],
    [
      {
        title: '相关资质', key: 'qualifiedPictures', style: logoView, leftStyle: { paddingLeft: 15 },
      },
    ],
    [
      { title: '接单范围', key: 'range' },
      {
        title: '店铺介绍', key: 'description', style: { alignItems: 'flex-start', flexWrap: 'wrap' },
      },
      {
        title: '展示图片', key: 'pictures', style: logoView, leftStyle: { paddingLeft: 15 },
      },
    ],
  ];
  if (detail.id) {
    items.unshift([
      { title: '店铺编号', key: 'code', value: detail.code },
      // {
      //   title: '推荐码', key: 'mrCode', value: currentShop.mrCode, rightTextStyle: { color: CommonStyles.globalHeaderColor },
      // },
    ]) ;
  }
  return items
}
export const detailItems=(currentShop,navigation)=>{
  const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
  const items = [
    [
        { title: "店铺编号", value: detail.code },
    ],
    [
        {
            title: "上级店铺",
            value: currentShop.masterMShopName,
            visible:
                currentShop.shopType == "SHOP_IN_SHOP" ||
                navigation.state.routeName == "StoreXiajiDetail"
        },
        {
            title: "与本店关系",
            value:
                currentShop.shopType == "SHOP_IN_SHOP"
                    ? "店中店"
                    : currentShop.shopType == "MASTER"
                        ? "本店"
                        : "分店"
        },
        { title: "店铺地址", value: detail.address },
        { title: "店铺分类", value: detail.industryName },
        { title: "店铺名称", value: detail.name },
        { title: "优惠方式", value: detail.discountType=='SHOP_DISCOUNT'?`店铺折扣(${detail.discount}折)`:'会员优惠' },
        {
            title: "宣传语",
            value:`每单均减${math.divide(detail.minMoney || 0,100)}元-${math.divide (detail.maxMoney || 0, 100)}元`
        },
        {
            title: "联系电话",
            value:
                `${(detail.contactPhones && detail.contactPhones[0]) ||
                ""}` +
                "  " +
                ((detail.fixedPhone &&
                    detail.fixedPhone.split("-")[1] && detail.fixedPhone.split("-")[1] != "undefined"
                    ? detail.fixedPhone.split("-")[0] && detail.fixedPhone.split("-")[0] != "undefined"
                        ? `${detail.fixedPhone.split("-")[0] + "-" + detail.fixedPhone.split("-")[1]}` : detail.fixedPhone.split("-")[1]
                    : ''))
        },
        { title: "营业时间", value: detail.newBusinessTime && detail.newBusinessTime.startAt && detail.newBusinessTime.endAt ?(detail.newBusinessTime.startAt+'-'+detail.newBusinessTime.endAt):'' },
        {
            title: "人均消费",
            value:
                detail.avgConsumption == null
                    ? "￥"
                    : "￥" + math.divide(detail.avgConsumption || 0,100),
            color: "#EE6161"
        },
        {
            title: "当前店铺状态",
            value:detail.secondAuthStatus == "SUBMIT"?'审核中':detail.firstAuthStatus == "FAILED" ||detail.secondAuthStatus == "FAILED"?'审核不通过':'审核成功',
            color: "#4A90FA"
        }, //提交认证SUBMIT，SUCCESS认证成功，认证失败FAILED
        {
            title: "当前是否接单",
            value: detail.isBusiness == 1 ? "接单" : "不接单"
        },
        {
            title: "是否自动接单",
            value: detail.automatic == 1 ? "是" : "否"
        }
    ],
    [
      {title: "顶部滚动图片"},
      {value:detail.rollingPics?detail.rollingPics:[]}
    ],
    [
        {title: "店铺logo"},
        {value:detail.logo?[detail.logo]:[]}
    ],
    [
        {title: "相关资质"},
        {value:detail.qualifiedPictures || []}

    ],
    [
        {
            title: "接单范围",
            value: `店铺地址为中心周围 ${detail.range ? detail.range : 0}km`
        },
        { title: "店铺介绍", value: detail.description },
        { title: "展示图片", value: detail.pictures }
    ]
];
return items
}