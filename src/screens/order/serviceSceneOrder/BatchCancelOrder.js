/**
 * 服务+现场点单-取消订单
 */
import React, { Component } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    TextInput,
    TouchableOpacity,
} from "react-native";
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Content from "../../../components/ContentItem";
import * as orderRequestApi from '../../../config/Apis/order'

const { width } = Dimensions.get("window")

function getwidth(val) {
    return width * val / 375
}

export default class BatchCancelOrder extends Component {
    state = {
        loading: false
    }
    saveData = () => {
        let val = this.cancelReson._lastNativeText
        if (!val) {
            Toast.show('请输入原因')
            return
        }
        const { navigation } = this.props
        const { purchaseId, shopId, sureDelete, deleteItemInfo } = navigation.state.params
        let param = {
            shopId: shopId,
            purchaseOrderIds: [purchaseId],
            reason: val
        }
        this.setState({
            loading: true
        })
        orderRequestApi.fetchShopPurchaseOrderMUserBatchDelete(param).then((res) => {
            if (sureDelete) {
                sureDelete(deleteItemInfo)
            }
            this.setState({
                loading: false
            })
            navigation.goBack()
        }).catch(error => {
            this.setState({
                loading: false
            })
        })
    }
    render() {
        const { navigation } = this.props
        const { loading } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='取消订单'
                />
                <Content style={styles.content}>
                    <TextInput
                        autoFocus={true}
                        multiline={true}
                        placeholder='取消原因'
                        returnKeyLabel="确定"
                        returnKeyType="done"
                        ref={(ref) => { this.cancelReson = ref }} />
                </Content>
                <TouchableOpacity
                    disabled={loading}
                    onPress={this.saveData}
                    style={[styles.savebtn, loading ? { opacity: 0.5 } : {}]}>
                    <Text style={styles.cff17}>确认提交</Text>
                </TouchableOpacity>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    content: {
        width: getwidth(355),
        height: 196,
        paddingHorizontal: 15
    },
    savebtn: {
        width: getwidth(355),
        height: 44,
        backgroundColor: '#4A90FA',
        borderRadius: 8,
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 20
    },
    cff17: {
        color: '#FFFFFF',
        fontSize: 17
    }
})
