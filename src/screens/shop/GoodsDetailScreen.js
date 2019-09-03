/**
 * 商品详情
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
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from "../../components/ImageView";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
import * as requestApi from "../../config/requestApi";
import math from '../../config/math.js';
const { width, height } = Dimensions.get("window");

class GoodsDetail extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = this.props.navigation.state.params || {};
        this.state = {
            discountParams:params.discountParams || {},
            editor: false,
            modelVisible: false,
            id: params.id,
            currentShop: params.currentShop || {},
            detail: {
                goods: {
                    category: {}
                },
                goodsSkuAttrsVO: {},
                goodsSkuVOList: []
            },
            refundsList: params.refundsList || [],
            callback: params.callback || (() => {}),
            industrys: [],
            serviceCatalogs: [],
            industrysName: [],
            serviceCatalogsName: [],
            goodsClassificationName: "",
            goodsTypeIdName: "",
            industryId1Name: "",
            industryId2Name: "",
            canEdit: params.canEdit ? true : false
        };
    }
    getDetail = () => {
        Loading.show();
        requestApi.shopOBMDetail({
                id: this.state.id,
                shopId: this.state.currentShop.id
            })
            .then(data => {
                console.log(data);
                let auditStatus1;
                switch (data.goods.auditStatus) {
                    case "UNAPPROVED":
                        auditStatus1 = "未通过";
                        break;
                    case "UNAUDITED":
                        // auditStatus1 = "未申请";
                        auditStatus1 = "未审核";
                        break;
                    case "VERIFIED":
                        auditStatus1 = "已通过";
                        break;
                    case "OTHER":
                        auditStatus1 = "其他";
                        break;
                }
                let goodsStatus1;
                switch (data.goods.goodsStatus) {
                    case "UP":
                        goodsStatus1 = "上架";
                        break;
                    case "DOWN":
                        goodsStatus1 = "下架";
                        break;
                }
                data.goods.refound1 = "否";
                for (let item of this.state.refundsList) {
                    item.key == data.goods.refunds
                        ? (data.goods.refound1 = item.title)
                        : null;
                }
                data.goods.goodsStatus1 = goodsStatus1;
                data.goods.auditStatus1 = auditStatus1;
                requestApi
                    .shopAndCatalogQList({
                        shopId: this.state.currentShop.id
                    })
                    .then(res => {
                        let newCate = [];
                        let category = data.goods.category;
                        let name = {
                            goodsClassificationName: "",
                            goodsTypeIdName: "",
                            industryId1Name: "",
                            industryId2Name: ""
                        };
                        for (let item of res.serviceCatalogs) {
                            let cate = [];
                            if (item.code == category.goodsTypeId) {
                                name.goodsTypeIdName = item.name || "";
                            }
                            for (item2 of item.goodsCatalogs) {
                                cate.push(item2.name);
                                if (
                                    item2.id == category.goodsClassificationId
                                ) {
                                    console.log(item2.name);
                                    name.goodsClassificationName =
                                        item2.name || "";
                                }
                            }
                            newCate.push({ [item.name]: cate });
                        }
                        let newInd = [];
                        for (let item of res.industrys) {
                            let ind = [];
                            if (
                                data.goods.id &&
                                item.code == category.industryId1
                            ) {
                                name.industryId1Name = item.name || "";
                            }
                            for (item2 of item.children) {
                                ind.push(item2.name || "");
                                if (
                                    data.goods.id &&
                                    item2.code == category.industryId2
                                ) {
                                    name.industryId2Name = item2.name || "";
                                }
                            }
                            newInd.push({ [item.name]: ind });
                        }

                        let skuAttrValue = data.goodsSkuVOList || [];
                        for (let item of skuAttrValue) {
                            item.originalPrice =math.divide(item.originalPrice || 0,100);
                            item.discountPrice =math.divide(item.discountPrice || 0,100);
                        }

                        this.setState({
                            detail: data,
                            industrysName: newInd,
                            serviceCatalogsName: newCate,
                            industrys: res.industrys,
                            serviceCatalogs: res.serviceCatalogs,
                            ...name
                        });
                    }).catch((err)=>{
                        console.log(err)
                    });
            }).catch(()=>{
          
            });
    };

    componentDidMount() {
        this.getDetail();
    }

    componentWillUnmount() {}

    render() {
        const { navigation} = this.props;
        const {
            detail,
            currentShop,
            refundsList,
            industrys,
            serviceCatalogs,
            industrysName,
            serviceCatalogsName,
            goodsClassificationName,
            goodsTypeIdName,
            industryId1Name,
            industryId2Name,
            canEdit,
            discountParams
        } = this.state;

        let commonItems = [
            { title: "商品编号", value: detail.goods.id },
            { title: "名称", value: detail.goods.goodsName },
            {
                title: "商品分类",
                value: `${
                    goodsTypeIdName ? goodsTypeIdName + "/" : ""
                }${goodsClassificationName}`
            },
            {
                title: "店铺分类",
                value: `${
                    industryId1Name ? industryId1Name + "/" : industryId1Name
                }${industryId2Name}`
            },
            { title: "审核状态", value: detail.goods.auditStatus1 },
            { title: "在架状态", value: detail.goods.goodsStatus1 }

            // { title: '是否需要预约', value: '需在线预约' },
        ];
        let serviceItems = [
            ...commonItems,
            {
                title: "是否可加购商品",
                value: detail.goods.purchased == 1 ? "是" : "否"
            },
            { title: "退款设置", value: detail.goods.refound1 },
            {
                title: "是否能免费下单",
                value: detail.goods.free == 1 ? "是" : "否"
            },
            {
                title: "是否作为订金使用",
                value: detail.goods.deposit == 1 ? "是" : "否"
            },
            {
                title: "是否最后结算时付款",
                value: detail.goods.zeroOrder == 1 ? "是" : "否"
            }
        ];
        let goodsItems = [
            ...commonItems,
            // {
            //     title: "是否可加购商品",
            //     value: detail.goods.purchased == 1 ? "是" : "否"
            // },
            // { title: "退款设置", value: detail.goods.refound1 },
            { title: "是否最后结算时付款", value: detail.goods.free == 1 ? "是" : "否" }
        ];
        let zhusuItems = [
            ...commonItems,
            { title: "退款设置", value: detail.goods.refound1 }
        ];
        let items = commonItems;
        switch (goodsTypeIdName) {
            case "服务类":
                items = serviceItems;
                break;
            case "商品类":
                items = goodsItems;
                break;
            case "住宿类":
                items = zhusuItems;
                break;
        }

        return (
            <View style={styles.container}>
                <Header
                    title="商品详情"
                    navigation={navigation}
                    goBack={true}
                    rightView={
                        canEdit ? (
                            <TouchableOpacity
                                onPress={() =>
                                    navigation.navigate("GoodsEditor", {
                                        currentGoods: detail,
                                        refundsList,
                                        currentShop,
                                        industrys,
                                        serviceCatalogs,
                                        industrysName,
                                        serviceCatalogsName,
                                        goodsClassificationName,
                                        goodsTypeIdName,
                                        industryId1Name,
                                        industryId2Name,
                                        discountParams,
                                        callback: (tabPage) => {
                                            this.state.callback(tabPage);
                                            this.getDetail();
                                        }
                                    })
                                }
                                style={{ width: 50 }}
                            >
                                <Text style={{ fontSize: 17, color: "#fff" }}>
                                    编辑
                                </Text>
                            </TouchableOpacity>
                        ) : null
                    }
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }} contentContainerStyle={{paddingBottom:CommonStyles.footerPadding}}>
                    <View style={styles.content}>
                        <Content>
                            {items.map((item, index) => {
                                return (
                                    <Line
                                        title={item.title}
                                        value={item.value}
                                        point={null}
                                        rightValueStyle={{
                                            flex: 1,
                                            textAlign: "right"
                                        }}
                                        key={index}
                                        type={item.type ? item.type : ""}
                                        onPress={() => {
                                            item.onPress
                                                ? item.onPress()
                                                : null;
                                        }}
                                    />
                                );
                            })}
                        </Content>
                        <Content>
                            <Line title="规格" point={null} />
                            {detail.goodsSkuAttrsVO.attrList &&
                                detail.goodsSkuAttrsVO.attrList.map(
                                    (item, index) => {
                                        return (
                                            <View
                                                key={index}
                                                style={[
                                                    styles.scaleView,
                                                    {
                                                        borderBottomWidth:
                                                            index ==
                                                            detail
                                                                .goodsSkuAttrsVO
                                                                .attrList
                                                                .length -
                                                                1
                                                                ? 0
                                                                : 1
                                                    }
                                                ]}
                                            >
                                                <Text style={styles.title}>
                                                    规格类型{index + 1}:
                                                    <Text
                                                        style={{
                                                            color: "#777777"
                                                        }}
                                                    >
                                                        {" "}
                                                        {item.name}
                                                    </Text>
                                                </Text>
                                                <View
                                                    style={{
                                                        marginTop: 15,
                                                        flexDirection: "row"
                                                    }}
                                                >
                                                    <Text style={styles.title}>
                                                        规格：
                                                    </Text>
                                                    <View
                                                        style={{
                                                            flexDirection: "row"
                                                        }}
                                                    >
                                                        {item.attrValues &&
                                                            item.attrValues.map(
                                                                (
                                                                    item,
                                                                    index
                                                                ) => {
                                                                    return (
                                                                        <View
                                                                            style={
                                                                                styles.scaleTextView
                                                                            }
                                                                            key={
                                                                                index
                                                                            }
                                                                        >
                                                                            <Text
                                                                                style={
                                                                                    styles.scaleText
                                                                                }
                                                                            >
                                                                                {
                                                                                    item.name
                                                                                }
                                                                            </Text>
                                                                        </View>
                                                                    );
                                                                }
                                                            )}
                                                    </View>
                                                </View>
                                            </View>
                                        );
                                    }
                                )}
                        </Content>
                        <Content>
                            <Line title="价格" point={null} />
                            {detail.goodsSkuVOList &&
                                detail.goodsSkuVOList.map((item, index) => {
                                    return (
                                        <View
                                            style={[ styles.contentCon,
                                                {
                                                    flexWrap:'wrap',
                                                    paddingBottom: index == detail.goodsSkuVOList .length - 1 ? 18 : 0
                                                }
                                            ]}
                                            key={index}
                                        >
                                            <Text
                                                style={[
                                                    styles.title,
                                                    { color: "#777777",width:'30%' }
                                                ]}
                                            >
                                                {item.skuName.replace("|", "+")}
                                            </Text>
                                            <View style={{ flexDirection: "row" ,flexWrap:'wrap',justifyContent:'flex-end',flex:1}} >
                                                <Text style={[ styles.title, { color: "#777777",  marginRight:15 } ]} >
                                                    ￥{item.originalPrice}
                                                    {goodsTypeIdName == "外卖类" || goodsTypeIdName == "在线购物" ? `${"/" + item.weight}g` : ''}
                                                </Text>
                                                <Text
                                                    style={[
                                                        styles.title,
                                                        {
                                                            color: "#777777",
                                                            marginRight:0,
                                                            textAlign: "right"
                                                        }
                                                    ]}
                                                >
                                                    {discountParams.shopDiscountType=='THE_CUSTOM_DISCOUNT'?'会员价':'折扣价'}:
                                                    <Text style={{ color: "#FF545B", width: 100 }} > ￥{item.discountPrice} </Text>
                                                </Text>
                                            </View>
                                        </View>
                                    );
                                })}
                        </Content>
                        <Content>
                            <Line
                                title="查看评价"
                                type="horizontal"
                                point={null}
                                onPress={() =>
                                    navigation.navigate("Comment", {
                                        shopId: currentShop.id,
                                        goodsId: detail.goods.id
                                    })
                                }
                            />
                        </Content>
                        <Content>
                            <Line title="商品介绍" point={null} />
                            <Text style={styles.introduction}>
                                {detail.goods.details || "无"}
                            </Text>
                        </Content>
                        <Content>
                            <Line title="展示图片" point={null} />
                            <View style={{ padding: 15, paddingBottom: 0 }}>
                                {detail.goods.showPics &&
                                    detail.goods.showPics.map((item, index) => {
                                        return (
                                            <ImageView
                                                source={{ uri: item }}
                                                key={index}
                                                sourceWidth={width - 50}
                                                sourceHeight={180}
                                                resizeMode={"cover"}
                                                style={{ marginBottom: 15 }}
                                            />
                                        );
                                    })}
                            </View>
                        </Content>
                    </View>
                </ScrollView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    content: {
        alignItems: "center",
        paddingBottom: 10
    },
    scaleView: {
        borderColor: "#F1F1F1",
        paddingVertical: 15,
        width: width - 35,
        marginLeft: 15
    },
    scaleRightView: {
        width: width - 20,
        borderTopWidth: 1,
        borderColor: "#F1F1F1",
        marginTop: 13
    },
    title: {
        fontSize: 14,
        color: "#222222"
    },
    scaleTextView: {
        borderWidth: 1,
        borderColor: "#4A90FA",
        borderRadius: 16,
        marginRight: 10
    },
    scaleText: {
        fontSize: 12,
        color: "#4A90FA",
        paddingHorizontal: 10,
        lineHeight: 16,
        height: 16
    },
    contentCon: {
        marginTop: 15,
        flexDirection: "row",
        justifyContent: "space-between",
        paddingHorizontal: 15
    },
    introduction: {
        padding: 15,
        color: "#777777",
        fontSize: 14,
        width: width - 20
    }
});

export default connect(
    state => ({ store: state }),
)(GoodsDetail);
