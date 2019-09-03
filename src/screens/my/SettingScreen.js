/*
* 我的设置
*/
import React, { PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Platform,
    StatusBar,
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import * as nativeApi from "../../config/nativeApi";
import CommonStyles from "../../common/Styles";
import Switch from 'react-native-switch-pro'
import { ListItem } from "../../components/List";
import List from "../../components/List";
import ModalDemo from "../../components/Model";
import { NavigationPureComponent } from "../../common/NavigationComponent";

const { width, height } = Dimensions.get("window");
function getwidth(val) {
    return (width * val) / 375;
}

const dataSetting = [
    { title: "商圈订单语音提示", name: "switchShopMsg", type: "switch" },
    { title: "可友消息通知", name: "switchFriendMsg", type: "switch" }, // todo 暂时未做 隐藏
    { title: "清除缓存", name: "clear", type: "default", value: "200M" },
    { title: "修改密码", name: "resetPwd", type: "arrow", path: "ResetPassword", params: {} },
    { title: "关于我们", name: "aboutus", type: "arrow", path: "AboutUs", params: {} },
    { title: "退出登录", name: "exit", type: "arrow", path: "Exit", params: {} }
]

class SettingScreen extends NavigationPureComponent {
    state = {
        clearValue: "200M",
        confimVis: false,
        flag: 0,//开关
    }
    blurState = {
        confimVis: false
    }

    screenDidFocus = (payload) => {
        super.screenDidFocus(payload)
        StatusBar.setBarStyle("dark-content")
    }

    screenWillBlur = (payload) => {
        super.screenWillBlur(payload)
        StatusBar.setBarStyle("light-content")
    }
    onSwitchIMMute(flag) {
        this.setState({ flag })
        console.log("kaadadasasdasd", flag);     //开关测试正常
        Platform.OS === 'ios' ? nativeApi.jumpSysSetting() : nativeApi.onSwitchFriendMsg(flag) //可友消息免打扰开关设置
    }
    componentDidMount() {
        const { fetchStorageSize } = this.props;
        fetchStorageSize()
        Platform.OS === "ios" ?
            nativeApi.getIMMute().then(res => {
                this.setState({ flag: res || 0 })
            }).catch(err => {
                console.log(err)
            }): //获取语音推送消息状态
            nativeApi.getFriendMsgSwitch().then(res => {
                this.setState({ flag: res || 0 })
            }).catch(err => {
                console.log(err)
            });//获取可友消息推送开关状态
    }

    handleSwitchChange(key, value) {
        if (key === "switchShopMsg") {
            const { settings, saveMySettings } = this.props;
            saveMySettings(settings, { [key]: !settings[key] })
        } else {
            const { flag } = this.state;
            this.onSwitchIMMute(!flag ? 1 : 0)
        }
    }

    render() {
        const { userLogout, navigation, restoreStorage, storageSize, settings } = this.props;
        const { confimVis, flag } = this.state;
        console.log("SettingsScreen.render", flag, flag === 1)
        return (
            <View style={styles.container}>
                <Header
                    title='设置'
                    navigation={navigation}
                    headerStyle={styles.header}
                    goBack={true}
                    backStyle={{ tintColor: "#222" }}
                    titleTextStyle={{ color: "#222" }}
                />
                <List style={styles.content}>
                    {/* header */}
                    {
                        dataSetting.map((item, index) => {
                            let key = item.name;
                            let extra = item.type === "switch" ?
                                <View style={styles.switchContainer}>
                                    <Switch key={key}
                                        style={styles.Switch}
                                        onSyncPress={(value) => this.handleSwitchChange(key, value)}
                                        value={key === "switchShopMsg" ? settings[key] : flag === 1}
                                    />
                                </View>
                                : item.type === "default" ? storageSize : null
                            return (
                                <ListItem
                                    key={index}
                                    title={item.title}
                                    titleStyle={styles.titleStyle}
                                    style={styles.lightstyle}
                                    arrowStyle={styles.arrowStyle}
                                    extraStyle={styles.extraStyle}
                                    extra={extra}
                                    arrow={item.type === "arrow"}
                                    onPress={() => {
                                        if (item.type === "default") {
                                            restoreStorage()
                                            return
                                        } else if (item.type === "arrow") {
                                            item.path === "Exit" ? this.setState({ confimVis: true }) : navigation.navigate(item.path, item.params)
                                        }
                                    }}
                                />
                            )
                        })
                    }
                    {/* footer */}
                </List>
                {/* 退出登录 modal */}
                <ModalDemo
                    fliterWrapStyle={{ backgroundColor: 'rgba(0,0,0,0.4)' }}
                    containerStyle={{ paddingHorizontal: 52 }}
                    noTitle={true}
                    titleStyle={styles.modalTitle}
                    leftBtnText="取消"
                    rightBtnText="确定"
                    visible={confimVis}
                    title="确定退出登录？"
                    type="confirm"
                    onClose={() => this.setState({ confimVis: false })}
                    onConfirm={() => {
                        this.setState({ confimVis: false })
                        userLogout()
                    }}
                />
            </View>
        )
    }

};
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: "#FFF",
        alignItems: 'center'
    },
    switchContainer: {
        height: 0,
        overflow: 'visible',
        position: 'relative',
        top: getwidth(-10),
        right: getwidth(0)
    },
    modalTitle: {
        color: '#030303',
        fontSize: 17
    },
    header: {
        backgroundColor: "#FFF",
        borderColor: "rgba(0,0,0,0.08)",
        borderWidth: 1,
    },
    Switch: {
        width: 36,
        height: 23,
    },
    arrowStyle: {
        tintColor: "#CCCCCC"
    },
    extraStyle: {
        color: "#9399A5"
    },
    lightstyle: {
        borderColor: '#F1F1F1',
        borderBottomWidth: 1,
        paddingVertical: 20
    },
    content: {
        marginHorizontal: 25,
        alignItems: "center",
        height: 65,
    },
    titleStyle: {
        fontSize: 14,
        textAlign: "right",
        color: "#222222"
    },
})

export default connect(
    (state) => ({
        settings: state.my.settings,
        storageSize: state.my.storageSize
    }),
    {
        saveMySettings: (settings, state) => ({
            type: "my/save", payload: {
                settings: { ...settings, ...state }
            }
        }),
        userLogout: () => ({ type: "user/logout" }),
        fetchStorageSize: (params) => ({ type: "my/fetchStorageSize", payload: { params } }),
        restoreStorage: () => ({ type: "my/restoreStorage" })
    }
)(SettingScreen);
