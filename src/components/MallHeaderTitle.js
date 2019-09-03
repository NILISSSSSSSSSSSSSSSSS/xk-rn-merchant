/**
 * 商城头部导航
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    Platform,
    TouchableOpacity,
} from 'react-native';
import CommonStyles from "../common/Styles";

export default class MallHeaderTitle extends PureComponent {
    static defaultProps = {
        data: []
    }
    render () {
        const { data } = this.props
        return (
            <View style={[CommonStyles.flex_end]}>
                {
                    data.map((item,index) => {
                        let style = {}
                        if (index === data.length - 2) {
                            style={
                                marginRight: 9
                            }
                        }
                        if (index === data.length - 3) {
                            style={
                                marginRight: 9
                            }
                        }
                        return (
                            <TouchableOpacity
                            style={[styles.itemWrap,style]}
                            key={index}
                            onPress={() => {
                                item.onPress()
                            }}>
                                <Image source={item.icon} />
                            </TouchableOpacity>
                        )
                    })
                }

            </View>
        )
    }
}
const styles = StyleSheet.create({
    itemWrap: {
        marginRight: 15
    },
})
