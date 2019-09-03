/**
 * 促销管理
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
import ImageView from '../../components/ImageView';

const { width, height } = Dimensions.get('window');

export default class SaleScreen extends PureComponent {
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
        const { navigation } = this.props;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='促销管理'
                />
                    <TouchableOpacity style={styles.imgView} onPress={() => navigation.navigate('SaleCustomerManage', { page: 'card' })}>
                        <ImageView
                            resizeMode='cover'
                            sourceWidth={width-20}
                            sourceHeight={(150*(width-20))/355}
                            source={require('../../images/cuxiao/custom_card.png')}
                        />
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.imgView} onPress={() => navigation.navigate('SaleCustomerManage', { page: 'ticket' })}>
                        <ImageView
                            resizeMode='cover'
                            style={styles.image}
                            sourceWidth={width-20}
                            sourceHeight={(150*(width-20))/355}
                            source={require('../../images/cuxiao/coupon.png')}
                        />
                    </TouchableOpacity>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems:'center'
    },
    image:{
        width:width-20,
        // height:355/(width-20)*150
    },
    imgView: {
        width:width-20,
        marginTop:10,
        // height:150
    },
});

