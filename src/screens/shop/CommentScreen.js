/**
 * 评价管理
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
    ScrollView,
    Modal,
    Platform,
    RefreshControl,
    TouchableNativeFeedback,
    TouchableWithoutFeedback,
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment'
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as regular from '../../config/regular';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import Line from '../../components/Line';
import ListEmptyCom from '../../components/ListEmptyCom';
const sjhuifu = require('../../images/pingjia/sjhuifu.png')
import FlatListView from '../../components/FlatListView';
import { NavigationComponent } from '../../common/NavigationComponent';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { dispatch } from 'rxjs/internal/observable/pairs';
let defaultImage = require("../../images/default/avatar.jpg");

const { width, height } = Dimensions.get('window');
const options = [
    { title: '全部', sortedBy:'',sortedDesc:null },
    { title: '评价时间由近到远', sortedBy:'commentDate',sortedDesc:true },
    { title: '评价时间由远到近',sortedBy:'commentDate',sortedDesc:false },
    { title: '评分从高到低', sortedBy:'score',sortedDesc:true },
    { title: '评分从低到高', sortedBy:'score',sortedDesc:false},
]

function getwidth(val) {
    return width * val / 375
}

let queryParam = {
    shopId: '',
    sortedBy: '',
    sortedDesc: null,
    page: 1,
    limit: 10,
}
class CommentScreen extends NavigationComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        let params = props.navigation.state.params || {}
        console.log(props.navigation.state)
        this.state = {
            visible: false,
            optionKey: 0,
            shopvisible: false,
            shopId: params.shopId || props.userShop.id,
            listData: [],
            refreshing: false,  //下拉加载 refreshing,hasMore,loading
            hasMore: true,   //是否还有更多
            loading: false,  //是否正在上拉加载
            sjHuifuval: '',
            sjhuifuVisible: false,
            goodsId: params.goodsId || '',
            isFirstLoad:true,
            bigPicVisible:false, //查看大图modal
            selectedImageIndex:0 ,//选中的大图index
            showBigPicArr:[]
        }
    }

    blurState = {
        visible: false,
        shopvisible: false,
        sjhuifuVisible: false,
    }

    componentWillUnmount() {
        queryParam = {
            shopId: '',
            sortedBy: '',
            sortedDesc: null,
            page: 1,
            limit: 10,
        }
    }
    //每一个item的数据增加一个 huifuStatus ：1显示 商家回复按钮。  2显示回复输入框  3,显示回复完成的数据
    componentDidMount() {
        this.firstLoad()
    }
    firstLoad = (refreshing) => {
        console.log(refreshing)
        const { shopId, goodsId } = this.state
        queryParam.shopId = shopId
        queryParam.page = 1
        if (goodsId) {
            queryParam.goodsId = goodsId
        } else {
            queryParam.goodsId = null
        }
        refreshing ? null : Loading.show()
        this.setState({
            refreshing: refreshing ? true : false,
        });
        requestApi.bcleGoodsCommentList4Merchant(queryParam).then((res) => {
            console.log('res', res)
            let listData = null
            if (res) {
                listData = res.data
                let hasMore = true
                if (listData && listData.length < 10) {
                    hasMore = false
                }
                this.setState({
                    listData,
                    hasMore,
                    refreshing: false,
                    isFirstLoad:false
                })
            } else {
                this.setState({
                    refreshing: false,
                    hasMore: false,
                    listData: [],
                    isFirstLoad:false
                })
            }
        }).catch(() => {
            this.setState({
                hasMore: true,
                refreshing: false
            })
        })
    }

    componentWillUnmount() {
        RightTopModal.hide()
    }
    renderStar = (number) => {
        let arr = [1, 2, 3, 4, 5]
        return (
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                {
                    arr.map((item, index) => {
                        return (
                            <ImageView
                                key={index}
                                source={number < index + 1 ? require('../../images/index/star_gray.png') : require('../../images/index/star_red.png')}
                                sourceWidth={15}
                                sourceHeight={15}
                                style={{ marginRight: 16.5 }}
                            />
                        )
                    })
                }
            </View>
        )
    }
    changehuifuInputVisible = (item) => {
        this.setState({
            sjhuifuVisible: true,
            clickedItem: item
        })
    }
    sendSJhuifu = (item) => {
        const { listData, sjHuifuval } = this.state
        //发送请求
        let param = {
            commentId: item.id,
            userId: this.props.user.id,
            content: sjHuifuval
        }
        requestApi.bcleGoodsCommentMerchantReply(param).then((res) => {
            listData.find((data) => {
                if (data.id === item.id) {
                    data.shopReplier = {
                        content: sjHuifuval
                    }
                    return
                }
            })
            this.setState({
                listData,
                sjHuifuval: '',
                clickedItem: null,
                sjhuifuVisible: false
            })
        }).catch(()=>{
          
        })
    }
    showBigPic=(pics,selectedImageIndex)=>{
        let showBigPicArr=[]
        pics.map((item,index)=>{
            showBigPicArr.push((typeof item)=='string' || item===null?{ type: 'images', url: item }:{ type: 'video', url: item.url })
        })
        this.setState({
            selectedImageIndex,
            showBigPicArr,
            bigPicVisible:true
        })
    }
    renderItem = ({ item, index }) => {
        const viewStyle = {
            backgroundColor: '#fff',
            paddingHorizontal:25
        }
        item.commenter = item.commenter || {}
        let picAndVideo=item.pictures || []
        item.video ? picAndVideo=[item.video,...picAndVideo]:null
        // console.log(item,picAndVideo)
        return (
            <View style={viewStyle} key={index}>
                <View style={styles.item}>
                    <View style={{ borderRadius: 6, overflow: 'hidden', flexDirection: 'row', alignItems: 'center' }}>
                        <Image defaultSource={defaultImage} style={{ width: 46, height: 46}} source={ item.commenter.avatar ? { uri: item.commenter.avatar } : defaultImage} />
                        <View style={{ marginLeft: 10, flex: 1 }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={{ color: '#222222', fontSize: 14, }}>{item.commenter.nickName}</Text>
                                <Text style={{ color: '#999999', fontSize: 10, marginTop: 2, flex: 1, textAlign: 'right' }}>{moment(item.createdAt * 1000).format('YYYY-MM-DD HH:mm')}</Text>
                            </View>
                            <Text style={{ fontSize: 12, color: '#4A90FA',marginTop:6 }}>{item.goods.name}</Text>
                        </View>
                    </View>

                    <View style={styles.rightView}>
                        <View style={[styles.row,{marginTop:10}]}>
                            <Text style={{ color: '#222222', fontSize: 12, marginRight: 17 }}>评分项</Text>
                            {this.renderStar(item.score)}
                        </View>
                        <Text style={{ color: '#777777', fontSize: 12, lineHeight: 16 }}>{item.content}</Text>
                        <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                            {
                                picAndVideo.map((item, index) => {
                                    // console.log('kkkkkk',item)
                                    return (
                                        <TouchableOpacity onPress={()=>this.showBigPic(picAndVideo,index)} key={index}>
                                            <ImageView
                                                source={{ uri: (typeof item)=='string' || item===null? item :item.mainPic}}
                                                sourceWidth={68}
                                                sourceHeight={68}
                                                style={{  marginRight: 10, marginTop: 5,backgroundColor:'#f7f7f7' }}
                                            />
                                            {
                                                (typeof item)=='string'?null:
                                                <View style={{height: 68,width: 68,top: 5,position: 'absolute',...CommonStyles.flex_center}}>
                                                    <Image style={{height: 30,width: 30}} source={require('../../images/index/video_play_icon.png')} />
                                                </View>
                                            }
                                        </TouchableOpacity>
                                    )
                                })
                            }
                        </View>
                    </View>
                </View>
                    <View style={{
                        padding: 10, backgroundColor: '#F6F6F6', borderRadius: 4,marginBottom:20
                    }}>
                        {
                            !item.shopReplier &&
                            < TouchableOpacity
                                style={{ flexDirection: 'row', alignItems: 'center' }}
                                onPress={() => { this.changehuifuInputVisible(item) }}>
                                <ImageView source={sjhuifu} sourceWidth={18} sourceHeight={18} />
                                <Text style={{ marginLeft: 4, fontSize: 12, color: '#999999' }}>商家回复</Text>
                            </TouchableOpacity>
                        }
                        {
                            item.shopReplier && item.shopReplier.content &&
                            <Text style={{ fontSize: 12, color: 'black' }} numberOfLines={6}>商家回复：<Text style={{ fontSize: 12, color: '#3F3F3F' }}>
                                {item.shopReplier && item.shopReplier.content}
                            </Text>
                            </Text>
                        }
                    </View>
                {
                    !item.previousReply || (item.previousReply && item.previousReply.length==0)?null:
                    <View style={[styles.item, { borderTopWidth: 1, borderColor: '#F6F6F6',paddingVertical:20 }]}>
                        {
                            this.renderpreviousReply(item)
                        }
                    </View>

                }

            </View >
        )
    }
    renderpreviousReply = (item = {}) => {
        let previousReply = item.previousReply
        if (previousReply && previousReply.length >= 2) {
            return (
                <View style={styles.rightView}>
                    {/* <Text style={[styles.smallText, { paddingVertical: 10, marginBottom: 10, borderBottomWidth: 1, borderColor: '#F1F1F1' }]}>
                        <Text style={{ color: '#629EFB' }}>{previousReply[0].creator.nickName}：</Text>{previousReply[0].content}
                    </Text> */}
                    {
                        previousReply[0] && previousReply[0].refCreator &&
                        <Text style={styles.smallText}>
                            <Text style={{ color: '#629EFB' }}>{previousReply[0].creator && previousReply[0].creator.nickName}</Text> 回复<Text style={{ color: '#629EFB' }}>{previousReply[0].refCreator.nickName}：</Text>{previousReply[0].content}
                        </Text>
                        ||
                        <Text style={styles.smallText}>
                            <Text style={{ color: '#629EFB' }}>{previousReply[0] && previousReply[0].creator && previousReply[0].creator.nickName}：</Text>{previousReply[0] && previousReply[0].content}
                        </Text>
                    }
                    {
                        previousReply[1] && previousReply[1].refCreator &&
                        <Text style={styles.smallText}>
                            <Text style={{ color: '#629EFB' }}>{previousReply[1].creator && previousReply[1].creator.nickName}</Text>回复<Text style={{ color: '#629EFB' }}>{previousReply[1].refCreator.nickName}：</Text>{previousReply[1].content}
                        </Text>
                        ||
                        <Text style={styles.smallText}>
                            <Text style={{ color: '#629EFB' }}>{previousReply[1] && previousReply[1].creator && previousReply[1].creator.nickName}：</Text>{previousReply[1] && previousReply[1].content}
                        </Text>
                    }

                    <TouchableOpacity
                        style={[styles.row, { marginBottom: 0 }]}
                        onPress={() => { this.props.navigation.navigate('CommentReply', { id: item.id, count: item.replyCount }) }}
                    >
                        <Text style={styles.smallText}>总共<Text style={{ color: '#629EFB' }}>{item.replyCount}条回复</Text></Text>
                        <Image
                            source={require('../../images/index/expand.png')}
                            tintColor={'#629EFB'}
                            style={{ marginLeft: 5, width: 10, height: 10 }}
                        />
                    </TouchableOpacity>

                </View>
            )
        }
    }
    handleshopChoose = () => {
        this.setState({
            shopvisible: true
        })
    }
    //选择店铺
    chooseShop = (item) => {
        this.setState({
            shopId: item.id,
            shopvisible: false
        }, () => this.firstLoad(1))
    }
    //选择排序
    changeSorter = (index,item) => {
        queryParam.sortedBy = item.sortedBy
        queryParam.sortedDesc = item.sortedDesc
        this.setState({ visible: false, optionKey: index }, () => this.firstLoad(1))
    }
    //下拉刷新数据
    refreshData = () => {
        this.setState({
            refreshing: true
        })
        this.firstLoad(1)
    }
    //上拉加载
    endReachedData = () => {
        const { refreshing, loading, hasMore, listData } = this.state
        if (!hasMore || loading || refreshing) {
            return
        }
        this.setState({
            loading: true
        })
        queryParam.page += 1
        requestApi.bcleGoodsCommentList4Merchant(queryParam).then((res) => {
            let listData = null
            if (res) {
                listData = res.data
                this.setState({
                    listData: this.state.listData.concat(listData),
                    refreshing: false,
                    loading: false,
                    hasMore: true
                })
            } else {
                this.setState({
                    refreshing: false,
                    loading: false,
                    hasMore: false
                })
            }
        }).catch(() => {
            this.setState({
                loading: false,
                hasMore: true
            })
        })
    }
    startScroll = () => {
        this.setState({
            sjhuifuVisible: false
        })
    }
    selectView=()=>{ //按条件筛选
        return(
            <TouchableOpacity style={{ flex: 1 }} onPress={() => { this.setState({ visible: false }) }} activeOpacity={1}>
                <View style={styles.modalView}>
                    <View style={styles.sanjiao}></View>
                    {
                        options.map((item, index) => {
                            let mt = {
                                marginTop: 0
                            }
                            if (index === 0) {
                                mt.marginTop = -10
                            }
                            return (
                                <Line
                                    title={item.title}
                                    key={index}
                                    style={{ backgroundColor: '#fff', paddingVertical: 15, ...mt }}
                                    onPress={() => { this.changeSorter(index,item) }}
                                    point={null}
                                />
                            )
                        })
                    }
                </View>
            </TouchableOpacity>
        )
    }
    storeReply=()=>{ //商家回复输入
        const { sjHuifuval, clickedItem } = this.state
        return(
            <View style={{ flex: 1 }} >
                <TouchableWithoutFeedback style={{ flex: 1 }} onPress={() => this.setState({ sjhuifuVisible: false, visible: false })}>
                    <View style={{ flex: 1 }}></View>
                </TouchableWithoutFeedback>
                <View style={{ width: width, height: 50 + CommonStyles.footerPadding }}>
                    <View style={{
                        flexDirection: 'row',
                        paddingHorizontal: 10,
                        alignItems: 'center',
                        height: 50 + CommonStyles.footerPadding,
                        backgroundColor: '#F5F5F7'
                    }}>
                        <TextInputView
                            inputView={{ flex: 1, height: 36 }}
                            placeholder={'回复客户'}
                            style={styles.input}
                            value={sjHuifuval}
                            autoFocus={true}
                            onChangeText={(val) => {

                                this.setState({ sjHuifuval: val })
                            }}
                        />
                        <TouchableOpacity style={{ width: getwidth(55), height: 36, justifyContent: 'center', alignItems: 'center', marginLeft: 14, backgroundColor: '#E3E3E3', borderRadius: 4 }} onPress={() => { this.sendSJhuifu(clickedItem) }}>
                            <Text style={{ color: '#777777', fontSize: 14 }}>发送</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        )
    }
    showPopover() {
        let options=[]
        options=[...this.props.juniorShops]
        options.map(item=>{
            item.title=item.name
            item.onPress=()=>this.chooseShop(item)
        })
        RightTopModal.show({
           options,
            children:<View style={{position:'absolute',top:Platform.OS=='ios'? 0:-CommonStyles.headerPadding}}>{this.renderHeader()}</View>,
            sanjiaoStyle:{right:30}
        })
    }
    renderHeader=()=>{
        const {goodsId}=this.state
        return(
            <Header
                navigation={this.props.navigation}
                goBack={true}
                title='评价管理'
                rightView={
                    <View style={{ width: 50, height: 44 + CommonStyles.headerPadding }}>
                        <TouchableOpacity
                            onPress={goodsId ? null : () => this.showPopover()}
                            // onPress={goodsId ? null : this.handleshopChoose}
                            style={{ height: 44 + CommonStyles.headerPadding, width: 100, position: 'absolute', marginLeft: -50, alignItems: 'center', justifyContent: 'center' }}
                        >
                            {
                                goodsId ? null : <Text style={{ fontSize: 17, color: '#fff' }}>店铺筛选</Text>
                            }
                        </TouchableOpacity>
                    </View>
                }
            />
        )
    }

    render() {
        const { navigation} = this.props;
        const { listData, refreshing, sjhuifuVisible, sjHuifuval, clickedItem, goodsId,loading,hasMore,isFirstLoad } = this.state
        return (
            <View style={styles.container}>
                {this.renderHeader()}
                <TouchableOpacity style={styles.topLine} onPress={() => this.setState({ visible: true })}>
                    <Text style={styles.topTitle}>{options[this.state.optionKey].title}</Text>
                    <Image style={{width:7,height:5}} source={require('../../images/index/down.png')}/>
                </TouchableOpacity>
                <FlatListView
                    data={listData}
                    onMomentumScrollBegin={this.startScroll}
                    renderItem={this.renderItem}
                    loadMoreData={this.endReachedData}
                    refreshData={this.refreshData}
                    style={styles.flatListView}
                    store={{...queryParam,
                        data:listData,
                        refreshing,
                        loading,
                        hasMore,
                        isFirstLoad
                    }}

                />
                <ShowBigPicModal
                    ImageList={this.state.showBigPicArr}
                    visible={this.state.bigPicVisible}
                    showImgIndex={this.state.selectedImageIndex}
                    callback={(index) => {}}
                    // childrenStyles={{top:CommonStyles.headerPadding, right: 17 }}
                    onClose={() => {
                        this.setState({
                            bigPicVisible: false
                        });
                    }}
                >
                </ShowBigPicModal>
                <Modal
                    animationType={sjhuifuVisible ? 'slide' : 'none'}
                    transparent={true}
                    visible={this.state.visible || sjhuifuVisible}
                    style={{ width: width }}
                    onRequestClose={() => { this.setState({ visible: false }) }}
                    onShow={() => { }}
                >
                    {
                        sjhuifuVisible ?this.storeReply():this.selectView()
                    }

                </Modal>
            </View >
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    topLine: {
        backgroundColor: '#fff',
        height: 38,
        alignItems: 'center',
        flexDirection: 'row',
        width: width,
        paddingHorizontal: 25,
    },
    topTitle: {
        color: '#555555',
        fontSize: 14,
        marginRight: 5
    },
    modalView1: {
        width: getwidth(170),
        position: 'absolute',
        top: (Platform.OS === 'ios' ? 50 : 44) + CommonStyles.headerPadding,
    },
    flatListView: {
        backgroundColor: CommonStyles.globalBgColor,
        marginBottom: 10,
        flex: 1,
        width: width
    },
    sanjiao: {
        width: 20,
        height: 20,
        borderWidth: 1,
        marginTop: -10,
        backgroundColor: 'white',
        borderLeftColor: '#DDDDDD',
        borderTopColor: '#DDDDDD',
        borderRightColor: 'white',
        borderBottomColor: 'white',
        transform: [{ rotateZ: '45deg' }],
    },
    bottomView: {
        backgroundColor: '#F5F5F7',
        width: width,

        borderTopColor: '#D7D7D7',
        borderWidth: 1,
        justifyContent: 'center',
    },
    input: {
        backgroundColor: '#FCFCFC',
        paddingHorizontal: 14,
        borderColor: '#E3E3E3',
        borderRadius: 4,
        borderWidth: 1
    },
    listView: {
        flex: 1,
        marginVertical: 10,
        width: width - 20,
        alignItems: 'center'
    },
    item: {
        backgroundColor: '#fff',
        paddingVertical: 15,
    },
    rightView: {
        flex: 1
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 5,
    },
    smallText: {
        color: '#777777',
        fontSize: 12,
        lineHeight: 16
    },
    modalView: {
        width: 170,
        borderWidth: 1,
        borderColor: '#DDDDDD',
        borderRadius: 10,
        marginLeft: 25,
        marginTop: (Platform.OS === 'ios' ? 90 : 70) + CommonStyles.headerPadding,
        paddingHorizontal: 10,
        backgroundColor: 'white',
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
        backgroundColor: '#fff',
    },
    footerText: {
        fontSize: 14,
        color: '#666',
    },

});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        juniorShops:state.shop.juniorShops || [],
        user:state.user.user || {},
    })
)(CommentScreen);
