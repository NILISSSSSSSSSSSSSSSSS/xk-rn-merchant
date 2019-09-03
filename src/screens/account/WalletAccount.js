/**
 * 财务账户 提现记录
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
import { connect } from "rn-dva";
import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import moment from 'moment'
import Content from '../../components/ContentItem'
import FlatListView from '../../components/FlatListView'

import * as requestApi from "../../config/requestApi";
const { width, height } = Dimensions.get('window')
function getwidth(val) {
    return width * val / 375
}

class WalletAccount extends Component {
    constructor(props) {
        super(props)
    this.state = {
        listName:'wallet',
        recordType:props.navigation.getParam('recordType')
    }
}
    getList = (isFirst = false, isLoadingMore = false,loading=true,refreshing=true) => {
        this.props.fetchList({
            witchList:this.state.listName,
            isFirst,
            isLoadingMore,
            paramsPrivate : {
                qMerchantId:this.props.userInfo.merchantId,
                type:-1
            },
            api:requestApi.shopMerchantAdvanceQPage,
            loading,
            refreshing
        })
    };

    componentDidMount() {
        this.getList(true, false);
    }

    renderItem = ({item,index}) => {
        let txtcolor = CommonStyles.globalHeaderColor
        let br= null
        const {longLists}=this.props
        const {listName}=this.state
        const lists=longLists[listName] && longLists[listName].lists || []
        if(index === 0){
            br = {
                borderTopLeftRadius:6,
                borderTopRightRadius:6,
            }
        }
        if(index === lists.length-1){
            br = {
                borderBottomRightRadius:6,
                borderBottomLeftRadius:6
            }
        }
        if(lists.length === 1){
            br = {
                borderTopLeftRadius:6,
                borderTopRightRadius:6,
                borderBottomRightRadius:6,
                borderBottomLeftRadius:6
            }
        }
        let auditName='未审核'
        switch(item.audit){
            case 'UNAUDITED':auditName='未审核';break;
            case 'UNAPPROVED':auditName='审核未通过';break;
            case 'UN_FINISH':auditName='提现失败';break;
            case 'VERIFIED':auditName='提现中';break;
            case 'FINISH':auditName='已到账';break;
        }
        return item.audit=='UNAPPROVED' && this.state.recordType === 'xkq'?null: (
            <View style={[styles.listItem,br]}>
                <View style={styles.topItem}>
                    <Text style={styles.tixianTxt}>提现</Text>
                    <Text style={[styles.tixianStatus,{color:item.audit=='UNAPPROVED'?CommonStyles.globalRedColor:'#ccc'}]}>{auditName}</Text>
                </View>
                <View style={styles.bottomItem}>
                    <Text style={styles.itemdate}>{moment(item.	createdAt * 1000).format('YYYY-MM-DD')}</Text>
                    <Text style={{ color: txtcolor, fontSize: 20 }}>-{parseFloat(item.amount)/100}</Text>
                </View>
            </View>
        )
    }
    renderSeparator = () => {
        return <View style={styles.separator} />
    }
    render() {
        const { navigation ,longLists } = this.props
        const { recordType,listName } = this.state
        return (
            <View style={styles.container} >
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={recordType === 'xkq' ? '钱包' : (recordType === 'xkb') ? '晓可币冻结记录' : '钱包'}
                />
                <FlatListView
                    style={{ width: getwidth(355), height: height - CommonStyles.headerPadding,backgroundColor:'#EEEEEE'}}
                    renderItem={this.renderItem}
                    ItemSeparatorComponent={this.renderSeparator}
                    store={{
                        ...(longLists[listName] || {}),
                        page: longLists[listName] && longLists[listName].listsPage || 1
                    }}
                    data={longLists[listName] && longLists[listName].lists || []}
                    numColumns={1}
                    refreshData={() =>
                        this.getList(false, false)
                    }
                    loadMoreData={() =>
                        this.getList(false, true)
                    }
                />
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
    listItem: {
        width: getwidth(355),
        height: 65,
        paddingVertical: 10,
        // borderRadius:8,
        // borderColor:'#eee',
        // borderWidth:0.2,
        backgroundColor:'#fff'
    },
    topItem: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 45 / 2,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    bottomItem: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 45 / 2,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    tixianTxt: {
        color: '#222222',
        fontSize: 14
    },
    tixianStatus: {
        color:'#222224',
    },
    itemdate: {
        color: '#999999',
        fontSize: 12
    }
})
export default connect(
     (state) => ({
        userInfo:state.user.user || {},
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
     }),
     {
        fetchList: (payload={})=> ({ type: "shop/getList", payload}),
        shopSave: (payload={})=>({ type: "shop/save", payload}),
     }
)(WalletAccount);
