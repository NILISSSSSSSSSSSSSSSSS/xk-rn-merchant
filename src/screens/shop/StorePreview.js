/**
 * 店铺预览
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
    Switch
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import * as nativeApi from '../../config/nativeApi';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
const { width, height } = Dimensions.get('window');
// import Swiper from "react-native-swiper";
import CarouselSwiper from '../../components/CarouselSwiper';

export default class StorePreview extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        const params = this.props.navigation.state.params || {}
        this.state = {
            currentShop: params.currentShop || {},
            timeItems: params.timeItems || [],
            minMoney: params.minMoney || 0,
            maxMoney: params.maxMoney || 0,
            avgConsumption:params.avgConsumption || 0,
        }
    }

    componentDidMount() {
        // const params = this.props.navigation.state.params || {}
        // this.setState({
        //     currentShop: params.currentShop || {},
        //     timeItems: params.timeItems || [],
        //     minMoney: params.minMoney || 0,
        //     maxMoney: params.maxMoney || 0
        // })
    }

    componentWillUnmount() {

    }

    render() {
        const { navigation } = this.props;
        const { currentShop, minMoney, maxMoney ,avgConsumption} = this.state
        const detail = currentShop.detail || {}
        console.log(detail)
        return (
            <View style={styles.container}>
                <Header
                    title='商家详情'
                    navigation={navigation}
                    goBack={true}
                />
                <ScrollView alwaysBounceVertical={false}>
                    <View style={styles.content}>
                        <Content style={{overflow:'hidden'}}>
                            {
                                detail && detail.pictures ?
                                <CarouselSwiper
                                    key={detail.pictures.length}
                                    style={styles.bannerView}
                                    loop={true}
                                    autoplay={true}
                                    onPageChanged={(index) => {
                                        // this.setState({ bannerIndex: index })
                                    }}
                                    index={0}
                                    autoplayTimeout={5000}
                                    showsPageIndicator={true}
                                    pageIndicatorStyle={styles.banner_dot}
                                    activePageIndicatorStyle={styles.banner_activeDot}
                                >
                                {
                                    detail.pictures.map((item, index) => {
                                        return (
                                            <ImageView
                                                key={index}
                                                source={{ uri: item || '' }}
                                                sourceWidth={width - 20}
                                                sourceHeight={150}
                                                resizeMode='cover'
                                            />
                                        );
                                    })
                                }
                                </CarouselSwiper> : <View style={styles.bannerView}></View>
                            }
                            <View style={styles.topTopItem}>
                                <Text style={styles.storeName}>{detail.name}</Text>
                                <Text style={styles.text}>
                                    <Text style={{ color: '#EE6161' }}>{"★★★★★☆☆☆☆☆".slice(5, 10)} </Text>
                                    0分 | ¥{avgConsumption}/人
                                    </Text>
                                <View></View>
                            </View>
                            <View style={styles.topTopItem}>
                                <View style={styles.row}>
                                    <Image source={require('../../images/shop/address.png')} style={{ marginRight: 10, width: 10, height: 14 }} />
                                    <Text style={styles.text}>{detail.address}</Text>
                                </View>
                            </View>


                        </Content>
                        <Content>
                            <Line
                                type='custom'
                                title='店铺活动'
                                point={null}
                                rightView={
                                    <View style={[styles.row, { flex: 1, justifyContent: 'space-between', marginLeft: 10 }]}>
                                        {/* <Text style={{ color: CommonStyles.globalHeaderColor, fontSize: 14 }}>满100减20</Text> */}
                                        <Text style={{ color: CommonStyles.globalHeaderColor, fontSize: 14 }}>每单均减{minMoney}到{maxMoney}元</Text>
                                        {/* <Image source={require('../../images/index/expand.png')} style={{ width: 14, height: 14 }} /> */}
                                    </View>
                                }
                            />
                        </Content>
                        <Content >
                            <Line title='商户信息' point={null} />
                            <View style={{ paddingHorizontal: 15, paddingVertical: 10 }}>
                                <Text style={styles.title}>营业时间</Text>
                                <View>
                                    {this.state.timeItems && this.state.timeItems.map(
                                        (item, index) => {
                                            return item.value ? (
                                                <Text style={[styles.contentTopText, { marginTop: 10 }]} key={index} >
                                                    {item.startAt + "-" + item.endAt + " " + item.title}
                                                </Text>
                                            ) : null;
                                        }
                                    )}
                                </View>
                                <Text style={styles.text}></Text>
                                <Text style={[styles.title, { marginTop: 6 }]}>简介</Text>
                                <Text style={styles.text}>{detail.description}</Text>
                            </View>

                        </Content>

                    </View>
                </ScrollView>

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
    bannerView: {
        height: 150,
        backgroundColor: "#f1f1f1"
    },
    banner_dot: {
        width: 3,
        height: 3,
        borderRadius: 4,
        marginLeft: 1.5,
        marginRight: 1.5,
        marginBottom: -20,
        backgroundColor: "#CCCCCC"
    },
    banner_activeDot: {
        width: 12,
        height: 3,
        borderRadius: 10,
        marginLeft: 1.5,
        marginRight: 1.5,
        marginBottom: -20,
        backgroundColor: CommonStyles.globalHeaderColor
    },
    topTopItem: {
        paddingHorizontal: 15,
        paddingVertical: 10,
        borderBottomWidth: 1,
        borderColor: '#f1f1f1'
    },
    storeName: {
        fontSize: 17,
        color: '#222'
    },
    title: {
        color: '#222',
        fontSize: 14
    },
    text: {
        color: '#666666',
        fontSize: 12
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    contentTopText: {
        fontSize: 14,
        color: "#777777"
    },


});

