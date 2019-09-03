/**
 * 店铺营业时间设置
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
    TouchableOpacity,
} from 'react-native';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import Picker from '../../components/Picker';
import PickerOld from 'react-native-picker-xk';
const { width, height } = Dimensions.get('window');
export default class StoreYingyeTimeScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        let { newBusinessTime={} } = this.props.navigation.state.params
        this.state = {
            startAt :newBusinessTime.startAt || '09:00',
            endAt :newBusinessTime.endAt || '22:00',
        }
    }

    componentDidMount() {
    }

    componentWillUnmount() {
        PickerOld.hide()
    }
    _showTimePicker = (witch) => {
      const {endAt,startAt}=this.state
        Picker._showTimePicker('time', (data) => {
            if(witch=='startAt' && data>endAt) {
              Toast.show('开始时间不能大于结束时间')
              return
            }
            if(witch=='endAt' && data<startAt) {
              Toast.show('结束时间不能小于开始时间')
              return
            }
            this.setState({ [witch]:data })
        }, null,(this.state[witch]).split(':'))
    }
    save = () => {
        const { navigation } = this.props;
        const {startAt,endAt}=this.state
        navigation.state.params.callback({ startAt,endAt })
        navigation.goBack()
    }


    render() {
        const { navigation } = this.props;
        const {startAt,endAt}=this.state
        return (
            <View style={styles.container}>
                <Header
                    title='店铺营业时间设置'
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
                <ScrollView alwaysBounceVertical={false}>
                    <View style={styles.content}>
                        <Content>
                          <Text style={{padding:15,color:'#222'}}>每日营业时间</Text>
                          <View style={styles.selectView}>
                            <TouchableOpacity
                              onPress={() => this._showTimePicker('startAt')}
                              style={[styles.slectButton,{backgroundColor:startAt?'#F6F6F6':'#EAF1FF'}]}
                            >
                              <Text style={{color:startAt?'#222':'#4A90FA'}}>{startAt || '请选择开始时间'}</Text>
                            </TouchableOpacity>
                            <Text style={{padding:15,color:'#222',textAlign:'center'}}>至</Text>
                            <TouchableOpacity
                              onPress={() => this._showTimePicker('endAt')}
                              style={[styles.slectButton,{backgroundColor:startAt?'#F6F6F6':'#F6F6F6'}]}
                            >
                              <Text style={{color:startAt?'#222':'#CCCCCC'}}>{endAt || '请选择结束时间'}</Text>
                            </TouchableOpacity>
                          </View>
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
    slectButton:{
      borderRadius:22,
      height:44,
      width:width-50,
      alignItems:'center',
      justifyContent:'center'
    },
    selectView:{
      paddingHorizontal:15,
      paddingVertical:20,
      borderTopColor:'#f1f1f1',
      borderTopWidth:1
    }


});
