/**
 * 发票信息管理
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    Platform,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity,
} from 'react-native'

import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import moment from 'moment'
import { connect } from 'rn-dva'
import Content from '../../components/ContentItem'
import FlatListView from '../../components/FlatListView'
import * as requestApi from '../../config/requestApi'
import { changeData } from '../../action/invoiceAction'
import ListEmptyCom from '../../components/ListEmptyCom';
const nofapiao = require('../../images/invoice/nofapiao.png')
const tiaozhuan = require('../../images/indianashopcart/tiaozhuan.png')

const { width, height } = Dimensions.get('window')
function getwidth(val) {
    return width * val / 375
}

let queryParam = {
    page: 1,
    limit: 20
}
let allRefreshing=true
class InvoiceInfonManage extends Component {
    _didFocusSubscription;
    constructor (props) {
        super(props)
        this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>{
            queryParam = {
                page: 1,
                limit: 20
            }
            allRefreshing=true
            this.requestFirst()
        });
        this.state = {
            store: {
                refreshing: false,
                loading: false,
                hasMore: true,
                isFirstLoad: true
            },
        }
    }

    requestFirst = () => {
        const { store } = this.state
        store.refreshing = true
        this.setState({
            store
        })
        queryParam.page = 1
        requestApi.merchantInvoiceQPage(queryParam).then((res) => {
            allRefreshing=false
            if (res) {
                let data = res.data
                let hasMore = true
                if (data.length < 10) {
                    hasMore = false
                }
                store.hasMore = hasMore
                store.refreshing = false
                store.isFirstLoad = false
                this.props.dispatch(changeData(data))
                this.setState({
                    store,
                })
            } else {
                store.hasMore = false
                store.refreshing = false
                store.isFirstLoad = false
                this.props.dispatch(changeData([]))
                this.setState({
                    store
                })
            }

        }).catch((res) => {
            Toast.show(res.message)
            store.hasMore = false
            store.refreshing = false
            allRefreshing=false
            store.isFirstLoad = false
            this.setState({
                store
            })
        })
    }
    refreshData = () => {
        this.requestFirst()
    }
    componentDidMount() {

    }
    componentWillUnmount () {
        this._didFocusSubscription && this._didFocusSubscription.remove();
    }
    loadMoreData = () => {
        const { store} = this.state
        const { data } = this.props
        let hasMore = store.hasMore
        if (allRefreshing|| store.loading || !hasMore || data.length == 0) return
        if (hasMore) {
            queryParam.page += 1
            requestApi.merchantInvoiceQPage(queryParam).then((res) => {
                if (res) {
                    let list = res.list
                    let hasMore = true
                    if (list.length < 10) {
                        hasMore = false
                    }
                    store.hasMore = hasMore
                    store.loading = false
                    this.props.dispatch(changeData(data.concat(list)))
                    this.setState({
                        store,
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
    createFapiao = () => {
        this.props.navigation.navigate('CreateInvoice')
    }
    renderSeparator = () => {
        return <View style={styles.separator} />
    }
    toEditor = (item) => {
        const { navigation } = this.props
        if (navigation.state.params) {
            if (navigation.state.params.getFapiaoData) {
                navigation.state.params.getFapiaoData(item)
                navigation.goBack()
            } else {
                navigation.navigate('CreateInvoice', { data: item })
            }
        } else {
            navigation.navigate('CreateInvoice', { data: item })
        }
    }
    // 处理显示公司发票抬头长度
    handleCompanyHead = (item) => {
        if (item.head.length > 30) {
            let str = item.head.slice(0,30);
            return `${str}...`
        }
        return item.head || '公司抬头'
    }
    renderItem = (data) => {
        let allData=this.props.data || []
        const viewStyle ={
                borderTopLeftRadius: data.index == 0 ? 6 : 0,
                borderTopRightRadius: data.index == 0 ? 6 : 0,
                borderBottomLeftRadius: data.index == allData.length - 1 ? 6 : 0,
                borderBottomRightRadius: data.index == allData.length - 1 ? 6 : 0,
                overflow: "hidden",
                width: width - 20
        };
        let item = data.item
        let type = item.type === 'PERSONAL' ? '个人' : '企业'
        return (
            <TouchableOpacity style={[styles.listItem,viewStyle]} onPress={() => this.toEditor(item)}>
                <View style={{ flexDirection: 'row', alignItems: 'center', flex: 1 }}>
                    <View style={{maxWidth:'70%' }}><Text ellipsizeMode='tail' numberOfLines={1} style={{ color: '#222222', fontSize: 14, }}>{(item.type === 'PERSONAL') ? item.head:this.handleCompanyHead(item) }</Text></View>
                    {
                        item.isDefault === 1 && <View style={{ marginLeft: 8, width: getwidth(50) }}><Text style={{ color: '#4A90FA', fontSize: 10 }}>[默认]</Text></View>
                    }
                </View>
                <View style={styles.rightView}>
                    <Text style={{ color: '#222', fontSize: 14 }}>{type}</Text>
                    <Image source={tiaozhuan} style={{ marginLeft: 10 }} />
                </View>
            </TouchableOpacity>
        )
    }
    render() {
        const { navigation, data } = this.props
        const { store } = this.state
        let hasData = (data && data.length > 0) ? true : false
        // console.log(store)
        return (
            <View style={styles.container} >
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={'发票信息管理'}
                    rightView={
                        <TouchableOpacity
                            onPress={this.createFapiao}
                        >
                            <Text style={{
                                fontSize: 17,
                                color: '#fff',
                                marginRight: 25,
                            }}>新建</Text>
                        </TouchableOpacity>
                    }
                />
                <FlatListView
                    ListEmptyComponent={<ListEmptyCom type='InvoiceInfoEmpty' />}
                    data={data}
                    style={{ width: getwidth(355),backgroundColor:CommonStyles.globalBgColor}}
                    renderItem={this.renderItem}
                    store={store}
                    limit={20}
                    ItemSeparatorComponent={this.renderSeparator}
                    refreshData={this.refreshData}
                    loadMoreData={this.loadMoreData}
                    // footerStyle={{ backgroundColor: '#fff' }}
                />
                {/* {
                    hasData ? (

                        <FlatListView
                            data={data}
                            style={{ width: getwidth(355),backgroundColor:CommonStyles.globalBgColor}}
                            renderItem={this.renderItem}
                            store={store}
                            ItemSeparatorComponent={this.renderSeparator}
                            refreshData={this.refreshData}
                            loadMoreData={this.loadMoreData}
                            // footerStyle={{ backgroundColor: '#fff' }}
                        />

                    ) : (
                            <View>
                                <View style={styles.nofapiaoView}>
                                    <Image source={nofapiao} style={styles.nofapiaoImg} />
                                </View>
                                <View style={styles.nofapiaoTxt}>
                                    <Text style={{ color: '#777777', fontSize: 14 }}>
                                        暂无内容
                                    </Text>
                                    <TouchableOpacity
                                        onPress={this.createFapiao}
                                        style={styles.createFaPiao}
                                    >
                                        <Text style={{color:'#FFFFFF',fontSize:17}}>新建发票信息</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        )
                } */}
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
    separator: {
        borderColor: '#F1F1F1',
        width: width,
        height: 0,
        borderWidth: 0.5
    },
    nofapiaoImg: {
        width: getwidth(140),
        height: 170
    },
    createFaPiao:{
        width:getwidth(295),
        height:44,
        backgroundColor:'#4A90FA',
        borderRadius: 8,
        marginTop:40,
        justifyContent:'center',
        alignItems:'center'
    },
    nofapiaoView: {
        width: width,
        height: getwidth(144),
        alignItems: 'center',
        marginTop: 70
    },
    nofapiaoTxt: {
        width: width,
        alignItems: 'center',
        marginTop: 37
    },
    listItem: {
        width: getwidth(355),
        height: 44,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: 15,
        backgroundColor:'#fff'
    },
    rightView: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end',
        width: getwidth(65),
    }
})

export default connect(
    (state) => ({ data: state.invoiceReducer.data })
)(InvoiceInfonManage)
