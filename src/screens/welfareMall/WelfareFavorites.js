/**
 * 福利商城收藏夹
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
} from 'react-native'
import math from '../../config/math';
import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import { connect } from 'rn-dva'
import ImageView from '../../components/ImageView'
import ModalDemo from '../../components/Model'
import FlatListView from '../../components/FlatListView'
import Process from '../../components/Process'
import SwipeListView from '../../components/SwipeListView'
// import BlurredPrice from '../../components/BlurredPrice'
import * as requestApi from '../../config/requestApi'
import { hashSettled } from 'rsvp';
import { getPreviewImage } from '../../config/utils';
import { NavigationComponent } from '../../common/NavigationComponent';

const unchecked = require('../../images/mall/unchecked.png')
const checked = require('../../images/mall/checked.png')
const { width, height } = Dimensions.get('window')

function getwidth(val) {
    return width * val / 375
}

let queryParam = {
    page: 1,
    limit: 10,
    xkModule: 'jf_mall'
}

class WelfareFavorites extends NavigationComponent {
    constructor(props) {
        super(props)
        this.deleteFlag = 0   //1 多个取消  2 单个取消
        this.deleteItemData = null
    }
    state = {
        store: {
            refreshing: false,
            loading: false,
            hasMore: true,
            isFirstLoad: true
        },
        isManager: true,  //管理
        data: [],
        alertVisible: false,
        selectedAll: false,
    }
    blurState = {
        alertVisible: false,
    }
    requestFirst = () => {
        const { store } = this.state
        store.refreshing = true
        this.setState({
            store
        })
        queryParam.page = 1
        requestApi.xkFavoriteQPage(queryParam).then((res) => {
            console.log(res)
            if (res) {
                let data = res.data
                let hasMore = true
                if (data.length < 10) {
                    hasMore = false
                }
                data.forEach((item) => {
                    item.target.checkedData = 0
                })
                store.hasMore = hasMore
                store.refreshing = false
                store.isFirstLoad = false
                this.setState({
                    store,
                    data,
                })
            } else {
                store.hasMore = false
                store.refreshing = false
                store.isFirstLoad = false
                this.setState({
                    store
                })
            }

        }).catch((res) => {
            store.hasMore = false
            store.refreshing = false
            store.isFirstLoad = false
            this.setState({
                store
            })
        })
    }
    componentDidMount() {
        this.requestFirst()
    }
    deleteItem = () => {
        let one = this.deleteItemData
        const { data } = this.state
        let param = {
            ids: []
        }
        let newdata = []
        data.forEach((item) => {
            if (item.id === one.item.id) {
                param.ids.push(item.id)
            } else {
                newdata.push(item)
            }
        })
        requestApi.xkFavoriteDelete(param).then(() => {
            Toast.show('取消成功', 2000)
            this.setState({
                data: newdata
            })
        }).catch(() => {
            Toast.show('取消失败', 2000)
        })
    }
    renderHiddenItem = (item,index) => {
        let br = null
        if(item.index === 0){
            br = {
                borderTopLeftRadius:12,
                borderTopRightRadius:12,
            }
        }
        if(item.index === this.state.data.length-1){
            br = {
                borderBottomRightRadius:12,
                borderBottomLeftRadius:12
            }
        }
        if(this.state.data.length === 1){
            br = {
                borderTopLeftRadius:12,
                borderTopRightRadius:12,
                borderBottomRightRadius:12,
                borderBottomLeftRadius:12
            }
        }
        return (
            <View style={[styles.hideContaner,br]}>
                <TouchableOpacity
                    style={[styles.hideItemDelete,br]}
                    onPress={() => {
                        this.deleteItemData = item
                        this.deleteFlag = 2
                        this.setState({
                            alertVisible: true
                        })

                    }}
                >
                    <Text style={{ color: '#FFFFFF', fontSize: 17 }}>删除</Text>
                </TouchableOpacity>
            </View>
        )
    }
    onRowDidOpen = (rowKey, rowMap) => {
        setTimeout(() => {
            this.closeRow(rowMap, rowKey);
        }, 2000);
    }
    changeItemChecked = (one) => {
        const { data } = this.state
        data.find((item) => {
            if (item.id === one.id) {
                if (item.target.checkedData === 1) {
                    item.target.checkedData = 0
                } else {
                    item.target.checkedData = 1
                }
            }
        })
        this.setState({
            data
        })
    }
    quXiaoSC = () => {
        const { data } = this.state
        let newData = []
        let param = {
            ids: []
        }
        data.forEach((item) => {
            if (item.target.checkedData === 1) {
                param.ids.push(item.id)
            } else {
                newData.push(item)
            }
        })
        if (param.ids.length === 0) {
            Toast.show('请选择取消收藏的商品', 2000)
            return
        }
        requestApi.xkFavoriteDelete(param).then(() => {
            Toast.show('取消成功', 2000)
            this.setState({
                data: newData
            })
        }).catch(() => {
            Toast.show('取消失败', 2000)
        })
    }
    toDetail = (item) => {
        const { navigation } = this.props
        if (item.isLoseEfficacy === '1' || item.isLoseEfficacy === 1) {
            Toast.show('商品已失效！')
            return
        }
        // item.mainUrl = item.url
        // item.id = item.sequenceId
        // item.goodsName = item.name
        // item.jSequenceId = item.sequenceId
        // item.perPrice = item.oldPrice
        // item.expectDrawTime = item.drawTime
        // console.log(item)
        // return
        navigation.navigate('WMGoodsDetail', { goodsId: item.targetId, sequenceId:item.sequenceId })
    }
    renderItem = (data) => {
        const { isManager } = this.state
        let item = data.item.target
        let br = null
        if(data.index === 0){
            br = {
                borderTopLeftRadius:10,
                borderTopRightRadius:10,
            }
        }
        if(data.index === this.state.data.length-1){
            br = {
                borderBottomRightRadius:10,
                borderBottomLeftRadius:10
            }
        }
        if(this.state.data.length === 1){
            br = {
                borderTopLeftRadius:10,
                borderTopRightRadius:10,
                borderBottomRightRadius:10,
                borderBottomLeftRadius:10
            }
        }
        return (
            <View style={[styles.itemContaner,br]}>
                {
                    !isManager && (
                        <View style={{
                            width: getwidth(34),
                            height: getwidth(80),
                            alignItems: 'center',
                            justifyContent: 'center',
                        }}>
                        <TouchableOpacity
                            style={styles.optItem}
                            onPress={() => { this.changeItemChecked(data.item) }}
                        >
                            <ImageView
                                source={
                                    item.checkedData === 1
                                        ? checked
                                        : unchecked
                                }
                                sourceWidth={18}
                                sourceHeight={18}

                            />
                        </TouchableOpacity>
                        </View>
                    )
                }
                <TouchableOpacity
                    onPress={() => {
                        this.toDetail(item)
                    }}
                    style={{ flexDirection: 'row', marginLeft: isManager ? 15 : 2, marginRight: 10, flex: 1 }}>
                    <Image source={{ uri: getPreviewImage(item.showPics, '50p') }} style={styles.itemImg} />
                    <View style={styles.rightView}>
                        <View style={{ paddingHorizontal: 10 }}>
                            <Text style={{ color: '#222222', fontSize: 12 }} numberOfLines={2}>{item.name}</Text>
                        </View>
                        <View style={styles.processSty}>
                            <Text style={{ color: '#555555', fontSize: 12 }}>消费券：
                                <Text style={{ color: '#EE6161', fontSize: 12, marginLeft: 4 }}>{math.divide(item.perPrice|| 0,100) }</Text>
                            </Text>
                        </View>
                    </View>
                </TouchableOpacity>

            </View >
        )
    }
    //下拉刷新数据
    refreshData = () => {
        this.requestFirst()
    }
    //上拉数据
    loadMoreData = () => {
        const { store, data } = this.state
        let hasMore = store.hasMore
        if (hasMore) {
            queryParam.page += 1
            requestApi.xkFavoriteQPage(queryParam).then((res) => {
                if (res) {
                    let list = res.data
                    let hasMore = true
                    if (list.length < 10) {
                        hasMore = false
                    }
                    store.hasMore = hasMore
                    store.loading = false
                    this.setState({
                        store,
                        data: data.concat(list)
                    })
                } else {
                    store.hasMore = false
                    store.loading = false
                    this.setState({
                        store
                    })
                }

            }).catch(() => {
                store.hasMore = false
                store.loading = false
                this.setState({
                    store
                })
            })
        }
    }
    closeRow(rowMap, rowKey) {
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }
    }
    // 全选
    _changeMallCartList = () => {
        let _data = this.state.data;
        const { selectedAll } = this.state
        if (!selectedAll) {
            _data.map(item => {
                item.target['checkedData'] = 1;
            })
        } else {
            _data.map(item => {
                item.target['checkedData'] = 0;
            })
        }
        this.setState({
            data: _data,
            selectedAll: !selectedAll,
        })
    }
    render() {
        const { navigation } = this.props
        const { store, isManager, data, alertVisible, selectedAll } = this.state
        let title = isManager ? '管理' : '关闭'
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                            <Text style={{ fontSize: 17, color: '#fff' }}>我的收藏</Text>
                        </View>
                    }
                    rightView={
                        data.length==0?null:
                        <TouchableOpacity
                            style={{ width: 50 }}
                            onPress={() => {
                                this.setState({
                                    isManager: !this.state.isManager
                                })
                            }}
                        >
                            <Text style={{ fontSize: 17, color: '#fff' }}>{title}</Text>
                        </TouchableOpacity>
                    }
                />
                <ModalDemo
                    title='确定要取消收藏?'
                    visible={alertVisible}
                    onConfirm={() => {
                        this.setState({ alertVisible: false })
                        if (this.deleteFlag === 1) {
                            this.quXiaoSC()
                        } else {
                            this.deleteItem()
                        }
                    }}
                    onClose={() => { this.setState({ alertVisible: false }) }} type='confirm'
                />
                <View style={{width:width,paddingHorizontal:10,height:height-44-CommonStyles.headerPadding}}>
                <SwipeListView
                    useFlatList
                    data={data}
                    style={styles.flatListView}
                    footerStyle={styles.flatListView}
                    renderItem={this.renderItem}
                    renderHiddenItem={this.renderHiddenItem}
                    ItemSeparatorComponent={()=><View style={styles.viewline}></View>}
                    store={store}
                    leftOpenValue={0}
                    rightOpenValue={-71}
                    previewRowKey={'0'}
                    previewOpenValue={-40}
                    previewOpenDelay={3000}
                    onRowDidOpen={this.onRowDidOpen}
                    refreshData={this.refreshData}
                    loadMoreData={this.loadMoreData}
                />
                    </View>
                {
                    !isManager && data.length>0 && (
                        <View style={[CommonStyles.flex_between,styles.footer]}>
                            <TouchableOpacity
                                activeOpacity={0.7}
                                style={[styles.footerItem, styles.footerItem1_m]}
                                onPress={() => {
                                    this._changeMallCartList();
                                }}
                            >
                                {
                                    selectedAll ?
                                        <Image style={styles.footerItem1_img} source={require('../../images/mall/checked.png')} /> :
                                        <Image style={styles.footerItem1_img} source={require('../../images/mall/unchecked.png')} />
                                }
                                <Text style={styles.footerItem1_text}>全选</Text>
                            </TouchableOpacity>
                            <TouchableOpacity
                                onPress={() => {
                                    this.deleteFlag = 1
                                    this.setState({
                                        alertVisible: true
                                    })
                                }}
                                style={styles.footerTouch}
                            >
                                <Text style={{ color: '#FFFFFF', fontSize: 14, }}>取消收藏</Text>
                            </TouchableOpacity>
                        </View>
                    )
                }
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
    },
    itemContaner: {
        flexDirection: 'row',
        paddingVertical: 15,
        backgroundColor: '#fff',
    },
    viewline:{
        width:'100%',
        height:0,
        borderWidth:0.5,
        borderColor:'#eeeeee'
    },
    flatListView: {
        backgroundColor: CommonStyles.globalBgColor,
        width: width - 20,
    },
    optItem: {
        width: 44,
        height: 44,
        alignItems: 'center',
        justifyContent: 'center',
    },
    itemImg: {
        width: getwidth(80),
        height: getwidth(80),
        borderColor: '#E6E6E6',
        borderRadius: 8,
        borderWidth: 1,
    },
    rightView: {
        flex: 1,
        marginLeft: 10,
    },
    processSty: {
        // height: 28,
        marginTop: 5,
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 10,
    },
    processStycenter: {
        // height: 28,
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 10,
    },
    footer: {
        position: 'absolute',
        bottom: 0,
        width: width,
        height: 50+CommonStyles.footerPadding,
        backgroundColor: '#FFFFFF',
        alignItems: 'flex-end'
    },
    footerTouch: {
        width: getwidth(105),
        height: 50,
        backgroundColor: '#EE6161',
        justifyContent: 'center',
        alignItems: 'center'
    },
    hideContaner: {
        width: '100%',
        backgroundColor: '#fff',
        height: '100%',
        alignItems: 'flex-end',
    },
    hideItemDelete: {
        width: 71,
        height: '100%',
        backgroundColor: '#EE6161',
        justifyContent: 'center',
        alignItems: 'center',
    },
    footerItem1_img: {
        marginLeft: 20,
        height: 18,
        width: 18
    },
    footerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        backgroundColor: '#fff',
    },
    footerItem1_m: {
        justifyContent: 'flex-start',
    },
    footerItem1_text: {
        fontSize: 14,
        color: '#777',
        marginLeft: 14,
    },
})

export default connect(
    (state) => ({ store: state })
)(WelfareFavorites)
