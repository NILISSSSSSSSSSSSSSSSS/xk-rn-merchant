//保证金提取FinancialPositDeposit
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
import * as regular from "../../config/regular";
import ImageView from "../../components/ImageView";
import Content from "../../components/ContentItem";
import CommonButton from '../../components/CommonButton';
const { width, height } = Dimensions.get("window");

export default class FinancialPositDeposit extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            topParams:props.navigation.state.params || {}
        }
    }

    componentDidMount() {

    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    componentWillUnmount() {
    }

    render() {
        const { navigation} = this.props;
        const { topParams } = this.state;

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title="保证金提取"
                />

                <View style={styles.content}>
                    <Content style={{paddingHorizontal:15,paddingVertical:30,alignItems:'center'}}>
                        <ImageView
                            source={require("../../images/caiwu/pay_failed.png")}
                            sourceWidth={66}
                            sourceHeight={66}
                        />
                        <Text style={styles.text1}>您确定要提取联盟商{topParams.name}身份的保证金吗？提取后该身份将无法正常使用，您也无法获得该身份的相关收益!</Text>
                        <CommonButton
                            title='确认提取'
                            style={{width:width-50,marginBottom:0}}
                            onPress={()=>navigation.navigate('AccountConfirmDeposit',topParams)}
                        />
                        <CommonButton
                            title='暂不提取'
                            style={{width:width-50,backgroundColor:'#fff'}}
                            textStyle={{color:CommonStyles.globalHeaderColor}}
                            onPress={()=>navigation.goBack()}
                        />
                    </Content>

                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    content: {
        width: width - 20,
        marginHorizontal: 10,
        marginTop: 10,
    },
    whiteBlock: {
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        height: 192,
        backgroundColor: "#fff",
    },
    text1: {
        fontSize: 14,
        color: "#222",
        marginTop: 18,
        lineHeight:24
    },
});
