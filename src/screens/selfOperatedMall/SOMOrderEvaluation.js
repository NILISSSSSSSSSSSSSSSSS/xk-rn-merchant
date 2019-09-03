/**
 * 自营商城订单评价
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
    TouchableOpacity,
    Keyboard,
    Platform
} from "react-native";
import { connect } from "react-redux";
import * as requestApi from "../../config/requestApi";
import { qiniuUrlAdd, getPreviewImage,debounce } from "../../config/utils";
import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import TextInputView from "../../components/TextInputView";
import ImageView from "../../components/ImageView";
import ActionSheet from '../../components/Actionsheet'
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { ScanSensitiveWords } from '../../config/utils'
import { TakeOrPickParams, TakeOrPickCropEnum, TakeTypeEnum, PickTypeEnum, } from '../../const/application';
import  math from "../../config/math.js";
const upload_pic = require("../../images/order/upload_pic.png");
const fine_pointed_red = require("../../images/order/fine_pointed_red.png");
const fine_pointed_transparent = require("../../images/order/fine_pointed_transparent.png");

const maxImgLen = 9;
const { width, height } = Dimensions.get("window");
let imgIndex = 0;

function getwidth(val) {
    return (width * val) / 375;
}
class SOMOrderEvaluation extends Component {
    constructor (props) {
        super(props)
        this.state = {
            modalVis: false,
            imgsLists: [],
            pfText: "",
            starNum: 4,
            score: 5,
            content: "非常好",
            comments: [{
                goods: {
                    price: ''
                },
                score: 5,
                content: "这个商品非常好！",
                showContent: "非常好",
                pictures: [],
                video: {
                    url: '',
                    mainPic: ''
                }
            }],
            thumbData: [[]], // 缩略图数据
            options: ['拍摄(照片或视频)', '从手机相册选择', '取消'], // 弹窗操作项
            showBigPicVisible: false,
            bigIndex: 0,
            actionIndex: 0,
        };
        this.debounceSubmit = debounce(this.handleSubmit);
    }
    ActionSheet = null;
    textInput = null;
    componentDidMount() {
        Loading.show();
        const { navigation } = this.props
        let orderData = navigation.getParam('orderData', { goods: [] })
        let _thumb = [];
        let temp = orderData.goods.map((item, index) => {
            _thumb.push([])
            return {
                goods: item,
                score: 5,
                content: "",
                showContent: "非常好",
                pictures: [],
                video: {
                    url: '',
                    mainPic: ''
                }
            }
        })
        this.setState({
            thumbData: _thumb,
            comments: temp,
        }, () => {
            Loading.hide();
        })
    }
    componentWillUnmount() {
        Loading.hide()
    }
    handleSubmit = () => {
        Loading.show();
        const { navigation } = this.props
        const { comments } = this.state
        let orderData = navigation.getParam('orderData', {})
        let callback = navigation.getParam('callback', () => { })
        orderData.goods.map((item, index) => {
            comments[index].goods["id"] = item.goodsId;
            comments[index].goods["skuCode"] = item.goodsSkuCode;
        });
        // let filterNullString = comments.filter(item => item.content === '');
        // if (filterNullString.length !== 0) {
        //     Toast.show('评价内容不能为空！')
        //     Loading.hide()
        //     return
        // }
        // 如果没有填写，设置默认文案
        comments.map(item => {
            if (item.content === '') {
                item.content = '该用户比较懒，没有留下评价。'
            }
        })
        let params = {
            orderId: orderData.orderId,
            comments
        };
        console.log('评价', comments)
        requestApi.mallGoodsCommentCreate(params).then(res => {
            // Toast.show("评价成功!", 2000);
            navigation.navigate("SOMOrderEvaluationSucess", {
                callback,
                goodsId: comments[0].goods.goodsId
            });
        }).catch(err => {
            console.log(err);
        });
    };

    handleChangeState(key, value, callback = () => { }) {
        this.setState(
            {
                [key]: value
            },
            () => {
                console.log("sfdsf", this.state.comments);
                callback();
            }
        );
    }
    handleSelectStar = (index, i) => {
        let data = JSON.parse(JSON.stringify(this.state.comments));
        data[i].score = index;
        data[i].showContent = this.renderText(index);
        this.handleChangeState("comments", data);
    };
    getStar = index => {
        [1, 2, 3, 4, 5].map((item, i) => {
            if (index >= i) {
                return (
                    <TouchableOpacity
                        key={Math.random()}
                        activeOpacity={1}
                        onPress={() => {
                            this.getStar(i);
                        }}
                    >
                        <Image style={styles.pfImg} source={fine_pointed_red} />
                    </TouchableOpacity>
                );
            }
            return (
                <TouchableOpacity
                    key={Math.random()}
                    activeOpacity={1}
                    onPress={() => {
                        this.getStar(i);
                    }}
                >
                    <Image
                        style={styles.pfImg}
                        source={fine_pointed_transparent}
                    />
                </TouchableOpacity>
            );
        });
        return temp;
    };
    handleInputComment = (i, text) => {
        let data = JSON.parse(JSON.stringify(this.state.comments));
        data[i].content = ScanSensitiveWords(text.trim())
        this.handleChangeState("comments", data);
    };
    renderText = n => {
        switch (n) {
            case 1:
                return "非常差";
            case 2:
                return "差";
            case 3:
                return "一般";
            case 4:
                return "好";
            case 5:
                return "非常好";
        }
    }
    //上传
    upload = (index) => {
        let i = imgIndex // 当前选择的第几个商品
        let len = maxImgLen;
      let { thumbData, comments } = this.state;
      const {  takeOrPickImageAndVideo } = this.props;
      let takeType = comments[i].video.url && comments[i].video.mainPic ? TakeTypeEnum.takeImage : TakeTypeEnum.takeImageOrVideo;
      let pickType = comments[i].video.url && comments[i].video.mainPic ? PickTypeEnum.pickImage : PickTypeEnum.pickImageOrVideo;
      const params = new TakeOrPickParams(index === 0 ? { func: 'take', type: takeType } : { func: 'pick', type: pickType });
      params.setTotalNum(len - thumbData[i].length);
      params.setCrop(TakeOrPickCropEnum.NoCrop);
      console.log(params)
      takeOrPickImageAndVideo(params.getOptions(), (res) => {
          console.log('res',res)
        this.handleSetUploadResponse(res)
      });
    }
    //
    handleSetUploadResponse = (res) => {
        let i = imgIndex // 当前选择的第几个商品
        let { comments, thumbData, pickPicVideoType, takePicVideoType} = this.state;
        let data = JSON.parse(JSON.stringify(comments))
        let _thumbData = JSON.parse(JSON.stringify(thumbData))
        let dataArr = []; // 组合到提交信息到数据
        let thumbArr = [];
        let _videoArr = [] // 上传的视频
        let _picArr = [] // 上传的图片

        res && res.map(item => {
            if (item.type && item.type=== 'video') {
                _videoArr.push({ url: item.url, mainPic: item.cover, type: 'video' })
            }
            if (item.type && item.type === 'images') {
                dataArr.push(item.url)
                _picArr.push(item)
            }
        })
        if (_videoArr.length !== 0){ // 如果上传了视频，这里取值为第一个
            data[i].video.url = _videoArr[0].url; // 只获取第一个视频地址
            data[i].video.mainPic = _videoArr[0].mainPic; // 只获取第一个视频地址
            _thumbData[i] = _thumbData[i].concat([_videoArr[0]]) // 获取第一个视频地址的缩略提
        } 
        if (_picArr.length !== 0) { // 如果是图片
            _thumbData[i] = _thumbData[i].concat(_picArr)
        }
        data[i].pictures = data[i].pictures.concat(dataArr)
        this.setState({
            comments: data,
            thumbData: _thumbData,
        })
    }
    /**
     * i 第几个商品
     * item 删除的数据
     * j 删除的索引
     */
    _deletePicture = (i, item, j) => {
        let data = this.state.comments;
        let _thumbData = JSON.parse(JSON.stringify(this.state.thumbData))
        // 如果是图片
        if (item.type === 'images') {
            let pic = JSON.parse(JSON.stringify(data[i].pictures))
            let index = pic.indexOf(item.url)
            let thumnIndex = null;
            if (index !== -1) {
                pic.splice(index, 1)
            }

            _thumbData[i].map((picObj, picIndex) => {
                console.log(picObj)
                if (picObj.url === item.url && picObj.type === 'images') {
                    thumnIndex = picIndex
                }
            })
            if (thumnIndex !== null) {
                _thumbData[i].splice(thumnIndex, 1);
            }
            data[i].pictures = pic
            this.setState({
                comments: data,
                thumbData: _thumbData,
            })
            return
        }
        if (item.type === 'video') {
            let thumbVideoIndex = null;
            data[i].video = {
                url: '',
                mainPic: ''
            }
            _thumbData[i].map((videoItem, videoIndex) => {
                if (videoItem.url == item.url && videoItem.type === 'video') {
                    thumbVideoIndex = videoIndex
                }
            })
            if (thumbVideoIndex !== null) {
                _thumbData[i].splice(thumbVideoIndex, 1);
            }
            this.setState({
                comments: data,
                thumbData: _thumbData,
            })
        }

    }
    render() {
        const { navigation } = this.props;
        const {
            modalVis,
            comments,
            thumbData,
            options,
            bigIndex,
            showBigPicVisible,
        } = this.state;
        console.log("commentscommentscommentscomments", comments);
        console.log("thumbDatathumbDatathumbDatathumbData", thumbData);
        let len = maxImgLen;
        if (comments[imgIndex].video && comments[imgIndex].video.url !== '' && comments[imgIndex].video.mainPic !== '') {
            len -= 1;
        }
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View
                            style={{
                                position: "relative",
                                flex: 1,
                                alignItems: "center"
                            }}
                        >
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                                评价
                            </Text>
                        </View>
                    }
                    rightView={
                        <TouchableOpacity
                            style={{ width: 50 }}
                            onPress={() => {
                                Loading.show();
                                this.debounceSubmit();
                            }}
                        >
                            <Text style={{ color: "#FFFFFF", fontSize: 17 }}>
                                提交
                            </Text>
                        </TouchableOpacity>
                    }
                />
                <ScrollView showsVerticalScrollIndicator={false}>
                    {comments.map((item, i) => {
                        let price = (math.divide(item.goods.price , 100) ).toFixed(2);
                        return (
                            <React.Fragment>
                                <View
                                    style={[styles.goodsItem, styles.flex_1]}
                                    key={i + "a"}
                                >
                                    <View style={[styles.flex_1, styles.flex_start]}
                                    >
                                        <View style={[styles.imgWrap, styles.flex_center]}>
                                            <Image source={{ uri: item.goods.goodsPic }}
                                                style={styles.imgStyle}
                                            />
                                        </View>
                                        <View
                                            style={[
                                                styles.flex_1,
                                                styles.goodsInfo
                                            ]}
                                        >
                                            <Text
                                                numberOfLines={2}
                                                style={styles.goodsTitle}
                                            >
                                                {item.goods.goodsName}
                                            </Text>
                                            <View style={[CommonStyles.flex_start]}>
                                            <Text style={styles.goodsAttr}>规格参数：</Text>
                                            <Text style={styles.goodsAttr}>
                                                {item.goods.goodsShowAttr} x{" "}
                                                {item.goods.num}
                                            </Text>
                                            </View>
                                            <View
                                                style={[
                                                    styles.flex_1,
                                                    styles.flex_start_noCenter,
                                                    { marginTop: 5}
                                                ]}
                                            >
                                                <Text
                                                    style={
                                                        styles.goodsPriceLabel
                                                    }
                                                >
                                                    价格:
                                                </Text>
                                                <Text
                                                    style={[styles.goodsPriceValue, { color: '#EE6161' }]}
                                                >
                                                    ￥ {price}
                                                </Text>
                                            </View>
                                        </View>
                                    </View>
                                </View>
                                <View style={[styles.pfWrap]}>
                                    <View style={[styles.flex_start]}>
                                        <Text style={styles.pfText}>
                                            评分项1
                                        </Text>
                                        <View style={[styles.flex_start]}>
                                            {[1, 2, 3, 4, 5].map((item, index) => {
                                                if (index >= comments[i].score) {
                                                    return (
                                                        <TouchableOpacity
                                                            key={
                                                                index + "b"
                                                            }
                                                            activeOpacity={1}
                                                            onPress={() => {
                                                                this.handleSelectStar(
                                                                    index +
                                                                    1,
                                                                    i
                                                                );
                                                            }}
                                                        >
                                                            <Image
                                                                style={styles.pfImg}
                                                                source={fine_pointed_transparent}
                                                            />
                                                        </TouchableOpacity>
                                                    );
                                                }
                                                return (
                                                    <TouchableOpacity
                                                        key={index + "b1"}
                                                        activeOpacity={1}
                                                        onPress={() => {
                                                            this.handleSelectStar(
                                                                index + 1,
                                                                i
                                                            );
                                                        }}
                                                    >
                                                        <Image
                                                            style={styles.pfImg}
                                                            source={fine_pointed_red}
                                                        />
                                                    </TouchableOpacity>
                                                );
                                            }
                                            )}
                                        </View>
                                        <Text
                                            style={{
                                                fontSize: 12,
                                                color: "#777"
                                            }}
                                        >
                                            {comments[i].showContent}
                                        </Text>
                                    </View>
                                    <View style={styles.contentView}>
                                        <View style={{ position: 'relative' }}>
                                            <TextInputView
                                                inputView={styles.textInputView}
                                                inputRef={e => {
                                                    this.textInput = e;
                                                }}
                                                style={styles.textInput}
                                                multiline={true}
                                                value={comments[i].content}
                                                maxLength={200}
                                                onBlur={() => {
                                                    Keyboard.dismiss();
                                                }}
                                                placeholder="请输入您的评价内容。"
                                                placeholderTextColor={"#999"}
                                                onChangeText={text => {
                                                    this.handleInputComment(
                                                        i,
                                                        text
                                                    );
                                                }}
                                            />
                                            <View style={[CommonStyles.flex_end]}>
                                                <View style={styles.fontNumView}>
                                                    <Text
                                                        style={[styles.flex_start, styles.fontNum]}
                                                    >
                                                        {comments[i].content.length}/200
                                                    </Text>
                                                </View>
                                            </View>
                                        </View>
                                        <View style={styles.imgsView}>
                                            {/* {comments[i].pictures.length !== 0 && comments[i].pictures.map((item, j) => {
                                                if (j >= maxImgLen) return;
                                                return (
                                                    <View
                                                        key={j + "c"}
                                                        style={styles.img_item_box}
                                                    >
                                                        <ImageView
                                                            style={styles.img_item}
                                                            source={{ uri: item }}
                                                            sourceWidth={60}
                                                            sourceHeight={60}
                                                            resizeMode="cover"
                                                        />
                                                        <TouchableOpacity
                                                            style={
                                                                styles.img_item_delete
                                                            }
                                                            onPress={() => {
                                                                this._deletePicture(i, item);
                                                            }}
                                                        >
                                                            <Image
                                                                source={require("../../images/index/delete.png")}
                                                            />
                                                        </TouchableOpacity>
                                                    </View>
                                                );
                                            }
                                            )} */}
                                            {
                                                thumbData[i].length !== 0 && thumbData[i].map((item, j) => {
                                                    if (item.type === 'images') {
                                                        return (
                                                            <TouchableOpacity
                                                                onPress={() => { this.setState({ bigIndex: j, showBigPicVisible: true }) }}
                                                                key={j + "c"}
                                                                style={styles.img_item_box}
                                                            >
                                                                <ImageView
                                                                    style={styles.img_item}
                                                                    source={{ uri: getPreviewImage(item.url) }}
                                                                    sourceWidth={60}
                                                                    sourceHeight={60}
                                                                    resizeMode="cover"
                                                                />
                                                                <TouchableOpacity
                                                                    style={
                                                                        styles.img_item_delete
                                                                    }
                                                                    onPress={() => {
                                                                        this._deletePicture(i, item, j);
                                                                    }}
                                                                >
                                                                    <Image
                                                                        source={require("../../images/index/delete.png")}
                                                                    />
                                                                </TouchableOpacity>
                                                            </TouchableOpacity>
                                                        )
                                                    }
                                                    return (
                                                        <TouchableOpacity
                                                            onPress={() => { this.setState({ bigIndex: j, showBigPicVisible: true }) }}
                                                            key={j + "d"}
                                                            style={styles.img_item_box}
                                                        >
                                                            <ImageView
                                                                style={styles.img_item}
                                                                source={{ uri: item.mainPic }}
                                                                sourceWidth={60}
                                                                sourceHeight={60}
                                                                resizeMode="cover"
                                                            />
                                                            {
                                                                item.type === 'video'
                                                                    ? <View style={{ height: '100%', width: '100%', position: 'absolute', ...CommonStyles.flex_center }}>
                                                                        <Image style={{ width: 30, height: 30 }} source={require('../../images/index/video_play_icon.png')} />
                                                                    </View>
                                                                    : null
                                                            }
                                                            <TouchableOpacity
                                                                style={
                                                                    styles.img_item_delete
                                                                }
                                                                onPress={() => {
                                                                    this._deletePicture(i, item);
                                                                }}
                                                            >
                                                                <Image
                                                                    source={require("../../images/index/delete.png")}
                                                                />
                                                            </TouchableOpacity>
                                                        </TouchableOpacity>
                                                    )
                                                })
                                            }
                                            {
                                                comments[i].pictures.length < len
                                                    ? (
                                                        <TouchableOpacity
                                                            style={styles.img_item_box}
                                                            onPress={() => {
                                                                imgIndex = i;
                                                                this.setState({
                                                                    actionIndex: i
                                                                }, () => {
                                                                    this.ActionSheet.show()
                                                                })

                                                                // this.handleChangeState(
                                                                //     "modalVis",
                                                                //     true
                                                                // );
                                                            }}
                                                        >
                                                            <Image
                                                                style={styles.img_item}
                                                                source={require("../../images/order/upload_pic.png")}
                                                            />
                                                        </TouchableOpacity>
                                                    )
                                                    : null
                                            }
                                        </View>
                                    </View>
                                </View>
                            </React.Fragment>
                        );
                    })}
                </ScrollView>
                <ActionSheet
                    ref={o => this.ActionSheet = o}
                    options={options}
                    cancelButtonIndex={options.length - 1}
                    onPress={(index) => {
                      index !== options.length - 1 && this.upload(index)
                    }}
                />
                {/* 查看大图 */}
                <ShowBigPicModal
                    ImageList={thumbData[imgIndex]}
                    visible={showBigPicVisible}
                    showImgIndex={bigIndex}
                    onClose={() => {
                        this.setState({
                            showBigPicVisible: false,
                        })
                    }}
                />
            </View>
        );
    }
}


export default connect(null,
  {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
  }
)(SOMOrderEvaluation)

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    flex_center: {
        justifyContent: "center",
        alignItems: "center"
    },
    flex_start: {
        justifyContent: "flex-start",
        flexDirection: "row",
        alignItems: "center"
    },
    flex_end: {
        flexDirection: "row",
        justifyContent: "flex-end",
        alignItems: "center",

    },
    flex_start_noCenter: {
        justifyContent: "flex-start",
        flexDirection: "row"
    },
    flex_between: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center"
    },
    flex_1: {
        flex: 1
    },

    goodsItem: {
        padding: 15,
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
        backgroundColor: "#fff",
        margin: 10,
        marginBottom: 0,
        borderWidth: 1,
        borderColor: "rgba(215,215,215,0.5)",
        overflow: "hidden",
        backgroundColor: "#fff",
        borderBottomColor: "#fff",
        borderBottomWidth: 0
    },
    selectedBtnWrap: {
        marginRight: 10
    },
    unSelected: {
        width: 15,
        height: 15,
        borderWidth: 1,
        borderColor: "#979797",
        borderRadius: 15
    },
    goodsTitle: {
        lineHeight: 17,
        fontSize: 12,
        color: "#222"
    },
    imgStyle: {
        height: '100%',
        width: '100%',
        borderRadius: 6,

    },
    imgWrap: {
        borderRadius: 6,
        borderWidth: 1,
        borderColor: "#E5E5E5",
        backgroundColor: "#fff",
        height: 69,
        width: 69,
    },
    goodsInfo: {
        paddingLeft: 10,

        flex: 1
    },
    goodsAttr: {
        fontSize: 10,
        color: "#999",
        marginTop: 5
    },
    goodsPriceLabel: {
        fontSize: 10,
        color: "#999"
    },
    goodsPriceValue: {
        fontSize: 10,
        color: "#101010",
        paddingLeft: 7
    },
    borderTop: {
        borderTopWidth: 1,
        borderTopColor: "#f1f1f1"
    },
    pfWrap: {
        padding: 15,
        paddingTop: 20,
        margin: 10,
        marginTop: 0,
        borderWidth: 1,
        borderBottomRightRadius: 8,
        borderBottomLeftRadius: 8,
        borderColor: "rgba(215,215,215,0.5)",
        overflow: "hidden",
        backgroundColor: "#fff"
    },
    pfImg: {
        marginRight: 15,
        width: 15,
        height: 15
    },
    pfText: {
        color: "#222",
        fontSize: 12,
        paddingRight: 15
    },
    pfInputText: {
        marginVertical: 15
    },

    contentView: {
        marginTop: 10,
        backgroundColor: "#fff",
    },
    textInputView: {
        height: 104,
        backgroundColor: "#f6f6f6"
    },
    textInput: {
        height: "100%",
        padding: 10,
        textAlignVertical: "top",
        fontSize: 12
    },
    imgsView: {
        flexDirection: "row",
        flexWrap: "wrap",
        alignItems: "center",
        borderTopWidth: 1,
        borderTopColor: '#f1f1f1'
    },
    img_item_box: {
        position: "relative",
        width: 60,
        height: 60,
        marginTop: 10,
        // borderWidth: 1,
        // borderColor: "#F1F1F1",
        borderRadius: 6,
        marginRight: 10
    },
    img_item: {
        width: "100%",
        height: "100%",
        borderRadius: 6,
        overflow: "hidden"
    },
    img_item_delete: {
        position: "absolute",
        top: -5,
        right: -5,
        alignItems: "flex-end",
        width: 24,
        height: 24
    },
    submitView: {
        // ...CommonStyles.shadowStyle,
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: width - 20,
        height: 44,
        marginHorizontal: 10,
        borderRadius: 8,
        backgroundColor: "#4A90FA"
    },
    submitView_text: {
        fontSize: 17,
        color: "#fff"
    },
    listItem: {
        width: getwidth(355),
        height: 388,
        backgroundColor: "#fff",
        marginTop: 10,
        borderRadius: 8
    },
    listItemTop: {
        width: getwidth(355),
        height: 110,
        flexDirection: "row",
        paddingVertical: 15,
        alignItems: "center",
        paddingHorizontal: 15,
        borderBottomColor: "#F1F1F1",
        borderBottomWidth: 1
    },
    listItemTopPic: {
        width: getwidth(80),
        height: 80
    },
    listItemTopText: {
        height: 80,
        flex: 1,
        marginLeft: 15
    },
    itemXing: {
        width: getwidth(15),
        height: 14,
        marginRight: 16.5
    },
    listXing: {
        width: getwidth(355),
        height: 84,
        paddingHorizontal: 15,
        paddingTop: 15
    },
    c2f12: {
        color: "#222222",
        fontSize: 12
    },
    c9f12: {
        color: "#999999",
        fontSize: 12
    },
    c7f12: {
        color: "#777777",
        fontSize: 12
    },
    textinputView: {
        width: getwidth(325),
        height: 104,
        marginHorizontal: 15,
        backgroundColor: "#F6F6F6"
    },
    bottomView: {
        flex: 1,
        paddingHorizontal: 15,
        flexDirection: "row",
        alignItems: "center"
    },
    modalView: {
        // width: width,
        // height: 160,
        backgroundColor: "rgba(10,10,10,.5)",
        // position: 'absolute',
        flex: 1,
        position: "relative",
        bottom: 0
    },
    modalContent: {
        position: "absolute",
        bottom: 0,
        padding: 15,
        paddingVertical: 0,
        width: width,
        backgroundColor: "#fff"
    },
    modalItem: {
        fontSize: 17,
        color: "#222",
        textAlign: "center",
        paddingVertical: 15,
        borderBottomColor: "#f1f1f1",
        borderBottomWidth: 1
    },
    img_item: {
        width: "100%",
        height: "100%",
        borderRadius: 6,
        overflow: "hidden"
    },
    img_item_delete: {
        position: "absolute",
        top: -5,
        right: -5,
        alignItems: "flex-end",
        width: 24,
        height: 24
    },
    fontNumView: {
        // backgroundColor: "rgba(0,0,0,.2)"
        paddingRight: 15,
        paddingBottom: 15,
        paddingTop: 5,
    },
    fontNum: {
        fontSize: 14,
        color: "#999",
    }
});
