/**
 * webview页面
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    ScrollView,
    Text,
    TouchableOpacity,
    ImageBackground,
    Image,
} from 'react-native';
import { connect } from 'rn-dva';

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import WebViewCpt from '../../components/WebViewCpt';

const { width, height } = Dimensions.get('window');

class WebViewScreen extends Component {
    static navigationOptions = {
        header: null,
    }
    constructor(props) {
        super(props)
        this.state = {
            source: props.navigation.state.params && props.navigation.state.params.source || null,
        }
    }

    componentDidMount() {
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    postMessage = () => {
    }

    goBack = () => {
        const { navigation } = this.props;
        const { canGoBack } = this.state;

        if (canGoBack) {
            this.webViewRef.goBack();
        } else {
            navigation.goBack();
        }
    }

    componentWillUnmount() {
        Loading.hide();
    }

    render() {
        const { navigation, store } = this.props;
        const { source } = this.state;

        return (
            <View style={styles.container}>
                <WebViewCpt
                    webViewRef={(e) => { this.webViewRef = e }}
                    isNeedUrlParams={false}
                    source={source}
                    postMessage={() => {
                        this.postMessage();
                    }}
                    getMessage={(data) => {
                    }}
                    navigationChange={(canGoBack) => {
                        this.changeState('canGoBack', canGoBack);
                    }}
                />

                <Header
                    navigation={navigation}
                    headerStyle={styles.headerStyle}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerItem}
                            activeOpacity={0.6}
                            onPress={() => {
                                this.goBack();
                            }}
                        >
                            <Image source={require('../../images/mall/goback_gray.png')} />
                        </TouchableOpacity>
                    }
                />
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    headerStyle: {
        position: 'absolute',
        top: CommonStyles.headerPadding,
        height: 44,
        paddingTop: 0,
        backgroundColor: 'transparent',
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        width: 50,
    },
});

export default connect(
    (state) => ({ store: state })
)(WebViewScreen);
