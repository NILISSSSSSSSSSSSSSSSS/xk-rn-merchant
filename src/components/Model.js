
/**
 * React Native App
 * dongtao 2017/04/22
 * @flow
 */

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    Modal,
    PixelRatio,
    View,
    TouchableOpacity,
    Dimensions
} from 'react-native';
import CommonStyles from '../common/Styles';

const { width, height } = Dimensions.get('window');
export default class ModalDemo extends Component {

    constructor(props) {
        super(props);//这一句不能省略，照抄即可
        this.state = {
            animationType: 'fade',//none slide fade
            transparent: true,//是否透明显示
        };
    }
    static defaultProps = {
        fliterWrap: {},
        containerStyle: {}
    }
    render() {
        let modalBackgroundStyle = {
            backgroundColor: this.state.transparent ? 'rgba(0, 0, 0, 0.5)' : CommonStyles.globalRedColor,
        };
        let innerContainerTransparentStyle = this.state.transparent
            ? { backgroundColor: '#fff', paddingTop: 20 }
            : null;
        const { noTitle = false, title, visible, onShow, onConfirm, onClose, type, confirmText, btnText ,titleStyle,fliterWrapStyle,containerStyle} = this.props //type为类型，confirm表示选择操作，alert表示提醒
        return (
            <Modal
                animationType={this.state.animationType}
                transparent={this.state.transparent}
                visible={visible}
                style={{ width: width - 105 }}
                onRequestClose={onClose}
                onShow={this.startShow}
            >
                <View style={[styles.container, modalBackgroundStyle,fliterWrapStyle,containerStyle]}>
                    <View style={[styles.innerContainer, innerContainerTransparentStyle]}>
                        { // 如果不要title，传入notitle = true，不传或者为false都会显示
                            noTitle ? null : <Text style={styles.title}>{confirmText || '提示'}</Text>
                        }
                        <Text style={[styles.title2,titleStyle]}>{title}</Text>
                        {
                            type == 'confirm' ?
                                <View style={styles.row}>
                                    <TouchableOpacity style={styles.btn} onPress={() => onClose()}>
                                        <Text style={styles.btn_text}>{this.props.leftBtnText || '否'}</Text>
                                    </TouchableOpacity>
                                    <TouchableOpacity onPress={() => onConfirm()} style={[styles.btn, { borderColor: '#F1F1F1', borderLeftWidth: 1 }]}>
                                        <Text style={styles.btn_text}>{this.props.rightBtnText || '是'}</Text>
                                    </TouchableOpacity>
                                </View> :
                                <TouchableOpacity onPress={() => onConfirm()} style={[styles.but, styles.button]}>
                                    {/* btnText是一个按钮的时候的文本，不传入则默认为完成 */}
                                    <Text style={{ color: '#fff', fontSize: 17, textAlign: 'center', lineHeight: 35 }}>{btnText ? btnText : '完成'}</Text>
                                </TouchableOpacity>
                        }


                    </View>
                </View>
            </Modal>
        );
    }


    startShow = () => {
        // alert('开始显示了');
    }




}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        padding: 40,
    },
    innerContainer: {
        borderRadius: 10,
        alignItems: 'center',
        paddingHorizontal: 10
    },
    title: {
        color: '#030303',
        fontSize: 17
    },
    title2: {
        color: '#030303',
        fontSize: 13,
        marginTop: 10,
        marginBottom: 16,
        marginTop: 25,

        textAlign: 'center'
    },
    row: {
        alignItems: 'center',
        width: '100%',
        flexDirection: 'row',
        marginTop: 20,
        borderColor: '#F1F1F1',
        borderTopWidth: 1
    },
    btn: {
        width: '50%',
        height: 40,
    },
    button: {
        backgroundColor: '#4A90FA',
        borderRadius: 8,
        width: '80%',
        marginBottom: 20
    },
    btn_text: {
        textAlign: 'center',
        color: '#4A90FA',
        fontSize: 17,
        lineHeight: 40
    },
})
