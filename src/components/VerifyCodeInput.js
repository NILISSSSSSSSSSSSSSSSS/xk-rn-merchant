// 验证码输入，密码输入组件
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TextInput,
    Keyboard,
    TouchableOpacity
} from "react-native";
import CommonStyles from "../common/Styles";
export default class VerifyCodeInput extends Component {
    static defaultProps = {
        secureTextEntry: true, // 安全模式
        callback: () => { }, // 输入完成后 回调
    }
    inputRefrr
    state = {
        inputValue: ['', '', '', '', '', ''],
        secureValue: ['', '', '', '', '', '']
    }
    handleInputVerify = (text) => {
        let inputValue = JSON.parse(JSON.stringify(this.state.inputValue));
        let secureValue = JSON.parse(JSON.stringify(this.state.secureValue));
        const { callback } = this.props
        let arr = text.split('');
        console.log('arr', arr)
        for (let i = 0; i < inputValue.length; i++) {
            if (i <= arr.length - 1) {
                secureValue[i] = '*'
                inputValue[i] = arr[i]
            } else {
                secureValue[i] = ''
                inputValue[i] = ''
            }
        }
        this.setState({
            inputValue,
            secureValue,
        }, () => {
            if (inputValue.join('').length === 6) {
                Keyboard.dismiss();
                callback(inputValue.join(''))
            }
        })
    }
    render() {
        const { inputValue, secureValue } = this.state
        const { secureTextEntry } = this.props
        // 安全模式则显示安全文本
        let showText = (secureTextEntry) ? secureValue : inputValue
        console.log('showText', showText)
        return (
            <View style={[{ paddingHorizontal: 40 }]}>
                <TextInput
                    autoFocus={true}
                    caretHidden={true}
                    keyboardType='numeric'
                    ref={(ref) => { this.inputRef = ref }}
                    maxLength={6}
                    value={inputValue.join('')}
                    style={styles.textInput}
                    secureTextEntry={secureTextEntry}
                    onChangeText={(text) => {
                        if (text.length > 6) { // 长度为6
                            return
                        }
                        if (!(/^[0-9]*$/.test(text))) { // 只能数字
                            return
                        }
                        this.handleInputVerify(text)
                    }}
                />
                <TouchableOpacity
                    activeOpacity={1}
                    style={[CommonStyles.flex_between]}
                    onPress={() => {
                        console.log(this.inputRef.isFocused())
                        if (!this.inputRef.isFocused())
                            this.inputRef.focus()
                        else this.inputRef.blur();
                    }}
                >
                    {
                        showText.map((item, index) => {

                            return (
                                <Text key={index} style={[styles.verifyCode, (item) ? styles.textActive : {}]}>{item}</Text>
                            )
                        })
                    }
                </TouchableOpacity>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    textInput: {
        color: 'transparent',
        position: 'absolute',
        left: 40,
        right: 40,
        height: 40,
    },
    verifyCode: {
        borderColor: '#f1f1f1',
        borderWidth: 1,
        fontSize: 21,
        color: '#222',
        height: 40,
        lineHeight: 42,
        width: 35,
        textAlign: 'center',
    },
    textActive: {
        borderColor: '#ccc'
    },
})
