/**
 * 申请售后 退款退货
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
    Platform,
    Modal,
    TouchableOpacity,
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import TextInputView from "../../components/TextInputView";
import ImageView from "../../components/ImageView";
import * as nativeApi from "../../config/nativeApi";
import { qiniuUrlAdd, getPreviewImage, keepTwoDecimalFull } from "../../config/utils";
import * as requestApi from "../../config/requestApi";
import UploadModal from '../../components/UploadModal';
import Header from "../../components/Header";
import ActionSheet from '../../components/Actionsheet'
import CommonStyles from "../../common/Styles";
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { TakeOrPickParams, TakeOrPickCropEnum, TakeTypeEnum, PickTypeEnum, } from '../../const/application';
import math from "../../config/math";
const { width, height } = Dimensions.get("window");

class SOMReturnedAllScreen extends Component {
    static navigationOptions = {
        header: null
    };
    ActionSheet = null;
    constructor(props) {
        super(props);

        super(props);
        this.state = {
            afterSaleGoods: [],
            remark: "",
            imgsLists: [],
            maxImgLen: 9, // 最大图片张数
            allprice: "", // 退款总额
            reasonList: "",
            reason: "请选择",
            modalVisible: false,
            options: ['拍摄(照片或视频)','从手机相册选择', '取消'], // 弹窗操作项

        };
        this.debounceApplyRefund = this.handleApplyRefund
    }

    componentDidMount() {
        Loading.show()
        this.getNavigaionParam()
        this.getReasonList()
    }
    getNavigaionParam = () => {
        const { navigation } = this.props;
        const afterSaleGoods = navigation.getParam("afterSaleGoods", []);
        const orderInfo = navigation.getParam("orderInfo");
        let allprice = 0;
        afterSaleGoods.map((item, index) => {
            allprice += item.realPrice;
        });
        // 退款时，如果订单是待发货且选择了所有的订单商品，则退运费，否则不退
        if (orderInfo.orderStatus === 'PRE_SHIP' && orderInfo.goods.length === afterSaleGoods.length) {
            allprice += orderInfo.postFee
        }
        this.setState({
            allprice: (math.divide(allprice , 100)).toFixed(2),
            afterSaleGoods
        });
    };
    // 获取原因列表
    getReasonList = () => {
        requestApi.fetchMallRefundReasonList({ xkModule: 'mall',type: 2 }).then(res => {
            this.handleChangeState("reasonList", res);
        }).catch((err)=>{
            console.log(err)
          });
    };
    componentWillUnmount() {
        Loading.hide()
        this.handleChangeState("modalVisible", false);
    }
    handleChangeState = (key = "", value = "") => {
        this.setState(
            {
                [key]: value
            }
        );
    };
    // 判断当前是否允许拍摄视频或者选择视频
    getNowType = () => {
        const { imgsLists } = this.state
        //takePicVideoType: 2, // 操作类型 0:拍照，1:拍视频，2:既能拍照又能拍视频
        // pickPicVideoType: 3, // 选择类型 1 图片 2 视频 3 选择图片或者视频
        if (imgsLists.length === 0) {
            return {
                pickPicVideoType: 3,
                takePicVideoType: 2,
            }
        } else {
            if (imgsLists.filter(item => item.type === 'video').length !== 0) {
                return {
                    pickPicVideoType: 1,
                    takePicVideoType: 0,
                }
            }
        }
        return {
            pickPicVideoType: 3,
            takePicVideoType: 2,
        }
    }
    //上传
    upload = (index) => {
        const { maxImgLen, imgsLists } = this.state;
        let len = maxImgLen;
        const {  takeOrPickImageAndVideo } = this.props;
        let videoItem = imgsLists.filter(item => item.type === 'video')
        let takeType = videoItem.length !== 0 ? TakeTypeEnum.takeImage : TakeTypeEnum.takeImageOrVideo;
        let pickType = videoItem.length !== 0 ? PickTypeEnum.pickImage : PickTypeEnum.pickImageOrVideo;
        const params = new TakeOrPickParams(index === 0 ? { func: 'take', type: takeType } : { func: 'pick', type: pickType });
        params.setTotalNum(len - imgsLists.length);
        params.setCrop(TakeOrPickCropEnum.NoCrop);
        console.log(params)
        takeOrPickImageAndVideo(params.getOptions(), (res) => {
            this.handleSetUploadResponse(res)
        });
    }

    handleSetUploadResponse = (res) => {
        let { imgsLists, } = this.state;
        let videObjArr = []
        let picArr = [];
        res && res.map(item => {
            if (item.type && item.type=== 'video') {
                videObjArr.push({
                    refundVideo: item.url,
                    refundPic: item.cover,
                    type: 'video'
                })
            }
            if (item.type && item.type === 'images') {
                picArr.push({ refundVideo: '', refundPic: item.url, type: 'images'})
            }
        })
        if (videObjArr.length > 1) {
            videObjArr = [videObjArr[0]]
            Toast.show('只能上传一个视频！')
        }
        this.setState({
            imgsLists: imgsLists.concat(videObjArr.concat(picArr)),
        })
    }
    _deletePicture = index => {
        let imgsLists = JSON.parse(JSON.stringify(this.state.imgsLists));
        if (imgsLists[index].refundVideo !== '') {
            imgsLists.splice(index, 1);
            this.setState({
                imgsLists,
            })
            return
        }
        imgsLists.splice(index, 1);
        this.setState({
            imgsLists,
        })
    };
    handleApplyRefund = () => {
        const { navigation } = this.props;
        const { reason, reasonId, afterSaleGoods, remark, imgsLists } = this.state;
        const orderInfo = navigation.getParam("orderInfo", {});
        const callback = navigation.getParam("callback", () => {});
        if (reason === "请选择" || reasonId === "") return;
        let temp = afterSaleGoods.map(item => {
            return {
                goodsId: item.goodsId,
                goodsSkuCode: item.goodsSkuCode
            };
        });

        let params = {
            mallRefundOrderParams: {
                refundType: "REFUND_GOODS", //退款REFUND，退货并退款REFUND_GOODS
                refundGoods: temp,
                orderId: orderInfo.orderId,
                refundReasonId: reasonId,
                refundMessage: remark,
                refundEvidence: imgsLists
            }
        };
        // console.log(params)
        // return
        requestApi
            .mallOrderMUserRefund(params)
            .then(res => {
                Toast.show("申请成功!", 2000);
                navigation.navigate("SOMReturnedAllWait", {
                    refundId: res.refundId,
                    callback,
                    routerIn: "returnAll"
                });
            })
            .catch(err => {
                Loading.hide();
                Toast.show("申请失败，请重试!");
            });
        // navigation.navigate('SOMReturnedAllWait', { refundId: res.refundId })
    };
    getPreviewPic = () => {
        const { imgsLists } = this.state
        let temp = []
        imgsLists.map(item => {
            if (item.refundVideo !== '') {
                temp.push({
                    url: item.refundVideo,
                    type: 'video'
                })
            } else {
                temp.push({
                    url: item.refundPic,
                    type: 'images'
                })
            }
        })
        return temp
    }
    render() {
        const { navigation, store } = this.props;
        const { afterSaleGoods, remark, imgsLists,showBigPicVisible,bigIndex, allprice, modalVisible, reasonList, reason, maxImgLen,options } = this.state;
        let refundAmount = (store.mallReducer.refundAmount || 0)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"售后申请"}
                />
                <ScrollView
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                >
                    <View style={styles.goodsWrpa}>
                        {afterSaleGoods.length > 0 &&
                            afterSaleGoods.map((item, index) => {
                                let price = (math.divide(item.price || item.goodsPrice, 100) ).toFixed(2);
                                let borderBottom =
                                    index === afterSaleGoods.length - 1
                                        ? {}
                                        : styles.borderBottom;
                                return (
                                    <View
                                        style={[
                                            styles.goodsItem,
                                            styles.flex_1,
                                            styles.flex_start_noCenter,
                                            borderBottom
                                        ]}
                                        key={index}
                                    >
                                        <View
                                            style={[
                                                styles.flex_1,
                                                styles.flex_start
                                            ]}
                                        >
                                            <View
                                                style={[
                                                    styles.imgWrap,
                                                    styles.flex_center
                                                ]}
                                            >
                                                <Image
                                                    source={{
                                                        uri: getPreviewImage(item.goodsPic, '50p')
                                                    }}
                                                    style={styles.imgStyle}
                                                />
                                            </View>
                                            <View
                                                style={[
                                                    styles.flex_1,
                                                    styles.goodsInfo
                                                ]}
                                            >
                                                <Text numberOfLines={2} style={styles.goodsTitle} >{item.goodsName} </Text>
                                                <Text style={styles.goodsAttr}> {item.goodsShowAttr} x {item.num} </Text>
                                                <View
                                                    style={[styles.flex_1, styles.flex_start, { marginTop: 5 }]}
                                                >
                                                    <Text style={styles.goodsPriceLabel} >价格:</Text>
                                                    <Text style={styles.goodsPriceValue} > {price}</Text>
                                                </View>
                                            </View>
                                        </View>
                                    </View>
                                );
                            })}
                    </View>
                    <View style={styles.selectWrap}>
                        <TouchableOpacity
                            style={[styles.flex_between, styles.selectItem]}
                            onPress={() => {
                                this.handleChangeState("modalVisible", true);
                            }}
                        >
                            <Text style={styles.selectItem_text}>
                                退货退款原因
                            </Text>
                            <View style={styles.flex_start}>
                                <Text style={styles.selectReason}>
                                    {reason}
                                </Text>
                                <Image
                                    source={require("../../images/mall/goto_gray.png")}
                                    style={styles.rightIcon}
                                />
                            </View>
                        </TouchableOpacity>
                        <View
                            style={[styles.flex_between, styles.selectItem]}
                            onPress={() => { }}
                        >
                            <Text style={styles.selectItem_text}>
                                退款金额：{keepTwoDecimalFull(math.divide(refundAmount , 100))}
                            </Text>
                        </View>
                        <View
                            style={[styles.flex_start, styles.selectItem, { borderBottomWidth: 0 }]}
                        >
                            <Text style={styles.selectItem_text}>
                                退货退款说明:
                            </Text>
                            <TextInputView
                                placeholderTextColor={"#999999"}
                                placeholder="选填"
                                style={{ flex: 1, color: "#777" }}
                                maxLength={50}
                                inputView={{ flex: 1, paddingHorizontal: 10 }}
                                // multiline={true}
                                value={remark}
                                onChangeText={text =>
                                    this.handleChangeState("remark", text)
                                }
                            />
                        </View>
                    </View>
                    <View style={styles.selectWrap}>
                        <View
                            style={[
                                styles.flex_between,
                                styles.selectItem,
                                { paddingVertical: 10 }
                            ]}
                        >
                            <Text style={styles.selectItem_text}>
                                上传凭证（最多九张图片）
                            </Text>
                        </View>
                        <View style={[styles.flex_start, styles.selectItem_upLoadImg,{flexWrap: 'wrap'}]}>
                            {/* <TouchableOpacity onPress={this.handleAddImage}>
                                <Image style={styles.addImgIcon} source={require('../../images/mall/add_img_icon.png')} />
                            </TouchableOpacity> */}
                            {imgsLists.length !== 0 &&
                                imgsLists.map((item, index) => {
                                    if (index >= maxImgLen) return;
                                    return (
                                        <TouchableOpacity onPress={() => {this.setState({bigIndex: index,showBigPicVisible: true})}} key={index} style={styles.img_item_box}   >
                                            <ImageView
                                                style={styles.img_item}
                                                source={{ uri: item.refundVideo === '' ?getPreviewImage(item.refundPic): item.refundPic }}
                                                sourceWidth={60}
                                                sourceHeight={60}
                                                resizeMode="cover"
                                            />
                                            <TouchableOpacity
                                                style={styles.img_item_delete}
                                                onPress={() => {
                                                    this._deletePicture(index);
                                                }}
                                            >
                                                <Image source={require("../../images/index/delete.png")} />
                                            </TouchableOpacity>
                                            {
                                                item.refundVideo !== ''
                                                ? <View style={{height: 60,width: 60,position: 'absolute',...CommonStyles.flex_center}}>
                                                    <Image style={styles.video_btn} source={require('../../images/index/video_play_icon.png')} />
                                                </View>
                                                : null
                                            }
                                        </TouchableOpacity>
                                    );
                                })}
                            {imgsLists.length === 0 ||
                                imgsLists.length < maxImgLen ? (
                                    <TouchableOpacity
                                        style={styles.img_item_box}
                                        onPress={() => {
                                            this.ActionSheet.show()
                                        }}
                                    >
                                        <Image
                                            style={styles.img_item}
                                            source={require("../../images/mall/add_img_icon.png")}
                                        />
                                    </TouchableOpacity>
                                ) : null}
                        </View>
                    </View>
                    <TouchableOpacity
                        activeOpacity={reason === "请选择" ? 1 : 0.2}
                        style={[
                            styles.bottomBtn,
                            reason === "请选择" ? styles.disableBtn : {}
                        ]}
                        onPress={() => {
                            Loading.show();
                            this.handleApplyRefund();
                        }}
                    >
                        <Text style={styles.bottomBtnText}>提交</Text>
                    </TouchableOpacity>
                </ScrollView>
                {/* 选择原因 modal */}
                <Modal
                    animationType="fade"
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={() => { console.log(0); }}
                >
                    <View style={styles.modal}>
                        <View style={styles.modalContent}>
                            <View
                                style={[styles.modalItem, styles.flex_center, styles.borderBottom
                                ]}
                            >
                                <Text
                                    style={[styles.modalItemText, styles.color_red
                                    ]}
                                >
                                    退款原因
                                </Text>
                            </View>
                            <ScrollView
                                showsHorizontalScrollIndicator={false}
                            >
                                {
                                    reasonList.length > 0 &&
                                        reasonList.map((item, index) => {
                                            return (
                                                <TouchableOpacity
                                                    key={index}
                                                    style={[styles.modalItem, styles.flex_center, styles.borderBottom]}
                                                    onPress={() => {
                                                        this.setState({
                                                            reason: item.refundReason,
                                                            reasonId:
                                                                item.refundReasonId,
                                                            modalVisible: false
                                                        });
                                                    }}
                                                >
                                                    <Text style={styles.modalItemText}>
                                                        {item.refundReason}
                                                    </Text>
                                                </TouchableOpacity>
                                            );
                                        })
                                }
                            </ScrollView>
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    this.handleChangeState("modalVisible", false);
                                }}
                                style={[styles.modalItem, styles.flex_center]}
                            >
                                <View style={styles.block} />
                                <Text style={[styles.modalItemText]}>取消</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
                {/* 选择上传方式 modal */}
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
                    ImageList={this.getPreviewPic()}
                    visible={this.state.showBigPicVisible}
                    showImgIndex={this.state.bigIndex}
                    onClose={() => {
                        this.setState({
                            showBigPicVisible: false,
                    }) }}
                />
            </View>
        );
    }
}

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
    goodsWrpa: {
        borderRadius: 8,
        backgroundColor: "#fff",
        margin: 10,
        borderWidth: 1,
        borderColor: "rgba(215,215,215,0.5)",
        overflow: "hidden"
        // marginBottom: 60
    },
    goodsItem: {
        padding: 15,
        backgroundColor: "#fff"
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
        height: 69,
        width: 69,
        borderRadius: 6,
    },
    imgWrap: {
        borderRadius: 6,
        borderWidth: 1,
        borderColor: "#E5E5E5",
        backgroundColor: "#fff",
        height: 69,
        width: 69
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
    selectWrap: {
        margin: 10,
        marginTop: 0,
        borderRadius: 8,
        backgroundColor: "#fff",
        borderWidth: 1,
        borderColor: "rgba(215,215,215,0.5)"
    },
    selectItem: {
        borderBottomColor: "#F1F1F1",
        borderBottomWidth: 1,
        padding: 13,
    },
    selectItem_upLoadImg: {
        borderBottomColor: "#F1F1F1",
        borderBottomWidth: 1,
        padding: 13,
        paddingTop: 0,
    },
    selectItem_text: {
        fontSize: 14,
        color: "#222"
    },
    selectItem_img: {
        width: 14,
        height: 8
    },
    modal: {
        // height: 342,
        flex: 1,
        backgroundColor: "rgba(10,10,10,.5)",
        position: "relative"
    },
    modalContent: {
        position: "absolute",
        bottom: 0,
        left: 0,
        width,
        backgroundColor: "#fff",
        maxHeight: 335 + CommonStyles.footerPadding,
        paddingBottom: CommonStyles.footerPadding,
    },
    color_red: {
        color: "#EE6161"
    },
    modalItemText: {
        fontSize: 17,
        color: "#222"
    },
    modalItem: {
        paddingVertical: 15,
        width,
        position: "relative"
    },
    marginTop: {
        marginTop: 5
    },
    borderBottom: {
        borderBottomColor: "#f1f1f1",
        borderBottomWidth: 1
    },
    block: {
        width,
        height: 5,
        backgroundColor: "#F1F1F1",
        position: "absolute",
        top: 0,
        left: 0
    },
    bottomBtn: {
        margin: 10,
        marginTop: 0,
        paddingVertical: 11,
        backgroundColor: "#4A90FA",
        borderRadius: 8
    },
    bottomBtnText: {
        textAlign: "center",
        color: "#fff",
        fontSize: 17
    },
    disableBtn: {
        backgroundColor: "#999"
    },
    img_item: {
        borderRadius: 6
    },
    img_item_box: {
        marginRight: 10,
        marginTop: 13,
    },
    img_item_delete: {
        position: "absolute",
        top: -5,
        right: -5,
        alignItems: "flex-end",
        width: 24,
        height: 24
    },
    video_btn: {
        // position: 'absolute',
        width: 30,
        height: 30,
    },
});

export default connect(
    state => ({ store: state }),
    {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
    }
)(SOMReturnedAllScreen);
