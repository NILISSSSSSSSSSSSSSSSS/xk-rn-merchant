/**
 * 首页/促销管理/新增会员卡
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
    Keyboard
} from "react-native";
import { connect } from "rn-dva";
import moment from "moment";
import math from '../../config/math.js';
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from "../../components/ImageView";
import TextInputView from "../../components/TextInputView";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
import CommonButton from "../../components/CommonButton";
import PickerOld from "react-native-picker-xk";
import Picker from "../../components/Picker";
import * as regular from "../../config/regular";
import ActionSheet from "../../components/Actionsheet";

import * as requestApi from "../../config/requestApi";
import { VirtualTimeScheduler } from "rxjs";
const DATETIME_FORMAT = 'YYYY-MM-DD HH:mm';
const { width, height } = Dimensions.get("window");
const ticketsTypes = [
    //优惠券类型 折扣券DISCOUNT,抵扣券 DEDUCTION, 满减券 FULL_SUB
    { key: "DISCOUNT", type: "折扣券" },
    { key: "DEDUCTION", type: "抵扣券" },
    { key: "FULL_SUB", type: "满减券" }
];
const ticketsScopes = [
    //优惠范围 GOODS, 全场ALL,商品品类CATEGORY
    { key: "GOODS", type: "单品" },
    { key: "CATEGORY", type: "品类" },
    { key: "ALL", type: "全场" }
];

class SaleAddCardScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const { page, currentShop } = props.navigation.state.params;
        let requestParams = {};
        const { userShop, user } = props;
        if (page == "card") {
            requestParams = {
                name: "",
                cardType: "GENERAL", //会员类型，枚举：VIP VIP会员卡，GENERAL 普通会员卡
                discount: 0,
                totalNum: 0,
                price: 0,
                validTime: "",
                invalidTime: "",
                // cardStatus: "NORMAL",//会员卡状态，枚举：NORMAL 正常，STOP 停用，默认正常
                // receiveNum: 10000,	//会员卡剩余张数，初始值为总张数
                shopId: currentShop.id,
                shopName: currentShop.name,
                source: "shop", //shop商户，mall自营平台,
                merchantId: currentShop.id,
                userId: user.id || "",
                isAnchors:0
            };
        } else {
            requestParams = {
                // limitNum: 12,
                limitNum: "",
                invalidTime: "",
                merchantId: currentShop.id,
                userId: user ? user.id : "",
                // codes: [], //优惠券分类在CATEGORY必须存在 最小分类id
                // goodsIds: [],
                shopId: currentShop.id,
                shopPic: [],
                discounts: 1,
                discounts: "",
                // totalNum: 12,
                totalNum: "",
                // couponType: "DISCOUNT",
                // couponScope: "GOODS",
                couponType: "请选择",
                couponScope: "请选择",
                name: "",
                couponStatus: "NORMAl",
                validTime: "",
                shopName: currentShop.name,
                subMoney: "",
                isAnchors:0
            };
        }
        this.state = {
            page: page,
            validTime: "",
            invalidTime: "",
            requestParams: requestParams,
            options: [], //actionSheet数据
            oprateActions: "couponType", //actionSheet操作的项
            selectedItems: [], //品类或单品选择的项
            currentShop: currentShop || {},
            numberWidth:60
        };
    }

    componentDidMount() { }

    componentWillUnmount() {
        PickerOld.hide();
    }
    changeRequestParams = param => {
        this.setState({
            requestParams: {
                ...this.state.requestParams,
                ...param
            }
        });
    };
    geTimeString = strtime => {
        //获取时间戳
        strtime = strtime.replace(/-/g, "/"); // 将-替换成/，因为下面这个构造函数只支持/分隔的日期字符串
        var date = new Date(strtime); // 构造一个日期型数据，值为传入的字符串
        console.log(Date.parse(date) / 1000)
        return Date.parse(date) / 1000;
    };
    selectDate = witch => {
        // console.log(witch)
        const {requestParams}=this.state
        const invalidTime = moment(this.state.invalidTime, DATETIME_FORMAT)
        const validTime = moment(this.state.validTime, DATETIME_FORMAT);
        Picker._showTimePicker("dateTime", data => {
            let newData = moment(data, DATETIME_FORMAT);
            if (
                (witch == "validTime" &&
                    this.state.invalidTime &&
                    newData > invalidTime) ||
                (witch == "invalidTime" &&
                    this.state.validTime &&
                    newData < validTime)
            ) {
                Toast.show("生效时间不能大于结束时间");
            } else {
                this.setState({
                    [witch]: data,
                    requestParams: {
                        ...requestParams,
                        validTime:
                            witch == "validTime"
                                ? this.geTimeString(data+':00')
                                : requestParams.validTime,
                        invalidTime:
                            witch == "invalidTime"
                                ? this.geTimeString(data+':59')
                                : requestParams.invalidTime
                    }
                });
            }
        },
        this.state.validTime && witch == "validTime"
        ? validTime._d
        :this.state.invalidTime && witch == "invalidTime"
          ? invalidTime._d
          :null
        )
    };
    confirm = () => {
        Keyboard.dismiss();
        const { page, selectedItems } = this.state;
        const { navigation } = this.props;
        let requestParams=JSON.parse(JSON.stringify(this.state.requestParams))
        let discount = requestParams.discount || requestParams.discounts;
        if (!/^[a-zA-Z\u4e00-\u9fa5]+$/.test(requestParams.name)) {
            // 验证中文字母大小写
            Toast.show("标题只能是中文和字母大小写！");
            return;
        }
        if (requestParams.couponType === "请选择") {
            Toast.show("请选择券类型！");
            return;
        }
        if (requestParams.couponScope === "请选择") {
            Toast.show("请选择范围！");
            return;
        }
        if (requestParams.couponType == "FULL_SUB") {
            if (
                !regular.price(discount) ||
                !regular.price(requestParams.subMoney) ||
                parseFloat(discount) == 0 ||
                parseFloat(requestParams.subMoney) == 0
            ) {
                Toast.show("满减价格不能为0且大于0");
                return;
            } else if (
                parseFloat(discount) < parseFloat(requestParams.subMoney) ||
                parseFloat(discount) == parseFloat(requestParams.subMoney)
            ) {
                Toast.show("满价不能小于或等于减价");
                return;
            }
        }
        if (
            requestParams.couponType == "DEDUCTION" &&
            (!regular.intLarge(discount) || parseFloat(discount) == 0)
        ) {
            Toast.show("抵扣价格为正整数");
            return;
        }
        if (!requestParams.validTime) {
            Toast.show("请选择生效时间");
        } else if (!requestParams.invalidTime) {
            Toast.show("请选择结束时间");
        } else if (
            (!/^[0-9]+([.]{1}[0-9]{1})?$/.test(discount) ||
                discount == 0) && requestParams.couponType != "DEDUCTION"
        ) {
            Toast.show("折扣不为0,且只能保留一位小数，");
        } else if (
            !regular.intLarge(requestParams.totalNum) ||
            parseFloat(requestParams.totalNum) == 0
        ) {
            Toast.show("数量为正整数");
        }
        else if (page == 'ticket' && (!regular.intLarge(requestParams.limitNum) || parseFloat(requestParams.limitNum) == 0)) {
            Toast.show('每人可领只能为正整数')
        }
        else if (!requestParams.name || requestParams.name.lenth > 10) {
            Toast.show(
                page == "card"
                    ? "会员卡名称不能为空且不超过10个字"
                    : "优惠卡券名称不能为空且不超过10个字"
            );
        } else if (
            requestParams.limitNum != undefined &&
            (!regular.intLarge(requestParams.limitNum) ||
                parseFloat(requestParams.limitNum) == 0)
        ) {
            Toast.show("每人可领为正整数");
        } else {
            let params = {};
            let func;
            if (page == "card") {
                func = requestApi.addShopCard;
                params = {
                    memberCard: {
                        ...requestParams,
                        discount:requestParams.discount?math.multiply(requestParams.discount,100):'',
                    },
                    merchantId: requestParams.merchantId,
                    userId: requestParams.userId
                };
            } else {
                let selectedItemsId = [];
                for (item of selectedItems) {
                    selectedItemsId.push(
                        requestParams.couponScope == "CATEGORY"
                            ? item.code2
                            : item.goodsCode
                    );
                }
                func = requestApi.shopCardCreate;
                params = {
                    coupon: {
                        ...requestParams,
                        discount:requestParams.discount?math.multiply(requestParams.discount,100):'',
                        subMoney:requestParams.subMoney?math.multiply(requestParams.subMoney,100):'',
                        discounts:requestParams.discounts?math.multiply(requestParams.discounts,100):'',
                    }
                };
                switch (requestParams.couponScope) {
                    case "CATEGORY":
                        params.coupon.codes = selectedItemsId;
                        break;
                    case "GOODS":
                        params.coupon.goodsIds = selectedItemsId;
                        params.goodsIds = selectedItemsId;
                        break;
                    default:
                        break;
                }
            }
            console.log(params)
            Loading.show()
            func(params).then(res => {
                Toast.show("新增成功");
                navigation.goBack();
                navigation.state.params.callback();
            }).catch(()=>{
          
            });
        }
    };
    showActions = (types, witch) => {
        let options = [];
        for (item of types) {
            options.push(item.type);
        }
        options.push("取消");
        this.setState({
            options: options,
            oprateActions: witch
        }, () => {
            this.ActionSheet.show();
        });

    };
    renderCate = (item, index) => {
        return (
            <View style={[styles.item, { borderBottomWidth: 1 }]} key={index}>
                <Text style={{ color: "#222", fontSize: 14 }}>
                    一级分类：{item.name1}
                </Text>
                <Text style={{ color: "#777", fontSize: 14 }}>
                    二级分类：{item.name2}
                </Text>
                <TouchableOpacity
                    style={styles.categryDelete}
                    onPress={() => this.deleteGoods(index)}
                >
                    <Text style={{ color: "#fff", fontSize: 12 }}>删除</Text>
                </TouchableOpacity>
            </View>
        );
    };
    deleteGoods = index => {
        let newSelectedItems = [...this.state.selectedItems];
        newSelectedItems.splice(index, 1);
        this.setState({ selectedItems: newSelectedItems });
    };
    renderGoods = (item, index) => {
        return (
            <View style={[styles.item, { borderBottomWidth: 1 }]} key={index}>
                <View>
                    <Text style={[styles.title, { marginBottom: 8 }]}>
                        商品编号{item.goodsCode}
                    </Text>
                    <View style={styles.fanweiItem}>
                        <ImageView
                            source={{ uri: item.pic }}
                            sourceWidth={60}
                            sourceHeight={60}
                            style={{ marginRight: 10, borderRadius: 8 }}
                        />
                        <View style={{ flex: 1 }}>
                            <Text style={[styles.title, { fontSize: 12 }]}>
                                {item.goodsName}
                            </Text>
                            <Text
                                style={[
                                    styles.title,
                                    { fontSize: 10, marginTop: 13 }
                                ]}
                            >
                                一级分类：{item.name1}
                            </Text>
                            <Text
                                style={[
                                    styles.title,
                                    { fontSize: 10, marginTop: 3 }
                                ]}
                            >
                                二级分类：{item.name2}
                            </Text>
                        </View>
                    </View>
                </View>

                <TouchableOpacity onPress={() => this.deleteGoods(index)}>
                    <Text style={{ color: "#777", fontSize: 14 }}>删除</Text>
                </TouchableOpacity>
            </View>
        );
    };
    onChangeText=(data,item, witch)=>{
        if (item.key === "subMoney") {
            this.changeRequestParams({ [witch]: data });
        } else if (item.key === "limitNum" || item.key === "totalNum") {
            // 如果是填写每人可领  如果是填写数量
            (regular.intLarge(data) && data != 0) || !data ? this.changeRequestParams({ [item.key]: data }) : Toast.show('只能填写大于0的整数')
        } else if (
            item.key === "discounts" ||
            item.key === "discount"
        ) {
            if (item.title == '折扣') {
                if (/^(?:([1-9](?:\.[\d]{0,1})?)|(?:0\.[1-9]{1,2})|10)$/.test(data)) {
                    // 验证折扣
                    this.changeRequestParams({
                        [item.key]: data == 10 ? 9.9 : data
                    }); // 不能10
                    return;
                } else if (data === "") {
                    this.changeRequestParams({ [item.key]: "" });
                    return;
                }
                Toast.show("折扣值超出范围！", 1.5, () => {
                    this.changeRequestParams({
                        [item.key]: this.state.requestParams[
                            item.key
                        ]
                    });
                });
            }
            else if (item.title == '抵扣') {
                if (parseFloat(data) > 0 || data === "") {
                    // 验证抵扣
                    this.changeRequestParams({
                        [item.key]: data
                    }); // 不能10
                    return;
                }
                Toast.show("抵扣价为正整数！", 1.5, () => {
                    this.changeRequestParams({
                        [item.key]: this.state.requestParams[
                            item.key
                        ]
                    });
                });
            }

        } else {
            this.changeRequestParams({ [item.key]: data });
        }
    }
    renderRight = (item, witch) => {
        const { page, requestParams } = this.state
        const value=witch ? this.state.requestParams[witch].toString() : item.value
        const valueWidth=this.state[(witch || item.key)+'Width']
        return (
            <View style={[styles.lineRight,{position:'relative'}]}>
                <TextInputView
                    placeholder=""
                    inputView={{alignItems:'flex-end'}}
                    placeholderTextColor={"#ccc"}
                    maxLength={item.maxLength || 10}
                    style={{backgroundColor:'#f1f1f1',width:!valueWidth || (valueWidth<40)?60:valueWidth+20,textAlign:'center',borderRadius:10}}
                    value={value}
                    onChangeText={data => {
                       this.onChangeText(data,item, witch)
                    }}
                />
                <Text style={{position:'absolute',bottom:-500,opacity:0,backgroundColor:'red'}} onLayout={({ nativeEvent }) =>{
                    this.setState({[(witch || item.key)+'Width']:nativeEvent.layout.width})
                }}>{value}</Text>
                {item.scale ? (
                    <Text style={{ color: "#222", fontSize: 14,marginLeft:10 }}>
                        {item.scale}
                    </Text>
                ) : null}
            </View>
        );
    };

    render() {
        const { navigation} = this.props;
        const {
            page,
            validTime,
            invalidTime,
            requestParams,
            options,
            oprateActions,
            selectedItems,
            currentShop
        } = this.state;
        const fanwei =
            this.state.page == "card"
                ? ""
                : requestParams.couponScope === "请选择"
                    ? "请选择"
                    : ticketsScopes.filter(
                        item => item.key == requestParams.couponScope
                    )[0].type;
        const ticketsType =
            this.state.page == "card"
                ? ""
                : requestParams.couponType === "请选择"
                    ? "请选择"
                    : ticketsTypes.filter(
                        item => item.key == requestParams.couponType
                    )[0].type;

        const cardItems = [
            {
                title: "生效时间",
                value: validTime,
                key: "validTime",
                type: "horizontal",
                onPress: () => this.selectDate("validTime")
            },
            {
                title: "结束时间",
                value: invalidTime,
                key: "invalidTime",
                type: "horizontal",
                onPress: () => this.selectDate("invalidTime")
            },
            {
                title: "折扣",
                value: requestParams.discount
                    ? requestParams.discount.toString()
                    : "",
                key: "discount",
                scale: "折",
                type: "custom"
            },
            {
                title: "数量",
                value: requestParams.totalNum
                    ? requestParams.totalNum.toString()
                    : "",
                key: "totalNum",
                type: "input",
                type: "custom"
            },
            {
                title: "会员卡名称",
                value: requestParams.name,
                key: "name",
                type: "input",
                width: 120,
                maxLength: 10,
                type: "custom"
            }
        ];

        const discontType = {
            title: ticketsType == "抵扣券" ? "抵扣" : "折扣",
            value: requestParams.discounts
                ? requestParams.discounts.toString()
                : "",
            key: "discounts",
            scale: ticketsType == "抵扣券" ? "元" : "折",
            type: "custom"
        }; //打折券时
        const subType = {
            title: "",
            value: requestParams.subMoney,
            key: "subMoney",
            type: "custom",
            scale: "元"
        }; //满减券时
        const ticketsItems = [
            {
                title: "券类型",
                value: ticketsType,
                key: "couponType",
                type: "horizontal",
                onPress: () => this.showActions(ticketsTypes, "couponType")
            },
            {
                title: "范围",
                value: fanwei,
                key: "couponScope",
                type: "horizontal",
                onPress: () => this.showActions(ticketsScopes, "couponScope")
            },
            {
                title: "生效时间",
                value: validTime,
                key: "validTime",
                type: "horizontal",
                onPress: () => this.selectDate("validTime")
            },
            {
                title: "结束时间",
                value: invalidTime,
                key: "invalidTime",
                type: "horizontal",
                onPress: () => this.selectDate("invalidTime")
            },
            {
                title: "每人可领",
                value: requestParams.limitNum
                    ? requestParams.limitNum.toString()
                    : "",
                key: "limitNum",
                scale: "张",
                type: "custom"
            },
            {
                title: "数量",
                value: requestParams.totalNum.toString(),
                key: "totalNum",
                type: "input",
                type: "custom"
            },
            {
                title: "优惠券卡名称",
                value: requestParams.name,
                key: "name",
                type: "input",
                maxLength: 10,
                width: 150,
                type: "custom"
            }
        ];
        ticketsType == "满减券"
            ? ticketsItems.splice(5, 0, subType)
            : ticketsItems.splice(5, 0, discontType);
        const items = page == "card" ? cardItems : ticketsItems;
        items.push({
            title: "分配给晓可主播",
            value: this.state.isAnchors,
            type: "switch",
            onChangeText:(data)=>{
                console.log('/////',data)
                this.setState({isAnchors:data})}
        })
        this.state.isAnchors?
        items.push({
            title: "卡券分配设置",
            type: "horizontal",
            onPress:()=>{
                regular.intLarge(requestParams.totalNum) && requestParams.totalNum>0?
                navigation.navigate('SaleDistribution',{
                    anchors:requestParams.anchors || [],
                    totalNum:requestParams.totalNum,
                    callback:(data)=>{
                        this.changeRequestParams({
                            anchors: data
                        });
                    }
                }):Toast.show('请先设置正确格式的数量')
            }

        }):null

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={page == "card" ? "新增会员卡" : "新增优惠券卡"}
                />
                <ScrollView alwaysBounceVertical={false}>
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => { }}
                        style={styles.content}
                    >
                        <Content>
                            {items.map((item, index) => {
                                let bordersty = null
                                if(index === items.length-1){
                                    bordersty = {
                                        borderBottomWidth:0
                                    }
                                }
                                return (
                                    <Line
                                        title={item.title}
                                        type={item.type}
                                        point={null}
                                        key={index}
                                        value={item.value}
                                        onChangeText={(data)=>item.onChangeText(data)}
                                        onPress={ item.onPress ? () => item.onPress() : null }
                                        style={[{
                                            justifyContent: "space-between",
                                        },bordersty]}
                                        rightView={
                                            item.type == "custom" ? (
                                                item.key == "subMoney" ? (
                                                    <View style={{ flexDirection: "row", alignItems: "center" }} >
                                                        <Text style={{ fontSize: 14, color: "#222",marginRight:10 }} >满</Text>
                                                        {this.renderRight( item, "discounts"  )}
                                                        <Text style={{ fontSize: 14, color: "#222",marginRight:10 }} >减</Text>
                                                        {this.renderRight( item, "subMoney" )}
                                                    </View>
                                                ) : (
                                                        this.renderRight(item)
                                                    )
                                            ) : null
                                        }
                                    />
                                );
                            })}
                        </Content>

                        {page == "card" || fanwei == "全场" || fanwei == '请选择' ? null : (
                            <Content>
                                <Line
                                    title={"适用" + fanwei}
                                    value={"添加"}
                                    point={null}
                                    rightValueStyle={{ textAlign: "right" }}
                                    onPress={() =>
                                        navigation.navigate("SaleSelectGoods", {
                                            fanwei,
                                            selectedItems: this.state
                                                .selectedItems,
                                            callback: data => {
                                                this.setState({
                                                    selectedItems: data
                                                });
                                            },
                                            currentShop
                                        })
                                    }
                                />
                                {selectedItems.map((item, index) => {
                                    return fanwei == "单品"
                                        ? this.renderGoods(item, index)
                                        : this.renderCate(item, index);
                                })}
                            </Content>
                        )}

                        <CommonButton
                            title="确定"
                            onPress={() => this.confirm()}
                        />
                    </TouchableOpacity>
                </ScrollView>
                <ActionSheet
                    ref={o => (this.ActionSheet = o)}
                    // title={'Which one do you like ?'}
                    options={options}
                    cancelButtonIndex={options.length - 1}
                    // destructiveButtonIndex={2}
                    onPress={index => {
                        if (index != options.length - 1) {
                            let data =
                                oprateActions == "couponType"
                                    ? ticketsTypes
                                    : ticketsScopes;
                            if (requestParams.couponScope != data[index].key) {
                                this.setState({ selectedItems: [] });
                            }
                            this.changeRequestParams({
                                [oprateActions]: data[index].key
                            });
                        }
                    }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    content: {
        alignItems: "center",
    },
    lineRight: {
        flexDirection: "row",
        alignItems: "center",
        height: 24,
        justifyContent: "flex-end",
    },
    inputStyle: {
        textAlign: "center",
        color: "#222222"
    },
    content: {
        alignItems: "center",
        paddingBottom: 10
    },
    item: {
        padding: 15,
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between",
        borderBottomWidth: 1,
        borderColor: "#F1F1F1"
    },
    title: {
        color: "#222222",
        fontSize: 14
    },
    fanweiItem: {
        flexDirection: "row",
        alignItems: "center",
        width: width - 100
    },
    categryDelete: {
        backgroundColor: "#EE6161",
        width: 50,
        height: 20,
        alignItems: "center",
        justifyContent: "center",
        borderRadius: 6
    }
});

export default connect(
    state => ({
        user:state.user.user || {},
        userShop:state.user.userShop || {},
     }),
)(SaleAddCardScreen);
