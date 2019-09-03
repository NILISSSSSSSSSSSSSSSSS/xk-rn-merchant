/**
 * 扫码
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  TouchableOpacity,
} from 'react-native';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import WebViewCpt from '../../components/WebViewCpt';

const { width, height } = Dimensions.get('window');

export default class ScanScreen extends PureComponent {
    static navigationOptions = {
      header: null,
    };

    constructor(props) {
      super(props);
      const params = props.navigation.state.params || {};
      this.state = {
        useWebview: params.useWebview || false,
        ScanData: params.ScanData || '',
      };
    }

    componentDidMount() { }

    componentWillUnmount() { }

    goBack = () => {
      const { navigation } = this.props;
      const { canGoBack } = this.state;

      if (canGoBack) {
        this.webViewRef.goBack();
      } else {
        navigation.goBack();
      }
    };

    render() {
      const { navigation } = this.props;
      const { ScanData, useWebview } = this.state;
      const source = {
        uri: ScanData,
        showLoading: true,
        headers: { 'Cache-Control': 'no-cache' },
      };
      return (
        <View style={styles.container}>
            <Header
                    navigation={navigation}
                    goBack
                    title="扫码"
                    headerStyle={{ backgroundColor: '#fff' }}
                    titleTextStyle={{ color: '#222' }}
                    leftView={(
                      <View>
  <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                  navigation.goBack();
                                }}
                            // onPress={() => { navigation.goBack() }}
                            >
                              <Image
                                    style={{ width: 23, height: 23 }}
                                    source={require('../../images/back_gray.png')}
                                />
                            </TouchableOpacity>
</View>
)}
              />
            {
                    useWebview
                      ? (
                        <WebViewCpt
                            webViewRef={(e) => {
                              this.webViewRef = e;
                            }}
                            isNeedUrlParams
                            source={source}
                            postMessage={() => { }}
                            getMessage={(data) => {
                              // let params = data && data.split(",");
                              // console.log(params);
                            }}
                            navigationChange={(canGoBack) => {
                              // this.changeState('canGoBack', canGoBack);
                            }}
/>
                      )
                      : <Text>{ScanData}</Text>

                }
          </View>
      );
    }
}

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
