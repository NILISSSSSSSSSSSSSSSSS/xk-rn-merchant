import React, { Component } from 'react';
import {
  Text, View, ImageBackground, Dimensions, StyleSheet, TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import Icon from '../../../components/Icon';
import ImageView from '../../../components/ImageView';

const listCardBg = require('../../../images/my/list-card-bg.png');

const IconMap = {
  anchor: require('../../../images/my/ico-zb.png'),
  familyL1: require('../../../images/my/ico-jzz.png'),
  familyL2: require('../../../images/my/ico-gh.png'),
  shops: require('../../../images/my/ico-sh.png'),
  personal: require('../../../images/my/ico-gr.png'),
  company: require('../../../images/my/ico-hhr.png'),
};

const IconMap2 = {
  audit_fail: require('../../../images/my/ico-wtg.png'),
  un_active: require('../../../images/my/ico-djh.png'),
  step_audited: require('../../../images/my/ico-shz.png'),
  un_audit: require('../../../images/my/ico-shz.png'),
  un_pass: require('../../../images/my/ico-wtg.png'),
};

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return (width * val) / 375;
}


export default class MerchantListCard extends Component {
  handlePress = ({
    type, title, status, familyUp, updateAuditStatus,
  }) => {
    const { onPress } = this.props;
    switch (status) {
      case 'un_active': // 待激活
        onPress({ path: 'AccountActive', params: { route: 'My', merchantType: type } });
        break;
      case 'step_audited': // 审核中和审核失败
      case 'audit_fail':
      case 'un_audit':
      case 'active': // /已激活，已入驻
        onPress({
          path: 'MyApplyForm',
          params: {
            route: 'My', merchantType: type, auditStatus: status, name: title, familyUp, updateAuditStatus,
          },
        });
        break;
      default:
        onPress({
          path: 'MyApplyForm',
          params: {
            route: 'My', merchantType: type, name: title, familyUp, updateAuditStatus,
          },
        });
        break;
    }
  }
  render() {
    const { merchantTypes } = this.props;
    return (
      <ImageBackground source={listCardBg} style={styles.cardBg}>
        <View style={styles.content}>
          {
            merchantTypes.map((item) => {
              // un_audit, //待审核，审核中
              // step_audited, //流程审核完成(任务完成)
              // audit_fail, //审核未通过
              // un_active, //审核通过，待激活
              // active, //已激活，已入驻
              const {
                type, title, status, updateAuditStatus
              } = item;
              const activing = !!status;
              const ico = IconMap[type] || IconMap.anchor;
              const titleStyle = activing ? { color: '#4A90FA' } : { color: '#999' };
              const tintStyle = activing ? { tintColor: '#4A90FA' } : { tintColor: '#999' };
              const auditStatus = status;

              return (
                <TouchableOpacity style={styles.iconContainer} onPress={() => this.handlePress(item)}>
                  <Icon source={ico} size={22} title={title} titleStyle={[{ marginTop: getwidth(10), fontSize: 12 }, titleStyle]} iconStyle={tintStyle} />
                  {
                    ['un_audit', 'step_audited', 'audit_fail', 'un_active', 'un_pass'].includes(auditStatus)
                      ? <ImageView style={styles.iconTips} source={IconMap2[auditStatus]} sourceWidth={getwidth(42)} sourceHeight={getwidth(18)} />
                      : null
                  }
                </TouchableOpacity>
              );
            })
          }
        </View>
      </ImageBackground>
    );
  }
}

const styles = StyleSheet.create({
  cardBg: {
    width: getwidth(355),
    height: getwidth(185),
    justifyContent: 'center',
    alignItems: 'center',
    marginVertical: -getwidth(22),
  },
  content: {
    width: getwidth(325),
    height: getwidth(146),
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-around',
    alignItems: 'center',
    backgroundColor: '#fff',
    borderRadius: 4,
    paddingVertical: getwidth(10),
  },
  iconContainer: {
    width: getwidth(108),
    height: getwidth(63),
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  iconTips: {
    position: 'absolute',
    top: getwidth(-0.5),
    right: getwidth(10),
  },
});
