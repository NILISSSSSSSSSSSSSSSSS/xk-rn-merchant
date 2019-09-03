/**
 * 验收中心/审核不通过原因
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Keyboard,
} from "react-native";
import { connect } from "rn-dva";

import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import TextInputView from "../../components/TextInputView";
import CommonButton from '../../components/CommonButton';
const { width, height } = Dimensions.get("window");

export default class TaskJugeReason extends Component {
    static navigationOptions = {
        header: null
    };
    constructor(props) {
        super(props);
        this.state = {
            text: "",
        };
    }

    componentDidMount() { }


    submit = () => {
        Keyboard.dismiss();
        this.props.navigation.navigate('TaskDetail')

    };

    componentWillUnmount() {
        Loading.hide();
    }

    render() {
        const { navigation } = this.props;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"审核不通过原因"}
                />
                <TextInputView
                    inputView={styles.textInputView}
                    inputRef={e => {
                        this.textInput = e;
                    }}
                    style={styles.textInput}
                    multiline={true}
                    maxLength={30}
                    onBlur={() => {
                        Keyboard.dismiss();
                    }}
                    placeholder={"请输入原因"}
                    placeholderTextColor={"#999"}
                    onChangeText={text => this.setState({ text: text.trim() })}
                />
                <CommonButton
                    title='确认并提交'
                    onPress={() => {
                        this.submit();
                    }}
                />

            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center'
    },
    contentView: {
        // ...CommonStyles.shadowStyle,
        width: width - 20,
        margin: 10,
        borderRadius: 6,
        backgroundColor: "#fff",
        overflow: "hidden",
        paddingBottom: 10
    },
    textInputView: {
        height: 155
    },
    textInput: {
        height: "100%",
        padding: 15,
        textAlignVertical: "top",
        backgroundColor: '#fff',
        width: width - 20,
        marginTop: 10,
        borderRadius: 8
    },

});
