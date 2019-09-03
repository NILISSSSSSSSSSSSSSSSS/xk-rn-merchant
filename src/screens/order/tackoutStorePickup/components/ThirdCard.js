/**
 * 物流选择 -  第三方物流信息输入卡片
 */
import React, { Component } from 'react';
import {
  Text, View, TextInput, StyleSheet, Image, Dimensions,
} from 'react-native';
import List, { ListItem, Splitter } from '../../../../components/List';
import { POST_COMPANY_LIST } from '../../../../const/order';
import Button from '../../../../components/Button';
import CommonStyles from '../../../../common/Styles';
import { scanQRCode } from '../../../../config/nativeApi';

const { width, height } = Dimensions.get('window');

export default class ThirdCard extends Component {
  scanQRCode() {
    const { onChange } = this.props;
    scanQRCode().then((res) => {
      if (res) {
        onChange({ logisticsNo: res });
      } else {
        Toast.show('未扫描到任何内容');
      }
    }).catch(err => {
      console.log(err);
    });
  }

  render() {
    const {
      logisticsName = '', logisticsNo, style, onNavigate, onChange,
    } = this.props;
    const postCompanyMap = new Map(POST_COMPANY_LIST.map(({ key, value }) => ([key, value])));
    return (
      <List style={[styles.container, style]}>
        <ListItem
          style={styles.no}
          contentStyle={styles.no}
          titleContainerStyle={styles.noTitle}
          extraContainerStyle={styles.noExtra}
          title={(
            <View style={[CommonStyles.flex_between, { width: width - 50 }]}>
              <Text>快递单号</Text>
              <Button type="link" onPress={() => this.scanQRCode()}>
                <Image source={require('../../../../images/logistics/scan.png')} style={{ width: 18, height: 18 }} />
              </Button>
            </View>
          )}
          horizontal={false}
          extra={<TextInput style={styles.textinput} value={logisticsNo} placeholder="请输入快递单号" placeholderTextColor="#CCC" returnKeyLabel="确定" returnKeyType="done" onChangeText={text => onChange({ logisticsNo: text })} />}
        />
        <Splitter />
        <ListItem
          onPress={onNavigate}
          style={styles.post}
          titleContainerStyle={styles.post}
          titleStyle={styles.postTitle}
          title="选择快递公司"
          extra={postCompanyMap.get(logisticsName)}
          extraContainerStyle={{ height: 30 }}
          extraStyle={styles.extra}
          arrow
        />
      </List>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    backgroundColor: '#fff',
    borderRadius: 8,
  },
  no: {
    height: 74,
    paddingVertical: 0,
  },
  post: {
    height: 44,
  },
  noExtra: {
    height: 34,
  },
  noTitle: {
    height: 40,
  },
  textinput: {
    color: '#777',
    fontSize: 14,
    paddingVertical: 0,
  },
  extra: {
    fontSize: 14,
    color: '#222222',
  },
});
