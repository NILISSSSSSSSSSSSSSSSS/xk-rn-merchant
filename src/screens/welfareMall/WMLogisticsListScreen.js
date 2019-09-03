// 福利商城 物流信息
/**
 * 物流追踪
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import * as requestApi from '../../config/requestApi'
import { getLogisticsInfo } from '../../config/utils'

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import moment from 'moment'
const { width, height } = Dimensions.get("window");
class WMLogisticsListScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            orderId: props.navigation.getParam('orderId', ''),
            orderType: props.navigation.getParam('orderType', 'NORMAL'),
            orderDdata: {
                orderId: props.navigation.getParam('orderId', '')
            },
            logisticsData: {
                companyName: '',
                id: '',
                list: []
            }
        }
    }

    componentDidMount() {
        this.getListData()
    }

    componentWillUnmount() {
    }
    getListData = () => {
        Loading.show();
        const { orderId, orderType } = this.state
        requestApi.logisticsQuery(
            {
                orderId,
                xkModule: 'jf_mall',
                logisticsType: 'PLATFORM',
                orderType
            }
        ).then(res => {
            console.log('物流信息', res)
            this.setState({
                logisticsData: res || this.state.logisticsData,
            })
        }).catch(err => {
            console.log(err)
        })
    }
    render() {
        const { navigation, store } = this.props;
        const { orderDdata, logisticsData} = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"物流追踪"}
                />

                <ScrollView
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                >
                    <View style={styles.infoWrap}>
                        <Text style={[styles.topInfoItemText, { marginTop: 0 }]}>
                            订单编号：{orderDdata.orderId}
                        </Text>
                        <Text style={[styles.topInfoItemText]}>
                            快递公司：{getLogisticsInfo(logisticsData.companyName)}
                        </Text>
                        <Text style={[styles.topInfoItemText]}>
                            快递单号：{logisticsData.number}
                        </Text>
                    </View>
                    <View style={[styles.refundInfoProcess, styles.flex_start]}>
                        <View style={[styles.refundInfoProcessLine,(logisticsData.list!== null && logisticsData.list.length !== 0) ? {minHeight: 230}:null]}>
                            {
                                logisticsData.list!== null && logisticsData.list.length !== 0
                                ? logisticsData.list.map((item, index) => {
                                    let refundInfoProcessActiveText = index === 0 ? styles.refundInfoProcessActiveText : {}
                                    let margigTop = index === 0 ? {} : { marginTop: 25 }
                                    return (
                                        <View style={[styles.flex_start_noCenter, margigTop]} key={index}>
                                            <View style={styles.refundInfoProcessCircle} />
                                            <View style={styles.flex_1}>
                                                {
                                                    index === 0 &&
                                                    <View style={[styles.flex_start, styles.carIconView]}>
                                                        <Image source={require('../../images/order/logistics.png')} />
                                                        <Text style={[styles.refundInfoProcessActiveText, { paddingLeft: 5 }]}>运送中</Text>
                                                    </View>
                                                }
                                                <Text style={[styles.refundInfoProcessText, refundInfoProcessActiveText]}>{item.location}</Text>
                                                <Text style={styles.refundInfoProcessSmallText}>{moment(item.time * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                                            </View>
                                        </View>
                                    )
                                })
                                : <Text style={{fontSize: 16,color: '#555',textAlign: 'center'}}>
                                    暂无物流信息
                                </Text>
                            }

                        </View>
                    </View>
                </ScrollView>

            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    flex_center: {
        justifyContent: 'center',
        alignItems: 'center'
    },
    flex_start: {
        justifyContent: 'flex-start',
        flexDirection: 'row',
        alignItems: 'center'
    },
    flex_start_noCenter: {
        justifyContent: 'flex-start',
        flexDirection: 'row',
    },
    flex_between: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    flex_1: {
        flex: 1
    },
    infoWrap: {
        margin: 10,
        backgroundColor: '#fff',
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)',
        borderRadius: 6,
        padding: 15,
    },
    topInfoItemText: {
        marginTop: 6,
        fontSize: 14,
        color: '#222',
    },
    refundInfoProcess: {
        borderRadius: 6,
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)',
        margin: 10,
        marginTop: 0,
        padding: 15,
        backgroundColor: '#fff'
    },
    refundInfoProcessLine: {
        flex: 1,
        borderLeftColor: '#D8D8D8',
        borderLeftWidth: 1,
    },
    refundInfoProcessCircle: {
        width: 8,
        height: 8,
        backgroundColor: '#4A90FA',
        borderRadius: 8,
        position: 'relative',
        left: -4,
        top: 0,
        marginRight: 7
    },
    refundInfoProcessText: {
        fontSize: 12,
        color: '#999',
        lineHeight: 18
    },
    refundInfoProcessActiveText: {
        color: '#222',
        fontSize: 12,
        lineHeight: 18
    },
    refundInfoProcessSmallText: {
        fontSize: 12,
        color: '#999',
        marginTop: 2
    },
    carIconView: {
        position: 'relative',
        top: -4,
        left: 0
    },
});

export default connect(
    state => ({ store: state })
)(WMLogisticsListScreen);
