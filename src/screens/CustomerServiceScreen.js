/**
 * 客服中心
 */
import React, { Component } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    StatusBar,
} from "react-native";
import Content from "../components/ContentItem";
import Line from "../components/Line";
import SplashScreen from 'react-native-splash-screen'

const lineDatas = [
    { title: "商户类咨询", route: "" },
    { title: "主播类咨询", route: "" },
    { title: "合伙人类咨询", route: "" },
    { title: "个人类咨询", route: "" }
];
import CommonStyles from "../common/Styles";
import Header from "../components/Header";

const { width, height } = Dimensions.get("window");

export default class CustomerServiceScreen extends Component {
    constructor() {
        this._didFocusSubscription = props.navigation.addListener('didFocus', (payload) =>{
            StatusBar.setBarStyle('dark-content')
        });
    }
    componentDidMount() {
        SplashScreen.hide()
    }
    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
    }
    render() {
        const { navigation } = this.props;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={false}
                    title="客服咨询"
                />
                <Content style={{ width: width - 20 }}>
                    {lineDatas.map((item, index) => {
                        return (
                            <Line
                                title={item.title}
                                key={index}
                                point={null}
                                type="horizontal"
                                onPress={() =>
                                    item.route
                                        ? navigation.navigate(item.route)
                                        : Toast.show("待开发")
                                }
                            />
                        );
                    })}
                </Content>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: "center"
    }
});
