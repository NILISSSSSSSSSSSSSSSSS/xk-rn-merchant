
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    View,
    Text,
    Modal,
    Dimensions,
    TouchableOpacity,
    Platform,
} from 'react-native';
const { width, height } = Dimensions.get('window')
import CommonStyles from "../common/Styles";
export default class UploadModal extends PureComponent {

    static defaultProps = {
        lists: [],
        visible: false,
        animationType: 'fade',
        transparent: true,
        onClose: () => { }, // 显示时候回调
        onDismiss: () => { }, // 回调会在 modal 被关闭时调用。
    }
    render() {
        const { visible, onClose, lists } = this.props
        return (
            <React.Fragment>
                {/* 选择上传方式 modal */}
                <Modal
                    animationType="fade"
                    transparent={true}
                    visible={visible}
                    onRequestClose={onClose}
                >
                    <View style={styles.modal}>
                        <View style={styles.modalContent}>
                            {lists.length > 0 && lists.map((item, index) => {
                                return (
                                    <TouchableOpacity key={index} style={[styles.modalItem, styles.flex_center, styles.borderBottom]}
                                        onPress={() => {
                                            item.callBack(item, index);
                                            onClose();
                                        }}
                                    >
                                        <Text style={styles.modalItemText}>{item.title}</Text>
                                    </TouchableOpacity>
                                );
                            })}
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => { onClose() }}
                                style={[styles.modalItem, styles.flex_center]}
                            >
                                <View style={styles.block} />
                                <Text style={[styles.modalItemText]}>取消</Text>
                            </TouchableOpacity>
                            <View style={styles.bottomStyle} />
                        </View>
                    </View>
                </Modal>
            </React.Fragment>
        )
    }
}

const styles = StyleSheet.create({
    flex_center: {
        justifyContent: 'center',
        flexDirection: 'row',
    },
    flex_1: {
        flex: 1
    },
    modal: {
        // height: 342,
        flex: 1,

        backgroundColor: "rgba(10,10,10,.5)",
        position: "relative",

    },
    modalContent: {
        position: "absolute",
        bottom: 0,
        left: 0,
        width,
        backgroundColor: "#fff",
        paddingBottom:CommonStyles.footerPadding
    },
    color_red: {
        color: CommonStyles.globalRedColor
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
    bottomStyle: {
        paddingBottom: Platform.OS === 'ios' ? CommonStyles.footerPadding: 0,
    },
})
