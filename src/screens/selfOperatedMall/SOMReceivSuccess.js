/**
 * 收货成功
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    TouchableOpacity,
    Image,
    BackHandler
} from 'react-native';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import actions from '../../action/actions';
import { StackActions, NavigationActions } from "react-navigation";

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
const { width, height } = Dimensions.get('window');
import { NavigationComponent } from '../../common/NavigationComponent';

const createResetAction = (routeName, params) => {
    return StackActions.reset({
        index: 0,
        actions: [NavigationActions.navigate({ routeName, params })]
    });
};
class SOMReceivSuccess extends NavigationComponent {
    static navigationOptions = {
        header: null,
    }
    _didFocusSubscription;
    _willBlurSubscription;
    constructor(props) {
        super(props)

        this.state = {
        }
    }
    screenDidFocus () {
        this._didFocusSubscription = this.props.navigation.addListener('didFocus', payload =>{
            BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
        });
    }
    screenWillBlur () {
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
        );
    }
    componentDidMount () {

    }
    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }
    onBackButtonPressAndroid = () => {
        const { navigation } = this.props
        let callback = navigation.getParam('callback', () => { })
        navigation.navigate('SOMOrder')
        callback();
        return true
    };
    render() {
        const { navigation, store } = this.props;
        let callback = navigation.getParam('callback', () => { })
        let orderData = navigation.getParam('orderData', {})
        const routerIn = navigation.getParam('routerIn', '')
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='交易完成'
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    if (routerIn === 'SOMOrderDetail') {
                                        navigation.dispatch(createResetAction("SOMOrder", { tabsIndex: 2 }));
                                    } else {
                                        navigation.navigate("SOMOrder");
                                    }
                                    callback();
                                }}
                            >
                                <Image
                                    source={require("../../images/mall/goback.png")}
                                />
                            </TouchableOpacity>
                        </View>
                    }
                />

                <View style={styles.view1}>
                    <View style={styles.view1_item1}>
                        <Image style={styles.view1_item1_img} source={require('../../images/mall/pay_success.png')} />
                    </View>
                    <Text style={styles.view1_text1}>交易成功</Text>
                    <View style={styles.view1_item2}>
                        <TouchableOpacity
                            style={styles.v1_i2_item1}
                            onPress={() => {
                                callback()
                                navigation.navigate('SOMOrder')
                            }}
                        >
                            <Text style={styles.v1_i2_text1}>返回订单页</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={styles.v1_i2_item1}
                            onPress={() => {
                                navigation.navigate('SOMOrderEvaluation', { orderData });
                            }}
                        >
                            <Text style={styles.v1_i2_text1}>立即评价</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%"
    },
    color_red: {
        color: '#EE6161'
    },
    view1: {
        width: width - 20,
        height: 223,
        margin: 10,
        borderRadius: 6,
        backgroundColor: '#fff',
        // ...CommonStyles.shadowStyle,
    },
    view1_item1: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 30,
    },
    view1_item1_img: {
        width: 66,
        height: 66,
    },
    view1_text1: {
        fontSize: 17,
        color: '#222',
        textAlign: 'center',
        marginTop: 16,
    },
    view1_item2: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: 30,
        marginTop: 38,
        paddingLeft: 15,
    },
    v1_i2_item1: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        flex: 1,
        height: '100%',
        marginRight: 15,
        borderWidth: 1,
        borderColor: '#999',
        borderRadius: 4,
    },
    v1_i2_text1: {
        fontSize: 14,
        color: '#999',
    },
    v1_i2_item2: {
        borderColor: '#4A90FA',
    },
    v1_i2_text2: {
        color: '#4A90FA',
    },
    view2: {
        marginTop: 0,
        paddingBottom: CommonStyles.footerPadding,
        borderRadius: 8,
    },
    v2_item1: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        height: 32,
        paddingHorizontal: 10,
    },
    v2_text1: {
        fontSize: 14,
        color: '#222',
    },
    content_ord: {
        flexDirection: 'row',
        width: '100%',
        height: 99,
        paddingVertical: 15,
        paddingHorizontal: 10,
        borderTopWidth: 1,
        borderTopColor: '#F1F1F1',
    },
    item_shop_imgView: {
        width: 70,
        height: 70,
        borderWidth: 1,
        borderColor: '#F1F1F1',
        borderRadius: 10,
    },
    item_shop_img: {
        width: '100%',
        height: '100%',
    },
    item_shop_other: {
        flex: 1,
        marginLeft: 10,
    },
    item_shop_titleView: {
        height: 36,
    },
    item_shop_title: {
        fontSize: 14,
        color: '#222',
    },
    item_shop_guige: {
        fontSize: 12,
        color: '#999',
        marginTop: 10,
    },
    item_shop_price1: {
        marginTop: 0,
    },
    item_shop_price2: {
        fontSize: 12,
        color: '#101010',
    },
    left: {
        width: 50
    }
});

export default connect(
    (state) => ({ store: state }),
    (dispatch) => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMReceivSuccess);
