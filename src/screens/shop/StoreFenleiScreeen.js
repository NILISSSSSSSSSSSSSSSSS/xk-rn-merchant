/**
 * 商城首页
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    
    View,
    ScrollView,
    Text,
    TouchableOpacity,
    Image,
    Button
} from "react-native";
import { connect } from "rn-dva";
import ImageView from "../../components/ImageView";

import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import * as requestApi from "../../config/requestApi";
import FlatListView from "../../components/FlatListView";

const { width, height } = Dimensions.get("window");

export default class StoreFenleiScreeen extends Component {
    static navigationOptions = {
        header: null
    };
    constructor(props) {
        super(props);
        const params = this.props.navigation.state.params || {};
        this.state = {
            list: [],
            parentIndex: 0,
            industry: params.industry || [],
            callback: (params.callback && params.callback) || (() => {}),
            allNum:0
        };
    }
    componentDidMount() {
        Loading.show();
        requestApi.industryAllQList().then((data)=>{
            if(data){
                let allNum=0
                for(let item1 of data.oneLevel){
                    item1.levelTwo = [];
                    item1.num=0
                    for(let item2 of data.twoLevel){
                        if(item2.parentCode==item1.code){
                            for (itemSelect of this.state.industry) {
                                if(itemSelect.levelOneCode == item1.code &&itemSelect.levelTwoCode ==item2.code){

                                    item2.select=true
                                    item1.num=item1.num+1
                                    allNum=allNum+1
                                }
                            }
                            item1.levelTwo.push(item2)
                        }
                        item2.select?null:item2.select=false
                    }
                }
                this.setState({ list: data.oneLevel,allNum });
            }
        })
        .catch(() => {
            Loading.hide();
        });
    }

    componentDidUpdate(prevProps, prevState) {}

    componentWillUnmount() {}
    levelOneOprate = (item, index) => {
        this.setState({
            parentIndex:index
        });
    };
    levelTwoOprate = (item, index) => {
        const { parentIndex,  list,allNum } = this.state;
        if((allNum==5 || allNum>5) && (!item.select)){
            Toast.show('最多选择5个分类')
        }else{
            let newAllNum=allNum
            if(item.select){
                newAllNum--
            }else{
                newAllNum++
            }
            let newList=[...list]
            let levelTwo = newList[parentIndex].levelTwo;
            levelTwo[index].select=!levelTwo[index].select
            newList[parentIndex].num=levelTwo[index].select?newList[parentIndex].num+1:newList[parentIndex].num-1
            this.setState({
                list: newList,
                allNum:newAllNum
            });
        }

    };
    save = () => {
        const {allNum}=this.state
        if(allNum>5){
            Toast.show('最多选择5个分类')
            return
        }
        let industry = [];
        let industryName = [];
        for (let item of this.state.list) {
            item.num>0?industryName.push(item.name):null;
            if (item.levelTwo.length > 0) {
                for (let itemTwo of item.levelTwo) {
                    if(itemTwo.select){
                        industry.push({
                            levelTwoCode: itemTwo.code.toString(),
                            levelOneName:itemTwo.name,
                            levelOneCode: item.code.toString(),
                            levelTwoName:item.name
                        });
                    }

                }
            }
        }
        this.state.callback(industry, industryName.join(";"));
        this.props.navigation.goBack();
    };

    render() {
        const { navigation} = this.props;
        const { list,parentIndex } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    title="店铺分类"
                    navigation={navigation}
                    goBack={true}
                    rightView={
                        <TouchableOpacity
                            onPress={() => this.save()}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                                保存
                            </Text>
                        </TouchableOpacity>
                    }
                />
                <View style={styles.modalInnerBottomView}>
                    <View style={styles.categorieListsView}>
                        <View style={styles.cagListsView}>
                            <ScrollView
                                alwaysBounceVertical={false}
                                showsVerticalScrollIndicator={false}
                            >
                                {list.length !== 0 &&
                                    list.map((item, index) => {
                                        return (
                                            <TouchableOpacity
                                                key={index}
                                                style={[
                                                    styles.cagListsView_left_view,
                                                    styles.cagListsView_left_view1,
                                                    {
                                                        borderLeftWidth: parentIndex == index ? 3 : 0,
                                                        borderLeftColor: "#EE6161"
                                                    }
                                                ]}
                                                onPress={() => this.levelOneOprate( item, index ) }
                                            >
                                                <View style={styles.cagListsView_left_item} >
                                                    <Text
                                                        style={[
                                                            styles.collectionText,
                                                            item.selected_status ? styles.cag1_item_text2 : null
                                                        ]}
                                                        numberOfLines={2}
                                                    >
                                                        {item.name}
                                                        {item.num == 0 ? null : <Text style={{ color:  "#EE6161" }} > ({ item.num })  </Text>}
                                                    </Text>
                                                </View>
                                                <View  style={ styles.cagListsView_left_item_line }  />
                                            </TouchableOpacity>
                                        );
                                    })}
                            </ScrollView>
                        </View>
                        <View style={[ styles.cagListsView, styles.cagListsView_right ]}
                        >
                            <ScrollView
                                alwaysBounceVertical={false}
                                showsVerticalScrollIndicator={false}
                            >
                                <View style={{ flexDirection: "row", alignItems: "center", flexWrap: "wrap", marginTop: 10 }}  >
                                    {list[parentIndex] &&
                                        list[parentIndex].levelTwo.map((item, index) => {
                                            return (
                                                <TouchableOpacity
                                                    key={index}
                                                    style={[ styles.cag_cld2_view ]}
                                                    onPress={() => this.levelTwoOprate( item, index ) }
                                                >
                                                    {item.select ? (
                                                        <Image source={require("../../images/index/select.png")} style={ styles.selectIcon } />
                                                    ) : null}

                                                    <Text style={ styles.cag_cld2_text }  >
                                                        {item.name}
                                                    </Text>
                                                </TouchableOpacity>
                                            );
                                        })}
                                </View>
                            </ScrollView>
                        </View>
                    </View>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%"
    },
    headerCenterView: {
        flex: 1
    },
    headerCenterItem1: {
        position: "relative",
        flex: 1,
        height: 30,
        borderRadius: 15,
        backgroundColor: "rgba(255,255,255,0.3)"
    },
    headerCenterItem1_search: {
        position: "absolute",
        top: 7,
        left: 10
    },
    headerCenterItem1_textView: {
        position: "absolute",
        top: 5,
        left: 35,
        justifyContent: "center",
        alignItems: "center",
        height: 20
    },
    headerCenterItem1_text: {
        fontSize: 14,
        color: "rgba(255,255,255,0.8)"
    },
    headerCenterItem2: {
        width: 114
    },
    headerCenterItem2_icon: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        flex: 1,
        height: "100%"
    },
    headerRightView: {
        width: 50
    },
    headerRight_line: {
        width: 1,
        height: 23,
        backgroundColor: "rgba(255,255,255,0.23)"
    },
    headerRight_icon: {
        flex: 1
    },
    categoriesView: {
        // ...CommonStyles.shadowStyle,
        flexDirection: "row",
        width: width,
        height: 36,
        borderBottomWidth: 2,
        borderBottomColor: "rgba(215,215,215,0.5)"
    },
    categoriesItem1: {
        flexDirection: "row",
        flexWrap: "wrap",
        justifyContent: "flex-start",
        alignItems: "center",
        flex: 1,
        height: "100%",
        overflow: "hidden",
        backgroundColor: "#fff"
    },
    selectIcon: {
        width: 14,
        height: 14,
        position: "absolute",
        bottom: 4,
        right: 4
    },
    cag1_item: {
        justifyContent: "center",
        alignItems: "center",
        height: "100%",
        paddingHorizontal: 10,
        marginLeft: 10
    },
    cag1_item_box: {
        justifyContent: "center",
        alignItems: "center",
        height: "100%"
    },
    cag1_item_text: {
        fontSize: 14,
        color: "#555"
    },
    cag1_item_text2: {
        color: "#4A90FA"
    },
    cag1_item_line: {
        width: "100%",
        height: 2,
        borderRadius: 8
    },
    cag1_item_line2: {
        backgroundColor: "#4A90FA"
    },
    categoriesItem2: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: 56,
        height: "100%",
        backgroundColor: "#fff"
    },
    modalOutView: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center"
    },
    modalInnerBottomView: {
        flex: 1,
        width: width,
        backgroundColor: "#fff"
    },
    collectionView: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center",
        width: width,
        height: 30,
        paddingHorizontal: 25,
        borderBottomWidth: 5,
        borderBottomColor: "#F1F1F1"
    },
    collectionText: {
        fontSize: 14,
        color: "#222"
    },
    categorieListsView: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center",
        flex: 1
    },
    cagListsView: {
        width: 114,
        height: "100%",
        backgroundColor: "#F1F1F1",
        paddingBottom: CommonStyles.footerPadding
    },
    cagListsView_right: {
        flex: 1,
        backgroundColor: "#fff"
    },
    cagListsView_left_view: {
        height: 50,
        backgroundColor: "#fff"
    },
    cagListsView_left_view1: {
        backgroundColor: "#F1F1F1"
    },
    cagListsView_left_item: {
        justifyContent: "center",
        height: "99%",
        paddingHorizontal: 25
    },
    cagListsView_left_item_line: {
        height: 1,
        marginHorizontal: 15,
        backgroundColor: "#E5E5E5"
    },
    cag_cld_view: {
        justifyContent: "center",
        flex: 1,
        height: 50,
        paddingHorizontal: 15,
        borderWidth: 1,
        borderColor: "#F1F1F1"
    },
    cag_cld_title: {
        fontSize: 14,
        color: "#777"
    },
    cag_cld_view2: {
        flexDirection: "row",
        flexWrap: "wrap",
        paddingTop: 15,
        paddingHorizontal: 15
    },
    cag_cld2_view: {
        justifyContent: "center",
        alignItems: "center",
        width: (width - 154) / 3,
        height: (width - 154) / 3,
        marginBottom: 10,
        borderColor: "#F1F1F1",
        borderWidth: 1,
        borderRadius: 6,
        marginLeft: 10,
        position: "relative",
        // ...CommonStyles.shadowStyle
    },
    cag_cld2_view1: {
        marginRight: 0
    },
    cag_cld2_img: {
        width: "100%",
        height: 80
    },
    cag_cld2_text: {
        // flex: 1,
        width: "100%",
        fontSize: 14,
        color: "#555",
        textAlign: "center",
        padding: 10
    },
    filterView: {
        // ...CommonStyles.shadowStyle,
        flexDirection: "row",
        justifyContent: "space-around",
        alignItems: "center",
        width: width,
        height: 44,
        backgroundColor: "#fff"
    },
    filterItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%",
        paddingHorizontal: 15
    },
    filterItem_text: {
        fontSize: 14,
        color: "#222"
    },
    filterItem_text_active: {
        color: "#4A90FA"
    },
    triangle: {
        flexDirection: "column",
        justifyContent: "center",
        marginLeft: 8
    },
    triangleTop: {
        width: 0,
        height: 0,
        borderWidth: 6,
        borderColor: "#fff",
        borderBottomColor: "#999"
    },
    triangleTop_active: {
        borderBottomColor: "#4A90FA"
    },
    triangleBottom: {
        width: 0,
        height: 0,
        borderWidth: 6,
        borderColor: "#fff",
        borderTopColor: "#999",
        marginTop: 2
    },
    triangleBottom_active: {
        borderTopColor: "#4A90FA"
    }
});
