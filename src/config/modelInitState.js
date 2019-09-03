
export default {
  shop: { // 商铺
    storeManagePage: 'manager',
    serviceCatalogList: [],
    longLists: {},
    goodsList: [],
    initList: {
      refreshing: false,
      loading: false,
      listsPage: 1,
      listsTotal: 0,
      hasMore: false,
      lists: [],
      isFirstLoad: true,
    },
    goodsDetail: {},
    juniorShops: [],
    roleList: [],
    roleManagerShopList: [],
    bannerLists: [],
    // 财务中心列表
    financialList: {
      params: {
          page: 1,
          limit: 10,
          hasMore: true,
          total: 0,
          refreshing: false,
      },
      data: [],
    },
    settleMoneySum: 0, // 累计结算
  },
  user: { // 用户
    user: {},// 用户登录信息
    firstMerchant: {}, // 第一个入驻身份
    canUpgrade: false, // 家族长是否可以升级
    userShop: {}, // 选择登录的店铺信息
    userRole: [], // 根据用户选择的店铺的权限
    userFinanceInfo: {},
    merchantData: {}, // 商户基本信息
    userRoleList: [], // 用户权限key
    setPayPwdStatus: { result: undefined }, // 是否设置过支付密码
    merchant: [
      {
        name: '商户',
        merchantType: 'shops',
        agreement: 'MERCHANT'
      },
      {
        name: '个人/团队/公司',
        merchantType: 'personal',
        agreement: 'PERSONAL'
      },
      {
        name: '合伙人',
        merchantType: 'company',
        agreement: 'PARTNER'
      },
      {
        name: '主播',
        merchantType: 'anchor',
        agreement: 'ZB'
      },
      {
        name: '家族长',
        merchantType: 'familyL1',
        agreement: 'FAMILY'
      },
      {
        name: '公会',
        merchantType: 'familyL2',
        agreement: 'TRADE_UNION'
      },
    ],
    messageData: [], // 系统消息
  },
  userActive: { // 用户激活
    activeInfo: { // 当前用户想激活的账户角色
      familyUp: false, // 是否是家族长升级
      merchantType: '', // 要激活的账户角色
    },
    payTmpl: { // 支付模版
      joinAmount: 1888, // 加盟费
      joinRatio: 15, // 加盟费店铺收益扣除比例
      cashAmount: 1888, // 保证金
    },
    checkedInfo: {}, // 当前用户是否有权激活账户角色
    paiedInfo: {

    }, // 当前用户的账户角色已经支付
    activeShopInfo: { // 当前用户要激活的店铺信息
      merchantId: '', // 用户的商户Id
      formTmpl: [], // 后台返回的模版
      formInfoList: [], // 表单模版
    },
    shopInfo: { // 当前用户想要激活的店铺结算账户
      formData: {
        // accountType: 'PRIVATE',
        // bankCode: '403513000012',
        // bankCodeMap: {
        //   code: '403513000012',
        //   key: 0,
        //   name: '中国邮政储蓄银行股份有限公司南阳市分行',
        //   parentCode: '100',
        // },
        // bizLicenseImg: 'https://gc.xksquare.com/FiA0DU-Vx0Mx_ekrUu90MtnJfLoP',
        // bizScope: '11111',
        // capital: 12000,
        // cityCode: '120100',
        // companyName: '33333',
        // companyWebsite: 'https://baidu.com',
        // contactName: '13648091632',
        // districtCode: '120101',
        // email: 'liuhong123@163.com',
        // firstIndustry: '1000',
        // legalPerson: 'sdfsdf',
        // legalPersonCertificateNo: '511523199205086594',
        // legalPersonCertificateValidity: 1640966400,
        // legalPersonIdCardOppositeImg: 'https://gc.xksquare.com/FiA0DU-Vx0Mx_ekrUu90MtnJfLoP',
        // legalPersonIdCardPositiveImg: 'https://gc.xksquare.com/FiA0DU-Vx0Mx_ekrUu90MtnJfLoP',
        // licenseDate: 1640966400,
        // licenseNo: '11111',
        // loginPassword: '33333333',
        // merchantCategory: 'personal',
        // merchantDoorHeaderImg: 'https://gc.xksquare.com/FiA0DU-Vx0Mx_ekrUu90MtnJfLoP',
        // merchantName: '324324',
        // merchantNature: 'OTHER',
        // merchantShortName: '324234',
        // merchantType: 'ON_LINE',
        // netBizName: 'RECORD_NO',
        // netBizNo: '32424234',
        // officeAddress: 'sdfdsf',
        // openBankCode: '100',
        // openBankCodeMap: {
        //   code: '100',
        //   key: 0,
        //   name: '邮政储蓄银行',
        //   parentCode: null,
        // },
        // phone: '13648091632',
        // provinceCode: '120000',
        // registerAddress: '1111',
        // registerCityCode: '510100',
        // registerDistrictCode: '510104',
        // registerProvinceCode: '510000',
        // secondIndustry: '1001',
        // settleAccount: '6222600260001072444',
        // settleCycle: 'T_1',
        // settleName: '1111',
        // settlePhone: '13648091632',
        // systemOpenDate: 1640966400,
      }, // 编辑的表单数据
      detailInfo: {}, // 后台返回详情数据
    },
  },
  task: {
    // 任务中心
    taskHomeData: [],
    merchantList: [],
    appointedList: [
      { // 任务预委派(已委派)列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing: false,
      },
      { // 验收预委派(已委派)列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing: false,
      },
      { // 审核预委派(已委派)列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing: false,
      },
    ],
    // 任务列表
    taskList: {
      pagination: {},
      list: [],
    },
    // 委派列表
    appointList: [
      { // 任务预委派分店列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing: true,
      },
      { // 验收预委派分店列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing: true,
      },
      { // 审核预委派分店列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing: true,
      }],
    // 单个委派员工列表
    singleAppontAccountList: {
      page: 1,
      limit: 10,
      data: [],
      total: 0,
      hasMore: true,
      refreshing: true,
    },
    // 单个委派联盟商列表
    singleMerchantList: {},
    // 审核任务详情
    taskDetail: {},
  },
  welfare: { // 福利商城
    cashireGoBackRoute: 'SOMPayResult', // 记录收银台的取消支付返回路由，默认支付失败
    cashireGoBackParams: {}, // 收银台返回页面的参数
    // opeartGoBackRouteName 如果福利订单列表进入 为 WMOrderList， 如果我的奖品列表进入 为 WMMyPrizeRecord， 如果我的夺奖进入 为 WMMyprize
    opeartGoBackRouteName: '', // WMGoodsDamagSuccessful页面返回路由
    wmOrderListItem: '', // 记录操作的Item
    refreshPrizeMessage: false, // 点击webView抽奖转盘按钮后，为true，需要刷新中间公告页面
    roleManagerShopList: [],
    orderData: {
      price: 0,
      joinCount: 0,
      maxStake: 0,
      userName: '',
      userPhone: '',
      userAddress: '',
      goodsName: '',
      showSkuName: '',
      lotteryNumbers: [],
    },
    // 福利订单详情
    wmOrderDetail: {
      price: 0,
      joinCount: 0,
      maxStake: 0,
      userName: '',
      userPhone: '',
      userAddress: '',
      goodsName: '',
      showSkuName: '',
      lotteryNumbers: [],
    },
    xfViweWebReload: false,
    bannerList_wm: [],
    recommendGoodsList: {
      goodLists: [],
      page: 1,
      limit: 10,
      refreshing: false,
      hasMore: false,
      total: 0,
    },
    latelyPrizeList: {
      goodLists: [],
      page: 1,
      limit: 10,
      refreshing: false,
      hasMore: false,
      total: 0,
    },
    orderList: [{
      data: [],
      refreshing: false,
      page: 1,
      hasMore: true,
      total: 0,
    }, {
      data: [],
      refreshing: false,
      page: 1,
      hasMore: true,
      total: 0,
    }, {
      data: [],
      refreshing: false,
      page: 1,
      hasMore: true,
      total: 0,
    }, {
      data: [],
      refreshing: false,
      page: 1,
      hasMore: true,
      total: 0,
    }],
    prizeOrderListNum: {
      activity: 0,
      merchant: 0,
    },
    // 我的夺奖 订单列表
    prizeOrderList: [
      {
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
      {
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
      {
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
      {
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
      {
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
      {
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
    ],
    pastWinnerList: { // 往期揭晓列表
      data: [],
      params: {
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
      },
    },
    wmRecommendList: { // 推荐
      data: [],
      params: {
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
      },
    },
    wmPrizeGoodsList: { // 夺奖商品
      data: [],
      params: {
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
      },
    },
    paltDrawDataList: { // 平台大奖
      data: [],
      params: {
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
      },
    },
    wmOrderList: [
      { // 全部
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
      { // 待开奖
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
      { // 已中奖
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
      { // 已完成
        data: [],
        params: {
          page: 1,
          limit: 10,
          refreshing: false,
          hasMore: false,
          total: 0,
        },
      },
    ],
  },
  order: {
    selectedAll: false, // 是否选择全部订单
    selectedOrder: [], // 选中的所有订单
    orderList: {
      list: [],
      pagination: {},
      params: {},
    },
    shopOrderSearchResult: {},
    orderDetail: {
      orderStatus: 4, // 订单状态
      confirmSettlement: false,
      sweepVisible: false,
      pickupWayVisible: false,
      timedate: '',
      endtime: '',
      isSelfLifting: '',
      freight: '',
      ischangefreight: false,
      hasWuliu: false, // 是否已经录入物流
      orderId: '',
      address: '',
      phone: '',
      createdAt: '',
      totalMoney: '',
      data: [],
      remark: '',
      isOrigiPrice: true,
      youhuiPrice: '',
      reson: '',
      discountMoney: 0,
      discountName: 0,
      isAll: 0,
      money: 0,
      resmoney: 0,
      price: 0,
      pPrice: 0,
      pPayPirce: 0,
      chooseKightData: null,
      getSomeData: {
        voucher: 0,
        shopVoucher: 0,
      },
      isUpLimit: false,
      editorble: false,
      orderDetails: {},
      orderList: {
        pagination: {},
        list: [],
      },
    },
    /** 物流信息选择页面数据 */
    logistics: {
      logisticsName: '',
      logisticsNo: '',
      postType: 'OWN',
      orderId: '',
      pickedRider: null,
    },
    riderPickList: {
      my: {
        list: [],
        pagination: {},
      },
      nearby: {
        list: [],
        pagination: {},
      },
    },
    /** 上一次选择的骑手 */
    lastPickRider: null,
    searchRiderList: {
      list: [],
      pagination: {},
    },
    lastLogisticsName: 'SF',
  },
};
