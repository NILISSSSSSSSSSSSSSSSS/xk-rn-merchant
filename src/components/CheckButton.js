/**
 * Created by iPZero on 2016/10/24.
 * 定时器封装,
 */
import React, { Component } from "react";
import { Text, View, StyleSheet, TouchableOpacity } from "react-native";
import CountDown from "./CountDown";
import moment from "moment";

class CheckButton extends Component {
    static defaultProps = {
        onClick: null,
        delay: ""
    };
    constructor(props) {
        super(props);
        this.state = {
            vercode: this.props.name || "获取验证码",
            disabled: false,
            time: "",
            delay: this.props.delay || 60
        };
    }
    sendVerCode = () => {
        this.setState({
            time: moment().add(this.state.delay, "s"),
            vercode: ""
        });
        this.disable();
    };
    // 计时器结束 回调
    handleTimerOnEnd = () => {
        this.setState({
            vercode: "重新获取",
            disabled: false
        });
    };
    enable = () => {
        this.setState({
            disabled: false
        });
    };
    disable = () => {
        this.setState({
            disabled: true
        });
    };
    onPress = () => {
        this.props.onClick(this.enable);
    };
    componentWillUnmount() {

    }
    render() {
        return (
            <TouchableOpacity
                style={[
                    styles.btnStyle,
                    this.props.styleBtn,
                    this.state.disabled && styles.disabled,
                    this.props.disabledStyles
                ]}
                onPress={this.onPress}
                disabled={this.state.disabled}
            >
                <Text
                    style={[
                        styles.title,
                        this.state.disabled
                            ? this.props.disableTitle
                            : this.props.title
                    ]}
                >
                    {
                        this.state.vercode ? this.state.vercode : (
                            <React.Fragment>
                                <CountDown
                                    date={this.state.time}
                                    hours="小时"
                                    mins="分钟"
                                    segs="秒"
                                    type="verCode"
                                    delay={this.state.delay}
                                    onEnd={() => {
                                        this.handleTimerOnEnd();
                                    }}
                                    verStyle={[
                                        styles.title,
                                        this.state.disabled
                                            ? this.props.disableTitle
                                            : this.props.title
                                    ]}
                                />
                                s后重发
                        </React.Fragment>
                        )}
                </Text>
            </TouchableOpacity>
        );
    }
}

const styles = StyleSheet.create({
    btnStyle: {
        paddingLeft: 10,
        paddingRight: 10

        // width:100,
        // height:36,
        // borderRadius:4,
        // justifyContent:'center',
        // alignItems:'center',
        // backgroundColor:'#0088ed',
    },
    title: {
        // margin:10,
        color: "gray",
        fontSize: 14
    },
    disabled: {
        // backgroundColor: "#dddddd",
        borderColor: "#ddd"
    }
});
export default CheckButton;
