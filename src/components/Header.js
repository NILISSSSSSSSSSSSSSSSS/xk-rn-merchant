/**
 * Header
 * https://reactnavigation.org/docs/en/connecting-navigation-prop.html
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
import { withNavigation } from 'react-navigation';
import CommonStyles from '../common/Styles';

class Header extends PureComponent {
    render() {
        /**
         * @param leftView
         * @param goBack 是否需要返回按钮
         * @param title 中间的标题
         * @param centerView
         * @param rightView
         */
        const { navigation, headerStyle, leftView, goBack, onBack, titleTextStyle, title, centerView, rightView, backStyle } = this.props;

        return (
            <View style={[styles.headerView, headerStyle]}>
                {
                    leftView ?
                        leftView :
                        goBack ?
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                        navigation.goBack();
                                        if(onBack) onBack();
                                    }
                                }
                            >
                                <Image style={[styles.backStyle, backStyle]} source={require('../images/header/back.png')} />
                            </TouchableOpacity> :
                            <View style={[styles.headerItem, styles.left]}></View>
                }
                <View style={[styles.headerItem, styles.center]}>
                    {
                        title ?
                            <Text style={[styles.titleText, titleTextStyle]}>{title}</Text> :
                            null
                    }
                    {
                        centerView ?
                            centerView :
                            null
                    }
                </View>
                {
                    rightView ?
                        rightView :
                        <View style={[styles.headerItem, styles.left]}></View>
                }
            </View>
        );
    }
};

const { width, height } = Dimensions.get('window');
const styles = StyleSheet.create({
    headerView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        width: width,
        height: 44 + CommonStyles.headerPadding,
        paddingTop: CommonStyles.headerPadding,
        backgroundColor: CommonStyles.globalHeaderColor,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    left: {
        width: 50
    },
    center: {
        flex: 1,
    },
    titleText: {
        fontSize: 17,
        color: '#fff',
    },
    backStyle: {
        tintColor: 'white'
    }
});

export default withNavigation(Header);
