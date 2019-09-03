/**
 * 所有评论回复
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
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment'
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as regular from '../../config/regular';
const { width, height } = Dimensions.get('window');
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import FlatListView from '../../components/FlatListView';
import ListEmptyCom from '../../components/ListEmptyCom';

let queryParam = {
    commentId: '',
    page: 1,
    limit: 10,
}
export default class CommentReplyScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        this.state = {
            listData: [],
            refreshing: false,  //下拉加载 refreshing,hasmore,loading
            hasmore: true,   //是否还有更多
            loading: false,  //是否正在上拉加载
        }
    }

    componentDidMount() {
        queryParam.page = 1
        queryParam.commentId = this.props.navigation.state.params.id
        requestApi.bcleGoodsCommentReplyList(queryParam).then((res) => {
            let listData = null
            if (res) {
                listData = res.data
                let hasmore = true
                if (listData.length < 10) {
                    hasmore = false
                }
                this.setState({
                    listData,
                    hasmore
                })
            }
        }).catch(()=>{
          
        })
    }

    componentWillUnmount() {
    }

    renderItem = ({ item, index }) => {
        const viewStyle = {
            borderTopLeftRadius: index == 0 ? 8 : 0,
            borderTopRightRadius: index == 0 ? 8 : 0,
            borderBottomLeftRadius: index == this.state.listData.length - 1 ? 8 : 0,
            borderBottomRightRadius: index == this.state.listData.length - 1 ? 8 : 0,
            overflow: 'hidden'
        }
        return (
            <View style={[viewStyle, styles.item]}>
                <View style={{ borderRadius: 6, overflow: 'hidden' }}>
                    <ImageView
                        source={{ uri: item.creator.avatar }}
                        sourceWidth={46}
                        sourceHeight={46}
                    />
                </View>

                <View style={styles.rightView}>
                    <View style={{ height: 46 }}>
                        <Text style={{ color: '#222222', fontSize: 14, lineHeight: 22 }}>{item.creator.nickName}</Text>
                        <Text style={{ color: '#999999', fontSize: 10, marginTop: 2 }}>{moment(item.createdAt).format('YYYY-MM-DD HH:mm')}</Text>
                    </View>
                    {
                        item.refCreator &&
                        <Text style={styles.smallText}>
                            回复<Text style={{ color: '#629EFB' }}>{item.creator.nickName}：</Text>{item.content}
                        </Text>
                        ||
                        <Text style={styles.smallText}>
                            {item.content}
                        </Text>
                    }

                </View>
            </View>

        )
    }
    ListEmptyComponent = () => {
        const { refreshing, loading } = this.state
        return (
            <View style={styles.emptyView}>
                {
                    refreshing && loading ?null:
                    <ListEmptyCom />
                }
            </View>
        )
    }
    ListFooterComponent = () => {
        const { refreshing, loading, hasmore, listData } = this.state
        if (refreshing || listData.length == 0) return null
        return (
            <View style={styles.footerView}>
                <Text style={styles.footerText}>
                    {hasmore && loading ? '加载中...' : listData.length >= 10 ? '已经到底啦' : ''}
                </Text>
            </View>
        )
    }
    refreshData = () => {
        this.setState({
            refreshing: true
        })
        queryParam.page += 1
        requestApi.bcleGoodsCommentReplyList(queryParam).then((res) => {
            let listData = null
            if (res) {
                listData = res.data
                this.setState({
                    listData: this.state.listData.concat(listData),
                    refreshing: false,
                    hasmore: true
                })
            } else {
                this.setState({
                    refreshing: false,
                    hasmore: false
                })
            }
        }).catch(()=>{
          
        })
    }
    endReachedData = () => {
        const { refreshing, loading, hasmore, listData } = this.state
        if (!hasmore || loading || refreshing) {
            return
        }
        this.setState({
            loading: true
        })
        queryParam.page += 1
        requestApi.bcleGoodsCommentReplyList(queryParam).then((res) => {
            let listData = null
            if (res) {
                listData = res.data
                this.setState({
                    listData: this.state.listData.concat(listData),
                    loading: false,
                    hasmore: true
                })
            } else {
                this.setState({
                    loading: false,
                    hasmore: false
                })
            }
        }).catch(()=>{
          
        })
    }
    render() {
        const { navigation, store } = this.props;
        const { listData, refreshing } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={this.props.navigation.state.params.count + '条回复'}
                />
                <FlatList
                    style={styles.flatListView}
                    data={listData}
                    refreshing={refreshing}
                    renderItem={this.renderItem}
                    ItemSeparatorComponent={() => { return (<View style={styles.separator} />) }}
                    ListEmptyComponent={this.ListEmptyComponent}
                    ListFooterComponent={this.ListFooterComponent}
                    onRefresh={this.refreshData}
                    onEndReached={this.endReachedData}
                    onEndReachedThreshold={0.1}
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
    flatListView: {
        backgroundColor: CommonStyles.globalBgColor,
        marginVertical: 10,
        flex: 1,
        width: width - 20,
        marginLeft: 10
    },
    item: {
        backgroundColor: '#fff',
        padding: 15,
        flexDirection: 'row',
    },
    rightView: {
        flex: 1,
        marginLeft: 16
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 5
    },
    smallText: {
        color: '#777777',
        fontSize: 12,
        lineHeight: 16
    },
    separator: {
        width: width,
        height: 1,
        backgroundColor: CommonStyles.globalBgColor,
    },
    emptyView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        marginTop: 50,
    },
    emptyText: {
        fontSize: 16,
        color: '#666',
    },
    footerView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        height: 40,
        backgroundColor: CommonStyles.globalBgColor,
    },
    footerText: {
        fontSize: 14,
        color: '#666',
    },

});
