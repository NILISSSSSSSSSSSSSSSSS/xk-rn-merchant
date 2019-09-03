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

export default class CommonButton extends PureComponent {
    static defaultProps = {
        title: '',
        style: {},
        onPress: () => {},
        textStyle: {},
        activeOpacity: 0.65
    }
    constructor(props) {
        super(props)
        this.state = {
        }
    }

    render() {
        const { title, style, onPress, textStyle, activeOpacity } = this.props
        return (
            <TouchableOpacity onPress={() => onPress ? onPress() : null} style={[styles.bottonView, style]} activeOpacity={activeOpacity}>
                <Text style={[styles.text, textStyle]}>{title} </Text>
            </TouchableOpacity>
        );
    }
};

const { width, height } = Dimensions.get('window');
const styles = StyleSheet.create({
    bottonView: {
        backgroundColor: CommonStyles.globalHeaderColor,
        width: width - 20,
        height: 44,
        alignItems: 'center',
        justifyContent:'center',
        borderRadius: 10,
        marginTop: 20,
        borderColor: CommonStyles.globalHeaderColor,
        borderWidth: 1,
        marginBottom:CommonStyles.footerPadding
    },
    text: {
        color: '#fff',
        fontSize: 17,
        width: '100%',
        textAlign: 'center'
    }
});
