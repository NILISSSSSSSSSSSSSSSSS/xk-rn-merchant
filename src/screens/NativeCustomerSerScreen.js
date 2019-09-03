import React , { Component }from 'react';
import { requireNativeComponent,Platform, StatusBar} from 'react-native';
import SplashScreen from 'react-native-splash-screen'

var NativeCusServiceScreen = requireNativeComponent('NativeCusServiceScreen', null);
var MerchantCusServiceFrameLayout = requireNativeComponent('MerchantCusServiceFrameLayout', null);

export default class CusServiceScreen extends Component {
    componentWillMount() {
        StatusBar.setBarStyle('dark-content')
    }
    componentDidMount() {
        SplashScreen.hide()
    }
    
    render() {
        return (
            Platform.OS=='ios'?
            <NativeCusServiceScreen style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
            </NativeCusServiceScreen>
            : <MerchantCusServiceFrameLayout style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
            </MerchantCusServiceFrameLayout>
        );
    }
}
