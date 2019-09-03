/**
 * 特别约定
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
import * as requestApi from "../../config/requestApi";
import * as regular from "../../config/regular";
import ImageView from "../../components/ImageView";
import WebViewCpt from "../../components/WebViewCpt";
import config from "../../config/config";
const { width, height } = Dimensions.get("window");
import { StackActions, NavigationActions } from 'react-navigation';
class AppointScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = props.navigation.state.params || {}
        this.state = {
            name: params.name,
            page:params.page,
            merchantType:params.merchantType,
            auditStatus:params.auditStatus,
            route:params.route,
            familyUp:params.familyUp,
            agreementUri: "",
            callback:params.callback || (()=>{}),
            getDataDetail:params.getDataDetail
        }
    }
    componentDidMount() {
        const { store } = this.props;
        const { merchantType } = this.state;
        const contractConfigKey = `${store.user.merchant.filter((item)=>item.merchantType==merchantType)[0].agreement}_SPECIAL_CONTRACT`;
        requestApi.merchantContractAgreement({
            contractConfigKey,
            forPlatform:"mam",
        }).then((res)=> {
            this.setState({
                agreementUri: res.url
            })
        }).catch(()=> {
            // Toast.show("协议请求失败")
        })
    }

    componentWillUnmount() {
        // this.state.callback()
        // this.state.getDataDetail && this.state.getDataDetail()
    }

    render() {
        const { navigation, store } = this.props;
        const { name,page,merchantType, regParams,auditStatus ,route, familyUp, agreementUri} = this.state;

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"特别约定"}
                />
                <View style={{flex:1}}>
                    {
                        agreementUri ? <WebViewCpt
                            source={{
                                uri: agreementUri,
                                showLoading: true
                            }}
                        />: null
                    }
                </View>

                {/* <TouchableOpacity
                    onPress={() => navigation.navigate("PayJoin",  navigation.state.params || {})}
                    style={styles.btn}
                >
                    <Text style={{ color: "#fff", fontSize: 17 }}>我已确认</Text>
                </TouchableOpacity> */}
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    content: {
        width: width - 20,
        margin: 10,
        padding: 15,
        backgroundColor: "#fff",
    },
    btn: {
        justifyContent: "center",
        alignItems: "center",
        height: 50,
        marginBottom: CommonStyles.footerPadding,
        backgroundColor: "#4A90FA",
    },
    headerLeftView: {
        width: 50,
        alignItems: 'flex-start',
        paddingLeft: 18,
    },
});

export default connect(
    state => ({ store: state })
)(AppointScreen);
