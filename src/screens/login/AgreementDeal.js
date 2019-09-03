
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    View
} from "react-native";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import config from "../../config/config"
import WebViewCpt from '../../components/WebViewCpt';
export default class AgreementDeal extends Component {
    componentWillUnmount(){
        this.props.navigation.state.params.callback &&  this.props.navigation.state.params.callback()
    }
    render(){
        const {navigation} = this.props
        const {uri,title,url} = navigation.state.params
        let fainalUrl = url || (config.baseUrl_h5+uri)
        console.log(url,fainalUrl)
        return (
            <View style={styles.container}>
            {
                title?
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={title}
                />:<View style={{height:CommonStyles.headerPadding,backgroundColor:CommonStyles.globalHeaderColor}}></View>
            }

            <WebViewCpt
                source={{
                    uri: fainalUrl,
                    showLoading: true,
                    headers: { "Cache-Control": "no-cache" }
                }}
            />
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: "#fff",

    },
})
