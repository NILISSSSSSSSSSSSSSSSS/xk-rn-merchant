/**
 * 常见问题
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
import { connect } from "rn-dva";
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import FlatListView from '../../components/FlatListView';
import * as requestApi from '../../config/requestApi';
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import {fetchCategoryManagerPage}  from "../../config/requestApi"

const { width, height } = Dimensions.get("window");

class ComeProblemCatrgory extends Component {
    static navigationOptions = {
        header: null
    };
    constructor(props) {
        super(props);
        this.state = {
            listName:'problemCatrgory',
        }

    }

    componentDidMount() {
        this.getList(true, false)
    }
    getList = (isFirst = false, isLoadingMore = false) => {
        this.props.fetchList({
            witchList:this.state.listName,
            isFirst,
            isLoadingMore,
            paramsPrivate : {bizStatus:'active'},
            api:fetchCategoryManagerPage,
            limit:20,
        })
    }
    renderItem = ({ item, index }) => {
        let length =this.props.longLists[this.state.listName].lists.length || 0
        const viewStyle = {
            borderTopLeftRadius: index == 0 ? 8 : 0,
            borderTopRightRadius: index == 0 ? 8 : 0,
            borderBottomLeftRadius: index == length - 1 ? 8 : 0,
            borderBottomRightRadius: index == length - 1 ? 8 : 0,
            overflow: 'hidden',
        }
        return (
            <View style={[styles.item, viewStyle]}>
                <Line
                    style={{ paddingLeft: 0, paddingRight: 0,paddingVertical: 15, borderBottomWidth: index == length - 1 ? 0 : 1 }}
                    type='horizontal'
                    title={item.name}
                    point={null}
                    onPress={() => this.props.navigation.navigate('CommonProblem', {
                        categoryId: item.id
                    })}
                />
            </View>

        )
    }
    render() {
        const { navigation,longLists } = this.props;
        const { listName } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"问题分类"}
                />
                <FlatListView
                    style={[{ backgroundColor: CommonStyles.globalBgColor, width: width}]}
                    renderItem={(data) =>
                        this.renderItem(data)
                    }
                    ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
                    store={{
                        ...longLists[listName],
                        page: longLists[listName] && longLists[listName].listsPage || 1
                    }}
                    data={longLists[listName] && longLists[listName].lists || []}
                    numColumns={1}
                    refreshData={() => this.getList(false, false)}
                    loadMoreData={() => this.getList(false, true)}
                    limit={20}
                />
            </View>
        );
    }
    handleChangeState = (key = '', data = []) => {
        this.setState({
            [key]: data
        })
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    item: {
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        width: width - 20,
        marginLeft: 10,
        // ...CommonStyles.shadowStyle
    },
    flatListLine: {
        height: 0,
    },
    container_textWrap: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: 'center',
        width: '100%',
        borderBottomWidth: 1,
        borderBottomColor: '#F1F1F1',
        paddingLeft: 20,
        paddingRight: 30,
        height: 50,
        backgroundColor: '#fff',
    },
    container_text: {
        fontSize: 14,
        color: '#222'
    },
    noBottomBorder: {
        borderBottomWidth: 0,
    },
    lastItem: {
        borderRadius: 6,
        marginTop: 20
    },
    topBorderRadius: {
        borderTopLeftRadius: 6,
        borderTopRightRadius: 6
    },
    bottomBorderRadius: {
        borderBottomLeftRadius: 6,
        borderBottomRightRadius: 6
    }
});
export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
     }),
    {
        fetchList: (payload={})=>({ type: "shop/getList", payload}),
        shopSave: (payload={})=> ({ type: "shop/save", payload}),
     }
)(ComeProblemCatrgory);
