/**
 * 夺宝购物车支付成功
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
    BackHandler
} from 'react-native'
import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import { connect } from 'rn-dva'

const { width, height } = Dimensions.get('window')
const success = require('../../images/indianashopcart/Group.png')

function getwidth(val) {
    return width * val / 375
}
const localCode = global.regionCode;


class IndianaShopPay extends Component {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
      };
    _didFocusSubscription;
    _willBlurSubscription;
    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>{
            this.refreshRecommendGoods()
            BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
        });
    }
    componentDidMount () {
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
        );
        
    }

    componentWillUnmount () {
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }
    // 获取推荐商品
    refreshRecommendGoods = (page = 1, address = localCode) => {
        const { dispatch } = this.props;
        const params = {
            page,
            limit: 10,
            jCondition: { districtCode: address },
        };
        dispatch({ type: 'welfare/getGoodsRecommendGoodsList', payload: { params } });
        }
    onBackButtonPressAndroid = () => {
        this.props.navigation.navigate('WM')
        return true
    };
    render() {
        const { navigation } = this.props
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                            <Text style={{ fontSize: 17, color: '#fff' }}>兑奖成功</Text>
                        </View>
                    }
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                            >
                            </TouchableOpacity>
                        </View>
                    }
                />
                <View style={{ width: getwidth(355), justifyContent: 'center', alignItems: 'center', marginTop: 10, backgroundColor: '#fff', borderRadius: 8 }}>
                    <Image source={success} />
                    <Text style={{fontSize: 14,color: '#EE6161',paddingTop:15,paddingBottom:20,width,textAlign: 'center'}}>您已成功参与活动，请注意查看中奖结果！</Text>
                    <View
                        style={{ position: 'relative',width: getwidth(355), paddingVertical:15, ...CommonStyles.flex_between, borderTopColor: 'rgba(0,0,0,0.06)', borderTopWidth: 1,borderBottomLeftRadius: 9,borderBottomRightRadius: 8 }}
                    >
                        <TouchableOpacity
                            style={[styles.touchItem,styles.borderRight]}
                            onPress={() => {
                                navigation.navigate('WMOrderList')
                            }}
                        >
                            <Text style={{ color: '#4A90FA' }}>查看订单</Text>
                        </TouchableOpacity>
                        <TouchableOpacity style={[styles.touchItem,styles.borderLeft]} onPress={() => {
                            this.refreshRecommendGoods()
                            navigation.navigate('WM')
                        }}>
                            <Text style={{ color: '#4A90FA' }}>返回</Text>
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
    touchItem: {
        flex: 1,
        alignItems: 'center',
        // backgroundColor:'red'
    },
    borderLeft: {
        borderLeftWidth: 0.5,
        borderLeftColor: 'rgba(0,0,0,0.06)',
    },
    borderRight: {
        borderRightWidth: 0.5,
        borderRightColor: 'rgba(0,0,0,0.06)',
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

export default connect(
    (state) => ({ store: state }),
    (dispatch) => ({ dispatch })
)(IndianaShopPay)
