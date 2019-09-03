/**
 * 自营商城商品详情页
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    TouchableOpacity,
    Image,
} from "react-native";
import { connect } from "rn-dva";
import config from "../../config/config";
import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import WebViewCpt from "../../components/WebViewCpt";
import * as Address from '../../const/address'
const { width, height } = Dimensions.get("window");

export default class AddressLocationScreen extends Component {
    static navigationOptions = {
        header: null
    };
    constructor(props) {
        super(props);
        const params=this.props.navigation.state.params || {}
        this.state = {

        };
    }
    render() {
        console.log('llllll',Address)
        const { navigation } = this.props;
        const { region=['四川省','成都市','高新区'],getLactionData=(()=>{}) ,title,lat,lng,uriValue='map'} = this.props.navigation.state.params || {};
        // let _url = `http://192.168.2.226:8080/#/${uriValue}?region=${region.join('')}&title=${title}&lat=${lat}&lng=${lng}&province=${region[0]}&city=${region[1]}&district=${region[2]}`;
        let _url = `${config.baseUrl_h5}${uriValue}?region=${region.join('')}&title=${title}&lat=${lat}&lng=${lng}&province=${region[0]}&city=${region[1]}&district=${region[2]}`;
        console.log("_url_url1", _url);
        let source = {
            uri: _url,
            showLoading: true,
            headers: { "Cache-Control": "no-cache" }
        }
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={navigation.getParam('headerTitle','选择定位')}
                />
                <WebViewCpt
                    webViewRef={e => {
                        this.webViewRef = e;
                    }}
                    isNeedUrlParams={true}
                    source={source}
                    getMessage={data => {
                        let params = data && data.split(",");
                        console.log("data", data);
                        if (params[0] === "jsHiddenXKHUDView") {
                            Loading.hide();
                        } else if (params[0] === "jsLocationCall") {
                            let _data = data.replace("jsLocationCall,", "");
                            getLactionData(_data); // 父组件回调。更新地址信息，并等待保存
                            navigation.goBack();
                        } else {
                            console.log(params);
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
});

