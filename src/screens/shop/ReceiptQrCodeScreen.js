/**
 * 生成收款码
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    View,
    Text,
    Dimensions,
    Image,
    Keyboard,
    TouchableOpacity,
    ImageBackground,
} from 'react-native';

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import Content from '../../components/ContentItem';
import * as priceUtils from '../../utils/price';

import * as requestApi from '../../config/requestApi';
import PriceInputView from '../../components/PriceInputView';
import { ListItem } from '../../components/List';
import Button from '../../components/Button';
import { RowCenter, BorderColor, TextThirdColor, TextSecondColor, TextColor } from '../../components/theme';
import { Validator } from '../../utils/validate-form';

const { width, height } = Dimensions.get('window');
function getwidth(val) {
    return width * val / 375;
}

const OptionItem = ({ item, discountAmount, discount, discountAmountLength, discountLength, changeDiscountAmount, changeDiscount }) => {
    if (item.value === '2') {
        return <View style={styles.optionItemView}>
            <PriceInputView
                // keyboardType='numeric'
                placeholderTextColor={'#CCCCCC'}
                value={discountAmount}
                maxLength={discountAmountLength}
                placeholder="优惠金额"
                returnKeyLabel="确定"
                returnKeyType="done"
                inputView={styles.optionItemView}
                style={{ textAlign: 'right', alignItems: 'center' }}
                onChangeText={changeDiscountAmount} />
            <Text style={styles.rightIcon}>元</Text>
        </View>;
    } else if (item.value === '3') {
        return <View style={styles.optionItemView}>
            <PriceInputView
                // keyboardType='numeric'
                value={discount}
                placeholderTextColor={'#CCCCCC'}
                maxLength={discountLength}
                placeholder="折扣值"
                returnKeyLabel="确定"
                returnKeyType="done"
                inputView={styles.optionItemView}
                style={{ textAlign: 'right', alignItems: 'center' }}
                onChangeText={changeDiscount} />
            <Text style={styles.rightIcon}>折</Text>
        </View>;
    } else {
        return null;
    }
};

const OptionButton = ({ title, onPress, selected = false })=> {
  return selected ? <Button style={styles.btnSize2} type="link" onPress={onPress}>
    <ImageBackground source={require('../../images/shop/btn-back169.png')} style={[styles.btnSize2, RowCenter, { paddingTop: getwidth(5), paddingBottom: getwidth(9) }]}>
      <Text style={{ color: '#fff', fontSize: 14, fontWeight: '400' }}>{title}</Text>
    </ImageBackground>
  </Button> :
  <Button
    type="default"
    title={title}
    style={styles.btnSize}
    titleStyle={{ color: TextSecondColor, fontSize: 14, fontWeight: '400' }}
    onPress={onPress}
  />;
};

const OptionButtonItem = ({ options, value, onChange })=> {
    return <View style={styles.options}>
        {
            options.map(opt=> {
                return <OptionButton key={opt.value} selected={value === opt.value} title={opt.title} onPress={()=> onChange(opt.value)} />;
            })
        }
        </View>;
};

class ReceiptQrCodeScreen extends PureComponent {
    state = {
        paymentAmount: '', // 收款金额
        checkValue: '2',
        discountAmount: '',   //优惠金额
        discount: '',    //折扣
        realAmount: '', // 实际金额
    }
    time = 0
    ycGame = null

    changePaymentAmount = (text) => {
        const paymentAmount = priceUtils.toNumber(text, '');
        let hasTwoDot = priceUtils.hasTwoDot(text);
        this.setState({
            paymentAmount: hasTwoDot ? text : paymentAmount && priceUtils.keepTwoDecimal(paymentAmount),
        }, ()=> {
            this.changeRealAmount(this.state.realAmount);
        });
    }
    handleSelect = (val) => {
        this.setState({
            checkValue: val,
        }, ()=> {
            if (val === '3') {
                this.changeDiscount(String(this.state.discount));
            } else {
                this.changeDiscountAmount(String(this.state.discountAmount));
            }
        });
    }

    changeDiscountAmount = (text) => {
        const { paymentAmount } = this.state;

        if (!priceUtils.isNumber(text)) {
            this.setState({
                discountAmount: '',
            });
            return;
        }

        let originPrice = priceUtils.toNumber(paymentAmount, 0);
        const discountAmount = priceUtils.toNumber(text, '');
        let realPrice = priceUtils.realPrice(originPrice, priceUtils.DiscountType.discountAmount, discountAmount);
        let hasTwoDot = priceUtils.hasTwoDot(text);

        this.setState({
            discountAmount: hasTwoDot ? text : priceUtils.keepTwoDecimal(discountAmount),
            realAmount: priceUtils.keepTwoDecimal(realPrice),
        });
    }

    changeDiscount = (text) => {
        const { paymentAmount } = this.state;
        const price = priceUtils.toNumber(text, '');
        if (!priceUtils.isNumber(text)) {
            this.setState({
                discount: '',
            });
            return;
        }

        let originPrice = priceUtils.toNumber(paymentAmount, 0);
        let discount = priceUtils.toNumber(price, 0);
        let realPrice = priceUtils.realPrice(originPrice, priceUtils.DiscountType.discount, discount);
        let hasTwoDot = priceUtils.hasTwoDot(text);

        this.setState({
            discount: hasTwoDot ? text : priceUtils.keepTwoDecimal(discount),
            realAmount: priceUtils.keepTwoDecimal(realPrice),
        });
    }

    changeRealAmount = (text = '')=> {
        const { paymentAmount, checkValue } = this.state;

        let realPrice = priceUtils.toNumber(text, 0);
        let originPrice = priceUtils.toNumber(paymentAmount, 0);
        let discountType = checkValue === '3' ? priceUtils.DiscountType.discount : priceUtils.DiscountType.discountAmount;
        let changedCount = checkValue === '3' ? priceUtils.discount(realPrice, originPrice) : priceUtils.discountAmount(realPrice, originPrice);

        let hasTwoDot = priceUtils.hasTwoDot(text);

        if (!priceUtils.isNumber(text)) {
            this.setState({
                [discountType]: '',
                realAmount: '',
            });
            return;
        }

        this.setState({
            [discountType]: priceUtils.keepTwoDecimal(changedCount),
            realAmount: hasTwoDot ? text : priceUtils.keepTwoDecimal(realPrice),
        });
    }

    submitForm = (formData) => {
        const { navigation } = this.props;
        Loading.show();
        requestApi.requestSystemTime().then((res) => {
            if (res) {
                navigation.navigate('ReceiptCodeScreen', { receiptQrCode: { ...formData, systemTime: res.systemTime } });
            } else {
                Toast.show('获取当前时间戳失败');
            }
        }).catch(()=>{

        });
    }

    createQrcode = () => {
        Keyboard.dismiss();
        const { paymentAmount, checkValue, discountAmount, discount, realAmount } = this.state;
        const formData = {
            paymentAmount: priceUtils.toNumber(paymentAmount, ''),
            checkValue,
            discountAmount: priceUtils.toNumber(discountAmount, ''),
            discount: priceUtils.toNumber(discount, ''),
            nowval: priceUtils.toNumber(realAmount, ''),
        };

        let rules = [
            { field: 'paymentAmount', required: true, msg: '原价不能为空' },
            { field: 'nowval', required: true, msg: '实收金额不能为空' },
            { field: 'nowval', custom: ()=> formData.nowval <= formData.paymentAmount && formData.nowval >= 0.01, msg: '实收金额不能大于原价或小于0.01' },
            { field: 'paymentAmount', custom: ()=> formData.paymentAmount <= 100000 && formData.paymentAmount > 0, msg: '原价不能大于10万或小于0'  },
        ];

        if (checkValue === '2') {
            rules = rules.concat([
                { field: 'discountAmount', required: true, msg: '会员优惠不能为空' },
                { field: 'discountAmount', custom: ()=> formData.discountAmount < formData.paymentAmount && formData.discountAmount > 0, msg: '会员优惠必须小于原价且大于0'  },
            ]);
        }
        if (checkValue === '3') {
            rules = rules.concat([
                { field: 'discount', required: true, msg: '折扣不能为空' },
                { field: 'discount', custom: ()=>  formData.discount < 10 && formData.discount >= 0, msg: '折扣必须小于10且大于0'  },
            ]);
        }

        let validator = new Validator(rules);
        let validateResult = validator.validate(formData);
        if (validateResult.validate) {
            this.submitForm(formData);
        } else {
            Toast.show(validateResult.msg, 2000);
        }
    }
    nativeStaticQrCode = () => {
        const { navigation } = this.props;
        navigation.navigate('ReceiptStaticQrCodeScreen');
    }
    render() {
        const { navigation } = this.props;
        const {
            paymentAmount, checkValue, discountAmount, discount, realAmount,
         } = this.state;
        let rightIcon = <Text style={styles.rightIcon}>元</Text>;
        // let options = [{ title: '优惠金额', value: '2' }, { title: '收款折扣', value: '3' }, { title: '不使用优惠', value: '1' }];
        let options = [{ title: '优惠金额', value: '2' }, { title: '收款折扣', value: '3' }];
        return (
            <View style={styles.container}>
                <Header
                    title="生成收款码"
                    navigation={navigation}
                    goBack={true}
                    leftView={
                        <TouchableOpacity
                            style={{ width: 100, justifyContent: 'center' }}
                            onPress={() => { navigation.goBack(); }}
                        >
                            <View style={{ width: 50, justifyContent: 'center', alignItems: 'center' }}>
                                <Image source={require('../../images/mall/goback.png')} />
                            </View>
                        </TouchableOpacity>
                    }
                    rightView={
                        <TouchableOpacity
                            style={{ width: 100, justifyContent: 'center', alignItems: 'center' }}
                            onPress={this.nativeStaticQrCode}
                        >
                            <Text style={{ fontSize: 17, color: '#fff', marginRight: 10 }}>静态二维码</Text>
                        </TouchableOpacity>
                    }
                />
                <Content>
                    <ListItem
                        title="原价"
                        titleStyle={styles.listItemTitle}
                        style={styles.bottomBorderItem}
                        extra={
                            <PriceInputView
                                placeholderTextColor={'#CCCCCC'}
                                rightIcon={rightIcon}
                                inputView={styles.optionItemView}
                                style={{ textAlign: 'right', alignItems: 'center' }}
                                value={paymentAmount}
                                maxLength={8}
                                placeholder="请输入收款金额"
                                onChangeText={this.changePaymentAmount}
                            />
                        }
                     />
                     <ListItem
                        title="优惠方式选择"
                        titleStyle={styles.listItemTitle}
                        style={styles.noBorderItem}
                        horizontal={false}
                        extra={<OptionButtonItem options={options} value={checkValue} onChange={(value)=> this.handleSelect(value)} />}
                    />
                    <ListItem
                        title="会员优惠"
                        titleStyle={styles.listItemTitle}
                        style={styles.bottomBorderItem}
                        hidden={checkValue !== '2'}
                        extra={
                            <OptionItem
                                item={options[0]}
                                discountAmount={discountAmount}
                                discount={discount}
                                discountAmountLength={8}
                                discountLength={4}
                                changeDiscount={this.changeDiscount}
                                changeDiscountAmount={this.changeDiscountAmount}
                            />
                        }
                    />
                    <ListItem
                        title="最低折扣"
                        titleStyle={styles.listItemTitle}
                        style={styles.bottomBorderItem}
                        hidden={checkValue !== '3'}
                        extra={
                            <OptionItem
                                item={options[1]}
                                discountAmount={discountAmount}
                                discount={discount}
                                discountAmountLength={8}
                                discountLength={4}
                                changeDiscount={this.changeDiscount}
                                changeDiscountAmount={this.changeDiscountAmount}
                            />
                        }
                     />
                     <ListItem
                        title="实收金额"
                        titleStyle={styles.listItemTitle}
                        style={styles.bottomBorderItem}
                        extra={
                            <PriceInputView
                                placeholderTextColor={'#CCCCCC'}
                                rightIcon={rightIcon}
                                inputView={styles.optionItemView}
                                style={{ textAlign: 'right', alignItems: 'center' }}
                                value={realAmount}
                                maxLength={8}
                                placeholder="请输入收款金额"
                                onChangeText={this.changeRealAmount}
                            />
                        }
                     />

                </Content>
                <Text style={{ color: '#999', fontSize: 12, width, textAlign: 'left', marginTop: getwidth(10), marginLeft: getwidth(25) }}>*单笔收款金额上限为100,000元</Text>
                <Content style={{ marginTop: getwidth(15), borderRadius: 10 }}>
                    <TouchableOpacity
                        onPress={this.createQrcode}
                    >
                        <View style={styles.createQrcodeBtn}>
                            <Text style={styles.createQrcodeBtntxt}>生成收款码</Text>
                        </View>
                    </TouchableOpacity>
                </Content>
            </View >

        );
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        flexDirection: 'column',
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    listItemTitle: {
        fontSize: 14,
        fontWeight: '400',
        color: TextSecondColor,
    },
    leftIconStyle: {
        width: getwidth(100),
        fontSize: 16,
        color: '#222',
        paddingLeft: 15,
        alignItems: 'center',
    },
    rightIcon: {
        fontSize: 14,
        color: TextColor,
        marginLeft: 7,
        alignItems: 'center',
    },
    grounp: {
        width: getwidth(355),
        height: 162,
        paddingTop: 10,
        flexDirection: 'column',
        justifyContent: 'space-around',
    },
    optTxt: {
        // width: getwidth(70),
        height: 16,
        fontSize: 14,
        color: '#222222',
        lineHeight: 16,
        marginLeft: 10,
        alignItems: 'center',
    },
    optinItemInputSty: {
        height: 38,
        textAlign: 'right',
        marginRight: 10,
        paddingHorizontal: 10,
        fontSize: 14,
        fontWeight: '400',
    },
    optionItemView: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        width: getwidth(200),
    },
    createQrcodeBtn: {
        width: '100%',
        height: 44,
        backgroundColor: '#4A90FA',
        borderRadius: 10,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    createQrcodeBtntxt: {
        color: '#FFFFFF',
        letterSpacing: 0,
        fontSize: 17,
        marginRight: 10,
        fontWeight: '400',
    },
    options: {
        width: width - getwidth(50),
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginTop: getwidth(10),
    },
    btnSize2: {
        width: getwidth(169),
        height: getwidth(58),
    },
    btnSize: {
        width: getwidth(155),
        height: getwidth(44),
        borderRadius: 6,
        backgroundColor: '#F8F8F8',
        marginLeft: getwidth(7),
        marginRight: getwidth(7),
        marginTop: getwidth(5),
        marginBottom: getwidth(9),
    },
    bottomBorderItem: {
        width: getwidth(355),
        height: getwidth(45),
        borderBottomWidth: 1,
        borderBottomColor: BorderColor,
        paddingHorizontal: getwidth(15),
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    noBorderItem: {
        width: getwidth(355),
        paddingHorizontal: getwidth(15),
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
});
export default ReceiptQrCodeScreen;
