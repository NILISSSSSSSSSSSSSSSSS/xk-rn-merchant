/**
 * 服务+现场点单-选择席位号
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Content from "../../../components/ContentItem";
import * as orderRequestApi from '../../../config/Apis/order'
import FlatListView from '../../../components/FlatListView'

const { width, height } = Dimensions.get("window")
const chooseArea = require('../../../images/shopOrder/chooseArea.png')

function getwidth(val) {
    return width * val / 375
}

let queryParam = {
    limit: 10,
    page: 1,
    shopId: ''
}
class ChooseTableNum extends Component {
    constructor(props) {
        super(props)
        this.state = {
            allData: [],
            store: {
                refreshing: false,
                loading: false,
                hasMore: true,
                isFirstLoad: true
            },
            selectedAreaId: 0,
        }
        this.isFirstLoad = true
        this.maxNum = this.props.navigation.state.params.maxNum
    }
    requesttableData = (selectedAreaId, allData) => {
        let param = {
            shopId: this.props.storeprop.user.userShop.id,
            seatTypeId: selectedAreaId
        }
        orderRequestApi.fetchMSeatList(param).then((res) => {
            if (res) {
                let seatData = this.props.navigation.state.params.seatData
                this.oldseatData = JSON.parse(JSON.stringify(seatData))
                allData.find((item) => {
                    if (item.id === selectedAreaId) {
                        let tableData = []
                        res.forEach((item) => {
                            if (item.status === 'active') {
                                item.isselected = false
                                tableData.push(item)
                            }
                        })
                        item.data = tableData
                        item.data.forEach((seatItem) => {
                            seatData.forEach((chooseItem) => {
                                if (chooseItem.seatId === seatItem.id) {
                                    seatItem.isselected = true
                                }
                            })
                        })
                        return true
                    }
                })
                this.setState({
                    allData,
                })
            }
        }).catch(err => {
            console.log(err)
        });
    }
    requestFirst = () => {
        queryParam.shopId = this.props.storeprop.user.userShop.id
        queryParam.page = 1
        const { store } = this.state
        store.refreshing = true
        this.setState({
            store
        })
        orderRequestApi.fetchMSeatStatistics(queryParam).then((res) => {
            if (res.data) {
                let areaData = res.data
                let selectedAreaId = 0
                let allData = []

                areaData.forEach((item, index) => {
                    if (index === 0) {
                        selectedAreaId = item.seatTypeId
                    }
                    allData.push({
                        id: item.seatTypeId,
                        name: item.seatTypeName,
                        chooseNum: 0,
                        data: null,
                    })
                })
                let seatData = this.props.navigation.state.params.seatData
                allData.forEach((item) => {
                    let sum = 0
                    seatData.forEach((chooseItem) => {
                        if (chooseItem.seatCode === item.id) {
                            sum += 1
                        }
                    })
                    item.chooseNum = sum
                })
                this.requesttableData(selectedAreaId, allData)
                let hasMore = true
                if (areaData.length < 10) {
                    hasMore = false
                }
                store.hasMore = hasMore
                store.refreshing = false
                store.isFirstLoad = false

                this.setState({
                    allData,
                    store,
                    selectedAreaId
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
    saveData = () => {
        const { allData } = this.state
        let seatData = []
        allData.forEach((item) => {
            if (item.chooseNum) {
                if (item.data) {
                    item.data.forEach((chooseItem) => {
                        if (chooseItem.isselected) {
                            seatData.push({
                                seatCode: item.id,
                                seatId: chooseItem.id,
                                seatName: chooseItem.name
                            })
                        }
                    })
                } else {
                    let oldSeatData = this.oldseatData
                    this.oldseatData.forEach((oldItem) => {
                        if (oldItem.seatCode === item.id) {
                            seatData.push(oldItem)
                        }
                    })
                }
            }
        })
        let sum = seatData.length
        if (sum !== this.maxNum) {
            Toast.show('选择的席位数量不够')
            return
        }
        const { changeSeatData, isCreateOrder } = this.props.navigation.state.params
        if (changeSeatData) {
            changeSeatData(seatData)
        }
        this.props.navigation.goBack()
    }
    selectedAreaItem = (data) => {
        //请求该类下面的数据
        const { allData } = this.state
        allData.find((item) => {
            if (item.id === data.id) {
                if (!item.data) {
                    this.requesttableData(data.id, allData)
                }
                return true
            }
        })
        this.setState({
            selectedAreaId: data.id
        })
    }
    renderAreaData = (data) => {
        const { selectedAreaId, allData } = this.state
        let chooseBorder = null
        let item = data.item
        if (selectedAreaId === item.id) {
            chooseBorder = styles.chooseBorder
        }
        return (
            <View style={[styles.areaListItem, chooseBorder]} key={item.id}>
                <TouchableOpacity
                    onPress={() => {
                        this.selectedAreaItem(item)
                    }}
                    style={styles.aredItemView}>
                    <Text style={[styles.c2f14]}>{item.name}<Text style={styles.crf14}>{item.chooseNum == 0 ? '' : `(${item.chooseNum})`}</Text></Text>
                </TouchableOpacity>
            </View>
        )

    }
    chooseThisItem = (item, selectedAreaId) => {
        const {serviceIndex,serviceData=[],orderId}=this.props.navigation.state.params || {}
        let param = {
            shopId:this.props.storeprop.user.userShop.id,
            seatId:item.id,
            orderId
        }
        
        orderRequestApi.fetchBcleUserVerifierOrderSeat(param).then((res)=>{
            const { allData } = this.state
            if(item.isselected || !res){
                let maxNum = this.maxNum
                let linshiNum = 0
                allData.forEach((item) => {
                    linshiNum = linshiNum + item.chooseNum
                })
                if (item.images && item.images.length) {
                    this.props.navigation.navigate('SeatsNameView', { images: item.images })
                }
                let tableData = []
                let resdata = null
                allData.find((item) => {
                    if (item.id === selectedAreaId) {
                        tableData = item.data
                        resdata = item
                        return true
                    }
                })
                let changeSum = 1
                let goOnFlag = false
                tableData.forEach((one) => {
                    if (one.id === item.id) {
                        if (item.isselected) {
                            one.isselected = false
                            changeSum = -1
                        } else {
                            let isExist=false
                            serviceData.map((item2,index)=>{
                                ((item2.seat && item2.seat.seatId==item.id) || item2.seatId==item.id) && index!=serviceIndex?isExist=true:null
                            })
                            if(isExist){
                                Toast.show('席位已经被占用')
                                goOnFlag = true
                                return
                            }
                            if (linshiNum >= maxNum) {
                                Toast.show('席位数量已经达到上限')
                                goOnFlag = true
                                return
                            }
                            one.isselected = true
                            changeSum = +1
                        }
                    }
                })
                if (goOnFlag) {
                    return
                }
                if (resdata) {
                    resdata.chooseNum = resdata.chooseNum + changeSum
                }
                this.setState({
                    allData
                })
            }else{
                Toast.show('席位已经被占用')
                return
            }
        }).catch(err => {
            console.log(err)
        });

    }
    renderChooseArea = () => {
        const { allData, selectedAreaId } = this.state
        let areaData = []
        allData.forEach((item) => {
            if (item.id === selectedAreaId) {
                areaData = item.data
            }
        })
        if (areaData) {
            return areaData.map((item) => {
                let isselected = item.isselected
                let styleborder = styles.noChoodeBorder
                if (isselected) {
                    styleborder = styles.areachooseBorder
                }
                return (
                    <TouchableOpacity
                        key={item.id}
                        onPress={() => { this.chooseThisItem(item, selectedAreaId) }}
                        style={[styles.tableItem, styleborder]}
                    >
                        {
                            isselected && (
                                <View style={styles.choose}>
                                    <Image source={chooseArea} />
                                </View>
                            )
                        }
                        <Text>{item.name}</Text>
                        {
                            item.images && item.images.length ?
                                <View style={styles.hsapic}>
                                    <Text style={styles.cff10}>有图</Text>
                                </View>:null
                        }
                    </TouchableOpacity>

                )
            })
        }
        return null
    }
    loadMoreData = () => {
        const { store } = this.state
        store.refreshing = true
        this.setState({
            store
        })
        queryParam.page += 1
        orderRequestApi.fetchMSeatStatistics(queryParam).then((res) => {
            if (res.data) {
                let areaData = res.data
                let allData = []
                areaData.forEach((item, index) => {
                    allData.push({
                        id: item.seatTypeId,
                        name: item.seatTypeName,
                        chooseNum: 0,
                        data: []
                    })
                })
                let hasMore = true
                if (areaData.length < 10) {
                    hasMore = false
                }
                store.hasMore = hasMore
                store.refreshing = false
                store.isFirstLoad = false
                this.setState({
                    allData: this.state.allData.concat(allData),
                    store,
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
    render() {
        const { navigation } = this.props
        const { store, areaData, allData } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='选择席位号'
                    rightView={
                        <TouchableOpacity
                            onPress={this.saveData}
                            style={{ width: 50, height: '100%', justifyContent: 'center' }}>
                            <Text style={styles.cff17}>确定</Text>
                        </TouchableOpacity>
                    }
                />
                <View style={styles.viewContaner}>
                    <View style={styles.leftView}>
                        <FlatListView
                            data={allData}
                            style={{ flex:1, backgroundColor: '#F6F6F6',paddingTop:-20 }}
                            footerStyle={{ backgroundColor: '#F6F6F6' }}
                            renderItem={this.renderAreaData}
                            ItemSeparatorComponent={()=><View />}
                            ListHeaderComponent={()=><View />}
                            store={store}
                            refreshData={this.requestFirst}
                            loadMoreData={this.loadMoreData}

                        />
                    </View>

                    <View style={styles.rightView}>
                        <ScrollView style={{ width: width - getwidth(110) }} contentContainerStyle={styles.listAreaView}>
                            {
                                this.renderChooseArea()
                            }
                        </ScrollView>
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
    cff17: {
        color: '#FFFFFF',
        fontSize: 17
    },
    crf14: {
        color: '#EE6161',
        fontSize: 14
    },
    c2f14: {
        color: '#222222',
        fontSize: 14
    },
    cff10: {
        color: '#FFFFFF',
        fontSize: 10
    },
    viewContaner: {
        width: width,
        flex: 1,
        flexDirection: 'row'
    },
    leftView: {
        width: getwidth(110),
        height: '100%',
        backgroundColor: '#F6F6F6'
    },
    rightView: {
        width: width - getwidth(110),
        flex: 1,
        backgroundColor: '#fff'
    },
    areaListItem: {
        width: getwidth(110),
        height: 54,
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: 15
    },
    chooseBorder: {
        borderLeftColor: '#EE6161',
        borderLeftWidth: 3
    },
    aredItemView: {
        width: getwidth(80),
        height: 54,
        borderBottomColor: '#e5e5e5',
        borderBottomWidth: 1,
        justifyContent: 'center',
        paddingLeft: 6
    },
    listAreaView: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        paddingRight: 10,
        paddingBottom:CommonStyles.footerPadding+10
    },
    tableItem: {
        width: getwidth(75),
        height: getwidth(75),
        marginLeft: 6,
        marginTop: 10,
        justifyContent: 'center',
        alignItems: 'center'
    },
    noChoodeBorder: {
        borderColor: '#e5e5e5',
        borderWidth: 1,
        shadowColor: '#e5e5e5',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.5,
        elevation: 1,
        borderRadius:6
    },
    areachooseBorder: {
        borderColor: '#0A5FDA',
        borderWidth: 1,
        shadowColor: '#0A5FDA',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.33,
        elevation: 1,
        borderRadius:6
    },
    hsapic: {
        width: getwidth(36),
        height: getwidth(16),
        backgroundColor: '#4A90FA',
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 8
    },
    choose: {
        width: getwidth(15),
        height: getwidth(15),
        position: 'absolute',
        right: -getwidth(7.5),
        top: -getwidth(7.5),
    }
})
export default connect(
    (state) => ({ storeprop: state }),
)(ChooseTableNum)
