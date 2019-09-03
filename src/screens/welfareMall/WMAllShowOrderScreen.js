/**
 * 全部晒单
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    Platform,
    StatusBar,
    View,
    Text,
    Keyboard,
    TouchableOpacity,
    Image,
    Button,
    ScrollView,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import ListEmptyCom from '../../components/ListEmptyCom';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { getPreviewImage } from '../../config/utils';
import { NavigationComponent } from '../../common/NavigationComponent';
const { width, height } = Dimensions.get('window');

let defaultImage = require("../../images/default/avatar.jpg");

class WMAllShowOrderScreen extends NavigationComponent {
    static navigationOptions = {
        header: null,
    }
    constructor(props) {
        super(props)
        this.state = {
            goodsId: props.navigation.getParam('goodsId', ''),
            showAllLabels: false,
            type: 'all',
            page: 1,
            limit: 10,
            refreshing: false,
            loading: false,
            hasMore: false,
            total: 0,
            commentLabels: [],
            commentLists: [],
            showBigPicArr: [],
            showIndex: 0,
            showBigModal: false,
        }
    }

    blurState = {
        showBigModal: false,
    }

    componentDidMount() {
        Loading.show();
        this.getCommentlabels();
        this.refresh(1);
        console.log('this.props',this.props)
    }

    getCommentlabels = () => {
        const { goodsId } = this.state;
        requestApi.jGoodsCommentLabels({ goodsId }).then(res => {
            console.log('getCommentlabels')
            console.log('resres', res)
            res = res || [];
            for (let i = 0; i < res.length; i++) {
                res[i].selected_status = false;
                res[0].selected_status = true;
            }
            this.changeState('commentLabels', res);
            this.changeState('type', (res.length > 0) ? res[0].code : 'all');
        }).catch((err)=>{
            console.log(err)
          });
    }

    refresh = (page = 1, type = this.state.type) => {
        this.changeState('loading', true);
        const { goodsId, limit, total, commentLists } = this.state;
        requestApi.jmallGoodsCommentList({ page, limit, goodsId, type }).then(data => {
            console.log('refresh')
            console.log('111',data)
            data = data || [];
            let _data;
            if (page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...commentLists, ...data.data] : commentLists;
            }
            // let _total = page === 1 ? data.total : total;
            let _total = page === 1
                ? (data)
                    ? data.total
                    : 0
                : total;
            let hasMore = data ? _total !== _data.length : false;

            this.setState({
                refreshing: false,
                loading: false,
                page,
                hasMore,
                total: _total,
                commentLists: _data,
            });
        }).catch(err => {
            this.setState({
                refreshing: false,
                loading: false,
            });
        })
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    // 显示大图和查看视频
    handleShowBigPic = (commentIndex,showIndex) => {
        const {commentLists} = this.state
        let temp = [];
        let showItem = commentLists[commentIndex];
        console.log('showItem',showItem)
        showItem.pictures.map((item,i) => {
            temp.push({
                type: 'images',
                url: item
            })
        })
        if (showItem.video && showItem.video.url !== '' && showItem.video.mainPic !== null) {
            temp.push({
                type: 'video',
                mainPic: showItem.video.mainPic,
                url: showItem.video.url
            })
        }
        this.setState({
            showBigPicArr: temp,
            showIndex,
            showBigModal: true,
        })
    }
    render() {
        const { navigation, store } = this.props;
        const { commentLabels, showAllLabels, commentLists,showBigPicArr,showIndex,showBigModal } = this.state;
        let emptyStyle = commentLists.length === 0 ? {backgroundColor: CommonStyles.globalBgColor}: null;
        console.log('commentListscommentLists',commentLists)
        console.log('commentLabelscommentLabels',commentLabels)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={'全部晒单'}
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    let callback = navigation.getParam('callback', () => { })
                                    let routerIn = navigation.getParam('routerIn', '')
                                    if (routerIn === 'orderEvaluation') {
                                        callback()
                                        navigation.navigate('SOMOrder')
                                    } else {
                                        navigation.goBack()
                                    }
                                }}
                            >
                                <Image source={require('../../images/mall/goback.png')} />
                            </TouchableOpacity>
                        </View>
                    }
                />

                {
                    commentLabels.length > 0
                    ?<View style={[styles.comLabelsView,{ paddingBottom: 10, }]}>
                        {
                            commentLabels.map((item, index) => {
                                return (
                                    <TouchableOpacity
                                        key={index}
                                        style={[styles.commentLabelsItem, item.selected_status ? styles.commentLabelsItem1 : null]}
                                        onPress={() => {
                                            for (let i = 0; i < commentLabels.length; i++) {
                                                commentLabels[i].selected_status = false;
                                                if (commentLabels[i].code == item.code) {
                                                    commentLabels[i].selected_status = !item.selected_status;
                                                }
                                            }
                                            this.changeState('commentLabels', commentLabels);
                                            this.changeState('type', item.code);
                                            this.flatListRef && this.flatListRef.scrollToOffset({ offset: 0 });
                                            this.changeState('refreshing', true);
                                            this.refresh(1, item.code);
                                        }}
                                    >
                                        <Text style={[styles.commentLabelsItem_text, !item.selected_status ? styles.commentLabelsItem_text1 : null]}>{item.displayName}</Text>
                                        {
                                            item.count === 0 ?
                                                null :
                                                <Text style={[styles.commentLabelsItem_text, !item.selected_status ? styles.commentLabelsItem_text1 : null]}> ({item.count})</Text>
                                        }
                                    </TouchableOpacity>
                                );
                            })
                        }
                    </View>
                    : null

                }
                {
                    showAllLabels ?
                        <TouchableOpacity
                            style={styles.moreComLabels}
                            onPress={() => {
                                this.changeState('showAllLabels', true);
                            }}
                        >
                            <Image style={styles.moreComLabels_img} source={require('../../images/mall/zhankai_bom.png')} />
                        </TouchableOpacity> :
                        null
                }

                <FlatListView
                    flatRef={(e) => { e && (this.flatListRef = e) }}
                    style={[styles.flatList,emptyStyle]}
                    store={this.state}
                    data={commentLists}
                    refreshData={() => {
                        this.changeState('refreshing', true);
                        this.refresh(1);
                    }}
                    loadMoreData={() => {
                        this.refresh(this.state.page + 1);
                    }}
                    ListEmptyComponent={() => {
                        return (
                            <ListEmptyCom/>
                        )
                    }}
                    ListHeaderComponent={() => <View style={styles.flatList_header}></View>}
                    footerStyle={styles.flatList_footer}
                    ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
                    renderItem={({ item, index }) => {
                        item.commenter = item.commenter || {}
                        return (
                            <View key={index} style={styles.itemView}>
                                <View style={styles.itemView_left}>
                                    {/* <Image defaultSource={require("../../images/default/avatar.jpg")} style={styles.itemView_left_img} source={{ uri: item.commenter.avatar }} /> */}
                                    <Image defaultSource={defaultImage} style={styles.itemView_left_img} source={ item.commenter.avatar ? { uri: item.commenter.avatar } : defaultImage} />
                                </View>
                                <View style={styles.itemView_right}>
                                    <Text style={styles.itemView_right_text1}>{item.commenter.nickName}</Text>
                                    <View style={styles.itemView_right_item1}>
                                        <Text style={styles.itemView_right_text2}>{moment(item.createdAt * 1000).format('YYYY-MM-DD')}</Text>
                                        <Text style={[styles.itemView_right_text2, { marginLeft: 10 }]}>{item.goods.skuValue}</Text>
                                    </View>
                                    <Text style={styles.itemView_right_text3}>{item.content}</Text>
                                    <View style={styles.itemView_right_imgView}>
                                    {
                                        !item.pictures || item.pictures.length === 0
                                        ? null
                                        : item.pictures.map((item2, index2) => {
                                            return (
                                                <TouchableOpacity key={index2} onPress={() => {
                                                    this.handleShowBigPic(index,index2)
                                                }}>
                                                    <Image
                                                        key={index2}
                                                        style={styles.itemView_right_img}
                                                        source={{ uri: getPreviewImage(item2) }}
                                                    />
                                                </TouchableOpacity>
                                            );
                                        })
                                    }
                                    {
                                        (item.video && item.video.mainPic !== '' && item.video.url !== '' && item.video.mainPic !== null)
                                        ? <TouchableOpacity onPress={() => {
                                            this.handleShowBigPic(index, item.pictures.length)
                                        }}>
                                            <Image
                                                style={styles.itemView_right_img}
                                                source={{ uri: item.video.mainPic }}
                                            />
                                            {
                                                item.video.mainPic !== '' || item.video.url !== ''
                                                ? <View style={{height: '100%',width: '100%',position: 'absolute',...CommonStyles.flex_center}}>
                                                    <Image style={{height: 30,width: 30}} source={require('../../images/index/video_play_icon.png')} />
                                                </View>
                                                : null
                                            }
                                        </TouchableOpacity>
                                        :null
                                    }
                                    </View>
                                </View>
                            </View>
                        );
                    }}
                />
                {
                    showBigModal && <ShowBigPicModal
                        ImageList={showBigPicArr}
                        visible={showBigModal}
                        showImgIndex={showIndex}
                        onClose={() => {
                            this.setState({
                                showBigModal: false
                            })
                        }}
                    />
                }

            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    comLabelsView: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        // height: 76,
        paddingLeft: 5,
        paddingRight: 15,
        backgroundColor: '#fff',
    },
    commentLabelsItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: 28,
        marginTop: 10,
        marginLeft: 10,
        paddingHorizontal: 10,
        borderWidth: 1,
        borderColor: '#4A90FA',
        borderRadius: 34,
        backgroundColor: '#fff',
    },
    commentLabelsItem1: {
        backgroundColor: '#4A90FA',
    },
    commentLabelsItem_text: {
        fontSize: 12,
        color: '#fff',
    },
    commentLabelsItem_text1: {
        color: '#4A90FA',
    },
    moreComLabels: {
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        // height: 28,
        backgroundColor: '#fff',
    },
    moreComLabels_img: {
        width: 18,
        height: 18,
    },
    flatList: {
        flex: 1,
        backgroundColor: '#fff',
    },
    flatList_header: {
        height: 10,
        backgroundColor: CommonStyles.globalBgColor,
    },
    flatList_footer: {
        height: 40 + CommonStyles.footerPadding,
        paddingBottom: CommonStyles.footerPadding,
        backgroundColor: '#fff',
    },
    flatListLine: {
        width: width - 20,
        height: 1,
        marginHorizontal: 10,
        backgroundColor: '#F1F1F1',
    },
    itemView: {
        flexDirection: 'row',
        paddingHorizontal: 10,
        paddingVertical: 15,
    },
    itemView_left: {
        width: 46,
        height: 46,
        marginRight: 10,
        borderRadius: 8,
        backgroundColor: '#F1F1F1',
        overflow: 'hidden',
    },
    itemView_left_img: {
        width: '100%',
        height: '100%',
    },
    itemView_right: {
        flex: 1,
    },
    itemView_right_text1: {
        fontSize: 14,
        color: '#5396FB',
    },
    itemView_right_item1: {
        flexDirection: 'row',
        marginTop: 10,
        marginBottom: 10,
    },
    itemView_right_text2: {
        fontSize: 12,
        color: '#999',
    },
    itemView_right_text3: {
        fontSize: 12,
        color: '#222',
    },
    itemView_right_imgView: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        width: width - 76,
        // height: 100,
        // marginTop: 10,
        overflow: 'hidden',
    },
    itemView_right_img: {
        width: 80,
        height: 80,
        marginRight: 10,
        marginTop: 10,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        // position: 'absolute'
    },
    left: {
        width: 50
    },
});

export default connect(
    (state) => ({ store: state })
)(WMAllShowOrderScreen);
