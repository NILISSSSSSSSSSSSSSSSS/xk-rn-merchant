import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Platform,
    Image,
    StatusBar,
} from "react-native";
import SplashScreen from 'react-native-splash-screen';
import CommonStyles from "../common/Styles";

const { width, height } = Dimensions.get("window");

export default class WelcomeScreen extends Component {
    static navigationOptions = {
        header: null
    };
    
    componentWillUnmount = ()=> {
        setTimeout(()=>{
            StatusBar.setTranslucent(true);
            Platform.OS === 'ios' ? StatusBar.setNetworkActivityIndicatorVisible(true): null;
            StatusBar.setBackgroundColor("transparent")
            StatusBar.setBarStyle("light-content");
        }, 100)
        SplashScreen.hide();
    }

    render() {
        // const { navigation } = this.props;
        return (
            <View style={styles.container}>
                <StatusBar
                    translucent={true}
                    backgroundColor={"transparent"}
                    barStyle="light-content"
                    networkactivityindicatorvisible={true}
                    showhidetransition={'fade'}
                    animated={true}
                />
                {/* <Image
                    style={styles.welcomeImg}
                    source={require("../images/launch_screen.png")}
                /> */}
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    welcomeImg: {
        width: width,
        height: height
    }
});
