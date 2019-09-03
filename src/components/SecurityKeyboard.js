// 安全键盘
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    TouchableOpacity,
    Modal,
    Image
} from "react-native";
import CommonStyles from '../common/Styles';
const { width, height } = Dimensions.get('window');

export default class SecurityKeyboard extends Component {
    static defaultProps = {
        visible: false, // 控制显示
        animationType: 'fade', // 出场动画
        transparent: true, // 背景
        onShow: () => { }, // 显示回调
        onDismiss: () => { }, // 关闭回调
        onClose: () => { }, // 关闭
        onOk: () => { }, // 点击完成按钮回调
        onKeyPress: () => { }, // 点击按键的回调
        disableOkBtn: false, // 禁用完成按钮，并且点击无响应
    }
    state = {
        keyValue: '',
        maxLength: 6,
    }
    handleChangeState = (key = '', value = '', callback = () => { }) => {
        const { onKeyPress } = this.props
        this.setState({
            [key]: value
        }, () => {
            onKeyPress(this.state.keyValue)
        })
    }
    // 删除最后一个字符
    handleBackSpace = () => {
        const { keyValue } = this.state
        if (keyValue.length === 0) return
        let nowVal = keyValue.toString().substring(0, keyValue.length - 1);
        this.handleChangeState('keyValue', nowVal)
    }
    // 拼接字符串
    handleOnKeyPress = (item) => {
        const { keyValue } = this.state
        this.handleChangeState('keyValue', keyValue + item)
    }
    render() {
        const { keyValue, maxLength } = this.state
        const { visible, transparent, animationType, onClose, onOk, onShow, onDismiss, disableOkBtn } = this.props
        let disable = disableOkBtn ? styles.completeBtn_disable : {}
        return (
            <Modal
                animationType={animationType}
                transparent={transparent}
                visible={visible}
                onRequestClose={onClose}
                onDismiss={onDismiss}
                onShow={onShow}
            >
                <TouchableOpacity onPress={onClose} activeOpacity={1} style={[CommonStyles.flex_1]}>
                    <View style={[styles.modalContent]}>
                        <View
                            style={[styles.topBtnWrap, CommonStyles.flex_end]}
                        >
                            <TouchableOpacity onPress={(disableOkBtn) ? () => { } : onOk} >
                                <Text style={[styles.completeBtn, disable]}>完成</Text>
                            </TouchableOpacity>
                        </View>
                        <View style={[CommonStyles.flex_start, { flexWrap: 'wrap' }]}>
                            {
                                [1, 2, 3, 4, 5, 6, 7, 8, 9].map((item, index) => {
                                    return (
                                        <TouchableOpacity
                                            activeOpacity={0.7}
                                            key={index}
                                            style={[styles.keyBtn, CommonStyles.flex_center]}

                                            onPress={() => {
                                                if (keyValue.length < maxLength) {
                                                    this.handleOnKeyPress(item)
                                                }
                                            }}
                                        >
                                            <Text style={styles.keyBtnText}>{item}</Text>
                                        </TouchableOpacity>
                                    )
                                })
                            }
                        </View>
                        {/* 特殊处理 0 和删除 */}
                        <View style={[CommonStyles.flex_end,]}>
                            <TouchableOpacity
                                activeOpacity={0.7}
                                style={[styles.keyBtn, CommonStyles.flex_center, { marginTop: 5, marginRight: 5 }]}
                                onPress={() => {
                                    if (keyValue.length < maxLength) {
                                        this.handleOnKeyPress(0)
                                    }
                                }}
                            >
                                <Text style={styles.keyBtnText}>{0}</Text>
                            </TouchableOpacity>
                            <TouchableOpacity
                                activeOpacity={0.7}
                                style={[styles.backspace, CommonStyles.flex_center]}
                                onPress={this.handleBackSpace}
                            >
                                <Image style={{ height: 35, width: 35 }} source={require('../images/back_gray.png')} />
                            </TouchableOpacity>
                        </View>
                    </View>
                </TouchableOpacity>
            </Modal>
        )
    }
}

const styles = StyleSheet.create({
    completeBtn: {
        color: '#222',
        fontWeight: '700',
        fontSize: 12,
    },
    completeBtn_disable: {
        color: '#666',
        fontWeight: '700',
        fontSize: 12,
    },
    modalContent: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        width,
        backgroundColor: '#d5d8dd',
        paddingBottom:CommonStyles.footerPadding
    },
    topBtnWrap: {
        paddingTop: 8,
        paddingHorizontal: 15,
        paddingBottom: 10,
    },
    keyBtn: {
        backgroundColor: '#fff',
        borderRadius: 5,
        // borderWidth: 1,
        // borderColor: '#f1f1f1',
        width: (width - 20) / 3,
        ...CommonStyles.shadowStyle,
        marginLeft: 5,
        marginBottom: 5,
    },
    keyBtnText: {
        fontSize: 26,
        color: '#222',
        paddingVertical: 10,
    },
    backspace: {
        // backgroundColor: '#fff',
        // borderRadius: 5,
        borderWidth: 1,
        borderColor: '#d5d8dd',
        width: (width - 20) / 3,
        // ...CommonStyles.shadowStyle,
        marginRight: 5,
        marginBottom: 5,
    },
})
