
import mallListEffects from './mallList'
import mallOrderEffects from './mallOrder'
const initState = {
    somRecommendGoodsList: [],
    somBannerList: [],
    goodsCategoryLists: [],
    goodsCategoryLists_pre: [],
    brandInfo: {},
    brandBannerList: [],
    recommendGoodsList: {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    recommendGoodsListOfCategory: {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    // 批发商城 收藏列表
    somCollectionGoodsList: {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    // 批发商城 购物车
    somCartLists: {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    categoryGoodsList: [],
    // 批发商城三级列表商品
    somListsThirdList: {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    // 搜索历史记录
    somHistoryLists: {
        title: '历史搜索',
        lists: [],
    },
    // 自营搜索热词
    somHotList: {
        title: '热门搜索',
        lists: [],
    },
    somOrderConfiirm:  {
        address: '',
        goodsList: [],
        userInfo: {merchantId: ''},
        goodsAmount: '', // 商品金额
        postAmount: '', // 运费
        orderAmount: '0', // 需支付金额
        couponList: [], // 优惠券列表
        couponIndex: '', // 选择的优惠券索引
        selectCoupon: { // 选择的优惠券
            cardType: '',
            id: '',
            cardName: '请选择优惠券',
            cardId: '',
        },
        selectInvoice: { // 选择的发票
            id: '',
            head: ''
        }
    },
    // 后台返回的收银台信息数据
    cashierResponse: {

    },
    cashierInfo: {
        routerIn: '',
        data: [], // 处理后的收银台数据，便于页面渲染
        surplusPayAmount: '', // 剩余支付的金额， 如果为0可以直接支付，如果不为0 需要选择其他支付方式支付
        proportion: {
            swqProportion: 1, // 实物券兑换比例
            xfqProportion: 1 // 消费券兑换比例
        },
    },
    // 设置支付密码状态
    payPwdStatus: {

    },
    inGoodsDetailRoute: {
        routeName: '',
        payStatus: false,
    },
    // 自营商城搜索列表
    somSearchGoodsList: {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    somFilterAttrList: {}, // 搜索属性模板
    // 自营商城搜索列表
    somOrderList: [{
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    },
    {
        params: {
            page: 1,
            limit: 10,
            hasMore: true,
            total: 0,
            refreshing: false,
        },
        data: []
    }], // 正常订单列表
}

export default {
    namespace: "mall",
    state: {
        ...initState
    },
    reducers: {
        save(state, action = {}) {
            console.log('action', action)
            return {
                ...state,
                ...action.payload
            }
        },
    },
    effects: {
        ...mallListEffects,
        ...mallOrderEffects,
    }
}
