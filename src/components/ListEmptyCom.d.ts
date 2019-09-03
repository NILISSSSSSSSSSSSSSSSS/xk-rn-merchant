import React, { PureComponent, ReactElement, ReactText } from 'react'
import { ViewStyle, ImageSourcePropType } from 'react-native'

export type ListEmptyComType = "WMPartakeDetail" | "WMLotteryAlgorithm" | "AddPointMerchantModal" | "AddPointModal" | "PreAppointList" | "InvoiceInfoEmpty" | "shopCarEmpty" | "orderListEmpty" | "G7_store" | "H1_goodsManage"
| "l1_accountManage" | "K6_categoryManage" | "K9_bankCardManage" | "K14_seatManage" | "L2_memberCardManage" | "L6_couponManage" | "N42_singleGoodsCoupon" | "R1_financial_Base"
| "SHRZ_01_auditCenter" | "SHRZ_01_1_taskCenter" | "SHRZ_01_2_taskCenter" | "SHRZ_goodsManage" | "Friends_Not_Audit" | "Riders_Not_Find" | "Riders_Not_Nearby" | "Hide_Profile"
 | 'No_Task';
interface ListEmptyComProps {
    type?: ListEmptyComType
    style?: ViewStyle
}

interface ListEmptyItemProps {
    title: ReactElement | ReactText,
    icon: ImageSourcePropType
}

export default class ListEmptyCom extends PureComponent<ListEmptyComProps>{}

export class ListEmptyItem extends Component<ListEmptyItemProps>{}
