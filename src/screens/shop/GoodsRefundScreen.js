/**
 * 退款设置
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity
} from 'react-native';
import { connect } from 'rn-dva';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import * as nativeApi from '../../config/nativeApi';
import Content from '../../components/ContentItem';
import Picker from 'react-native-picker-xk';
import picker from '../../components/Picker';
const { width, height } = Dimensions.get('window');

export default class GoodsRefundScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }
    constructor(props) {
        super(props)
        let date = new Date();
        const params = this.props.navigation.state.params || {}
        let refundsTime = 30;
        if (params.refundsTime) {
            refundsTime = parseInt(params.refundsTime) / 60
        }
        this.state = {
            selectItem: params.selectRefunds || {},
            refundsTime: refundsTime + '分钟',
            refundsList: this.props.navigation.state.params.refundsList
        }
    }

    componentDidMount() {
    }

    componentWillUnmount() {
        Picker.hide()
    }
    select = (data) => {
        this.setState({
            selectItem: data
        })
    }

    _showTimePicker() {
        let data = []
        for (let i = 0; i < 120; i++) {
            data.push((i + 1) + '分钟')
        }
        Picker.init({
            ...picker.basicSet,
            pickerData: data,
            selectedValue: [this.state.refundsTime],
            onPickerConfirm: pickedValue => {
                this.setState({ refundsTime: pickedValue[0] })
            }
        });
        Picker.show();
    }
    save = () => {
        const { navigation} = this.props;
        const { refundsTime, selectItem, callback } = this.state
        let time = parseInt(refundsTime.split('分钟')[0]) * 60
        navigation.state.params.callback(selectItem, time);
        navigation.goBack()
    }

    render() {
        const { navigation, callback } = this.props;
        return (
            <View style={styles.container}>
                <Header
                    title='退款设置'
                    navigation={navigation}
                    goBack={true}
                    rightView={
                        <TouchableOpacity
                            onPress={() => this.save()}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: '#fff' }}>保存</Text>
                        </TouchableOpacity>
                    }
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        {
                            this.state.refundsList.map((item, index) => {
                                return (
                                    <Content key={index}>
                                        <TouchableOpacity style={styles.row} onPress={() => this.select(item)}>
                                            <ImageView
                                                source={this.state.selectItem.key == item.key ? require('../../images/index/select.png') : require('../../images/index/unselect.png')}
                                                sourceWidth={14}
                                                sourceHeight={14}
                                            />
                                            <Text style={styles.title}>{item.title}</Text>
                                        </TouchableOpacity>
                                        {
                                            index == 1 ?
                                                <TouchableOpacity style={styles.line} onPress={() => this._showTimePicker()}>
                                                    <Text style={styles.value}>限定时间</Text>
                                                    <View style={[styles.row]}>
                                                        <Text style={styles.value}>{this.state.refundsTime}</Text>
                                                        <ImageView
                                                            source={require('../../images/index/expand.png')}
                                                            sourceWidth={14}
                                                            sourceHeight={14}
                                                        />
                                                    </View>

                                                </TouchableOpacity> : null
                                        }

                                    </Content>
                                )
                            })
                        }

                    </View>
                </ScrollView>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    content: {
        alignItems: 'center',
        paddingBottom: 10
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: 15
    },
    line: {
        flexDirection: 'row',
        alignItems: 'center',
        borderTopWidth: 1,
        borderColor: '#F1F1F1',
        justifyContent: 'space-between',
        paddingLeft: 44
    },
    title: {
        fontSize: 17,
        color: '#222222',
        marginLeft: 15
    },
    value: {
        color: '#555555',
        fontSize: 14
    }



});
