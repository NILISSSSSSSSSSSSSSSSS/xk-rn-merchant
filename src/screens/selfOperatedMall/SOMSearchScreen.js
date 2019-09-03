/**
 * 自营商城搜索页
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    StatusBar,
    View,
    Text,
    Keyboard,
    TouchableOpacity,
    Image,
} from 'react-native';
import { connect } from 'rn-dva'
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import TextInputView from '../../components/TextInputView';

const { width, height } = Dimensions.get('window');

class SOMSearchScreen extends Component {
    static navigationOptions = {
        header: null,
    }
    _didFocusSubscription;
    _willBlurSubscription;
    constructor(props) {
        super(props)
        this._didFocusSubscription = props.navigation.addListener('didFocus', (payload) => {
            StatusBar.setBarStyle('dark-content')
        });
        this.state = {
            searchText: '', // 搜索关键字
        }
    }

    componentDidMount() {
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            StatusBar.setBarStyle('light-content')
        );
        this.getSearchHistory();
        this.getHotLists();
    }

    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }

    // 读取搜索历史
    getSearchHistory = () => {
        const { dispatch } = this.props
        dispatch({ type: 'mall/getStorageSearchHistory'})
    }

    // 获取搜索热词
    getHotLists = () => {
        const { dispatch } = this.props
        dispatch({ type: 'mall/getHotList'})
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    // 清空输入框内容
    clearTextInput = () => {
        this.searchTextInput.clear();
        this.changeState('searchText', '');
        this.searchTextInput.focus();
    }
    // 清除搜索历史
    handleClearHistory = () => {
        const { dispatch } = this.props
        dispatch({ type: 'mall/clearHistory' })
    }
    // 提交搜索
    onSubmitText = (data) => {
        const { dispatch, navigation } = this.props
        const { searchText } = this.state
        Loading.show();
        Keyboard.dismiss();
        if (!searchText && !data) {
            Toast.show('请输入搜索内容');
            return
        }
        dispatch({ type: 'mall/saveSomSearchHistory', payload: { keyword: data || searchText } })
        // dispatch({ type: 'mall/searchGoodsList', payload: { params }})
        navigation.replace('SOMSearchResult', { keyword: data || searchText, activeIndex: -1 });
    }

    renderHistory = (data, hasBottomLine = false, isHot = false) => {
        return (
            <View>
                {
                    data.lists.length !== 0 ?
                        <View style={styles.historyView}>
                            <View style={[CommonStyles.flex_between, styles.his_title]}>
                                <Text style={styles.his_title_text}>{data.title}</Text>
                                {
                                    (!isHot)
                                        ? <TouchableOpacity style={styles.imgWrap} onPress={() => { this.handleClearHistory() }}>
                                            <Image source={require('../../images/mall/history_close_icon.png')} />
                                        </TouchableOpacity>
                                        : null
                                }
                            </View>
                            <View style={styles.his_lists}>
                                {
                                    data.lists.map((item, index) => {
                                        return (
                                            <TouchableOpacity
                                                key={index}
                                                style={styles.his_lists_item}
                                                onPress={() => {
                                                    this.onSubmitText(item);
                                                }}
                                            >
                                                <Text style={styles.his_lists_item_text} numberOfLines={1}>{item}</Text>
                                            </TouchableOpacity>
                                        );
                                    })
                                }
                            </View>
                        </View> :
                        null
                }
                {
                    data.lists.length !== 0 && hasBottomLine ?
                        <View style={[styles.historyView, styles.historyView_line]}></View> :
                        null
                }
            </View>
        );
    }

    render() {
        const { navigation, store } = this.props;
        const { searchText } = this.state;
        const { somHistoryLists, somHotList } = this.props
        console.log('this.props',this.props)
        return (
            <View style={styles.container}>
                <StatusBar barStyle={'dark-content'} />
                <Header
                    navigation={navigation}
                    headerStyle={styles.headerView}
                    leftView={
                        <View style={{ width: 0 }}></View>
                    }
                    centerView={
                        <TextInputView
                            inputView={[styles.headerItem, styles.headerCenterView]}
                            inputRef={(e) => { this.searchTextInput = e }}
                            style={styles.headerTextInput}
                            value={searchText}
                            autoFocus={true}
                            placeholder={'输入商品名称'}
                            placeholderTextColor={'#999'}
                            onChangeText={(text) => {
                                this.changeState('searchText', text);
                            }}
                            returnKeyType={'search'}
                            onSubmitEditing={() => {
                                this.onSubmitText();
                            }}
                            leftIcon={
                                <View style={[styles.headerTextInput_icon, styles.headerTextInput_search]}>
                                    <Image source={require('../../images/mall/search_gray.png')} />
                                </View>
                            }
                            rightIcon={
                                searchText === '' ?
                                    null :
                                    <TouchableOpacity
                                        style={[styles.headerTextInput_icon, styles.headerTextInput_close]}
                                        onPress={() => {
                                            this.clearTextInput();
                                        }}
                                    >
                                        <Image source={require('../../images/mall/close_gray.png')} style={styles.headerTextInput_close_img} />
                                    </TouchableOpacity>
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
                    {this.renderHistory(somHistoryLists, true)}
                    {this.renderHistory(somHotList, false, true)}
                </TouchableOpacity>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    headerView: {
        backgroundColor: '#fff',
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    headerCenterView: {
        position: 'relative',
        flex: 1,
        height: 30,
        marginLeft: 10,
        zIndex: 1,
    },
    headerTextInput: {
        flex: 1,
        height: '100%',
        paddingHorizontal: 40,
        paddingVertical: 0,
        borderRadius: 15,
        fontSize: 14,
        backgroundColor: '#EEE',
    },
    headerTextInput_icon: {
        position: 'absolute',
        top: 0,
        justifyContent: 'center',
        alignItems: 'center',
        width: 40,
        height: '100%',
        zIndex: 2,
    },
    headerTextInput_search: {
        left: 0,
    },
    headerTextInput_close: {
        right: 0,
    },
    headerTextInput_close_img: {
        width: 18,
        height: 18,
    },
    headerRightView: {
        paddingLeft: 12,
        paddingRight: 23,
    },
    header_search_text: {
        fontSize: 17,
        color: '#222',
    },
    contentView: {
        flex: 1,
        paddingBottom: CommonStyles.footerPadding,
        backgroundColor: '#fff',
    },
    historyView: {
        width: width - 20,
        marginHorizontal: 10,
    },
    historyView_line: {
        height: 1,
        backgroundColor: '#F1F1F1',
    },
    his_title: {
        width: '100%',
        paddingVertical: 10,
    },
    his_title_text: {
        fontSize: 14,
        color: '#4A90FA',
    },
    his_lists: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        width: '100%',
        maxHeight: 120,
        overflow: 'hidden',
    },
    his_lists_item: {
        justifyContent: 'center',
        alignItems: 'center',
        height: 30,
        marginRight: 10,
        marginBottom: 10,
        paddingHorizontal: 14,
        borderRadius: 15,
        backgroundColor: '#F1F1F1',
    },
    his_lists_item_text: {
        fontSize: 12,
        color: '#666',
    },
    imgWrap: {

    },
});

export default connect(
    (state) => ({
        somHistoryLists: state.mall.somHistoryLists, // 自营历史记录
        somHotList: state.mall.somHotList,
     }),
    (dispatch) => ({ dispatch })
)(SOMSearchScreen);
