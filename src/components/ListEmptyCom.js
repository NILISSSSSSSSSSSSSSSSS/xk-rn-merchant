// 列表为空时，缺省内容
// 需对接的：M1客户咨询首页（缺省）
// 使用：
// 有自定义children：
// <ListEmptyCom type='G7_store'>
//    <Text>123</Text>
// </ListEmptyCom>
// 无children：
// <ListEmptyCom type='G7_store'/>
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity
} from "react-native";
import CommonStyles from '../common/Styles'

export const ListEmptyItem = ({ icon, title })=> {
    return <React.Fragment>
        <Image source={icon} />
        <View style={[CommonStyles.flex_center,styles.textWrap]}>
            <Text style={styles.text}>{title}</Text>
        </View>
    </React.Fragment>
}

export default class ListEmptyCom extends PureComponent {
    getComponent = (type) => {
        switch (type) {
            // 开奖算法
            case 'WMLotteryAlgorithm':
                return <ListEmptyItem title="无人参与，系统自动开奖" icon={require('../images/emptyData/H1_goodsManage.png')} />
            // 参与详情
            case 'WMPartakeDetail':
                return <ListEmptyItem title="暂无用户参与" icon={require('../images/emptyData/l1_accountManage.png')} />
            // 预委派添加图层
            case 'AddPointMerchantModal':
            case 'AddPointModal':
                return <ListEmptyItem title={`您还没有分号\n您可以在我的-联盟商信息-分号管理中新增分号`} icon={require('../images/emptyData/l1_accountManage.png')} />
            // 预委派列表
            case 'PreAppointList':
                return <ListEmptyItem title="您还没有添加分号哦" icon={require('../images/emptyData/l1_accountManage.png')} />
            // 发票列表信息为空
            case 'InvoiceInfoEmpty':
                return <ListEmptyItem title="暂无发票" icon={require('../images/emptyData/InvoiceInfoEmpty.png')} />
            // 购物车
            case 'shopCarEmpty':
                return <ListEmptyItem title="购物车空空如也" icon={require('../images/emptyData/shopCarEmpty.png')} />
            // 订单列表
            case 'orderListEmpty':
                return <ListEmptyItem title="暂无订单" icon={require('../images/emptyData/orderListEmpty.png')} />
            // 下级店铺
            case 'G7_store':
                return <ListEmptyItem title={`暂无下级店铺\n点击“绑定店铺”，新增下级店铺`} icon={require('../images/emptyData/G7_storeEmpty.png')} />
            // 商品管理
            case 'H1_goodsManage':
                return <ListEmptyItem title={`暂无商品\n点击“加号”为该分类新增商品`} icon={require('../images/emptyData/H1_goodsManage.png')} />
            // 账号管理
            case 'l1_accountManage':
                return <ListEmptyItem title={`您还没有其他分号\n点击“新增”按钮添加分号`} icon={require('../images/emptyData/H1_goodsManage.png')} />
            // 品类管理
            case 'K6_categoryManage':
                return <ListEmptyItem title={`暂无分类\n点击“新增”按钮添加任意分类`} icon={require('../images/emptyData/K6_categoryManage.png')} />
            // 银行卡管理
            case 'K9_bankCardManage':
                return <ListEmptyItem title={`您还没有绑定银行卡\n点击“加号”添加银行卡`} icon={require('../images/emptyData/K9_bankCardManage.png')} />
            // 席位管理
            case 'K14_seatManage':
                return <ListEmptyItem title={`您还没有添加席位\n点击“新建分类”按钮，添加席位`} icon={require('../images/emptyData/K14_seatManage.png')} />
            // 会员卡管理
            case 'L2_memberCardManage':
                return <ListEmptyItem title={`暂无店铺会员卡\n点击“新增”添加会员卡`} icon={require('../images/emptyData/L2_memberCardManage.png')} />
            // 优惠券管理
            case 'L6_couponManage':
                return <ListEmptyItem title={`暂无店铺优惠券\n点击“新增”按钮添加优惠券`} icon={require('../images/emptyData/L6_couponManage.png')} />
            // 单品优惠券
            case 'N42_singleGoodsCoupon':
                return <ListEmptyItem title={`暂无单品优惠券`} icon={require('../images/emptyData/N42_singleGoodsCoupon.png')} />
            // 财务中心
            case 'R1_financial_Base':
                return <ListEmptyItem title={`所选时间内暂无订单财务数据\n请尝试更改查询时间或店铺`} icon={require('../images/emptyData/R1_financial_Base.png')} />
            // 审核中心
            case 'SHRZ_01_auditCenter':
                return <ListEmptyItem title="暂无需要审核的任务" icon={require('../images/emptyData/SHRZ_01_auditCenter.png')} />
            // 任务中心
            case 'SHRZ_01_1_taskCenter':
                return <ListEmptyItem title="暂无任务" icon={require('../images/emptyData/SHRZ_01_1_taskCenter.png')} />
            // 验收中心
            case 'SHRZ_01_2_taskCenter':
                return <ListEmptyItem title="暂无需要验收的任务" icon={require('../images/emptyData/SHRZ_01_2_taskCenter.png')} />
             // 商品管理
             case 'SHRZ_goodsManage':
                return <ListEmptyItem title={`暂无商品\n点击'新增'为该分类新增商品`} icon={require('../images/emptyData/H1_goodsManage.png')} />
            // 好友-未审核通过-缺省
            case 'Friends_Not_Audit':
                return <ListEmptyItem title={`您的入驻资料正在审核中，\n请耐心等待`} icon={require('../images/emptyData/Friends_Not_Audit.png')} />
            // 好友-未激活通过-缺省
            case 'Friends_Not_Active':
            return <ListEmptyItem title="账号待激活" icon={require('../images/emptyData/Friends_Not_Active.png')} />
            // 店铺订单 - 物流选择 - 骑手选择
            case 'Riders_Not_Find':
                return <ListEmptyItem title={`您暂未绑定骑手，请在晓可物流模块中\n绑定晓可骑手`} icon={require('../images/emptyData/Riders_Not_Find.png')} />
             // 店铺订单 - 物流选择 - 骑手选择
            case 'Riders_Not_Nearby':
                return <ListEmptyItem title={`附近没有骑手，请稍后再试`} icon={require('../images/emptyData/Riders_Not_Find.png')} />
                /** 个人资料缺省页  */
            case 'Hide_Profile':
                return <ListEmptyItem title={`对方隐藏了个人资料`} icon={require('../images/emptyData/Hide_Profile.png')} />
            case 'No_Task':
                return <ListEmptyItem icon={require('../images/task/no-task.png')} title="入驻审核中，您还没有任务" />
            default:
                return <ListEmptyItem title="暂无数据" icon={require('../images/emptyData/H1_goodsManage.png')} />
        }
    }
    render () {
        const { type,style } = this.props
        return (
            <View style={[styles.container,CommonStyles.flex_center,CommonStyles.flex_1,style]}>
                {/* 根据类型获取图片和文字 */}
                {
                    this.getComponent(type)
                }
                <View style={[styles.otherWrap,CommonStyles.flex_center]}>
                {/* 显示传入的children */}
                {
                    this.props.children
                }
                </View>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        paddingTop: 70,
    },
    textWrap: {
        marginTop: 26,
    },
    text: {
        marginBottom: 6,
        fontSize: 14,
        color: '#777',
        textAlign: 'center',
        lineHeight: 17
    },
    otherWrap: {
        marginTop: 25,
    },
})
