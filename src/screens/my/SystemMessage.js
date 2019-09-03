/**
 * 我的/系统消息
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
import { connect } from 'rn-dva';
import moment from 'moment';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi';
import * as utils from '../../config/utils';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import IconWithRedPoint from '../../components/IconWithRedPoint';

const { width, height } = Dimensions.get('window');

class SystemMessage extends PureComponent {
    static navigationOptions = {
      header: null,
    }

    constructor(props) {
      super(props);
      const { page, currentData } = this.props.navigation.state.params || {};
      this.state = {
        valuableTime: '2018-03-12',
        endTime: '2018-03-22',
        modelVisible: false,
        currentData: currentData || {},
        page: page || 'card',
      };
    }


    componentDidMount() {
      Loading.show();
      requestApi.sysFictitiousUserList().then((res) => {
        res ? this.props.userSave({ messageData: res }) : null;
      }).catch(err => {
        console.log(err)
      });
    }
    componentWillUnmount() {
    }
    render() {
      const { navigation, messageData, messageMapDesc } = this.props;
      const modCodeMap = {
        '001': /^user.system.systemMessage/gm,
        '002': /^user.system.huodongMessage/gm,
        '007': /^user.system.shangquanMessage/gm,
        '004': /^user.system.selfMall/gm,
        '005': /^user.system.wfMall/gm,
        '006': /^user.system.choujiangMessage/gm,
      };
      const items = [
        { title: '活动', data: messageData.find(item => item.code == '002'), icon: require('../../images/message/activity.png') },
        { title: '专题', data: messageData.find(item => item.code == '003'), icon: require('../../images/message/special.png') },
        { title: '自营商城消息', data: messageData.find(item => item.code == '004'), icon: require('../../images/message/self.png') },
        { title: '福利商城消息', data: messageData.find(item => item.code == '005'), icon: require('../../images/message/welfare.png') },
        { title: '抽奖/AA彩', data: messageData.find(item => item.code == '006'), icon: require('../../images/message/choujiang.png') },
        { title: '系统提示', data: messageData.find(item => item.code == '001'), icon: require('../../images/message/system.png') },
        { title: '周边消息', data: messageData.find(item => item.code == '007'), icon: require('../../images/message/around.png') },
      ];
      return (
        <View style={styles.container}>
          <Header
                    title="系统通知"
                    navigation={navigation}
                    goBack
          />
          <ScrollView>
            <Content style={styles.content}>
              {
                            items.map((itemArr, index) => {
                              const item = itemArr.data;
                              const desc = item && messageMapDesc[item.code] || {};
                              console.log(desc);
                              return item && item.platform && item.platform.find(itemPlat => itemPlat == 'ma') && (
                              <TouchableOpacity
                                        onPress={() => {
                                          navigation.navigate('Message', { ...item, title: itemArr.nickname || item.nickname });
                                          if (modCodeMap[item.code]) {
                                            const modName = modCodeMap[item.code].source.slice(1);
                                            this.props.changeMessageModules({ modules: [modName], flag: false });
                                          }
                                        }}
                                        style={[styles.item]}
                                        key={index}
                              >
                                <ImageView
                                            source={itemArr.icon}
                                            sourceWidth={40}
                                            sourceHeight={40}
                                            style={{ marginRight: 15, width: 40, height: 40 }}
                                />
                                <View style={{ flex: 1 }}>
                                  <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                                    <IconWithRedPoint test={modCodeMap[item.code]}>
                                      <Text style={{ color: '#424242', fontSize: 17 }}>{item.nickname}</Text>
                                    </IconWithRedPoint>
                                    <Text style={[styles.rightText]}>{desc.time ? moment(desc.time).fromNow() : ''}</Text>
                                  </View>
                                  {
                                    desc.message
                                      ? (
                                        <Text
                                            style={{
                                              color: '#999', fontSize: 12, marginTop: 6, marginRight: 25,
                                            }}
                                            numberOfLines={1}
                                        >
                                          {desc.message}
                                        </Text>
                                      ) : null
                                    }
                                </View>
                              </TouchableOpacity>
                              );
                            })
                        }
            </Content>
          </ScrollView>
        </View>
      );
    }
}
const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    backgroundColor: CommonStyles.globalBgColor,
    alignItems: 'center',
  },
  content: {
    overflow: 'hidden',

  },
  item: {
    borderBottomWidth: 1,
    borderColor: '#F1F1F1',
    paddingHorizontal: 15,
    paddingVertical: 10,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    flex: 1,
  },
  rightText: {
    color: '#777777',
    fontSize: 14,
    textAlign: 'right',
  },
});

export default connect(
  state => ({
    messageMapDesc: state.application.messageMapDesc || {},
    messageData: state.user.messageData || [],
  }), {
    changeMessageModules: (payload = {}) => ({ type: 'application/changeMessageModules', payload }),
    userSave: (payload = {}) => ({ type: 'user/save', payload }),
  },
)(SystemMessage);
