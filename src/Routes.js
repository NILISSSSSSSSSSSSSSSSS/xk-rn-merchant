/**
 * 路由配置
 */
import React, { Component, PureComponent } from 'react';
import {
  Dimensions,
  StyleSheet,
  View,
  Text,
  Image,
  Animated,
  Platform,
  Easing,
  StatusBar,
} from 'react-native';

import { connect } from 'rn-dva';

import {
  createStackNavigator,
  createBottomTabNavigator,
} from 'react-navigation';

import {
  reduxifyNavigator,
  createReactNavigationReduxMiddleware,
  createNavigationReducer,
} from 'react-navigation-redux-helpers';
import { checkoutRole, recodeGoGoodsDetailRoute } from './config/utils';


import * as nativeApi from './config/nativeApi';
import CommonStyles from './common/Styles';

import WelcomeScreen from './screens/WelcomeScreen';

import ShopScreen from './screens/ShopScreen';
import CustomerServiceScreen from './screens/CustomerServiceScreen';
import NativeCustomerServiceScreen from './screens/NativeCustomerSerScreen';
import FriendsScreen from './screens/FriendsScreen';
import MyScreen from './screens/MyScreen';
import AppIntroScreen from './screens/AppIntroScreen'; // App引导页

import LoginScreen from './screens/login/LoginScreen';
import UserShopListsScreen from './screens/login/UserShopListsScreen';
import RegisterScreen from './screens/login/RegisterScreen';
import RegisterListScreen from './screens/login/RegisterListScreen';
import ResetPasswordScreen from './screens/login/ResetPasswordScreen';
import ForgetPassWordScreen from './screens/login/ForgetPassWordScreen';
import PayJoin from './screens/login/PayJoin';
import PayCashDeposit from './screens/login/PayCashDeposit';


// 首页
import HomeScreen from './screens/HomeScreen';
import PrizeMessageScreen from './screens/home/PrizeMessageScreen';
import CommonProblemScreen from './screens/home/CommonProblemScreen';
import ComeProblemCatrgory from './screens/home/ComeProblemCatrgory';
import XKLogisticsScreen from './screens/home/XKLogisticsScreen';// 晓可物流
import XKRiderListScreen from './screens/home/XKRiderListScreen'; // 骑手列表
import VerifyPhoneScreen from './screens/home/VerifyPhoneScreen'; // 验证商户手机号
import ProfitScreen from './screens/home/ProfitScreen'; // 联盟商收益

// 财务账户
import FinancialAccount from './screens/account/FinancialAccount';
import WalletAccount from './screens/account/WalletAccount';
import TransactionRecord from './screens/account/TransactionRecord';
import WithdrawalAccount from './screens/account/WithdrawalAccount';
import AccountTransfer from './screens/account/AccountTransfer';
import TransferSuccess from './screens/account/TransferSuccess';
import FinanceMakeQrcodeScreen from './screens/account/FinanceMakeQrcodeScreen';
import FinanceQrcodeScreen from './screens/shop/FinanceQrcodeScreen';
import FinanceChargeScreen from './screens/account/FinanceChargeScreen';
import FinanceTradeRecordScreen from './screens/account/FinanceTradeRecordScreen'; // 现金交易记录
import FinanceTradeRecordDetail from './screens/account/FinanceTradeRecordDetail'; // 晓可币，晓可券 交易记录详情
import FinancialPositDeposit from './screens/account/FinancialPositDeposit';
import AccountConfirmDeposit from './screens/account/AccountConfirmDeposit';
import AccountDepositSuccess from './screens/account/AccountDepositSuccess';
// selfOperatedMall
import SOMScreen from './screens/selfOperatedMall/SOMScreen';
import SOMMoreScreen from './screens/selfOperatedMall/SOMMoreScreen';
import SOMListsScreen from './screens/selfOperatedMall/SOMListsScreen';
import SOMListsThirdScreen from './screens/selfOperatedMall/SOMListsThirdScreen'; // 自营商城三级列表查询
import SOMGoodsDetailScreen from './screens/selfOperatedMall/SOMGoodsDetailScreen';
import SOMSearchScreen from './screens/selfOperatedMall/SOMSearchScreen';
import SOMSearchResultScreen from './screens/selfOperatedMall/SOMSearchResultScreen';
import SOMShoppingCartScreen from './screens/selfOperatedMall/SOMShoppingCartScreen';
import SOMBalancePayScreen from './screens/selfOperatedMall/SOMBalancePayScreen';
import SOMPayResultScreen from './screens/selfOperatedMall/SOMPayResultScreen';
import SOMOrderScreen from './screens/selfOperatedMall/SOMOrderScreen';
import SOMOrderDetailsScreen from './screens/selfOperatedMall/SOMOrderDetailsScreen';
import SOMOrderConfirmScreen from './screens/selfOperatedMall/SOMOrderConfirmScreen';
import SOMCollectionScreen from './screens/selfOperatedMall/SOMCollectionScreen';
import SOMGoodsCommentsScreen from './screens/selfOperatedMall/SOMGoodsCommentsScreen';
import SOMAfterSaleScreen from './screens/selfOperatedMall/SOMAfterSaleScreen'; // 申请售后
import SOMOrderEvaluation from './screens/selfOperatedMall/SOMOrderEvaluation'; // 评价
import SOMOrderEvaluationSucess from './screens/selfOperatedMall/SOMOrderEvaluationSucess'; // 评价成功
import SOMAfterSaleCategoryScreen from './screens/selfOperatedMall/SOMAfterSaleCategoryScreen'; // 售后申请 选择类型
import SOMShareTemplate from './screens/selfOperatedMall/SOMShareTemplate'; // 详情页，模板
import SOMRefundScreen from './screens/selfOperatedMall/SOMRefundScreen'; // 退款
import SOMReturnedAllScreen from './screens/selfOperatedMall/SOMReturnedAllScreen'; // 退货退款
import SOMReturnedAllWaitScreen from './screens/selfOperatedMall/SOMReturnedAllWaitScreen'; // 退货退款 等待同意
import SOMRefundProcessScreen from './screens/selfOperatedMall/SOMRefundProcessScreen'; // 售后进度
import SOMLogisticsScreen from './screens/selfOperatedMall/SOMLogisticsScreen'; // 物流追踪
import SOMReceivSuccessScreen from './screens/selfOperatedMall/SOMReceivSuccess'; // 收货成功
import SOMShopDetailScreen from './screens/selfOperatedMall/SOMShopDetailScreen'; // 商家详情
import SOMCashierScreen from './screens/selfOperatedMall/SOMCashierScreen'; // 收银台
import SOMRefundMoneyScreen from './screens/selfOperatedMall/SOMRefundMoneyScreen'; // 退款审核

// welfareMall 福利商城
import WMScreen from './screens/welfareMall/WMScreen'; // 首页
import WMListsScreen from './screens/welfareMall/WMListsScreen'; // 分类列表 二级页面
import WMMyprizeScreen from './screens/welfareMall/WMMyprizeScreen'; // 我的大奖
import WMLatelyPrizeListScreen from './screens/welfareMall/WMLatelyPrizeListScreen'; // 最近揭晓
import WMActiveRoleScreen from './screens/welfareMall/WMActiveRoleScreen'; // 抽奖规则
import WMMyLotteryScreen from './screens/welfareMall/WMMyLotteryScreen'; // 我的奖券
import WMFeedbackScreen from './screens/welfareMall/WMFeedbackScreenScreen'; // 商品反馈
import WMOrderListScreen from './screens/welfareMall/WMOrderListScreen'; // 订单列表
import WMGoodsDetailScreen from './screens/welfareMall/WMGoodsDetailScreen'; // 福利商城商品详情页
import WMSearchScreen from './screens/welfareMall/WMSearchScreen'; // 搜索页
import WMSearchResultScreen from './screens/welfareMall/WMSearchResultScreen'; // 搜索结果页
import WMOpenPrizeDetailScreen from './screens/welfareMall/WMOpenPrizeDetailScreen'; // 待开奖详情
import WMWinPrizeDetailScreen from './screens/welfareMall/WMWinPrizeDetailScreen'; // 已中奖详情
import WMOrderCompleteDetailScreen from './screens/welfareMall/WMOrderCompleteDetailScreen'; // 已完成订单详情
import WMLotteryActivityScreen from './screens/welfareMall/WMLotteryActivityScreen'; // 抽奖转盘
import WMMyPrizeRecordScreen from './screens/welfareMall/WMMyPrizeRecordScreen'; // 中奖记录
import WMXFGoodsDetailScreen from './screens/welfareMall/WMXFGoodsDetailScreen'; // 消费抽奖 产品详情
import WMLogisticsListScreen from './screens/welfareMall/WMLogisticsListScreen'; // 福利商城物流信息
import WMGetLotterGoodsScreen from './screens/welfareMall/WMGetLotterGoodsScreen'; // 领取奖品
import WMAllLatelyPrizeScreen from './screens/welfareMall/WMAllLatelyPrizeScreen'; // 福利商城 所有人最新揭晓
import WMPartakeDetailScreen from './screens/welfareMall/WMPartakeDetailScreen'; // 参与详情
import WMOrderLotteryScreen from './screens/welfareMall/WMOrderLotteryScreen'; // 待晒单详情
import WMLotteryDetailScreen from './screens/welfareMall/WMLotteryDetailScreen'; // 中奖详情
import WMLotteryAlgorithmScreen from './screens/welfareMall/WMLotteryAlgorithm'; // 开奖算法
import WMNewGoodsDetailScreen from './screens/welfareMall/WMNewGoodsDetailScreen'; // 消费抽奖商品详情
import WMExpenseWaitOpenOrderDetail from './screens/welfareMall/WMExpenseWaitOpenOrderDetail'; // 平台大奖待开奖订单详情
import WMExpenseWinLotteryScreen from './screens/welfareMall/WMExpenseWinLotteryScreen'; // 平台大奖已中奖订单详情
import WMExpenseShowOrderDetail from './screens/welfareMall/WMExpenseShowOrderDetail'; // 平台大奖已中奖晒单流程订单详情


import BigPrizeOrder from './screens/welfareMall/BigPrizeOrder'; // 大奖晒单
import PastWinners from './screens/welfareMall/PastWinners'; // 往期中奖名单
// 福利商城夺宝购物车
import IndianaShopCart from './screens/welfareMall/IndianaShopCart';
import IndianaShopOrder from './screens/welfareMall/IndianaShopOrder';
import IndianaShopPay from './screens/welfareMall/IndianaShopPay';
import WelfareFavorites from './screens/welfareMall/WelfareFavorites';
// 福利商城货物报损
import WMGoodsDamag from './screens/welfareMall/WMGoodsDamag';
import WMGoodsDamagSuccessful from './screens/welfareMall/WMGoodsDamagSuccessful';
import WMGoodsDamagDetailNo from './screens/welfareMall/WMGoodsDamagDetailNo';
import WMGoodsDamagResult from './screens/welfareMall/WMGoodsDamagResult';
import WMAllShowOrderScreen from './screens/welfareMall/WMAllShowOrderScreen'; // 福利商品晒单列表

import ScanScreen from './screens/account/ScanScreen';

// 店铺信息
import StoreDetailScreen from './screens/shop/StoreDetailScreen';
import StoreEditorScreen from './screens/shop/storeEditor';
import StoreAddressScreen from './screens/shop/StoreAddressScreen';
import StoreFenleiScreeen from './screens/shop/StoreFenleiScreeen';
import YingyeTimeScreen from './screens/shop/StoreYingyeTimeScreen';
import DataCenterScreen from './screens/shop/DataCenterScreen';
import DataCenterFiter from './screens/shop/DataCenterScreen';
import DataCenterQueryScreen from './screens/shop/DataCenterQueryScreen';
import AccountRoleConfiScreen from './screens/shop/AccountRoleConfiScreen'; // 店铺权限配置

// 店铺管理
import StoreManageScreen from './screens/shop/StoreManageScreen';
import BindstoreScreen from './screens/shop/StoreBindScreen';
import SaveSuccessScreen from './screens/shop/SaveSuccessScreen';
import StorePreview from './screens/shop/StorePreview';
import ConfirmCreateOrder from './screens/order/createOrder/ConfirmCreateOrder';

// 店铺财务中心
import FinancialCenter from './screens/shop/FinancialCenter';
import FinancialOrderDetail from './screens/shop/FinancialOrderDetail'

// 店铺商品管理
import GoodsScreen from './screens/shop/GoodsScreen';
import GoodsDetailScreen from './screens/shop/GoodsDetailScreen';
// import GoodsEditorScreen from './screens/shop/GoodsEditorScreen';
import GoodsEditorScreen from './screens/shop/goodsEditer/index';
import GoodsRefundScreen from './screens/shop/GoodsRefundScreen';
import GoodsScaleScreen from './screens/shop/GoodsScaleScreen';
// 店铺收款二维码
import ReceiptQrCodeScreen from './screens/shop/ReceiptQrCodeScreen';
import ReceiptCodeScreen from './screens/shop/ReceiptCodeScreen';
import ReceiptStaticQrCodeScreen from './screens/shop/ReceiptStaticQrCodeScreen';
// 店铺授权管理
import AuthorizationScreen from './screens/shop/AuthorizationScreen';
// 店铺评论管理
import CommentScreen from './screens/shop/CommentScreen';
import CommentReplyScreen from './screens/shop/CommentReplyScreen';
// 店铺促销管理
import SaleScreen from './screens/shop/SaleScreen';
import SaleCustomerManageScreen from './screens/shop/SaleCustomerManageScreen';
import SaleAddCardScreen from './screens/shop/SaleAddCardScreen';
import SaleCardDetailScreen from './screens/shop/SaleCardDetailScreen';
import SaleUseDetailsScreen from './screens/shop/SaleUseDetailsScreen';
import SaleSelectGoodsScreen from './screens/shop/SaleSelectGoodsScreen';
import SaleDistribution from './screens/shop/SaleDistribution';

// 店铺/席位管理
import SeatScreen from './screens/shop/SeatScreen';
import SeatAddScreen from './screens/shop/SeatAddScreen';
import SeatRoomsScreen from './screens/shop/SeatRoomsScreen';
import SeatImagesScreen from './screens/shop/SeatImagesScreen';

// 店铺/品类管理
import CategoryScreen from './screens/shop/CategoryScreen';
import CategoryFirstSetting from './screens/shop/CategoryFirstSetting';//一级分类设置
import CategoryEditerScreen from './screens/shop/CategoryEditerScreen';

// 运费管理
import FreightManagScreen from './screens/shop/FreightManagScreen';
import FreightManagEditor from './screens/shop/FreightManagEditor';

// 我的
import ProfileScreen from './screens/my/ProfileScreen';
import WebViewScreen from './screens/my/WebViewScreen';
import MyApplyFormScreen from './screens/my/myApplyForm';
import MySearchBankAddress from './screens/my/MySearchBankAddress';
import ApplyFormDoneScreen from './screens/my/ApplyFormDoneScreen';
import ContractScreen from './screens/my/ContractScreen';
import AppointScreen from './screens/my/AppointScreen';
import InviteCodeScreen from './screens/my/InviteCodeScreen';
import CampaignCode from './screens/my/CampaignCode';
import FeedbackScreen from './screens/my/FeedbackScreen';
import PersonalFeedback from './screens/my/PersonalFeedback';
import AboutUsScreen from './screens/my/AboutUsScreen';
import InvoiceInfonManage from './screens/my/InvoiceInfonManage';
import CreateInvoice from './screens/my/CreateInvoice';
import Message from './screens/my/Message';
// 我的/设置
import SettingScreen from './screens/my/SettingScreen';


// 商户入驻
import MerchantsMessageScreen from './screens/my/MerchantsMessageScreen';
import AccountActiveScreen from './screens/my/AccountActiveScreen';
import AccountActiveShopScreen from './screens/my/AccountActiveShop/AccountActiveShopScreen';

// 我的/分号管理
import AccountScreen from './screens/my/AccountScreen';
import AccountEditerScreen from './screens/my/AccountEditerScreen';
import AccountDetailScreen from './screens/my/AccountDetailScreen';
import AccountLimitSettingScreen from './screens/my/AccountLimitSettingScreen';
import AccountUpdateScreen from './screens/my/AccountUpdateScreen';
// 我的/银行卡设置
import BankcardScreen from './screens/my/BankcardScreen';
import BankcardEditScreen from './screens/my/BankcardEditScreen';
import BankcardValidatePhoneScreen from './screens/my/BankcardValidatePhoneScreen';
// 设置支付密码、修改支付密码时，验证页面
import MerchantSetPswValidate from './screens/my/MerchantSetPswValidate';
// 设置、修改、重置支付密码页面
import SettingsPayPswScreen from './screens/my/SettingsPayPswScreen';
// 我的/修改支付密码（废弃，暂保留！！！！！）
import EditPayPwdScreen from './screens/my/EditPayPwdScreen';

import PayPswAddScreen from './screens/my/PayPswAddScreen';// 设置支付密码
import PayPswEntryScreen from './screens/my/PayPswEntryScreen';// 确认支付密码
import VerifyPayPswScreen from './screens/my/VerifyPayPswScreen';// 修改支付密码，验证原支付密码
import VerifyUserScreen from './screens/my/VerifyUserScreen'; // 修改密码时候，验证用户
import ResetPayPswScreen from './screens/my/ResetPayPswScreen';
// 我的/收货地址
import DeliveryAddressScreen from './screens/my/DeliveryAddressScreen';
import DeliveryAddressEditScreen from './screens/my/DeliveryAddressEditScreen';
import GoodsTickets from './screens/my/GoodsTickets'; // 单品优惠券
import AddressLocation from './screens/my/AddressLocationScreen'; // 地址定位

// 我的/系统消息
import SystemMessage from './screens/my/SystemMessage'; // 系统消息
import MessageDetails from './screens/my/MessageDetails'; // 系统消息详情

// 店铺订单/服务+现场点单
import ChangeOrdersScreen from './screens/order/serviceSceneOrder/ChangeOrdersScreen'; // 订单详情修改
import StayStatementOrder from './screens/order/serviceSceneOrder/StayStatementOrder'; // 订单详情
import ChooseCalculateGoods from './screens/order/serviceSceneOrder/ChooseCalculateGoods'; // 选择结算商品
import InputConsumerCode from './screens/order/serviceSceneOrder/InputConsumerCode';
import CancelOrder from './screens/order/serviceSceneOrder/CancelOrder';
import ChooseTableNum from './screens/order/serviceSceneOrder/ChooseTableNum'; // 选择餐桌
import SeatsNameView from './screens/order/serviceSceneOrder/SeatsNameView';
import EditorMenu from './screens/order/serviceSceneOrder/EditorMenu';
import RefundOrSettlement from './screens/order/serviceSceneOrder/RefundOrSettlement'; // 确认接单带选择商品，拒绝退款，退款商品选择
// 店铺订单/商品现场消费
import GoodsSceneConsumption from './screens/order/goodsSceneConsumption/GoodsSceneConsumption'; // 订单详情
import ModifySceneConsumption from './screens/order/goodsSceneConsumption/ModifySceneConsumption'; // 修改订单
// 店铺订单/外卖或到店取货
import GoodsTakeOut from './screens/order/tackoutStorePickup/GoodsTakeOut'; // 订单详情
import ChooseRider from './screens/order/tackoutStorePickup/ChooseRiderScreen'; // 骑手选择
import RiderSearch from './screens/order/tackoutStorePickup/RiderSearchScreen'; // 搜索骑手
import ChoosePostCompany from './screens/order/tackoutStorePickup/ChoosePostCompany';
//  店铺订单/外卖骑手
import LogisticsInform from './screens/order/tackoutStorePickup/LogisticsInform';
import LogisticsScreen from './screens/order/tackoutStorePickup/LogisticsScreen';
import ChooseSendType2 from './screens/order/tackoutStorePickup/ChooseSendType2';
// 店铺订单/住宿
import AccommodationOrder from './screens/order/accommodation/AccommodationOrder'; // 住宿订单详情
import ModifyAccommodationOrder from './screens/order/accommodation/ModifyAccommodationOrder'; // 修改订单详情
// 店铺订单列表
import OrderListScreen from './screens/order/orderList/OrderListScreen'; // 订单列表
import OrderSearch from './screens/order/orderList/OrderSearch'; // 搜索
// 线下订单
import CreateOrderScreen from './screens/order/createOrder/CreateOrderScreen'; // 新建订单
import BatchCancelOrder from './screens/order/serviceSceneOrder/BatchCancelOrder'; // 删除架构商品
import OfflneOrder from './screens/order/createOrder/OfflneOrder'; // 线下订单详情
import OfflneChangeOrders from './screens/order/createOrder/OfflneChangeOrders'; // 线下订单修改
import OrderQrcode from './screens/order/createOrder/OrderQrcode'; // 收款二维码
import CreateOrderSucess from './screens/order/createOrder/CreateOrderSucess';
// 售后
import RefundGoodsList from './screens/order/accommodation/RefundGoodsList';
import RefundServiceList from './screens/order/accommodation/RefundServiceList';
import RefusedRefund from './screens/order/accommodation/RefusedRefund';
// 晓可物流订单
import LogisticsOrder from './screens/order/orderList/LogisticsOrder';

// 任务中心
import TaskDetail from './screens/task/TaskDetail';
import TaskSetting from './screens/task/TaskSetting';
import TaskDetailNext from './screens/task/TaskDetailNext';
import TaskJugeReason from './screens/task/TaskJugeReason';
// 任务审核中心
import CancelTaskAudit from './screens/task/CancelTaskAudit';
// 任务中心===>预委派
import PreAppointScreen from './screens/task/PreAppointScreen';
// 任务中心===>预委派列表
import PreAppointListScreen from './screens/task/PreAppointListScreen';
import FinanceWLChargeScreen from './screens/account/FinanceWLChargeScreen';
import TaskHomeScreen from './screens/task/TaskHomeScreen';
import TaskQuestionScreen from './screens/task/TaskQuestionScreen';
import TaskListScreen from './screens/task/TaskListScreen';
// 协议
import AgreementDeal from './screens/login/AgreementDeal';

import IconWithRedPoint from './components/IconWithRedPoint';
import NavigatorService from './common/NavigatorService';

const { width, height } = Dimensions.get('window');


// 首页底部Tab
const IndexScreen = createBottomTabNavigator(
  {
    Home: HomeScreen,
    Shop: ShopScreen,
    // CustomerService: CustomerServiceScreen,
    NativeCustomerService: NativeCustomerServiceScreen,
    Friends: FriendsScreen,
    My: MyScreen,
  },
  {
    tabBarOptions: {
      activeTintColor: '#4A90FA',
      inactiveTintColor: '#777',
      style: {
        backgroundColor: '#fff',
      },
    },
    navigationOptions: ({ navigation }) => ({
      tabBarIcon: ({ focused, tintColor }) => {
        const { routeName } = navigation.state;
        let iconName;
        let redPointRegx;
        if (routeName === 'Home') {
          redPointRegx = /^home/gm;
          iconName = focused
            ? require('./images/index/start_active.png')
            : require('./images/index/start_inactive.png');
        } else if (routeName === 'Shop') {
          redPointRegx = /^shop/gm;
          iconName = focused
            ? require('./images/index/home_active.png')
            : require('./images/index/home_inactive.png');
        } else if (routeName === 'NativeCustomerService') {
          // } else if (routeName === "CustomerService") {
          redPointRegx = /^service/gm;
          iconName = focused
            ? require('./images/index/customerService_active.png')
            : require('./images/index/customerService_inactive2.png');
        } else if (routeName === 'Friends') {
          redPointRegx = /^friends/gm;
          iconName = focused
            ? require('./images/index/friends_active.png')
            : require('./images/index/friends_inactive.png');
        } else if (routeName === 'My') {
          redPointRegx = /^user/gm;
          iconName = focused
            ? require('./images/index/my_active.png')
            : require('./images/index/my_inactive.png');
        }
        return (
          <IconWithRedPoint test={redPointRegx}>
            <Image
                source={iconName}
                style={{ width: 24, height: 24 }}
            />
          </IconWithRedPoint>
        );
      },
      tabBarLabel: ({ focused, tintColor }) => {
        const { routeName } = navigation.state;
        let title;
        if (routeName === 'Home') {
          title = '首页';
        } else if (routeName === 'Shop') {
          title = '店铺';
        } else if (routeName === 'NativeCustomerService') {
          // else if (routeName === "CustomerService") {
          title = '客服';
        } else if (routeName === 'Friends') {
          title = '好友';
        } else if (routeName === 'My') {
          title = '我的';
        }

        return (
          <Text
            style={{
              fontSize: 12,
              textAlign: 'center',
              color: tintColor,
              marginBottom: 3,
            }}
          >
            {title}
          </Text>
        );
      },
      tabBarOnPress: ({ previousScene, scene, jumpToIndex }) => { // 使用tabBarOnPress点击事件
        const { routeName } = navigation.state;
        setTimeout(() => {
          ['Home', 'NativeCustomerService'].indexOf(routeName) !== -1 ? StatusBar.setBarStyle('dark-content') : StatusBar.setBarStyle('light-content');
        });
        if (global.nativeProps) { global.nativeProps = null; }
        if (routeName === 'Friends') {
          recodeGoGoodsDetailRoute()
          if (checkoutRole('friend', global.userRoleList || [])) { // 判断好友权限
            route(navigation);
          }
        } else {
          route(navigation);
        }
      },
    }),
  },
);

/**
 * Tab点击跳转调用的公共方法
 */
const route = (navigation) => {
  if (!navigation.isFocused()) {
    // 路由方法, 动态跳转到对应界面
    const { routeName } = navigation.state;
    if (routeName === 'Friends') {
      nativeApi.clickFriendScreen();
    } else if (routeName == 'Shop' && global.loginInfo && loginInfo.isAdmin == 0 && !loginInfo.userShop) {
      Toast.show('没有权限访问');
      return;
    }
    navigation.navigate(navigation.state.routeName, {
      title: navigation.state.routeName,
    });
  }
};


// 隐藏首页底部Tab的header
IndexScreen.navigationOptions = {
  header: null,
};

// 路由
const createAppNavigator = (createRoute = (initialRouteName = 'Welcome') => {
  const Routes = createStackNavigator(
    {
      Welcome: WelcomeScreen,
      Index: IndexScreen,
      Login: LoginScreen,
      Register: RegisterScreen,
      UserShopLists: UserShopListsScreen,
      RegisterList: RegisterListScreen,
      ResetPassword: ResetPasswordScreen,
      ForgetPassWord: ForgetPassWordScreen,
      PayJoin,
      PayCashDeposit,
      XKLogistics: XKLogisticsScreen,
      XKRiderList: XKRiderListScreen,
      VerifyPhone: VerifyPhoneScreen,
      Profit: ProfitScreen,
      AppIntro: AppIntroScreen,

      SOM: SOMScreen,
      SOMMore: SOMMoreScreen,
      SOMLists: SOMListsScreen,
      SOMListsThird: SOMListsThirdScreen,
      SOMGoodsDetail: SOMGoodsDetailScreen,
      SOMSearch: SOMSearchScreen,
      SOMSearchResult: SOMSearchResultScreen,
      SOMShoppingCart: SOMShoppingCartScreen,
      SOMBalancePay: SOMBalancePayScreen,
      SOMPayResult: SOMPayResultScreen,
      SOMOrder: SOMOrderScreen,
      SOMOrderDetails: SOMOrderDetailsScreen,
      SOMOrderConfirm: SOMOrderConfirmScreen,
      SOMCollection: SOMCollectionScreen,
      SOMGoodsComments: SOMGoodsCommentsScreen,
      SOMAfterSale: SOMAfterSaleScreen,
      SOMOrderEvaluation, // 评价
      SOMOrderEvaluationSucess, // 评价成功
      SOMAfterSaleCategory: SOMAfterSaleCategoryScreen, // 选择售后申请
      SOMRefund: SOMRefundScreen,
      SOMReturnedAll: SOMReturnedAllScreen,
      SOMReturnedAllWait: SOMReturnedAllWaitScreen,
      SOMRefundProcess: SOMRefundProcessScreen, // 售后进度
      SOMLogistics: SOMLogisticsScreen, // 物流追踪
      SOMReceivSuccess: SOMReceivSuccessScreen, // 收货成功
      SOMShopDetail: SOMShopDetailScreen, // 店铺详情
      SOMShareTemp: SOMShareTemplate, // 店铺详情，分享，模板
      SOMCashier: SOMCashierScreen, // 收银台
      SOMRefundMoney: SOMRefundMoneyScreen, // 退款审批等待

      // 福利商城
      WM: WMScreen,
      PastWinners,
      WMLists: WMListsScreen,
      WMMyprize: WMMyprizeScreen,
      WMLatelyPrizeList: WMLatelyPrizeListScreen,
      WMActiveRole: WMActiveRoleScreen,
      WMShowOrder: WMFeedbackScreen, // 福利晒单
      WMOrderList: WMOrderListScreen,
      WMOpenPrizeDetail: WMOpenPrizeDetailScreen,
      WMGoodsDetail: WMGoodsDetailScreen,
      WMSearch: WMSearchScreen,
      WMSearchResult: WMSearchResultScreen,
      WMWinPrizeDetail: WMWinPrizeDetailScreen,
      WMOrderCompleteDetail: WMOrderCompleteDetailScreen,
      BigPrizeOrder,
      WMMyLottery: WMMyLotteryScreen,
      WMLotteryActivity: WMLotteryActivityScreen,
      WMMyPrizeRecord: WMMyPrizeRecordScreen,
      WMXFGoodsDetail: WMXFGoodsDetailScreen,
      WMLogisticsList: WMLogisticsListScreen,
      WMGetLotterGoods: WMGetLotterGoodsScreen,
      WMAllLatelyPrize: WMAllLatelyPrizeScreen,
      WMAllShowOrder: WMAllShowOrderScreen,
      WMPartakeDetail: WMPartakeDetailScreen,
      WMOrderLottery: WMOrderLotteryScreen,
      WMLotteryDetail: WMLotteryDetailScreen,
      WMLotteryAlgorithm: WMLotteryAlgorithmScreen,
      WMNewGoodsDetail: WMNewGoodsDetailScreen,
      WMExpenseWaitOpenOrderDetail,
      WMExpenseWinLottery: WMExpenseWinLotteryScreen,
      WMExpenseShowOrderDetail,
      // 财务账户
      FinancialAccount,
      WalletAccount,
      TransactionRecord,
      WithdrawalAccount,
      AccountTransfer,
      TransferSuccess,
      FinanceTradeRecord: FinanceTradeRecordScreen,
      FinanceTradeRecordDetail,
      FinancialPositDeposit,
      AccountConfirmDeposit,
      AccountDepositSuccess,
      // my
      AddressLocation,
      Profile: ProfileScreen,
      WebView: WebViewScreen,
      MyApplyForm: MyApplyFormScreen,
      MySearchBankAddress,
      ApplyFormDone: ApplyFormDoneScreen,
      Contract: ContractScreen,
      Appoint: AppointScreen,
      InviteCode: InviteCodeScreen,
      CampaignCode,
      Feedback: FeedbackScreen,
      PersonalFeedback,
      AboutUs: AboutUsScreen,
      CommonProblem: CommonProblemScreen,
      IndianaShopCart,
      IndianaShopOrder,
      IndianaShopPay,
      WelfareFavorites,
      WMGoodsDamag,
      WMGoodsDamagSuccessful,
      WMGoodsDamagDetailNo,
      WMGoodsDamagResult,
      GoodsTickets,
      Message,
      SystemMessage,
      MerchantSetPswValidate,
      SettingsPayPsw: SettingsPayPswScreen,
      AddressLocation,
      // my/验收中心
      TaskHome: TaskHomeScreen,
      TaskQuestion: TaskQuestionScreen,
      TaskList: TaskListScreen,
      TaskDetail,
      TaskSetting,
      TaskDetailNext,
      TaskJugeReason,
      // my/设置
      Setting: SettingScreen,
      MessageDetails,
      // shop
      Account: AccountScreen,
      Category: CategoryScreen,
      CategoryFirstSetting,
      Comment: CommentScreen,
      Goods: GoodsScreen,
      Sale: SaleScreen,
      Scan: ScanScreen,
      StoreManage: StoreManageScreen,
      StoreDetail: StoreDetailScreen,
      StoreEditor: StoreEditorScreen,
      StoreAddress: StoreAddressScreen,
      StoreFenlei: StoreFenleiScreeen,
      YingyeTime: YingyeTimeScreen,
      Bindstore: BindstoreScreen,
      SaveSuccess: SaveSuccessScreen,
      GoodsDetail: GoodsDetailScreen,
      GoodsEditor: GoodsEditorScreen,
      GoodsRefund: GoodsRefundScreen,
      GoodsScale: GoodsScaleScreen,
      CommentReply: CommentReplyScreen,
      SaleCustomerManage: SaleCustomerManageScreen,
      SaleAddCard: SaleAddCardScreen,
      SaleCardDetail: SaleCardDetailScreen,
      SaleUseDetails: SaleUseDetailsScreen,
      AccountEditer: AccountEditerScreen,
      AccountDetail: AccountDetailScreen,
      AccountLimitSetting: AccountLimitSettingScreen,
      AccountUpdate: AccountUpdateScreen,
      StorePreview,
      SaleDistribution,
      AccountRoleConfi: AccountRoleConfiScreen,
      ConfirmCreateOrder,
      // FinanceTradeRecord: FinanceTradeRecord,
      FinanceMakeQrcode: FinanceMakeQrcodeScreen,
      FinanceQrcode: FinanceQrcodeScreen,
      FinanceCharge: FinanceChargeScreen,
      FinanceWLCharge: FinanceWLChargeScreen,
      Bankcard: BankcardScreen,
      BankcardEdit: BankcardEditScreen,
      BankcardValidatePhone: BankcardValidatePhoneScreen,
      Seat: SeatScreen,
      SeatAdd: SeatAddScreen,
      SeatRooms: SeatRoomsScreen,
      SeatImages: SeatImagesScreen,
      SaleSelectGoods: SaleSelectGoodsScreen,
      CategoryEditer: CategoryEditerScreen,
      FinancialCenter,
      FinancialOrderDetail,
      PayPswAdd: PayPswAddScreen, // 新增支付密码
      PayPswEntry: PayPswEntryScreen, // 确认支付密码
      VerifyPayPsw: VerifyPayPswScreen, // 修改支付密码 验证支付密码
      VerifyUser: VerifyUserScreen, // 修改支付密码 验证用户
      ResetPayPsw: ResetPayPswScreen, // 重置支付密码

      ReceiptQrCodeScreen,
      ReceiptCodeScreen,
      ReceiptStaticQrCodeScreen,
      EditPayPwd: EditPayPwdScreen,
      FreightManag: FreightManagScreen,
      FreightManagEditor,
      DataCenter: DataCenterScreen,
      DataCenterFiter,
      DataCenterQuery: DataCenterQueryScreen,
      Authorization: AuthorizationScreen,
      InvoiceInfonManage,
      CreateInvoice,
      DeliveryAddress: DeliveryAddressScreen,
      DeliveryAddressEdit: DeliveryAddressEditScreen,
      // 首页
      PrizeMessage: PrizeMessageScreen,
      ComeProblemCatrgory,

      // 入驻
      MerchantsMessage: MerchantsMessageScreen,
      AccountActive: AccountActiveScreen,
      AccountActiveShop: AccountActiveShopScreen,

      // 订单
      LogisticsScreen,
      ChangeOrders: ChangeOrdersScreen,
      StayStatementOrder,
      ChooseCalculateGoods,
      InputConsumerCode,
      CancelOrder,
      ChooseTableNum,
      SeatsNameView,
      EditorMenu,
      RefundOrSettlement,
      GoodsSceneConsumption,
      ModifySceneConsumption,
      GoodsTakeOut,
      AccommodationOrder,
      ModifyAccommodationOrder,
      OrderListScreen,
      OrderSearch,
      CreateOrder: CreateOrderScreen,
      BatchCancelOrder,
      OfflneOrder,
      OfflneChangeOrders,
      RefundGoodsList,
      RefundServiceList,
      RefusedRefund,
      OrderQrcode,
      CancelTaskAudit,
      ChooseSendType2,
      LogisticsInform,
      LogisticsOrder,
      AgreementDeal,
      PreAppoint: PreAppointScreen,
      PreAppointList: PreAppointListScreen,
      CreateOrderSucess,
      ChooseRider,
      RiderSearch,
      ChoosePostCompany,
    },
    {
      initialRouteName,
      headerMode: 'screen',
      navigationOptions: {
        header: null,
      },
      // 页面切换动画
      transitionConfig: () => ({
        transitionSpec: {
          duration: 300,
          easing: Easing.out(Easing.poly(4)),
          timing: Animated.timing,
        },
        screenInterpolator: (sceneProps) => {
          const { layout, position, scene } = sceneProps;
          const { index } = scene;

          const width = layout.initWidth;
          const translateX = position.interpolate({
            inputRange: [index - 1, index, index + 1],
            outputRange: [width, 0, 0],
          });

          const opacity = position.interpolate({
            inputRange: [index - 1, index - 0.99, index],
            outputRange: [0, 1, 1],
          });

          return { opacity, transform: [{ translateX }] };
        },
      }),
    },
  );

  return Routes;
});

export const AppNavigator = createAppNavigator();
export const middleware = createReactNavigationReduxMiddleware('root', state => state.nav);
const AppContainer = reduxifyNavigator(AppNavigator, 'root');
const AppConnect = connect(state => ({
  state: state.nav,
}))(props => (
  <AppContainer
    ref={(e) => {
      NavigatorService.setContainer(props);
      // 全局路由信息
      global.Routers = e;
    }}
    {...props}
  />
));

export default (initialRouteName = 'Welcome', props) => {
  if (initialRouteName === 'Welcome') { return <View style={{ flex: 1 }}><AppConnect /></View>; }

  const _AppNavigator = createAppNavigator(initialRouteName);
  return <_AppNavigator />;
};
