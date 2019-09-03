/**
 * 大奖晒单
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../common/Styles'
import * as requestApi from '../../config/requestApi'
import Header from '../../components/Header'
import FlatListView from "../../components/FlatListView";
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { getPreviewImage } from '../../config/utils'
import { NavigationComponent } from "../../common/NavigationComponent";

let defaultImage = require("../../images/default/avatar.jpg");

const { width, height } = Dimensions.get("window")
const errorImage = require('../../images/default/break_long.png');
function getwidth(val) {
    return width * val / 375
}
class BigPrizeOrder extends NavigationComponent {
    state = {
        store: {
            refreshing: false,
            loading: false,
            hasMore: true,
            isFirstLoad: true,
            page: 1,
            limit: 10
        },
        data: [{
            display: 'flex',
            id: 1,
        }, {
            display: 'none',
            id: 2
        }, {
            display: 'none',
            id: 3
        }],
        allLists: [],
        limit: 10,
        page: 1,
        refreshing: false,
        total: 0,
        hasMore: false,
        showImgLimit: 3,
        showImgIndex: 0,
        showBingPicVisible: false,
        largeImage: [],


    }

    blurState = {
        showBingPicVisible: false,
    }
    componentDidMount() {
        Loading.show()
        this.refresh(1)
        // this.getLists()
    }
    refresh = (page = 1, refreshing = false) => {
        this.handleChangeState('refreshing', refreshing)
        const { limit, total, allLists } = this.state;
        requestApi.jmallGoodsCommentList({
            page,
            limit,
        }).then(data => {
            let _data;
            if (page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...allLists, ...data.data] : allLists;
            }
            // let _total = page === 1 ? data.total : total;
            let _total = page === 1
                ? (data)
                    ? data.total
                    : 0
                : total;
            let hasMore = data ? _total !== _data.length : false;
            _data.map(item => { // 设置展开关闭
                let largeImage = []; // 获取所有图片视频
                let i = 0;
                if (item.video && item.video.mainPic !== '' && item.video.mainPic !== null && item.video.url !== '' && item.video.url !== null) {
                    i ++
                }
                i += item.pictures.length;
                if (i > 3) {
                    item['isShowToggle'] = true
                    item['toggle'] = false
                }else {
                    item['isShowToggle'] = false
                    item['toggle'] = false
                }
                if (item.pictures) {
                    item.pictures.map((item, index) => {
                        largeImage.push({
                            type: 'images',
                            url: item
                        })
                    })
                }
                if (item.video && item.video.mainPic !== '' && item.video.url !== '' && item.video.mainPic !== null) {
                    largeImage.push({
                        type:'video',
                        mainPic: item.video.mainPic,
                        url: item.video.url
                    })
                }
                item['largeImage'] = largeImage
            })

            this.setState({
                refreshing: false,
                page,
                hasMore,
                total: _total,
                allLists: _data,
            });
        }).catch(() => {
            this.setState({
                refreshing: false
            });
        });
    };
    handleChangeState = (key, val, callback = () => { }) => {
        this.setState({
            [key]: val
        });
        callback();
    };
    chengItemDispaly = (one) => {
        const { data } = this.state
        data.forEach((item) => {
            if (item.id === one.id) {
                if (one.display === 'none') {
                    item.display = 'flex'
                } else {
                    item.display = 'none'
                }
            }
        })
        this.setState({
            data
        })
    }
    handleToogleShow = (item,index) => {
        const { allLists } = this.state
        allLists[index].toggle  = !allLists[index].toggle;
        this.setState({
            allLists,
        })
    }
    handleShowBigPic = (item,index) => {
        let largeImage = [];
        if (item.pictures) {
            item.pictures.map((item, index) => {
                largeImage.push({
                    type: 'images',
                    url: item
                })
            })
        }
        if (item.video && item.video.mainPic !== '' && item.video.url !== '' && item.video.mainPic !== null) {
            largeImage.push({
                type:'video',
                mainPic: item.video.mainPic,
                url: item.video.url
            })
        }
        this.setState({
            largeImage,
            showBingPicVisible: true,
            showImgIndex: index
        })
    }
    renderImgVideo = (item,itemImg,i) => {
        return (
            <React.Fragment key={i}>
                {
                    (itemImg.type === 'video')
                    ? <TouchableOpacity onPress={() => { this.handleShowBigPic(item,(item.pictures) ? item.pictures.length: 0) }} activeOpacity={0.7}>
                        <Image style={styles.showOrderImg}
                        defaultSource={require('../../images/skeleton/skeleton_img.png')}
                        onError={() => {console.log('图片加载失败',item,itemImg)}}
                        source={{ uri: itemImg.mainPic }} />
                        <View style={{height: 68,width: 68,top: 5,position: 'absolute',...CommonStyles.flex_center}}>
                            <Image style={{height: 30,width: 30}} source={require('../../images/index/video_play_icon.png')} />
                        </View>
                    </TouchableOpacity>
                    : <TouchableOpacity key={i} onPress={() => { this.handleShowBigPic(item,i) }}  activeOpacity={0.7}>
                        <Image
                        style={styles.showOrderImg}
                        source={{ uri: itemImg.url }}
                        onError={() => {console.log('图片加载失败',item,itemImg)}}
                        defaultSource={require('../../images/skeleton/skeleton_img.png')}
                        />
                    </TouchableOpacity>
                }
            </React.Fragment>
        )
    }
    renderItem = ({ item, index }) => {
        const { largeImage } = this.state
        let borderTopRadius = index === 0 ? styles.borderTopRadius : {};
        let borderBottomRadius = index === this.state.allLists.length - 1 ? styles.borderBottomRadius : {};
        let borderTop = index === 0 ? styles.borderTop : {};
        let borderBottom = index === this.state.allLists.length - 1 ? styles.borderBottom : {};
        item.commenter = item.commenter || {}
        return (
            <View style={[styles.listItem, borderTopRadius, borderBottomRadius, styles.borderHor]} key={index}>
                <View style={styles.listItemImg} onPress={() => { }}>
                    <Image defaultSource={defaultImage} style={styles.titlePig} source={ item.commenter.avatar ? { uri: item.commenter.avatar } : defaultImage} />
                    {/* <Image defaultSource={require("../../images/default/avatar.jpg")} source={{ uri: item.commenter.avatar }} style={styles.titlePig} onError={() => {this.onError(index)}} /> */}
                </View>
                <View style={styles.listItemRight}>
                    <TouchableOpacity style={styles.listRightTitle} onPress={() => { }}>
                        <Text style={{ color: '#222222', fontSize: 14 }}>{item.commenter.nickName}</Text>
                    </TouchableOpacity>

                    <Text style={{ color: '#999999', fontSize: 10 }}>中奖时间：{moment(item.goods.winDate * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>

                    <Text style={{ color: '#777777', fontSize: 12,marginTop: 5 }} ellipsizeMode='tail'>{item.content}</Text>

                    <View style={styles.showOrderImgWrap}>
                        {
                            item.largeImage.map((itemImg, i) => {
                                if (item.toggle) {
                                    return this.renderImgVideo(item,itemImg,i)

                                } else {
                                    if (i >= 3) return
                                    return this.renderImgVideo(item,itemImg,i)
                                }
                            })
                        }
                    </View>
                    {
                        item.isShowToggle
                        ?<TouchableOpacity onPress={() => {this.handleToogleShow(item,index)}}>
                            <Text style={styles.showMoreImgBtn}>{!item.toggle ? '展开' : '收起'}</Text>
                        </TouchableOpacity>
                        : null
                    }
                </View>
            </View>
        )
    }
    renderSeparator = () => {
        return <View style={styles.separatorCom} />
    }
    render() {
        const { navigation } = this.props
        const { store, allLists, showBingPicVisible, showImgIndex, largeImage } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                            <Text style={{ fontSize: 17, color: '#fff' }}>大奖晒单</Text>
                        </View>
                    }
                />
                <FlatListView
                    data={allLists}
                    style={styles.flatListSty}
                    renderItem={this.renderItem}
                    store={this.state}
                    ItemSeparatorComponent={this.renderSeparator}
                    refreshData={this.refresh}
                    loadMoreData={() => {
                        this.refresh(this.state.page + 1);
                    }}
                // footerStyle={{ backgroundColor: '#fff' }}
                />
                <ShowBigPicModal
                    ImageList={largeImage}
                    visible={showBingPicVisible}
                    showImgIndex={showImgIndex}
                    onClose={() => { this.handleChangeState('showBingPicVisible', false) }}
                />
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        // backgroundColor: CommonStyles.globalBgColor,
    },
    flatListSty: {
        width: getwidth(355),
        flex: 1,
        backgroundColor: CommonStyles.globalBgColor,
    },
    separatorCom: {
        width: width,
        height: 0,
        borderWidth: 0.5,
        borderColor: '#F1F1F1'
    },
    listItem: {
        width: getwidth(355),
        paddingHorizontal: 15,
        paddingRight: 10,
        paddingBottom: 10,
        paddingTop: 15,
        flexDirection: 'row',
        backgroundColor: '#fff'
    },
    listItemImg: {
        width: getwidth(46),
    },
    listItemRight: {
        flex: 1,
        marginLeft: 15,
    },
    listRightTitle: {
        width: getwidth(265),
    },
    titlePig: {
        width: getwidth(46),
        height: getwidth(46),
        borderRadius: 5,
    },
    listPig: {
        width: getwidth(68),
        height: getwidth(68),
        marginRight: 10
    },
    zhankaisty: {
        width: getwidth(44),
        height: '100%',
        alignItems: 'flex-start',
        justifyContent: 'flex-end',
    },
    showOrderImgWrap: {
        backgroundColor: '#fff',
        flexDirection: 'row',
        justifyContent: 'flex-start',
        flexWrap: 'wrap',
        // paddingLeft: 15,
        paddingTop: 5,
    },
    showOrderImg: {
        width: 68,
        height: 68,
        marginRight: 5,
        marginTop: 5,
        borderRadius: 3,
    },

    showMoreImgBtn: {
        color: CommonStyles.globalHeaderColor,
        fontSize: 12,
        // paddingLeft: 15,
        marginTop: 5,
        paddingBottom: 5,
    },
    borderTopRadius: {
        borderTopLeftRadius: 6,
        borderTopRightRadius: 6,
    },
    borderBottomRadius: {
        borderBottomLeftRadius: 6,
        borderBottomRightRadius: 6,
    },
    borderTop: {
        borderTopWidth: 0.7,
        borderTopColor: 'rgba(215,215,215,0.5)',
    },
    borderBottom: {
        borderBottomColor: 'rgba(215,215,215,0.5)',
        borderBottomWidth: 0.7,
    },
    borderHor: {
        borderLeftColor: 'rgba(215,215,215,0.5)',
        borderLeftWidth: 0.7,
        borderRightWidth: 0.7,
        borderRightColor: 'rgba(215,215,215,0.5)',
    }
})
export default connect(
    (state) => ({ store: state })
)(BigPrizeOrder)
