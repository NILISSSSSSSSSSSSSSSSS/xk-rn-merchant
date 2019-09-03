/**
 * 参与详情
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
} from "react-native";
import * as requestApi from '../../config/requestApi';
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import FlatListView from '../../components/FlatListView';
import ListEmptyCom from '../../components/ListEmptyCom'
const defaultImg = require('../../images/default/user.png')
const { width, height } = Dimensions.get("window");
function getwidth(val) {
    return width * val / 375
}
export default class WMPartakeDetailScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };
    state = {
        userList: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    }
    componentDidMount() {
        Loading.show();
        this.refresh(1)
    }
    refresh = (page = 1) => {
        const { navigation } = this.props
        const { limit, total,userList } = this.state;
        let sequenceId = navigation.getParam('sequenceId', '');
        if (!sequenceId) {
            Loading.hide();
            return
        }
        console.log('jSequenceJoinQPage',sequenceId)
        let params = {
            page,
            limit,
            sequenceId,
        }
        requestApi.jSequenceJoinQPage(params).then(data => {
            console.log('12321321',data)
            let _data;
            if (params.page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...userList, ...data.data] : userList;
            }
            // let _total = page === 1 ? data.total : total;
            let _total = params.page === 1
                ? (data)
                    ? data.total
                    : 0
                : total;
            let hasMore = data ? _total !== _data.length : false;
            this.setState({
                userList: _data,
                page:params.page,
                limit: params.limit,
                refreshing: false,
                hasMore,
                total:_total,
            })
        }).catch((err) => {
            console.log(err)
        });
    }
    handleChangeState = (key = '',value = '') => {
        this.setState({
            [key]: value
        })
    }
    componentWillUnmount() {
    }
    renderItem = ({item,index}) => {
        console.log(item)
        let borderRadiusTop = index === 0 ? styles.borderRadiusTop: {};
        let borderRadiusBottom = index === this.state.userList.length - 1 ? styles.borderRadiusBottom: {};
        return (
            <View style={[styles.listItem,borderRadiusBottom,borderRadiusTop,CommonStyles.flex_start_noCenter]} key={index}>
                <View style={styles.listItemImg}>
                    <Image source={(item.avatar) ? {uri:item.avatar}: defaultImg} style={{ width: getwidth(40), height: getwidth(40),borderRadius: 6 }} />
                </View>
                <View style={[styles.listItemRight,borderRadiusBottom,borderRadiusTop]}>
                    <View style={styles.listItemTitle}>
                        <Text style={{ color: '#222222', fontSize: 14 }}>{item.nickname || ''}</Text>
                    </View>
                    <View>
                        <Text style={{ color: '#555555', fontSize: 12,marginTop: 5 }}>参与注数：<Text style={{color:'#EE6161',fontSize: 12}}>{item.orderNumber}</Text></Text>
                        <Text style={{ color: '#555555', fontSize: 12,marginTop: 3,lineHeight: 18 }}>编号：
                        {
                            item.lotteryNumbers.map(item => `  ${item}`)
                        }
                        </Text>
                    </View>
                </View>
            </View>
        )
    }
    render() {
        const { navigation } = this.props;
        const { userList } = this.state
        console.log('this.state',this.state)
        return (
            <View style={styles.container}>
                <Header
                    goBack={true}
                    navigation={navigation}
                    title={"参与详情"}
                />
                <FlatListView
                    ListEmptyComponent={<ListEmptyCom type='WMPartakeDetail'/>}
                    style={styles.flatList}
                    store={this.state}
                    data={userList}
                    emptyStyle={{
                        paddingBottom: 40
                    }}
                    renderItem={this.renderItem}
                    refreshData={() => {
                        this.handleChangeState("refreshing", true);
                        this.refresh(1);
                    }}
                    ItemSeparatorComponent={() => (
                        <View style={styles.flatListLine} />
                    )}
                    loadMoreData={() => {
                        this.refresh(this.state.page + 1);
                    }}
                    // ListFooterComponent={() => {
                    //     return null
                    //     return (
                    //         <Text style={{textAlign:'center',paddingVertical: 15}}>已经到底啦</Text>
                    //     )
                    // }}
                />
            </View>
        );
    }
}


const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
    },
    flatList: {
        // flex: 1,
        backgroundColor: CommonStyles.globalBgColor
    },
    separator: {
        borderColor: '#F1F1F1',
        width: width,
        height: 0,
        borderWidth: 0.5
    },
    listItem: {
        marginHorizontal: 10,
        backgroundColor: '#fff'
    },
    listItemImg: {
        marginTop: 15,
        marginLeft:15,
    },
    listItemRight: {
        flex: 1,
        justifyContent: 'center',
        marginLeft: 10,
        paddingVertical: 15,
        paddingRight: 15,
        backgroundColor: '#fff',
        borderBottomWidth: 1,
        borderBottomColor: '#f1f1f1',
    },
    listItemTitle: {
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    flatListLine: {
        height: 1,
        backgroundColor: CommonStyles.globalBgColor
    },
    borderRadiusTop: {
        borderTopRightRadius: 8,
        borderTopLeftRadius: 8,
    },
    borderRadiusBottom: {
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
    },
})
