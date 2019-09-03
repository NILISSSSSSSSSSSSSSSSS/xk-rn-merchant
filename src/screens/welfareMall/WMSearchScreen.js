/**
 * 自营商城搜索页
 */
import React, { Component, PureComponent } from "react";
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
    Button
} from "react-native";
import { connect } from "rn-dva";
import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import * as requestApi from "../../config/requestApi";
import TextInputView from "../../components/TextInputView";

const { width, height } = Dimensions.get("window");

class WMSearchScreen extends Component {
    static navigationOptions = {
        header: null
    };
    constructor(props) {
        super(props);
        this.state = {
            searchText: "",
            historyLists: {
                title: "历史搜索",
                lists: []
            },
            hotLists: {
                title: "热门搜索",
                lists: []
            }
        };
    }

    componentDidMount() {
        this.getSearchHistory();
        this.getHotLists();
    }

    // 读取搜索历史
    getSearchHistory = () => {
        requestApi
            .storageSearchWMHistory("load")
            .then(res => {
                this.setState(({ historyLists }) => {
                    return {
                        historyLists: {
                            ...historyLists,
                            lists: res
                        }
                    };
                });
            })
            .catch(err => {
                console.log(err);
            });
    };

    // 获取搜索热词
    getHotLists = () => {
        requestApi.requestWMHotWordsList().then(res => {
            // 测试用
            if (res.length === 0) {
                res = [
                    "小可",
                    "书",
                    "包",
                    "商品",
                    "书包",
                    "鼠标",
                    "键盘",
                ];
            }
            this.setState(({ hotLists }) => {
                return {
                    hotLists: {
                        ...hotLists,
                        lists: res
                    }
                };
            });
        }).catch((err)=>{
            console.log(err)
          });
    };

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    // 清空输入框内容
    clearTextInput = () => {
        this.searchTextInput.clear();
        this.changeState("searchText", "");
        this.searchTextInput.focus();
    };
    // 清除搜索历史
    handleClearHistory = () => {
        requestApi.storageSearchHistory("remove");
        let data = JSON.parse(JSON.stringify(this.state.historyLists));
        data.lists = [];
        this.changeState("historyLists", data);
    };
    // 提交搜索
    onSubmitText = data => {
        Loading.show();
        Keyboard.dismiss();
        const { searchText, historyLists } = this.state;
        let keyword;
        if (data) {
            keyword = data;
        } else {
            if (searchText.trim().length === 0) {
                Loading.hide();
                Toast.show("请输入搜索内容");
                this.changeState("searchText", "");
                return;
            }
            keyword = searchText;
        }
        requestApi.storageSearchWMHistory("save", historyLists.lists, keyword);

        this.props.navigation.replace("WMSearchResult", { keyword });
    };

    renderHistory = (data, hasBottomLine = false, isHot) => {
        return (
            <View>
                {data.lists.length !== 0 ? (
                    <View style={styles.historyView}>
                        <View style={[styles.his_title, styles.flex_between]}>
                            <Text style={styles.his_title_text}>
                                {data.title}
                            </Text>
                            {!isHot ? (
                                <TouchableOpacity
                                    style={styles.imgWrap}
                                    onPress={() => {
                                        this.handleClearHistory();
                                    }}
                                >
                                    <Image
                                        source={require("../../images/mall/history_close_icon.png")}
                                    />
                                </TouchableOpacity>
                            ) : null}
                        </View>
                        <View style={styles.his_lists}>
                            {data.lists.map((item, index) => {
                                return (
                                    <TouchableOpacity
                                        key={index}
                                        style={styles.his_lists_item}
                                        onPress={() => {
                                            this.onSubmitText(item);
                                        }}
                                    >
                                        <Text
                                            style={styles.his_lists_item_text}
                                            numberOfLines={1}
                                        >
                                            {item}
                                        </Text>
                                    </TouchableOpacity>
                                );
                            })}
                        </View>
                    </View>
                ) : null}
                {data.lists.length !== 0 && hasBottomLine ? (
                    <View
                        style={[styles.historyView, styles.historyView_line]}
                    />
                ) : null}
            </View>
        );
    };

    componentWillUnmount() {
        // requestApi.storageSearchHistory('remove');
    }

    render() {
        const { navigation, store } = this.props;
        const { searchText, historyLists, hotLists } = this.state;

        return (
            <View style={styles.container}>
                <StatusBar barStyle={"dark-content"} />
                <Header
                    navigation={navigation}
                    headerStyle={styles.headerView}
                    leftView={<View style={{ width: 0 }} />}
                    centerView={
                        <TextInputView
                            inputView={[
                                styles.headerItem,
                                styles.headerCenterView
                            ]}
                            inputRef={e => {
                                this.searchTextInput = e;
                            }}
                            style={styles.headerTextInput}
                            value={searchText}
                            autoFocus={true}
                            placeholder={"搜索你想要的商品"}
                            placeholderTextColor={"#999"}
                            onChangeText={text => {
                                this.changeState("searchText", text);
                            }}
                            returnKeyType={"search"}
                            onSubmitEditing={() => {
                                this.onSubmitText();
                            }}
                            leftIcon={
                                <View
                                    style={[
                                        styles.headerTextInput_icon,
                                        styles.headerTextInput_search
                                    ]}
                                >
                                    <Image
                                        source={require("../../images/mall/search_gray.png")}
                                    />
                                </View>
                            }
                            rightIcon={
                                searchText === "" ? null : (
                                    <TouchableOpacity
                                        style={[
                                            styles.headerTextInput_icon,
                                            styles.headerTextInput_close
                                        ]}
                                        onPress={() => {
                                            this.clearTextInput();
                                        }}
                                    >
                                        <Image
                                            source={require("../../images/mall/close_gray.png")}
                                            style={
                                                styles.headerTextInput_close_img
                                            }
                                        />
                                    </TouchableOpacity>
                                )
                            }
                        />
                    }
                    rightView={
                        <TouchableOpacity
                            style={[styles.headerItem, styles.headerRightView]}
                            onPress={() => {
                                navigation.goBack();
                            }}
                        >
                            <Text style={styles.header_search_text}>取消</Text>
                        </TouchableOpacity>
                    }
                />

                <TouchableOpacity
                    activeOpacity={1}
                    style={styles.contentView}
                    onPress={() => {
                        this.searchTextInput.blur();
                    }}
                >
                    {this.renderHistory(historyLists, true)}
                    {this.renderHistory(hotLists, false, true)}
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    flex_between: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center"
    },
    headerView: {
        backgroundColor: "#fff"
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%"
    },
    headerCenterView: {
        position: "relative",
        flex: 1,
        height: 30,
        marginLeft: 10,
        zIndex: 1
    },
    headerTextInput: {
        flex: 1,
        height: "100%",
        paddingHorizontal: 40,
        paddingVertical: 0,
        borderRadius: 15,
        backgroundColor: "#EEE",
        fontSize:14
    },
    headerTextInput_icon: {
        position: "absolute",
        top: 0,
        justifyContent: "center",
        alignItems: "center",
        width: 40,
        height: "100%",
        zIndex: 2
    },
    headerTextInput_search: {
        left: 0
    },
    headerTextInput_close: {
        right: 0
    },
    headerTextInput_close_img: {
        width: 18,
        height: 18
    },
    headerRightView: {
        paddingLeft: 12,
        paddingRight: 23
    },
    header_search_text: {
        fontSize: 17,
        color: "#222"
    },
    contentView: {
        flex: 1,
        paddingBottom: CommonStyles.footerPadding,
        backgroundColor: "#fff"
    },
    historyView: {
        width: width - 20,
        marginHorizontal: 10
    },
    historyView_line: {
        height: 1,
        backgroundColor: "#F1F1F1"
    },
    his_title: {
        width: "100%",
        paddingVertical: 10
    },
    his_title_text: {
        fontSize: 14,
        color: "#4A90FA"
    },
    his_lists: {
        flexDirection: "row",
        flexWrap: "wrap",
        width: "100%",
        maxHeight: 120,
        overflow: "hidden"
    },
    his_lists_item: {
        justifyContent: "center",
        alignItems: "center",
        height: 30,
        marginRight: 10,
        marginBottom: 10,
        paddingHorizontal: 14,
        borderRadius: 15,
        backgroundColor: "#F1F1F1"
    },
    his_lists_item_text: {
        fontSize: 12,
        color: "#666"
    },
    imgWrap: {}
});

export default connect(
    state => ({ store: state })
)(WMSearchScreen);
