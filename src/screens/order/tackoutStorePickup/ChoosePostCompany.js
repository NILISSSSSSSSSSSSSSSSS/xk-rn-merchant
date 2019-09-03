import React, { Component } from 'react';
import { View, Text, StyleSheet, Image, ScrollView } from 'react-native';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import List, { ListItem } from '../../../components/List';
import { POST_COMPANY_LIST } from '../../../const/order';
import { connect } from 'rn-dva';
import ModalDemo from '../../../components/Model';
import { NavigationComponent } from '../../../common/NavigationComponent';

class ChoosePostCompanyScreen extends NavigationComponent {
  state = {
    confimVisible: false,
    selectedName: ""
  }
  blurState = {
    confimVisible: false
  }
  changeLogistics = (logisticsName)=> {
    const { navigation, changeLogistics } = this.props;
    changeLogistics({ logisticsName })
    navigation.goBack();
  }

  confirmChangeLogistics(selectedName) {
    this.setState({
      confimVisible: true,
      selectedName,
    })
  }

  renderListHeader(icon, title) {
    return <View style={styles.header}>
      <Image source={icon} style={{ width: 14, height: 14 }}></Image>
      <Text style={styles.title}>{title}</Text>
    </View>
  }

  render() {
    const { confimVisible, selectedName } = this.state;
    const { lastLogisticsName } = this.props;
    const postCompanyList = POST_COMPANY_LIST.filter(({ key })=> key!==lastLogisticsName);
    const postCompanyMap = new Map(POST_COMPANY_LIST.map(({ key, value })=> ([key, value])));
    const postCompanyIconMap = new Map(POST_COMPANY_LIST.map(({ key, icon })=> ([key, icon])));
    const lastLogistics = postCompanyMap.get(lastLogisticsName);
    return (
      <View style={styles.container}>
        <Header title="选择快递公司" goBack />
        <ScrollView>
        {
          lastLogistics ? <List style={styles.list} header={this.renderListHeader(require("../../../images/logistics/countdown.png"), "最近使用")}>
            <ListItem style={styles.listItem} title={postCompanyMap.get(lastLogisticsName)} titleStyle={styles.listItemTitle} icon={postCompanyIconMap.get(lastLogisticsName)} onPress={()=> this.changeLogistics(lastLogisticsName)} />
          </List> : null
        }
          <List style={styles.list} header={this.renderListHeader(require("../../../images/logistics/logistics.png"), "快递公司")}>
              {
                postCompanyList.map(({ key, value })=> {
                  return <ListItem style={styles.listItem} title={value} titleStyle={styles.listItemTitle} icon={postCompanyIconMap.get(key)} onPress={()=> this.confirmChangeLogistics(key)}  />
                })
              }
          </List>
        </ScrollView>
        <ModalDemo 
          noTitle 
          title={"确定使用"+ postCompanyMap.get(selectedName)+"快递？"} 
          leftBtnText="取消"
          rightBtnText="确定"
          visible={confimVisible}
          type="confirm"
          onClose={() => this.setState({ confimVisible: false })}
          onConfirm={() =>this.changeLogistics(selectedName)}
        ></ModalDemo>
      </View>
    );
  }
}

export default connect(state=> ({
  lastLogisticsName: state.order.lastLogisticsName,
  logistics: state.order.logistics,
}), {
  changeLogistics: (item)=> ({ type: "order/changeLogistics", payload: item}),
})(ChoosePostCompanyScreen)

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  list: {
    backgroundColor: '#fff',
    marginHorizontal: 10,
    marginTop: 10,
    borderRadius: 8,
  },
  title: {
    color: '#555',
    fontSize: 15,
    marginLeft: 5,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
    height: 34,
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(0,0,0,0.08)',
    width: '100%',
    paddingHorizontal: 15,
  },
  listItem: {
    paddingHorizontal: 15,
    height: 80,
  },
  listItemTitle: {
    color: '#222',
    fontSize: 14,
    fontWeight: 'bold',
  }
})
