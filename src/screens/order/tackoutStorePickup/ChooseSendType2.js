import React, { Component } from 'react'
import { Text, View, StyleSheet, ImageBackground, Dimensions, ScrollView, Image } from 'react-native'
import Header from '../../../components/Header';

import math from '../../../config/math';
import { connect } from 'rn-dva';
import Button from '../../../components/Button';
import TextInputView from '../../../components/TextInputView';
import CommonStyles from '../../../common/Styles'

const { width, height } = Dimensions.get("window");

const dajianActiveImg = require('../../../images/logistics/dajian-active.png');
const dajianDefaultImg = require('../../../images/logistics/dajian-default.png');
const xiaojianActiveImg = require('../../../images/logistics/xiaojian-active.png');
const xiaojianDefaultImg = require('../../../images/logistics/xiaojian-default.png');

import * as regular from '../../../config/regular';
import { fetchMerchantCalcPrice } from '../../../config/Apis/order';

class ChooseSendType2 extends Component {
  state = {
      tabIndex: 0,
      weight: 0,
      height: 0,
      width: 0,
			length: 0,
			money: 0,
			confirmVisible: false,
  }

	changeState(key, value) {
		let { tabIndex, weight, height, width, length } = this.state;
		const { userShop, navigation } = this.props;
		let xiaoJianActive = tabIndex===0;
		let shopId = userShop.id;
		let { orderId } = navigation.state.params || {};
		let formData = {
			weight,
			height, 
			width,
			length 
		}
		formData[key] = value;
		let param = {
				shopId: shopId,
				weight: Number(weight),
				length: xiaoJianActive ? 0 :length,
				width: xiaoJianActive ? 0 : width,
				height: xiaoJianActive ? 0 :height,
				goodsOrderNo: orderId,
				xKModule:'shop'
		}
		this.setState({
			...formData,
		})
		Loading.show()
		fetchMerchantCalcPrice(param).then(res=> {
			this.setState({ 
				money: res.price,
			})
		}).catch(err => {
			console.log(err)
		});
	}

  submitForm = (lifangmi)=> {
		let { tabIndex, weight, height, width, length } = this.state;
		const { userShop, navigation, changeLogistics } = this.props;
		let xiaoJianActive = tabIndex===0;
		let shopId = userShop.id;
		let { orderId } = navigation.state.params || {};

		let param = {
				shopId: shopId,
				weight: Number(weight),
				length: xiaoJianActive ? 0 :length,
				width: xiaoJianActive ? 0 : width,
				height: xiaoJianActive ? 0 :height,
				goodsOrderNo: orderId,
				xKModule:'shop'
		}
		Loading.show()
		fetchMerchantCalcPrice(param).then(res=> {
			changeLogistics({ 
				goodsData: {
					type: tabIndex===1 ? "大件": "小件",
					tabIndex: tabIndex,
					price: res.price,
					weight: Number(weight),
					length: xiaoJianActive ? 0 :length,
					width: xiaoJianActive ? 0 : width,
					height: xiaoJianActive ? 0 :height,
					lifangmi,
				}
			})
			navigation.goBack()
		}).catch(err => {
			console.log(err)
		});
	}

	canSubmit=(tabIndex, weight, lifangmi)=>{
			if(!parseFloat(weight) || !regular.price(weight)){
					return false
			}else if(weight>20 && tabIndex === 0){
					return false
			}else if(tabIndex === 1 && (!parseFloat(lifangmi) || !Number(lifangmi))){
					return false
			}else {
					return true
			}
	}

  render() {
    const { tabIndex, weight, height, width, length, money } = this.state;
	let xiaoJianActive = tabIndex===0;
	let lifangmi = math.multiply(math.multiply(math.divide(length,100),math.divide(height,100)),math.divide(width,100));
    return (
      <ScrollView style={styles.container}>
        <Header title="选择寄件类型" goBack></Header>
        <ImageBackground source={require("../../../images/logistics/map-background.png")} style={styles.mapBack}>
            <View style={styles.card}>
                <View style={styles.titleContainer}>
                    <Text style={styles.title}>选择寄件类型</Text>
                    <Text style={styles.subtitle}>超过20公斤请选择大件</Text>
                </View>
                <View style={styles.tabView}>
                    <Button style={styles.tab} onPress={()=> this.setState({ tabIndex: 0})}>
                        <View style={styles.tabContent}>
                            <Image source={xiaoJianActive?xiaojianActiveImg:xiaojianDefaultImg} style={{ width: 20, height: 20, marginRight: 7 }}></Image>
                            <Text style={xiaoJianActive?styles.textActive: styles.textDefault}>寄小件</Text>
                        </View>
                        <View style={[styles.tabBottom, xiaoJianActive ? styles.tabActiveBottom : styles.tabDefaultBottom]}></View>
                    </Button>
                    <Button style={styles.tab} onPress={()=> this.setState({ tabIndex: 1})}>
                        <View style={styles.tabContent}>
                            <Image source={!xiaoJianActive?dajianActiveImg:dajianDefaultImg} style={{ width: 20, height: 20, marginRight: 7 }}></Image>
                            <Text style={!xiaoJianActive?styles.textActive: styles.textDefault}>寄大件</Text>
                        </View>
                        <View style={[styles.tabBottom, !xiaoJianActive ? styles.tabActiveBottom : styles.tabDefaultBottom]}></View>
                    </Button>
                </View>
            </View>
        </ImageBackground>
        <View style={styles.formCard}>
            <View style={styles.formTitleContainer}>
                <Text style={styles.unitTitle}>物品总重量</Text>
                <Text style={[styles.c7f14, {marginLeft: 10}]}><Text style={styles.unitTitle}>{weight||0}</Text>kg</Text>
            </View>
            <View style={[CommonStyles.flex_start, { marginBottom: 13 }]}>
                <TextInputView inputView={styles.inputView} keyboardType="numeric" placeholder="" value={weight} onChangeText={(text)=> this.changeState("weight", text)} /><Text style={styles.unitTitle2}>kg</Text>
            </View>
            <View style={xiaoJianActive?{display:"none"}: {}}>
                <View  style={styles.formTitleContainer}>
                    <Text style={styles.unitTitle}>物品总体积</Text>
                    <Text style={[styles.c7f14, {marginLeft: 10}]}><Text style={styles.unitTitle}>{lifangmi}</Text>立方米</Text>
                </View>
                <View style={[CommonStyles.flex_start, {marginBottom: 10}]}>
                    <Text style={styles.inputTitle}>长</Text><TextInputView inputView={styles.inputView} keyboardType="numeric" placeholder="" value={length} onChangeText={(text)=> this.changeState("length", text)} /><Text style={styles.unitTitle2}>cm</Text>
									</View>
									<View style={[CommonStyles.flex_start, {marginBottom: 10}]}>
                    <Text style={styles.inputTitle}>宽</Text><TextInputView inputView={styles.inputView} keyboardType="numeric" placeholder="" value={width} onChangeText={(text)=> this.changeState("width", text)} /><Text style={styles.unitTitle2}>cm</Text>
									</View>
									<View style={[CommonStyles.flex_start, {marginBottom: 24}]}>
                    <Text style={styles.inputTitle}>高</Text><TextInputView inputView={styles.inputView} keyboardType="numeric" placeholder="" value={height} onChangeText={(text)=> this.changeState("height", text)} /><Text style={styles.unitTitle2}>cm</Text>
                </View>
            </View>
        </View>
		<View style={styles.peisongContainer}>
			<Text style={styles.peisong}>配送费：<Text style={styles.money}>¥{math.divide(money, 100)}</Text></Text>
		</View>
        <View style={styles.btnContainer}>
          <Button style={styles.btnConfirm} disabled={!this.canSubmit(tabIndex, weight, lifangmi)} type="primary" title="确认" onPress={()=> this.submitForm(lifangmi)} />
        </View>
      </ScrollView>
    )
  }
}

export default connect(state=> ({
		logistics: state.order.logistics || {},
		userShop: state.user.userShop || {},
}), {
    changeLogistics: (item)=> ({ type: "order/changeLogistics", payload: item}),
})(ChooseSendType2)

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    mapBack: {
        width,
        height: 100,
        marginBottom: 50,
    },
    card: {
        width: width - 20,
        height: 100,
        marginHorizontal: 10,
        position: 'relative',
        top: 50,
        backgroundColor: '#FFf',
        borderRadius: 8,
    },
    title: {
        fontSize: 18,
        color: '#2e2e2e'
    },
    subtitle: {
        fontSize: 14,
        color: '#999',
        marginLeft: 10,
    },
    formCard: {
        marginTop: 10,
        marginHorizontal: 10,
				backgroundColor: '#FFf',
				paddingHorizontal: 15,
				borderRadius: 8
		},
		formTitleContainer: {
			flexDirection: 'row',
			justifyContent: 'flex-start',
			alignItems: 'center',
			height: 42,
		},
    titleContainer: {
        height: 48,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        marginHorizontal: 15,
    },
    tabView: {
        flexDirection: 'row',
        height: 43,
        marginTop: 9,
    },
    tab: {
        flex: 1,
        flexDirection: 'column',
        alignItems: 'center',
        backgroundColor: '#fff',
    },
    tabContent: {
        flexDirection: 'row',
        height: 40,
        alignItems: 'center',
        justifyContent: 'center',
    },
    textActive: {
        fontSize: 17,
        color: '#4A90FA'
    },
    textDefault: {
        fontSize: 17,
        color: '#999'
    },
    tabBottom: {
        height: 3,
        width: 42,
        borderTopLeftRadius: 3,
        borderTopRightRadius: 3,
    },
    tabActiveBottom: {
        backgroundColor: '#4A90FA',
		},
		peisongContainer: {
			marginTop: 27,
			flexDirection: 'row',
			justifyContent: "center",
			alignItems: 'center',
		},
		peisong: {
			color: "#777",
			fontSize: 16,
		},
		money: {
			fontSize: 20,
			color: '#EE6161',
		},
		btnContainer: {
			marginTop: 17,
			marginHorizontal: 10,
		},
		inputTitle: {
			color: '#222',
			fontSize: 14,
			marginRight: 10,
		},
		unitTitle2: {
			color: '#2E2E2E',
			fontSize: 14,
			marginLeft: 10
		},
		unitTitle: {
			color: '#2E2E2E',
			fontSize: 14,
		},
		btnConfirm: {
			borderRadius: 8,
		},
		inputView: {
			height: 40,
			flex: 1,
			borderColor: '#F1F1F1',
			borderWidth: 1,
			borderRadius: 3,
			paddingHorizontal: 10
		},
		c7f14: {
			color: '#777',
			fontSize: 14
		}
})