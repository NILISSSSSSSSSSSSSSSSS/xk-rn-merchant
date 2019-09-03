/**
 * Header
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    TouchableOpacity,
} from 'react-native';
import ImageView from './ImageView';
import CommonStyles from '../common/Styles';
import TextInputView from './TextInputView';
import Switch from './Switch'

export default class Line extends PureComponent {
    constructor(props) {
        super(props)
        this.state = {
        }
    }

    render() {
        const { activeOpacity,unit,onBlur,keyboardType,rightView, isInput, title, value, style, rightTextStyle,onPress, placeholder, type, styleInput, leftStyle, point, rightValueStyle, onChangeText, maxLength, secureTextEntry, leftView, editable } = this.props
        const Content = onPress ? TouchableOpacity : View
        let rightViewNow;
        switch (type) {
            case 'input': rightViewNow =
            <View style={[CommonStyles.flex_start,{flex:1}]}>
              <TextInputView
                inputView={styles.inputView}
                placeholder={placeholder}
                style={{ height: 20, color: '#222',...styleInput }}
                placeholderTextColor={'#ccc'}
                keyboardType={keyboardType}
                value={value}
                onChangeText={(data) => onChangeText(data)}
                maxLength={maxLength}
                secureTextEntry={secureTextEntry}
                editable={editable}
                onBlur={(data)=>{onBlur && onBlur(data)}}

            />
            {
              unit?<Text style={{color:'#222',marginLeft:7}}>{unit}</Text>:null
            }
            </View>
            ; break;
            case 'horizontal': rightViewNow = <View style={[styles.row, rightValueStyle]}>
                <Text style={[{ color: '#222', fontSize: 14 },rightTextStyle]}>{value}</Text>
                <ImageView
                    source={require('../images/index/expand.png')}
                    sourceWidth={14}
                    sourceHeight={14}
                />
            </View>; break;
            case 'switch': rightViewNow =
                <View style={{ flex: 1, alignItems: 'flex-end' }}>
                    <Switch
                        value={value}
                        onChangeState={(data) => onChangeText(data)}
                    />
                </View>
                ; break;
            case 'custom': rightViewNow = rightView; break;
            default: rightViewNow =value? <Text style={[styles.lineRightTitle, rightValueStyle, rightTextStyle]}>{value}</Text>:null

        }
        return (
            <Content activeOpacity={activeOpacity || 0.7} onPress={() => onPress ? onPress() : null} style={[styles.line, { justifyContent: onPress ? 'space-between' : 'flex-start' }, style]}>
                {
                    leftView ? leftView :
                        <Text style={[styles.contentTopText, leftStyle]}>
                            {isInput ? <Text style={styles.important}>*</Text> : null}
                            {title}{point === null ? null : ': '}
                        </Text>
                }

                {
                    rightViewNow
                }
                {this.props.children}
            </Content>
        );
    }
};

const { width, height } = Dimensions.get('window');
const styles = StyleSheet.create({
    line: {
        flexDirection: 'row',
        alignItems: 'center',
        // height: 50,
        paddingVertical: 18,
        paddingLeft: 15,
        paddingRight: 15,
        borderColor: '#F1F1F1',
        borderBottomWidth: 1
    },
    lineRightTitle: {
        color: '#222',
        fontSize: 14,
        flex: 1,
        marginLeft: 10
    },
    contentTopText: {
        fontSize: 14,
        marginRight:10,
        color: '#222222',
        position: 'relative'
    },
    inputView: {
        flex: 1,
        marginLeft: 10
    },
    row: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        marginLeft: 10
    },
    important: {
        color: CommonStyles.globalRedColor,
        top: 0,
        left: -10,
        position: 'absolute'
    }
});
