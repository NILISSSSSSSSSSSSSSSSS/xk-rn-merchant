/**
 * 福利商城 货物报损 提交
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    Platform,
    View,
    Text,
    Keyboard,
    TouchableOpacity,
    Image,
    Button,
    ScrollView
} from "react-native";
import { connect } from "rn-dva";


import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import * as requestApi from "../../config/requestApi";
import * as nativeApi from "../../config/nativeApi";
import { qiniuUrlAdd, getPreviewImage } from "../../config/utils";
import ImageView from "../../components/ImageView";
import TextInputView from "../../components/TextInputView";
// import UploadModal from "../../components/UploadModal";
import ActionSheet from "../../components/Actionsheet";
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { NavigationComponent } from "../../common/NavigationComponent";
const { width, height } = Dimensions.get("window");
import { TakeOrPickParams, TakeOrPickCropEnum, TakeTypeEnum, PickTypeEnum, } from '../../const/application';

class WMGoodsDamag extends NavigationComponent {
    static navigationOptions = {
        header: null
    };
    constructor(props) {
        super(props);
        this.state = {
            qiniuToken: null,
            text: "",
            imgsLists: [],
            maxImgLen: 9, // 最大图片张数
            options: ['拍摄(照片或视频)','从手机相册选择', '取消'], // 弹窗操作项
            modalVisible: false,
            bigIndex: 0,
            showBigPicVisible: false,
        };
    }

    blurState = {
        modalVisible: false,
        showBigPicVisible: false,
    }

    componentDidMount() { }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    submit = () => {
        Keyboard.dismiss();
        const { navigation } = this.props
        const { text, imgsLists } = this.state;
        let orderData = navigation.getParam('orderData', {})
        let callback = navigation.getParam('getData', () => { })
        if (text === "" || text.length < 6) {
            Toast.show("请输入最少6字描述内容！");
            return;
        }
        if (imgsLists.length === 0) {
            Toast.show('请最少上传一张图片')
            return
        }
        let temp = [];
        imgsLists.map(item => {
            // 因为后台改了接口，现在调整上传图片的格式
            if (item.type === 'images') {
                temp.push({
                    pic: item.url,
                    video: "",
                })
            }
            if (item.type === 'video') {
                temp.push({
                    pic: item.mainPic,
                    video: item.url,
                })
            }

        });
        let params = {
            reason: text,
            explainUrls: temp,
            orderId: orderData.orderId
        };
        Loading.show();
        requestApi.jmallOrderRefundCreate(params).then(res => {
            console.log('resres', res)
            Toast.show('提交成功!')
            callback()
            navigation.navigate('WMGoodsDamagSuccessful', { resultType: 2, awardUsage: orderData.awardUsage })
        }).catch(err => {
            console.log(err)
        })
    };

    componentWillUnmount() {
        super.componentWillUnmount()
        Loading.hide();
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

    _deletePicture = item => {
        let data = this.state.imgsLists;
        console.log('item',item);
        for (let i = 0; i < data.length; i++) {
            if (item.url === data[i].url) {
                data.splice(i, 1);
            }
        }
        this.changeState("imgsLists", data);
    };
    handleSetUploadResponse = (res) => {
        let { imgsLists } = this.state;
        let videObjArr = []
        let picArr = [];
        res && res.map(item => {
            if (item.type && item.type=== 'video') {
                videObjArr.push({
                    url: item.url,
                    mainPic: item.cover,
                    type: 'video'
                })
            }
            if (item.type && item.type === 'images') {
                picArr.push(item)
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
    render() {
        const { navigation, store } = this.props;
        const { text, imgsLists, maxImgLen, options,showBigPicVisible,bigIndex } = this.state;
        console.log('imgsLists',imgsLists)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"货物报损"}
                />

                <TouchableOpacity
                    activeOpacity={1}
                    onPress={() => {
                        Keyboard.dismiss();
                    }}
                    style={styles.contentView}
                >
                    <View style={{ position: "relative" }}>
                        <TextInputView
                            inputView={styles.textInputView}
                            inputRef={e => {
                                this.textInput = e;
                            }}
                            style={styles.textInput}
                            multiline={true}
                            maxLength={155}
                            value={text}
                            onBlur={() => {
                                Keyboard.dismiss();
                            }}
                            placeholder={"请输入描述内容"}
                            placeholderTextColor={"#999"}
                            onChangeText={text => {
                                console.log(text);
                                this.changeState("text", text.trim());
                            }}
                        />
                        <View style={styles.flex_end}>
                            <View style={styles.fontNumView}>
                                <Text
                                    style={[styles.flex_start, styles.fontNum]}
                                >
                                    {text.length}/155
                                </Text>
                            </View>
                        </View>
                    </View>
                    <View style={styles.imgsView}>
                        {imgsLists.length !== 0 &&
                            imgsLists.map((item, index) => {
                                if (index >= maxImgLen) return;
                                return (
                                    <TouchableOpacity
                                        onPress={() => {
                                            this.setState({bigIndex: index,showBigPicVisible: true})
                                        }}
                                        key={index}
                                        style={styles.img_item_box}
                                    >
                                        <ImageView
                                            style={styles.img_item}
                                            source={{ uri: (item.type === 'video') ? qiniuUrlAdd(item.mainPic) : getPreviewImage(item.url) }}
                                            sourceWidth={60}
                                            sourceHeight={60}
                                            resizeMode="cover"
                                        />
                                        {
                                            item.type === 'video'
                                            ? <View style={{height: '100%',width: '100%',position: 'absolute',...CommonStyles.flex_center}}>
                                                <Image style={styles.video_btn} source={require('../../images/index/video_play_icon.png')} />
                                            </View>
                                            : null
                                        }
                                        <TouchableOpacity
                                            style={styles.img_item_delete}
                                            onPress={() => {
                                                this._deletePicture(item);
                                            }}
                                        >
                                            <Image
                                                source={require("../../images/index/delete.png")}
                                            />
                                        </TouchableOpacity>
                                    </TouchableOpacity>
                                );
                            })}
                        {imgsLists.length === 0 ||
                            imgsLists.length < maxImgLen ? (
                                <TouchableOpacity
                                    style={styles.img_item_box}
                                    onPress={() => {
                                        this.ActionSheet.show()
                                        // this.changeState("modalVisible", true);
                                    }}
                                >
                                    <Image
                                        style={styles.img_item}
                                        source={require("../../images/order/upload_pic.png")}
                                    />
                                </TouchableOpacity>
                            ) : null}
                    </View>
                </TouchableOpacity>

                <TouchableOpacity
                    style={styles.submitView}
                    activeOpacity={0.8}
                    onPress={() => {
                        this.submit();
                    }}
                >
                    <Text style={styles.submitView_text}>确认提交</Text>
                </TouchableOpacity>
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
                    ImageList={imgsLists}
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
    contentView: {
        // ...CommonStyles.shadowStyle,
        width: width - 20,
        margin: 10,
        borderRadius: 6,
        backgroundColor: "#fff",
        overflow: "hidden",
        paddingBottom: 10
    },
    textInputView: {
        height: 155,
    },
    textInput: {
        height: "100%",
        padding: 15,
        textAlignVertical: "top"
    },
    imgsView: {
        flexDirection: "row",
        flexWrap: "wrap",
        alignItems: "center",
        justifyContent: "flex-start",
        borderTopWidth: 1,
        borderTopColor: "#E5E5E5"
    },
    img_item_box: {
        position: "relative",
        width: 60,
        height: 60,
        marginTop: 10,
        marginLeft: 15,
        // borderWidth: 0.5,
        // borderColor: "#f1f1f1",
        // borderRadius: 6
    },
    img_item: {
        width: "100%",
        height: "100%",
        borderRadius: 6,
        overflow: "hidden",
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
        // height: 44,
        paddingVertical: 14,
        marginHorizontal: 10,
        borderRadius: 8,
        backgroundColor: "#4A90FA",

    },
    submitView_text: {
        fontSize: 17,
        color: "#fff"
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
        backgroundColor: "#fff"
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
    flex_end: {
        flexDirection: "row",
        justifyContent: "flex-end",
        alignItems: "center"
    },
    flex_start: {
        flexDirection: "row",
        justifyContent: "flex-start",
        alignItems: "center"
    },
    fontNumView: {
        // backgroundColor: "rgba(0,0,0,.2)"
        paddingRight: 15,
        paddingBottom: 15,
    },
    fontNum: {
        fontSize: 14,
        color: "#999",
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
)(WMGoodsDamag);
