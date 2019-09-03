/**
 * 服务+现场点单-输入消费码
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    TextInput,
    TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Content from "../../../components/ContentItem";
import * as orderRequestApi from '../../../config/Apis/order'
const { width, height } = Dimensions.get("window")

function getwidth(val) {
    return width * val / 375
}

export default class InputConsumerCode extends Component {
    saveData = () => {
        let val = this.vouchers._lastNativeText
        if (val == '') {
            Toast.show('请输入消费码')
            return
        }
        const { initDataDidMount, orderId } = this.props.navigation.state.params
        orderRequestApi.fetchBcleMUserConfirmConsume({ consumeCode: val,orderId }).then((res) => {
            if (initDataDidMount) {
                initDataDidMount(orderId)
            }
            this.props.navigation.goBack()
        }).catch(err => {
            console.log(err)
        });
    }
    render() {
        const { navigation } = this.props
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='输入消费码'
                    rightView={
                        <TouchableOpacity
                            onPress={this.saveData}
                            style={{ width: 50, height: '100%', justifyContent: 'center' }}>
                            <Text style={styles.cff17}>确定</Text>
                        </TouchableOpacity>
                    }
                />
                {/* <Content style={styles.textinpitView}> */}
                <TextInput
                    style={styles.textinpitView}
                    keyboardType="numeric"
                    placeholder='请输入消费码'
                    returnKeyLabel="确定"
                    returnKeyType="done"
                    ref={(ref) => { this.vouchers = ref }} />
                {/* </Content> */}
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
    cff17: {
        color: '#FFFFFF',
        fontSize: 17
    },
    textinpitView: {
        width: getwidth(355),
        height: 54,
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        borderRadius: 6,
        marginTop: 10
    },
})
