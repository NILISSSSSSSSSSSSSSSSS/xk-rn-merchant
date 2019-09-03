/**
 * 提交成功
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as regular from '../../config/regular';
const { width, height } = Dimensions.get('window');
import ImageView from '../../components/ImageView';

export default class SaveSuccessScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        this.state = {

        }
    }

    componentDidMount() {
    }

    componentWillUnmount() {
    }


    render() {
        const { navigation} = this.props;
        return (
            <View style={styles.container}>
                <Header
                    title='提交成功'
                    navigation={navigation}
                    goBack={true}
                />
                <View style={{ alignItems: 'center' }}>
                    <ImageView
                        style={{ marginTop: 50 }}
                        source={require('../../images/index/tijiao_success.png')}
                        sourceWidth={144}
                        sourceHeight={144}
                    />
                    <Text style={{ color: '#4A90FA', color: '#777777', marginTop: 37, marginBottom: 3 }}>提交完成，请耐心等待系统审核通过！</Text>
                    <TouchableOpacity onPress={() => { navigation.navigate('Xiaji') }}>
                        <Text style={{ color: '#4A90FA', color: '#4A90FA' }}>返回首页</Text>
                    </TouchableOpacity>
                </View>

            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    header: {
        width: width,
        height: 44 + CommonStyles.headerPadding,
        paddingTop: CommonStyles.headerPadding,
        overflow: 'hidden',
    },

});
