
/**
 * 运费管理
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    FlatList,
    RefreshControl,
    TouchableOpacity,
} from 'react-native';
import Header from '../../components/Header'
import { connect } from 'rn-dva'
import CommonStyles from '../../common/Styles'
import FlatListView from '../../components/FlatListView'
import Content from '../../components/ContentItem'
import * as requestApi from '../../config/requestApi'
import ListEmptyCom from '../../components/ListEmptyCom';
import math from '../../config/math';
const { width, height } = Dimensions.get('window')
function getwidth(val) {
    return width * val / 375
}
class FreightManagScreen extends Component {
    constructor(props) {
        super(props)
        this.state={
            listName:'freight'
        }
    }
    componentDidMount(){
        this.getList(true, false);
    }

    getList = (isFirst = false, isLoadingMore = false) => {
        this.props.fetchList({
            witchList:this.state.listName,
            isFirst,
            isLoadingMore,
            paramsPrivate : {
                shopId: this.props.userShop.id
            },
            api:requestApi.mUserPostFeeQList
        })
    };
    renderdestFee = (item) => {
        let destFee = item.destFee || {}
        let valuateType = item.valuateType
        // if(valuateType === 'NONE'){
        //     return <Text style={styles.itemcontenttxt}>晓可物流</Text>
        // }
        let defaultNum = destFee.defaultNum  //多少内
        let defaultFee =math.divide(Number(destFee.defaultFee || 0) ,100)      //多少钱
        let increNum = destFee.increNum   //每增加
        let increFee =math.divide(Number(destFee.increFee || 0) ,100)     //增加多少钱
        if (!defaultNum && !defaultFee && !increNum && !increFee) {
            return <Text style={styles.itemcontenttxt}>未设置</Text>
        }
        if (valuateType === 'BY_NUMBER') {
            defaultNum = defaultNum + '件'
            increNum = increNum + '件'
        } else if(valuateType === 'BY_WEIGHT'){
            defaultNum = (math.divide(defaultNum || 0,1000)) + 'kg'
            increNum = (math.divide(increNum || 0,1000)) + 'kg'
        }else{
            defaultNum = (math.divide(defaultNum || 0,1000)) + 'km'
            increNum = (math.divide(increNum || 0,1000)) + 'km'
        }
        return <Text ellipsizeMode='tail' numberOfLines={1} style={styles.itemcontenttxt} >{defaultNum}内{defaultFee}元，每增加{increNum}增加运费{increFee}元</Text>
    }
    renderItem = (data) => {
        let item = data.item
        return (
            <Content style={styles.itemcontent} key={data.index}>
                <View>
                    <Text style={styles.itemTitle}>{item.storeName}</Text>
                    {
                        this.renderdestFee(item)
                    }
                </View>
                <TouchableOpacity style={styles.btnItem} onPress={() => { this.handleItem(item) }}>
                    <Text style={{ color: '#4A90FA' }}>编辑</Text>
                </TouchableOpacity>
            </Content>
        )
    }
    handleItem = (item) => {
        const { navigation } = this.props
        navigation.navigate('FreightManagEditor', { itemdata: item,callback:()=>this.getList(false, false)})
    }
    render() {
        const { navigation, longLists } = this.props;
        const {  listName } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='运费管理'
                />
                <FlatListView
                    style={styles.flatListView}
                    renderItem={data => this.renderItem(data)}
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
        backgroundColor: CommonStyles.globalBgColor
    },
    flatListView:{
        backgroundColor:CommonStyles.globalBgColor,
    },
    itemcontent: {
        // alignItems: 'center',
        flexDirection: 'row',
        flexWrap: 'nowrap',
        width: width - 20,
        marginLeft: 10,
        borderRadius: 6,
        padding:15,
        marginBottom:0,
        marginTop:0
    },
    itemTitle: {
        fontSize: 14,
        color: '#222222'
    },
    itemcontenttxt: {
        fontSize: 12,
        color: '#999999',
        marginTop: 15,
    },
    btnItem: {
        width: getwidth(60),
        height: 22,
        borderColor: '#4A90FA',
        borderWidth: 1,
        borderRadius: 12,
        position: 'absolute',
        top: 15,
        right: 15,
        alignItems: 'center',
        justifyContent: 'center',
    },
})
export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
     }),
    (dispatch) => ({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
     })
)(FreightManagScreen)

