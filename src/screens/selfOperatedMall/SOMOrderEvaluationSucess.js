/**
 * 自营商城订单评价成功
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity,
    BackHandler,
} from 'react-native'
import CommonStyles from '../../common/Styles'
import Header from '../../components/Header'
import { NavigationComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');
export default class SOMOrderEvaluationSucess extends NavigationComponent {
    _didFocusSubscription;
    _willBlurSubscription;
    constructor(props) {
        super(props);

    }
    screenWillFocus () {
        this._didFocusSubscription = this.props.navigation.addListener('willFocus', payload =>{
            BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
        });
    }
    screenWillBlur () {
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
                BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
        );
    }
    onBackButtonPressAndroid = () => {
        this.props.navigation.navigate('SOMOrder')
        return true
    };
    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }
    render() {
        const { navigation } = this.props
        let payFailed = false
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                            <Text style={{ fontSize: 17, color: '#fff' }}>评价成功</Text>
                        </View>
                    }
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    let callback = navigation.getParam('callback', () => { })
                                    callback()
                                    navigation.navigate('SOMOrder')
                                }}
                            >
                                <Image source={require('../../images/mall/goback.png')} />
                            </TouchableOpacity>
                        </View>
                    }
                />
                <View style={styles.view1}>
                    <View style={styles.view1_item1}>
                        {
                            payFailed ?
                                <Image style={styles.view1_item1_img} source={require('../../images/mall/pay_failed.png')} /> :
                                <Image style={styles.view1_item1_img} source={require('../../images/mall/pay_success.png')} />
                        }
                    </View>
                    <Text style={styles.view1_text1}>
                        评价成功
                    </Text>
                    <View style={styles.view1_item2}>
                        <TouchableOpacity
                            style={styles.v1_i2_item1}
                            onPress={() => {
                                let callback = navigation.getParam('callback', () => { })
                                callback()
                                navigation.navigate('SOMOrder')
                            }}
                        >
                            <Text style={styles.v1_i2_text1}>返回订单页</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={styles.v1_i2_item1}
                            onPress={() => {
                                let callback = navigation.getParam('callback', () => { })
                                callback()
                                this.props.navigation.navigate('SOMGoodsComments', { goodsId: navigation.getParam('goodsId', ''), callback, routerIn: 'orderEvaluation' });

                                // navigation.navigate('SOM');
                            }}
                        >
                            <Text style={styles.v1_i2_text1}>查看评价</Text>
                        </TouchableOpacity>
                    </View>
                </View>
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
    view1: {
        width: width - 20,
        height: 223,
        margin: 10,
        borderRadius: 6,
        backgroundColor: '#fff',
        alignItems: 'center',
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
        width: '80%',
        height: 30,
        marginTop: 38,
        paddingHorizontal: 15
    },
    v1_i2_item1: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        width: 115,
        // marginRight: 15,
        borderWidth: 1,
        borderColor: '#999',
        borderRadius: 4,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        // position: 'absolute'
    },
    left: {
        width: 50
    },
})
