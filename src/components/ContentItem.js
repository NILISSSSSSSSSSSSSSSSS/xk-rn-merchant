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
import CommonStyles from '../common/Styles';

export default class Content extends PureComponent {
    constructor(props) {
        super(props)
        this.state = {
        }
    }

    render() {
        const {style,onPress,activeOpacity}=this.props
        return (
            // <TouchableOpacity disabled={this.props.onPress?false:true} style={CommonStyles.shadowStyle} onPress={() => this.props.onPress ? this.props.onPress() : null}>
            //     <View style={[styles.contentItem,{borderRadius: 10,overflow:'hidden',backgroundColor: '#fff',}, this.props.style,]}>
            //         {this.props.children}
            //     </View>
            // </TouchableOpacity>
            <TouchableOpacity activeOpacity={activeOpacity || 0} disabled={onPress?false:true} style={[styles.contentItem,style]} onPress={() => onPress ? onPress() : null}>
                {this.props.children}
            </TouchableOpacity>
        );
    }
};

const { width, height } = Dimensions.get('window');
const styles = StyleSheet.create({
    contentItem: {
        // ...CommonStyles.shadowStyle,
        width: width - 20,
        marginTop: 10,
        borderRadius: 6,
        // overflow:'hidden',
        backgroundColor: '#fff'
        // borderWidth:1
    },
});
