/**
 * 自营商城收藏夹
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    RefreshControl,
    Image,
    ScrollView,
    TouchableOpacity,
    TouchableHighlight
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import ListView from 'deprecated-react-native-listview';
import actions from "../../action/actions";

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import SwipeListView from '../../components/SwipeListView'
import ListEmptyCom from '../../components/ListEmptyCom'
import ModelView from '../../components/Model';
import BlurredPrice from '../../components/BlurredPrice';
import CommoditiesText from '../../components/CommoditiesText'
import { showSaleNumText, getPreviewImage, getSalePriceText,recodeGoGoodsDetailRoute } from '../../config/utils'
import  math from "../../config/math.js";
const { width, height } = Dimensions.get("window");
const shixiao = require('../../images/indianashopcart/shixiao.png')

function getwidth(val) {
    return width * val / 375
}
class SOMCollectionScreen extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 })
        this.state = {
            isManage: false,
            modelVisible: false,
            page: 1,
            limit: 10,
            refreshing: false,
            loading: false,
            hasMore: false,
            isFirstLoad: true,
            total: 0,
            collectLists: [],
            confimVis1: false, // 删除弹窗
            deleteData: {
                data: '',
                secId: '',
                rowId: '',
                rowMap: ''
            }, // 删除数据
            selectedAll: false,
        }
    }

    componentDidMount() {
        Loading.show()
        this.refresh(1);
    }

    refresh = (page = 1) => {
        this.changeState('loading', true);
        const { limit } = this.state
        requestApi.requestxkFavoriteQPage({ page, limit, xkModule: 'mall' }, (data => {
            let _data;
            let isFirstLoad;
            const { total, collectLists } = this.state;
            if (page === 1) {
                _data = data ? data.data : [];
                isFirstLoad = true
            } else {
                isFirstLoad = false
                _data = data ? [...collectLists, ...data.data] : collectLists;
            }
            // let _total = page === 1 ? data.total : total;
            let _total = page === 1
                ? (data)
                    ? data.total
                    : 0
                : total;
            let hasMore = data ? _total !== _data.length : false;

            _data.forEach(item => {
                if (!item.selected_status) {
                    item.selected_status = false;
                }
            });
            this.setState({
                refreshing: false,
                loading: false,
                page,
                hasMore,
                isFirstLoad,
                total: _total,
                collectLists: _data,
            });
        }), () => {
            this.setState({
                refreshing: false,
                loading: false,
            });
        });
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    // 更改选择状态
    _changeSelset = (_data) => {
        let data = this.state.collectLists;
        data.forEach(item => {
            if (_data.target.targetId == item.target.targetId) {
                item.selected_status = !item.selected_status;
            }
        });
        this.changeState('collectLists', data);
    }

    // 过滤已选择商品
    filterData = () => {
        const { collectLists } = this.state;
        let _data = [];
        for (let i = 0; i < collectLists.length; i++) {
            if (collectLists[i].selected_status) {
                _data.push(collectLists[i]);
            }
        }
        return _data;
    }

    // 删除
    delete = () => {
        let data = this.state.collectLists;
        let _data = this.filterData();
        let params = {
            ids: []
        };
        console.log('dsfdasfa',_data)
        _data.map(item => {
            params.ids.push(item.id)
        })
        requestApi.requestxkFavoriteDelete(params, res => {
            this.changeState('modelVisible', false);
            Toast.show('取消成功');
            for (let i = 0; i < data.length; i++) {
                for (let j = 0; j < _data.length; j++) {
                    if (_data[j].target.targetId == data[i].target.targetId) {
                        data.splice(i, 1);
                    }
                }
            }
            this.changeState('collectLists', data);
        }, e => {
            this.setState({
                isManage:false,
                modelVisible:false,
            })
        });
    }

    componentWillUnmount() {

    }
    closeRow(rowMap, rowKey) {
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }
    }
    onRowDidOpen = (rowKey, rowMap) => {
        setTimeout(() => {
            this.closeRow(rowMap, rowKey);
        }, 2000);
    }
    deleteOneServiceData = (data, secId, rowId, rowMap) => {
        console.log(this.state.deleteData)
        let param = {
            ids: [data.id]
        }
        requestApi.requestxkFavoriteDelete(param).then((res) => {
            this.refresh(1);
            this.setState({
                selectedAll: false,
            })
            this.closeRow(rowMap, `${secId}${rowId}`)
            
        }).catch((res) => {
            Toast.show(res.message)
        })
    }
    // 全选操作
    _changeMallCartList = () => {
        let data = this.state.collectLists;
        const { selectedAll } = this.state
        if (!selectedAll) {
            data.map(item => {
                item['selected_status'] = true;
            })
        } else {
            data.map(item => {
                item['selected_status'] = false;
            })
        }
        this.setState({
            collectLists: data,
            selectedAll: !selectedAll,
        })
    }
    render() {
        const { navigation, store } = this.props;
        const { isManage, modelVisible, collectLists, confimVis1, deleteData,selectedAll } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View style={[styles.header_center, styles.header_pad]}>
                            <View style={styles.header_center_item}></View>
                            <View style={styles.header_center_item2}>
                                <Text style={styles.header_titleText}>我的收藏</Text>
                            </View>
                            <TouchableOpacity
                                style={[styles.header_center_item, styles.header_pad]}
                                onPress={() => {

                                }}
                            >
                                {/* <Image source={require('../../images/mall/search.png')} /> */}
                            </TouchableOpacity>
                        </View>
                    }
                    rightView={
                        collectLists && collectLists.length === 0 ? null:
                        <TouchableOpacity
                            style={[styles.header_center_item, styles.header_right]}
                            onPress={() => {
                                this.changeState('isManage', !isManage);
                            }}
                        >
                            {
                                isManage ?
                                    <Text style={[styles.header_titleText, {}]}>关闭</Text> :
                                    <Text style={styles.header_titleText}>管理</Text>
                            }
                        </TouchableOpacity>
                    }
                />
                {
                    collectLists && collectLists.length === 0 ?
                     <View style={[styles.emptyView]}>
                        <ListEmptyCom/>
                    </View> : (
                    <SwipeListView
                    showsVerticalScrollIndicator={false}
                    enableEmptySections={true}
                    // useFlatList
                    store={this.state}
                    flatRef={(e) => { e && (this.flatListRef = e) }}
                    style={styles.flatList}
                    dataSource={this.ds.cloneWithRows(collectLists)}
                    refreshControl={
                        <RefreshControl
                            colors={["#2ba09d"]}
                            refreshing={this.state.refreshing}
                            onRefresh={() => {
                                this.changeState('refreshing', true);
                                this.refresh(1);
                            }}
                        />
                    }
                    onEndReached={() => {
                        this.refresh(this.state.page + 1);
                    }}
                    onEndReachedThreshold={0.1}
                    renderHiddenRow={(data, secId, rowId, rowMap) => (
                        <TouchableOpacity
                            onPress={() => {
                                let _data = {
                                    data,
                                    secId,
                                    rowId,
                                    rowMap
                                }
                                this.setState({
                                    confimVis1: true,
                                    deleteData: _data
                                })
                            }}
                            style={styles.rowBack}>
                            <Text style={styles.cf14}>删除</Text>
                        </TouchableOpacity>

                    )}
                    stopLeftSwipe={68}
                    stopRightSwipe={-68}
                    leftOpenValue={68}
                    rightOpenValue={-68}
                    onRowDidOpen={this.onRowDidOpen}
                    ListHeaderComponent={() => <View style={styles.flatList_header}></View>}
                    footerStyle={styles.flatList_footer}
                    ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
                    renderRow={(item,rowIndex,colindex) => {
                        let itemBox_start = colindex == 0 ? styles.itemBox_start : null;
                        let itemBox_end = colindex == collectLists.length - 1 ? styles.itemBox_end : null;
                        return (
                            <TouchableHighlight
                                underlayColor="#f1f1f1"
                                activeOpacity={0.2}
                                style={{ position: 'relative' }}
                                onPress={() => {
                                    let param = {
                                        ...item,
                                        id: item.target.targetId
                                    }
                                    recodeGoGoodsDetailRoute('SOMCollection')
                                    navigation.navigate('SOMGoodsDetail', { goodsId: param.id });
                                }}>
                                    <React.Fragment>
                                        { // 收藏商品 失效
                                            item.target.isLoseEfficacy === 1
                                            ? <View style={{position: 'absolute',bottom: 10,right:0,zIndex: 1}}>
                                                <Image source={shixiao} />
                                            </View>
                                            : null
                                        }
                                        <View style={[styles.itemBox, itemBox_start, itemBox_end]} >
                                            {
                                                isManage 
                                                    ? <TouchableOpacity
                                                        style={styles.itemBox_check}
                                                        onPress={() => { this._changeSelset(item) }}
                                                    >
                                                        {
                                                            item.selected_status ?
                                                                <Image style={{width:18,height:18}} source={require('../../images/index/select.png')} /> :
                                                                <Image style={{width:18,height:18}} source={require('../../images/index/unselect.png')} />
                                                        }
                                                    </TouchableOpacity>
                                                    : <View style={[styles.itemBox_check, styles.itemBox_check2]} />
                                            }
                                            <View style={styles.itemBox_left}>
                                                <Image source={{ uri: getPreviewImage(item.target.showPics, '50p') }} style={styles.itemBox_left_img} />
                                            </View>
                                            <View style={styles.itemBox_right}>
                                                <Text numberOfLines={2} style={styles.itemBox_right_text1}>{item.target.name}</Text>
                                                {
                                                    item.target.goodsDivide === 2 // 如果是大宗商品
                                                    // true
                                                    ? <CommoditiesText price={item.target.price} buyPrice={item.target.buyPrice} subscription={item.target.subscription}/>
                                                    : <React.Fragment>
                                                        <View style={[{ paddingTop: 10 }]}>
                                                            <Text style={[styles.itemBox_right_text2]}>惊喜价：
                                                                <BlurredPrice>
                                                                    <Text style={styles.itemBox_right_text3}>¥ {getSalePriceText(math.divide(item.target.buyPrice || 0, 100))} </Text>
                                                                </BlurredPrice>
                                                            </Text>
                                                        </View>
                                                        <View>
                                                            {
                                                                item.target.price ? <Text style={[{ fontSize: 12, color: '#222' } ]} >原价：<Text style={styles.originalPrice}>¥{ getSalePriceText(math.divide(item.target.price || 0, 100))}</Text></Text>:null
                                                            }
                                                        </View>
                                                    </React.Fragment>
                                                }
                                                
                                                <Text style={[styles.itemBox_right_text2, { fontSize: 10, color: '#999', marginTop: 5}]}>总销量：{showSaleNumText(item.target.mouthVolume)}</Text>
                                            </View>
                                        </View>
                                    </React.Fragment>
                            </TouchableHighlight>
                        );
                    }}
                />
                 )
                }
                {
                    isManage && collectLists.length>0?
                        <View style={[CommonStyles.flex_between,styles.bomView]}>
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
                                style={styles.bom_btn}
                                onPress={() => {
                                    if (this.filterData().length === 0) {
                                        Toast.show('请选择商品');
                                        return
                                    }
                                    this.changeState('modelVisible', true);
                                }}
                            >
                                <Text style={styles.bom_btn_text}>取消收藏</Text>
                            </TouchableOpacity>
                        </View> :
                        null
                }
                <ModelView
                    type={'confirm'}
                    title={'确定要取消收藏？'}
                    confirmText=''
                    visible={modelVisible}
                    onShow={() => this.setState({ modelVisible: true })}
                    onConfirm={() => this.delete()}
                    onClose={() => this.setState({ modelVisible: false })}
                />
                {/* 删除时候弹窗 */}
                <ModelView
                    noTitle={true}
                    leftBtnText="否"
                    rightBtnText="是"
                    visible={confimVis1}
                    title="确定要取消收藏"
                    type="confirm"
                    onClose={() => {
                        this.changeState("confimVis1", false);
                    }}
                    onConfirm={() => {
                        this.changeState("confimVis1", false);
                        this.deleteOneServiceData(deleteData.data, deleteData.secId, deleteData.rowId, deleteData.rowMap)
                    }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
    },
    header_center: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        flex: 1,
        height: '100%',
    },
    rowBack: {
        width: getwidth(68),
        height: '100%',
        backgroundColor: '#EE6161',
        justifyContent: 'center',
        alignItems: 'center',
        position: 'absolute',
        right: 4,
        top: 1
    },
    cf14: {
        color: '#FFFFFF',
        fontSize: 14
    },
    header_pad: {
        paddingLeft: 10,
    },
    header_center_item: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: 40,
        height: '100%',
    },
    header_center_item2: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        flex: 1,
        height: '100%',
    },
    header_titleText: {
        fontSize: 17,
        color: '#fff',
    },
    header_right: {
        width: 60,
        justifyContent: 'flex-end',
        flexDirection: 'row',
        paddingRight: 25
    },
    originalPrice:{
      fontSize:12,
      color:'#999999',
      textDecorationLine:'line-through',
      marginLeft:5
    },
    flatList: {
        flex: 1,
        width: width - 20,
        marginHorizontal: 10,
        backgroundColor: CommonStyles.globalBgColor,
        marginTop: 10
    },
    flatList_header: {
        height: 12,
    },
    flatList_footer: {
        height: 40 + CommonStyles.footerPadding,
        paddingBottom: CommonStyles.footerPadding,
    },
     emptyView: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: width,
        height:height-40 -44- CommonStyles.footerPadding-CommonStyles.headerPadding,
    },
    flatListLine: {
        height: 0,
        backgroundColor: '#F1F1F1',
    },
    itemBox: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        width: '100%',
        height: 120,
        paddingVertical: 15,
        paddingRight: 15,
        backgroundColor: '#fff',
        marginTop: 1,
    },
    itemBox_start: {
        borderTopLeftRadius: 6,
        borderTopRightRadius: 6,
    },
    itemBox_end: {
        borderBottomLeftRadius: 6,
        borderBottomRightRadius: 6,
    },
    itemBox_check: {
        justifyContent: 'center',
        alignItems: 'center',
        width: 40,
        height: '100%',
    },
    itemBox_check2: {
        width: 15,
    },
    itemBox_left: {
        width: 80,
        height: 80,
        borderWidth: 1,
        borderColor: '#E7E7E7',
        borderRadius: 6,
        marginRight: 15,
        // padding: 2,
    },
    itemBox_left_img: {
        width: '100%',
        height: '100%',
        borderRadius: 6
    },
    itemBox_right: {
        // justifyContent: 'space-between',
        flex: 1,
        height:'100%',
    },
    itemBox_right_item: {
        //
        marginTop: 10
    },
    itemBox_right_text1: {
        fontSize: 14,
        color: '#222',
        lineHeight: 17,
    },
    itemBox_right_text2: {
        fontSize: 12,
        color: '#555',
    },
    itemBox_right_text3: {
        color: '#EE6161',
    },
    bomView: {
        width: width,
        height: 50 + CommonStyles.footerPadding,
        // paddingBottom: CommonStyles.footerPadding,
        backgroundColor: '#fff',
    },
    bom_btn: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: 105,
        height: 50,
        backgroundColor: '#EE6161',
    },
    bom_btn_text: {
        fontSize: 14,
        color: '#fff',
    },
    itemBorderHor: {
        borderLeftWidth: 0.8,
        borderLeftColor: 'rgba(215,215,215,0.5)',
        borderRightWidth: 0.8,
        borderRightColor: 'rgba(215,215,215,0.5)',
    },
    itemBorderBottom: {
        borderBottomColor: 'rgba(215,215,215,0.5)',
        borderBottomWidth: 0.8,
    },
    itemBorderTop: {
        borderTopColor: 'rgba(215,215,215,0.5)',
        borderTopWidth: 0.8,
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
});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMCollectionScreen);
