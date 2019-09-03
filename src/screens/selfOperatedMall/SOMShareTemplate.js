/**
 * 自营分享模板
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
    RefreshControl
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from "../../config/requestApi";

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ShareTemplate from '../../components/ShareTemplate';
import config from '../../config/config'
let configShareUrl = config.baseUrl_share_h5
const { width, height } = Dimensions.get("window");

class SOMShareTemplate extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            shareTemp: [],
            shareUrl: '',
            shareParams: {},
            refreshing: false,
        }
    }

    componentDidMount() {
        this.handleGetNavigationParam()
    }

    componentWillUnmount() {
    }
    handleGetNavigationParam = () => {
        let shareParams = this.props.navigation.getParam('shareParams',{})
        let shareUrl = this.props.navigation.getParam('shareUrl',{})
        let goodsId = this.props.navigation.getParam('goodsId','')
        Loading.show();
        requestApi.promotionTemplateQList({
            goodsId,
        }).then(res => {
            console.log('获取分析模板',res)
            if (res) {
                this.setState({
                    shareTemp: res,
                    shareParams,
                    refreshing: false,
                })
            }
        }).catch(err => {
            console.log(err)
        })
    }
    handleSelectSharTemp = (item) => {
        const { shareParams } = this.state
        if (shareParams) {
            this.setState({
                shareModal: true,
                shareUrl: item.h5Url ? item.h5Url : `${configShareUrl}spreadTmpInfo?id=${item.id}`
            })
        } else {
            Toast.show("获取分享信息失败");
        }
    }
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }
    _onRefresh = () => {
        this.setState({
            refreshing: true,
        })
        this.handleGetNavigationParam()
    }
    render() {
        const { navigation, store } = this.props;
        const { shareModal,shareUrl, shareTemp,shareParams,refreshing } = this.state
        console.log('shareUrl',shareUrl)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"模板列表"}
                />
                <View style={styles.templateListWrap}>
                    <ScrollView
                        showsHorizontalScrollIndicator={false}
                        showsVerticalScrollIndicator={false}
                        refreshControl={
                            <RefreshControl
                                refreshing={refreshing}
                                onRefresh={this._onRefresh}
                            />
                        }
                    >
                        {
                            shareTemp && shareTemp.length > 0 && shareTemp.map((item, index) => {
                                let topBorder = index !== 0 ? styles.topBorder : {}
                                return (
                                    <View style={[styles.itemWrap, topBorder]} key={index}>
                                        <Text style={styles.itemTitle}>{item.name}</Text>
                                        <View style={[CommonStyles.flex_between, { paddingTop: 15 }]}>
                                            <TouchableOpacity
                                                style={styles.itemLeftBtn}
                                                onPress={() => {
                                                    let source = {
                                                        uri: item.h5Url ? item.h5Url : `${configShareUrl}spreadTmpInfo?id=${item.id}`,
                                                        showLoading: true,
                                                        headers: { "Cache-Control": "no-cache" }
                                                    }
                                                    this.props.navigation.navigate('WebView', { source })}}
                                            >
                                                <Text
                                                style={[styles.itemBtnText, { color: CommonStyles.globalHeaderColor }]}

                                                >预览</Text>
                                            </TouchableOpacity>
                                            <TouchableOpacity
                                            style={styles.itemRightBtn}
                                            onPress={() => {
                                                this.handleSelectSharTemp(item)
                                            }}
                                            >
                                                <Text style={[styles.itemBtnText, { color: '#fff' }]}>使用该模板分享</Text>
                                            </TouchableOpacity>
                                        </View>
                                    </View>
                                )
                            })
                        }
                    </ScrollView>
                </View>
                {/* 分享 */}
                {
                    shareModal && shareUrl !== ''
                    ? <ShareTemplate
                        type='SOM'
                        onClose={() => { this.changeState("shareModal", false); }}
                        shareParams={shareParams}
                        shareUrl={shareUrl}
                    />
                    : null
                }
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    templateListWrap: {
        margin: 10,
        // paddingBottom: 70,
        borderRadius: 8,
        borderWidth: 0.5,
        borderColor: 'rgba(215,215,215,0.5)',
        backgroundColor: '#fff'
    },
    itemWrap: {
        padding: 15,
    },
    topBorder: {
        borderTopColor: '#f1f1f1',
        borderTopWidth: 1,
    },
    itemTitle: {
        color: '#222',
        fontSize: 14,
    },
    itemLeftBtn: {
        paddingHorizontal: 38,
        paddingVertical: 8,
        borderWidth: 1,
        borderColor: CommonStyles.globalHeaderColor,
        borderRadius: 80
    },
    itemRightBtn: {
        paddingHorizontal: 12,
        paddingVertical: 8,
        backgroundColor: CommonStyles.globalHeaderColor,
        borderRadius: 30
    },
    itemBtnText: {
        fontSize: 14,
    },
    itemBtnText: {
        fontSize: 14,
    },
});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMShareTemplate);
