/**
 * 编辑或新增规格
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
import TextInputView from "../../components/TextInputView";
import * as nativeApi from "../../config/nativeApi";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";

const { width, height } = Dimensions.get("window");
let scale=['A','B','C','D','E','F']
export default class GoodsScaleScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = this.props.navigation.state.params;
        let newArr = [
            {
                title: "规格类型",
                name: params.value ? params.value.name : "",
                placeholder: "请输入规格类型，如颜色"
            }
        ];
        if (params.value) {
            let attrValues = params.value.attrValues;
            for (let i = 0; i < attrValues.length; i++) {
                newArr.push({
                    title: "规格" + (i + 1),
                    name: attrValues[i].name
                });
            }
        } else {
            newArr.push({
                title: "规格1",
                name: "",
                placeholder: "请输入规格，如黄色"
            });
        }

        this.state = {
            items: newArr,
            keyScale: params.type == "新增" ? scale[params.skuAttr.length] : scale[params.index]
        };
    }

    componentDidMount() {}

    componentWillUnmount() {}
    add = () => {
        let newArr = [];
        for (let i = 0; i < this.state.items.length; i++) {
            newArr.push(this.state.items[i]);
        }
        newArr.push({
            title: "规格" + newArr.length,
            name: ""
        });
        this.setState({ items: newArr });
    };
    changeData = (data, index) => {
        let newArr = [];
        for (let i = 0; i < this.state.items.length; i++) {
            newArr.push(this.state.items[i]);
        }
        newArr[index] = {
            name: data,
            title: newArr[index].title,
            code: this.state.keyScale + "" + index+1
        };
        this.setState({ items: newArr });
    };
    save = () => {
        let attrValues = [];
        for (let i = 0; i < this.state.items.length; i++) {
            if (
                !this.state.items[i].name ||
                this.state.items[i].name.length > 5
            ) {
                Toast.show("规格类型或具体规格最少1个字，最多5个字");
                return;
            }
            i != 0 && this.state.items[i].name
                ? attrValues.push({
                      name: this.state.items[i].name,
                      code: this.state.keyScale + "" + i,
                      showPics:this.state.items[i].showPics || ''
                  })
                : null;
        }
        const { skuAttr, callback, index } = this.props.navigation.state.params;
        let newSpecifications = [];
        for (let i = 0; i < skuAttr.length; i++) {
            newSpecifications.push(skuAttr[i]);
        }
        if (this.state.items.length > 1) {
            const params = {
                name: this.state.items[0].name,
                key: this.state.keyScale,
                attrValues: attrValues
            };
            this.props.navigation.state.params.type == "新增"
                ? newSpecifications.push(params)
                : (newSpecifications[index] = params);
        }
        console.log(newSpecifications)

        callback(newSpecifications);
        this.props.navigation.goBack();
    };
    delete = index => {
        let newArr = [];
        for (let i = 0; i < this.state.items.length; i++) {
            i == index ? null : newArr.push(this.state.items[i]);
        }
        this.setState({ items: newArr });
    };

    render() {
        const { navigation } = this.props;
        return (
            <View style={styles.container}>
                <Header
                    title={navigation.state.params.type + "规格"}
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
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        <Content>
                            {this.state.items.map((item, index) => {
                                return (
                                    <View
                                        style={{ position: "relative" }}
                                        key={index}
                                    >
                                        <Line
                                            title={item.title}
                                            point={null}
                                            type="input"
                                            value={item.name}
                                            leftStyle={{ width: 80 }}
                                            styleInput={{ width: 150 ,color: "#555555"}}
                                            placeholder={item.placeholder}
                                            onChangeText={data =>
                                                this.changeData(data, index)
                                            }
                                        />
                                        {index < 2 ? null : (
                                            <TouchableOpacity
                                                onPress={() =>
                                                    this.delete(index)
                                                }
                                                style={styles.deleteView}
                                            >
                                                <Text style={styles.delete}>
                                                    删除
                                                </Text>
                                            </TouchableOpacity>
                                        )}
                                    </View>
                                );
                            })}
                        </Content>
                        {this.state.items.length < 4 ? (
                            <TouchableOpacity
                                style={styles.add}
                                onPress={() => this.add()}
                            >
                                <Image source={require('../../images/shop/scaleadd.png')}/>
                            </TouchableOpacity>
                        ) : null}
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
        // paddingBottom: 10,
    },
    inputView: {
        flex: 1,
        marginLeft: 10
    },
    input: {
        flex: 1,
        padding: 0,
        fontSize: 14,
        lineHeight: 20,
        height: 20
    },
    add: {
        backgroundColor: "#fff",
        borderRadius: 30,
        width: 30,
        height: 30,
        alignItems: "center",
        justifyContent: "center",
        marginTop: 20
    },
    deleteView: {
        position: "absolute",
        right: 15,
        top: 20,
        borderWidth: 1,
        borderColor: "#C4C4C4",
        borderRadius: 16,
        height: 18,
        paddingHorizontal: 15,
        alignItems: "center",
        justifyContent: "center"
    },
    delete: {
        fontSize: 10,
        color: "#AFAFAF"
    }
});
