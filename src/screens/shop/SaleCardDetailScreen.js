/**
 * 首页/促销管理/会员卡详情
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
    TouchableOpacity
} from 'react-native';
import { connect } from 'rn-dva';
import math from '../../config/math.js';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import CommonButton from '../../components/CommonButton';
import Model from '../../components/Model';
import { NavigationPureComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');
const refundsList = [
    { title: '消费前随时退', key: 'CONSUME_BEFORE' },
    { title: '预约时间前指定时间内可退', key: 'RESERVATION_BEFORE_BYTIME' },
    { title: '预定时间前随时退', key: 'RESERVATION_BEFORE' },
]

class SaleCardDetailScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        const { currentData, page, type, opretaIndex, currentShop,listName,callback } = this.props.navigation.state.params || {}
        this.state = {
            valuableTime: '2018-03-12',
            endTime: '2018-03-22',
            modelVisible: false,
            currentData: currentData || {},
            page,
            listName,
            opretaIndex,
            callback,
            ticketDetail: {
                codes: [],
                goods: []
            },//优惠券详情
            currentShop: currentShop || {},
        }
    }

    blurState = {
        modelVisible: false,
    }

    componentDidMount() {
        const { currentData, page } = this.state
        let func = this.state.page == 'card' ? requestApi.mUserCardMemberDetail : requestApi.mUserCardCouponDetail
        Loading.show()
        func({ id: currentData.id }).then((res) => {
            Loading.hide()
            res ? this.setState({ ticketDetail: res }) : null
        }).catch(() => {
            Loading.hide()
        })
    }

    delete = () => {
        const { user } = this.props
        const {listName,callback}=this.state
        const params = {
            id: this.state.currentData.id,
            shopId: this.state.currentShop.id,
            updateId: user.id,
            userId: user.id
        }
        let func = this.state.page == 'card' ? requestApi.mUserCardMemberDelete : requestApi.mUserCardCouponDelete
        func(params).then((res) => {
            this.setState({
                modelVisible: false,
                currentData: {
                    ...this.state.currentData,
                    cardStatus: 'OVERDUE',
                    status: '已作废'
                }
            })
            Toast.show('操作成功')
            callback && callback()
        }).catch(()=>{
          
        });
    }
    renderCate = (item, index) => {
        return (
            <View style={[styles.item, { borderBottomWidth: 1 }]} key={index}>
                <Text style={{ color: '#222', fontSize: 14 }}>一级分类：{item && item.name1 || ''}</Text>
                <Text style={{ color: '#777', fontSize: 14 }}>二级分类：{item && item.name2 || ''}</Text>
            </View>
        )
    }
    renderGoods = (item, index) => {
        return (
            <TouchableOpacity style={[styles.item, { borderBottomWidth: 1 }]} key={index} onPress={() => this.props.navigation.navigate('GoodsDetail', {
                id: item.code,
                currentShop: this.state.currentShop,
                refundsList,
                canEdit: false,
                callback: () => { }
            })}>
                <View>
                    <Text style={[styles.title, { marginBottom: 8 }]}>商品编号{item.code}</Text>
                    <View style={styles.fanweiItem}>
                        <ImageView
                            source={{ uri: item.bcleGoodsPic }}
                            sourceWidth={60}
                            sourceHeight={60}
                            style={{ marginRight: 10, borderRadius: 8 }}
                        />
                        <View style={{ flex: 1 }}>
                            <Text style={[styles.title, { fontSize: 12 }]}>{item.bcleGoodsName}</Text>
                            <Text style={[styles.title, { fontSize: 10, marginTop: 13 }]}>一级分类:{item.name1 && item.name1.name}</Text>
                            <Text style={[styles.title, { fontSize: 10, marginTop: 3 }]}>二级分类:{item.name2 && item.name2.name}</Text>
                        </View>


                    </View>
                </View>

                <ImageView
                    source={require('../../images/index/expand.png')}
                    sourceWidth={14}
                    sourceHeight={14}
                    style={{ marginTop: 2 }}
                />

            </TouchableOpacity>
        )
    }
    render() {
        const { navigation} = this.props;
        const { page, currentData, ticketDetail, currentShop } = this.state
        console.log(page, currentData, ticketDetail)
        const items = [
            { title: '编号', value: currentData.id },
            { title: '状态', value: currentData.status },
            { title: '总量', value: currentData.totalNum },
            { title: '已领', value: currentData.num, type: 'horizontal', onPress: () => navigation.navigate('SaleUseDetails', { page: page, currentData: currentData, currentShop }) },
            { title: '生效时间', value: currentData.startTime },
            { title: '结束时间', value: currentData.endTime },
        ]
        if (page == 'ticket') {
            items.splice(2, 0, { title: '类型', value: currentData.ticketype });
            switch (currentData.couponType) {
                case 'DISCOUNT': items.splice(3, 0, { title: '折扣', value: (math.divide(ticketDetail.discount,100) || '' )+ '折' }); break;
                case 'DEDUCTION': items.splice(3, 0, { title: '抵扣', value: (math.divide(ticketDetail.deductionMoney,100) || '') + '元' }); break;
                case 'FULL_SUB': items.splice(3, 0, { title: '满减', value: '满' + (math.divide(ticketDetail.fulMoney,100) || '') + '减' + (parseFloat(ticketDetail.subMoney)/100 || '')  }); break;
                default: break;
            }
        }
        else {
            items.splice(2, 0, { title: '折扣', value: (math.divide(currentData.discount,100)  || '') + '折' });
        }
        // if(ticketDetail.cardAnchors && ticketDetail.cardAnchors.length>0){
        //     items.push({
        //         title:'卡券分配设置',
        //         type:'horizontal',
        //         onPress:()=>navigation.navigate('SaleDistribution',{anchors:ticketDetail.cardAnchors})
        //     })
        // }

        return (
            <View style={styles.container}>
                <Header
                    title={page == 'card' ? '会员卡详情' : '优惠券详情'}
                    navigation={navigation}
                    goBack={true}
                    rightView={
                        currentData.status == '生效中' || currentData.status == '待生效' ?
                            <TouchableOpacity
                                onPress={() => this.setState({ modelVisible: true })}
                                style={{ width: 50 }}
                            >
                                <Text style={{ fontSize: 17, color: '#fff' }}>作废</Text>
                            </TouchableOpacity> : null
                    }

                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        <Content>
                            {
                                items.map((item, index) => {
                                    return (
                                        <Line
                                            key={index}
                                            title={item.title}
                                            type={item.type}
                                            rightValueStyle={{ textAlign: 'right' }}
                                            point={null}
                                            value={item.value}
                                            onPress={item.onPress ? () => item.onPress() : null}

                                        />
                                    )
                                })
                            }


                        </Content>
                        {
                            page == 'card' || (page == 'tickets' && currentData.fanwei == '全部') ? null :
                                <Content>
                                    <Line title='范围' value={currentData.fanwei} point={null} rightValueStyle={{ textAlign: 'right' }} />
                                    {
                                        currentData.fanwei == '单品' ? ticketDetail.goods.map((item, index) => this.renderGoods(item, index)
                                        ) : ticketDetail.codes.map((item, index) => this.renderCate(item, index)
                                        )
                                    }
                                </Content>

                        }


                    </View>

                </ScrollView>
                <Model
                    type={'confirm'}
                    title={'确定要作废？'}
                    confirmText='作废后该卡无法恢复'
                    visible={this.state.modelVisible}
                    onShow={() => this.setState({ modelVisible: true })}
                    onConfirm={() => this.delete()}
                    onClose={() => this.setState({ modelVisible: false })}
                />
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    content: {
        alignItems: 'center',
        paddingBottom: 10
    },
    item: {
        padding: 15,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        borderBottomWidth: 1,
        borderColor: '#F1F1F1'

    },
    fanweiItem: {
        flexDirection: 'row',
        alignItems: 'center',
        width: width - 100

    },
    title: {
        color: '#222222',
        fontSize: 14
    }



});

export default connect(
    (state) => ({
        user:state.user.user || {},
     })
)(SaleCardDetailScreen);
