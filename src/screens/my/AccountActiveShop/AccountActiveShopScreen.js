import React, { Component } from 'react';
import {
  View, Text, StyleSheet, ScrollView, Dimensions,
} from 'react-native';

import { connect } from 'rn-dva';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import ActiveShopInfo from './sections/ActiveShopInfo';
import ActiveShopEdit from './sections/ActiveShopEdit';
import Button from '../../../components/Button';
import ShowBigPicModal from '../../../components/ShowBigPicModal';
import { NavigationComponent } from '../../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');

const getWidth = dP => dP * width / 375;

class AccountActiveShopScreen extends NavigationComponent {
  constructor(props) {
    super(props);
    this.state = {
      canEdit: false,
      showBigPicArr: [],
      showBigModal: false,
      showIndex: 0,
    };
  }

  blurState = {
    showBigModal: false,
  }

  handleEdit= () => {
    this.setState({
      canEdit: true,
    });
  }

  handleShowBigModal = (showBigPicArr = [], showIndex = 0) => {
    this.setState({
      showBigPicArr,
      showIndex,
      showBigModal: true,
    });
  }

  render() {
    const { payTmpl } = this.props;
    const actived = payTmpl.authStatus === 'SUCCESS';
    const failed = payTmpl.authStatus === 'FAILED';
    const {
      canEdit, showBigPicArr, showIndex, showBigModal,
    } = this.state;
    /**
     * 没有数据，可编辑
     * 编辑状态，可编辑
     * 激活成功，不可编辑
     */
    const editable = (!payTmpl.authStatus || canEdit) && !actived;
    const canUpdate = payTmpl.authStatus && !actived && !canEdit;

    console.log(editable, canUpdate);

    return (
      <View style={styles.container}>
        <Header goBack title="结算账户信息" rightView={canUpdate ? <Button type="link" title="修改" titleStyle={styles.btnUpdate} onPress={() => this.handleEdit()} /> : null} />
        {
          failed ? (
            <View style={styles.autfailView}>
              <View style={styles.failicon}><Text style={{ fontSize: 17, color: '#FFC125' }}>!</Text></View>
              <Text style={styles.autfailViewText}>
                {`审核不通过原因：${payTmpl.remark}`}
              </Text>
            </View>
          )
            : null
        }
        <ScrollView contentContainerStyle={{ paddingBottom: 15 }}>
          {
            !editable ? <ActiveShopInfo onShowBigModal={this.handleShowBigModal} /> : <ActiveShopEdit onShowBigModal={this.handleShowBigModal} />
          }
        </ScrollView>
        <ShowBigPicModal
          ImageList={showBigPicArr}
          visible={showBigModal}
          showImgIndex={showIndex}
          onClose={() => {
            this.setState({
              showBigModal: false,
            });
          }}
        />
      </View>
    );
  }
}

export default connect(state => ({
  payTmpl: state.userActive.payTmpl || {},
}), {

})(AccountActiveShopScreen);

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    paddingBottom: CommonStyles.footerPadding,
    backgroundColor: CommonStyles.globalBgColor,
  },
  btnUpdate: {
    color: '#fff',
    paddingHorizontal: 15,
  },
  autfailView: {
    backgroundColor: '#FFEBCD',
    paddingHorizontal: 15,
    paddingVertical: 10,
    flexDirection: 'row',
    alignItems: 'center',
  },
  autfailViewText: {
    fontSize: 14,
    color: CommonStyles.globalRedColor,
  },
  failicon: {
    borderColor: '#FFC125',
    borderWidth: 2,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
    width: 24,
    height: 24,
    marginRight: 10,
  },
});
