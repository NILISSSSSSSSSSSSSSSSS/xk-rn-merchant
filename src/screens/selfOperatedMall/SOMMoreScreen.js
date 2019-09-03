/**
 * 自营商城更多商品分类
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
// import { connect } from "react-redux";
// import { bindActionCreators } from "redux";
// import actions from "../../action/actions";

import { connect } from 'rn-dva'

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from '../../config/requestApi';

const { width, height } = Dimensions.get("window");

class SOMMoreScreen extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            categoryLists: JSON.parse(JSON.stringify(props.navigation.state.params && props.navigation.state.params.categoryLists)),
            maxLen: props.navigation.state.params && props.navigation.state.params.categoryListsMaxLen,
            editType: false,
            categoryLists_sys: [],
            categoryLists_pre: [],
            categoryLists_other: [],
            categoryLists_pre_len: 0,
        }
    }

    componentDidMount() {
        this.filterCategoryLists(this.state.categoryLists);
    }

    filterCategoryLists = (data) => {
        const { maxLen } = this.state;

        // pre_selected 默认null，用户已选择true，用户删除false
        // 用户删除的排在最后
        let data_sys = [];
        let data_pre = [];
        let data_other = [];
        let data_other2 = [];
        for (let i = 0; i < data.length; i++) {
            if (data[i].moveEnable === 0) {
                data_sys.push(data[i]);
            } else {
                if (data[i].pre_selected) {
                    data_pre.push(data[i]);
                } else if (data[i].pre_selected == false) {
                    data_other2.push(data[i]);
                } else {
                    data_other.push(data[i]);
                }
            }
        }
        data = [...data_sys, ...data_pre, ...data_other, ...data_other2];

        this.setState({
            categoryLists: data,
            categoryLists_sys: data_sys,
            categoryLists_pre: data_pre,
            categoryLists_other: [...data_other, ...data_other2],
            categoryLists_pre_len: maxLen - data_sys.length,
        });
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    // 添加
    addCate = (item) => {
        const { categoryLists_pre, categoryLists_pre_len } = this.state;
        if (categoryLists_pre.length >= categoryLists_pre_len) {
            Toast.show('已超过选择上限');
            return
        }

        let data = this.state.categoryLists;
        for (let i = 0; i < data.length; i++) {
            if (item.code === data[i].code) {
                data[i].pre_selected = true;
            }
        }
        this.filterCategoryLists(data);
    }

    // 删除
    deleteCate = (item) => {
        item.pre_selected = false;
        let data = this.state.categoryLists;
        for (let i = 0; i < data.length; i++) {
            if (item.code === data[i].code) {
                data.splice(i, 1);
                data.push(item);
            }
        }
        this.filterCategoryLists(data);
    }

    // 保存
    _save = (editType) => {
        const { categoryLists } = this.state;
        this.changeState('editType', !editType);
        if (editType) {
            requestApi.storageSOMCateLists('save', categoryLists);
            this.props.fetchSomPageData()
            // this.props.actions.changePreCategoryList(categoryLists);
        }
    }


    componentWillUnmount() {
    }

    render() {
        const { navigation, store } = this.props;
        const { categoryLists_sys, categoryLists_pre, categoryLists_other, maxLen, categoryLists_pre_len, editType } = this.state;

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"商品分类"}
                />

                <ScrollView alwaysBounceVertical={false}>
                    <View style={styles.titleView}>
                        <Text style={styles.content_text1}>平台推荐</Text>
                    </View>
                    <View style={styles.contentView}>
                        {
                            categoryLists_sys && categoryLists_sys.length !== 0 && categoryLists_sys.map((item, index) => {
                                if (index >= maxLen) return

                                return (
                                    <View
                                        key={index}
                                        style={styles.contentItem}
                                    >
                                        <Text numberOfLines={2} style={styles.content_text2}>{item.name}</Text>
                                    </View>
                                );
                            })
                        }
                    </View>

                    <View style={styles.titleView}>
                        <Text style={styles.content_text1}>私人订制</Text>
                        <TouchableOpacity
                            style={styles.titleView_icon}
                            onPress={() => {
                                this._save(editType);
                            }}
                        >
                            {
                                editType ?
                                    <Text style={styles.content_text3}>保存</Text> :
                                    <Image source={require('../../images/mall/category_edit.png')} />
                            }
                        </TouchableOpacity>
                    </View>
                    <View style={styles.contentView}>
                        {
                            categoryLists_pre && categoryLists_pre.length !== 0 && categoryLists_pre.map((item, index) => {
                                if (index >= categoryLists_pre_len) return

                                return (
                                    <View
                                        key={index}
                                        style={styles.contentItem}
                                    >
                                        <Text numberOfLines={2} style={styles.content_text2}>{item.name}</Text>
                                        {
                                            editType ?
                                                <TouchableOpacity
                                                    style={styles.contentItem_icon}
                                                    onPress={() => {
                                                        this.deleteCate(item);
                                                    }}
                                                >
                                                    <Image source={require('../../images/mall/category_delete.png')} />
                                                </TouchableOpacity> :
                                                null
                                        }
                                    </View>
                                );
                            })
                        }
                    </View>

                    <View style={styles.titleView}>
                        <Text style={styles.content_text1}>所有分类</Text>
                    </View>
                    <View style={styles.contentView}>
                        {
                            categoryLists_other && categoryLists_other.length !== 0 && categoryLists_other.map((item, index) => {
                                return (
                                    <View
                                        key={index}
                                        style={styles.contentItem}
                                    >
                                        <Text numberOfLines={2} style={styles.content_text2}>{item.name}</Text>
                                        {
                                            editType ?
                                                <TouchableOpacity
                                                    style={styles.contentItem_icon}
                                                    onPress={() => {
                                                        this.addCate(item);
                                                    }}
                                                >
                                                    <Image source={require('../../images/mall/category_add.png')} />
                                                </TouchableOpacity> :
                                                null
                                        }
                                    </View>
                                );
                            })
                        }
                    </View>
                    <View style={styles.bomView}></View>
                </ScrollView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    titleView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-end',
        height: 44,
        paddingLeft: 18,
    },
    content_text1: {
        fontSize: 14,
        color: '#999',
    },
    titleView_icon: {
        justifyContent: 'flex-end',
        alignItems: 'center',
        height: '100%',
        paddingHorizontal: 18,
    },
    content_text3: {
        fontSize: 14,
        color: '#4A90FA',
    },
    contentView: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        marginHorizontal: 10,
    },
    contentItem: {
        // ...CommonStyles.shadowStyle,
        position: 'relative',
        justifyContent: 'center',
        alignItems: 'center',
        width: (width - 50) / 5,
        height: (width - 50) / 5,
        marginTop: 5,
        marginLeft: 5,
        borderRadius: 2,
        backgroundColor: '#fff',
    },
    content_text2: {
        fontSize: 14,
        color: '#555',
        textAlign: 'center',
        paddingHorizontal: 10
    },
    contentItem_icon: {
        position: 'absolute',
        top: 1,
        right: 1,
    },
    bomView: {
        marginBottom: 20 + CommonStyles.footerPadding,
    },
});

export default connect(
    state => ({  state }),
    dispatch => ({
        fetchSomPageData: ()=> dispatch({ type: "mall/fetchSomPageData" }),
    })
)(SOMMoreScreen);