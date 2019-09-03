/**
 * 店铺地址
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
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import picker from "../../components/Picker";

import * as Address from '../../const/address'

const { width, height } = Dimensions.get('window');

export default class StoreAddressScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        this.state = {
            address: this.props.navigation.state.params.address,
            areaData: {
                codes: ['120000', '120000', '120118'],
                names: ['天津市', '天津市', '和平区']
            },
            location: {
                lng: '',
                lat: ''
            },
            currentShop: {
                detail: {

                }
            }
        }
    }

    componentDidMount() {
        const { navigation } = this.props
        let currentShop = navigation.getParam('currentShop', {})
        let currentShopDetail = currentShop.detail || {};
        let {  provinceCode, cityCode, districtCode } = currentShopDetail || {};
        let areaData = { // 获取省市区
            codes: [provinceCode, cityCode, districtCode],
            names: Address.getNamesByDistrictCode(districtCode)
        }
        let location = {
            lat: currentShopDetail.lat || "",
            lng: currentShopDetail.lng || ""
        }
        this.handleChangeState('areaData', areaData)
        this.setState({
            location,
            areaData,
            currentShop
        })
    }

    componentWillUnmount() {
        Loading.hide()
    }
    handleChangeState = (key = '', value = '', callback = () => { }) => {
        this.setState({
            [key]: value
        }, () => {
            callback()
        })
    }
    save = () => {
        if (this.state.address && this.state.currentShop.detail.locationAddress) {
            this.props.navigation.state.params.callback({
                address: this.state.address,
                provinceCode: this.state.areaData.codes[0],
                cityCode: this.state.areaData.codes[1],
                districtCode: this.state.areaData.codes[2],
                locationAddress: this.state.currentShop.detail.locationAddress,
                ...this.state.location
            })
            this.props.navigation.goBack()
        }

    }
    // 未保存的状态下，保存选择的经纬度和店铺名
    getLactionData = (data) => {
        console.log(JSON.parse(data))
        let _currentShop = JSON.parse(JSON.stringify(this.state.currentShop))
        let locationData = JSON.parse(data)
        const { title, point } = locationData
        _currentShop.detail.locationAddress = title
        _currentShop.detail.lat = point.lat
        _currentShop.detail.lng = point.lng
        this.setState({
            currentShop: _currentShop,
            location: point
        })
    }
    selectArea=()=>{
        picker._showAreaPicker(data => {
            const isOldAdress=data==JSON.stringify(this.state.areaData)
            const districtItem=Address.pickerArea.districts.find(item=>item.code==data.codes[2] && item.parentCode==data.codes[1]) || {}
            this.setState({
                areaData: data,
                location:{lng: districtItem.longitude,lat: districtItem.latitude},
                address:isOldAdress?this.state.address:'',
                currentShop:{
                    ...this.state.currentShop,
                    detail:{
                        ...this.state.currentShop.detail,
                        locationAddress:isOldAdress?this.state.currentShop.detail.locationAddress:''
                    }
                }
            })
        },this.state.areaData.names || []);
    }
    render() {
        const { navigation } = this.props;
        const { areaData, location, currentShop } = this.state
        console.log(areaData)
        return (
            <View style={styles.container}>
                <Header
                    title='店铺地址'
                    navigation={navigation}
                    goBack={true}
                    rightView={
                        <TouchableOpacity
                            onPress={() => this.save()}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: this.state.address && this.state.currentShop.detail.locationAddress ? '#fff' : 'rgba(255,255,255,0.5)' }}>保存</Text>
                        </TouchableOpacity>
                    }
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        <Content>
                            <Line title='所属地区' type="horizontal" point={null}
                                onPress={this.selectArea}
                                value={!areaData || (areaData && areaData.codes && !areaData.codes[0])?'':areaData.names.join('-')}
                            />
                        </Content>
                        <Content>
                            <Line title='店铺定位' type="horizontal"  point={null} onPress={() => {
                                if (!areaData || (areaData && areaData.codes && !areaData.codes[0])) {
                                    Toast.show('请选择所属地区')
                                } else {
                                    let newLocation={...location}
                                    if(!location.lat){
                                        const districtItem=Address.pickerArea.districts.find(item=>item.code==areaData.codes[2]) || {}
                                        newLocation.lat=districtItem.latitude
                                        newLocation.lng=districtItem.longitude
                                        this.setState({
                                            location:newLocation
                                        })
                                    }
                                    navigation.navigate('AddressLocation', {
                                        headerTitle:'选择定位',
                                        region:areaData.names,
                                        title: currentShop.detail && currentShop.detail.locationAddress || '',
                                        getLactionData: this.getLactionData,
                                        ...newLocation,
                                        uriValue:'map'
                                    })
                                }
                            }
                            }
                            value={currentShop.detail && currentShop.detail.locationAddress || ''}
                            />
                            <Line
                                title='详细地址'
                                point={null}
                                type='input'
                                maxLength={20}
                                styleInput={{textAlign:'right'}}
                                placeholder='请输入详细地址'
                                value={this.state.address}
                                onChangeText={(data) => this.setState({ address: data })}
                            />

                        </Content>

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
    inputView: {
        flex: 1,
        marginLeft: 10
    },
    input: {
        flex: 1,
        padding: 0,
        fontSize: 14,
        lineHeight: 20,
        height: 20,


    },


});
