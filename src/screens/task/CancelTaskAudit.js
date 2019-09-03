/**
 * 验收中心不通过
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
import CommonStyles from '../../common/Styles'
import Header from '../../components/Header'
import Content from "../../components/ContentItem";
import * as taskRequest from '../../config/taskCenterRequest'

const { width, height } = Dimensions.get("window")

function getwidth(val) {
    return width * val / 375
}

export default class CancelTaskAudit extends Component {
    saveData = () => {
        let val = this.cancelReson._lastNativeText
        if (!val) {
            Toast.show('请输入原因')
            return
        }
        const { navigation } = this.props
        const { taskId, taskcore, callback, isToCneter, listcallBack } = navigation.state.params
        if (taskcore !== 'acceptancecore') {
            let param = {
                jobId: taskId,
                // action: 'no',
                reason: val,
                // merchantTaskNode:merchantTaskNode,
            }
            //审核
            taskRequest.fetchMerchantauditFail(param).then(() => {
                Toast.show('操作成功')
                if (callback) {
                    callback(1)
                }
                if (listcallBack) {
                    listcallBack(1)
                }
                if (isToCneter) {
                    navigation.navigate('TaskList')
                } else {
                    navigation.navigate('TaskDetail')
                }
            }).catch((err)=>{
                console.log(err)
              });
        } else {
            let param = {
                jobId: taskId,
                // action: 'no',
                // merchantTaskNode:merchantTaskNode,
                reason: val,
            }
            //验收
            taskRequest.fetchMerchantJoincheckJobFail(param).then((res) => {
                Toast.show('操作成功')
                if (callback) {
                    callback(1)
                }
                if (listcallBack) {
                    listcallBack(1)
                }
                navigation.navigate('TaskList')
            }).catch((err)=>{
                console.log(err)
              });
        }
    }
    render() {
        const { navigation } = this.props
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='审核不通过原因'
                />
                <Content style={styles.content}>
                    <TouchableOpacity
                        style={{ width: '100%', height: '100%' }}
                        onPress={
                            () => {
                                this.cancelReson.focus()
                            }
                        }
                    >
                        <TextInput
                            multiline={true}
                            autoFocus={true}
                            placeholder='取消原因'
                            returnKeyLabel="确定"
                            returnKeyType="done"
                            ref={(ref) => { this.cancelReson = ref }} />
                    </TouchableOpacity>
                </Content>
                <TouchableOpacity
                    onPress={this.saveData}
                    style={styles.savebtn}>
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
