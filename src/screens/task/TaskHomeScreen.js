import React, { Component } from 'react';
import {
  View, Text, Dimensions, Image, TouchableOpacity, StyleSheet, RefreshControl, StatusBar, ScrollView,
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import { TASK_CATEGORIES, TASK_CATEGORIES_DESPCRIPTION } from '../../const/task';
import CommonStyles from '../../common/Styles';
import { JOIN_AUDIT_STATUS } from '../../const/user';
import { NavigationComponent } from '../../common/NavigationComponent';
import ListEmptyCom from '../../components/ListEmptyCom';

const questionImg = require('../../images/task/question.png');

const { width, height } = Dimensions.get('window');

class TaskHomeScreen extends NavigationComponent {
    state = {
      refreshing: false,
    }

    screenDidFocus = (payload) => {
      super.screenDidFocus(payload);
      this.props.dispatch({ type: 'task/fetchMerchantNewJobPage' });
      StatusBar.setBarStyle('dark-content');
    }

    screenWillBlur = (payload) => {
      super.screenWillBlur(payload);
      StatusBar.setBarStyle('light-content');
    }

    toAcceptanceSetting() {
      const { navigation } = this.props;
      navigation.navigate('TaskSetting', { isSingle: false, taskPosition: navigation.state.params.page });
    }

    toTaskQuestionPage() {
      const { navigation } = this.props;
      navigation.navigate('TaskQuestion', { page: 'TaskHome' });
    }

    toTaskListPage(type, merchantType) {
      const { navigation } = this.props;
      navigation.navigate('TaskList', { page: 'TaskHome', type, merchantType });
    }

    handleRefresh = () => {
      // 刷新数据
      this.setState({ refreshing: true });
      this.props.dispatch({ type: 'task/fetchMerchantNewJobPage' });
      setTimeout(() => {
        this.setState({ refreshing: false });
      }, 2000);
    }

    renderHeader() {
      const { navigation, userInfo } = this.props;
      const title = navigation.state.params.title;
      return (
        <Header
            headerStyle={styles.header}
            navigation={navigation}
            goBack
            title={title}
            backStyle={{ tintColor: '#222' }}
            titleTextStyle={{ color: '#222' }}
            rightView={
                // eslint-disable-next-line eqeqeq
                userInfo.isAdmin == 1 && userInfo.auditStatus == 'active'
                // <TouchableOpacity onPress={() =>this.toAcceptanceSetting()} style={{ width: 86 }}>
                  ? (
                    <TouchableOpacity onPress={() => navigation.navigate('PreAppoint')} style={styles.headerAction}>
                      <Text style={styles.headerText} numberOfLines={1}>预委派</Text>
                    </TouchableOpacity>
                  )
                  : <View style={{ width: 50 }} />
            }
        />
      );
    }

    renderItem(item, index) {
      return (
        <View style={styles.listItem} key={item.merchantType}>
          <View style={styles.listItemTitleWrap}><Text style={styles.listItemTitle}>{`${item.merchantTypeName}身份`}</Text></View>
          <View style={styles.categoryRow}>
            {
                TASK_CATEGORIES_DESPCRIPTION.map(cate => (
                  <View style={styles.categoryColumn} key={cate.type}>
                    <View style={CommonStyles.flex_start}>
                      <TouchableOpacity style={styles.categoryTitleWrap} onPress={() => this.toTaskListPage(cate.type, item.merchantType)}><Text style={styles.categoryTitle}>{cate.name}</Text></TouchableOpacity>
                      <TouchableOpacity style={[styles.btnQuestionImg, index === 0 ? {} : styles.hidden]} onPress={() => this.toTaskQuestionPage(cate.type)}>
                        <Image source={questionImg} style={styles.questionImg} />
                      </TouchableOpacity>
                    </View>
                    <TouchableOpacity style={styles.categoryCountRow} onPress={() => this.toTaskListPage(cate.type, item.merchantType)}>
                      <Text style={styles.categoryCount}>{item[cate.key] == 0 ? '当前暂无任务' : `${cate.type === TASK_CATEGORIES.TrainTask ? '待操作' : '待完成'}(${item[cate.key]})` }</Text>
                    </TouchableOpacity>
                  </View>
                ))
            }
          </View>
        </View>
      );
    }
    renderList() {
      const { refreshing } = this.state;
      const { taskHomeData, auditSuccessMerchantTypes } = this.props;
      const list = taskHomeData.filter(task => auditSuccessMerchantTypes.includes(task.merchantType));
      return (
        <ScrollView
            contentContainerStyle={styles.list}
            refreshControl={(
              <RefreshControl
                colors={['#2ba09d']}
                refreshing={refreshing}
                onRefresh={() => this.handleRefresh()}
              />
            )}
        >
          {
            list.map((task, index) => this.renderItem(task, index))
          }
          {
            list.length === 0 ? <ListEmptyCom type="No_Task" style={{ paddingTop: 108 }} /> : null
          }
        </ScrollView>
      );
    }
    render() {
      return (
        <View style={styles.container}>
          <StatusBar barStyle="dark-content" />
          {this.renderHeader()}
          {this.renderList()}
        </View>
      );
    }
}


export default connect(state => ({
  userInfo: state.user.user || {},
  taskHomeData: state.task.taskHomeData,
  auditSuccessMerchantTypes: (state.user.user.identityStatuses || []).filter(item => item.auditStatus === JOIN_AUDIT_STATUS.success).map(item => item.merchantType),
}))(TaskHomeScreen);

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    backgroundColor: '#FFFFFF',
  },
  header: {
    backgroundColor: '#FFF',
    borderColor: 'rgba(0,0,0,0.08)',
    borderWidth: 1,
  },
  headerTitle: {
    position: 'relative',
    flex: 1,
    alignItems: 'center',
  },
  headerText: {
    fontSize: 17,
    color: '#222',
    textAlign: 'right',
    overflow: 'visible',
    width: 80,
  },
  headerAction: {
    paddingRight: 25,
    width: 50,
    overflow: 'visible',
    justifyContent: 'flex-end',
    flexDirection: 'row',
  },
  list: {
    paddingBottom: 20,
  },
  listItem: {
    marginTop: 20,
    marginHorizontal: 15,
    backgroundColor: '#FAFAFA',
    borderRadius: 6,
    paddingHorizontal: 20,
    paddingVertical: 20,
    flexDirection: 'column',
    justifyContent: 'flex-start',
    alignItems: 'flex-start',
  },
  listItemTitleWrap: {
    width: width - 20 * 4,
    height: 25,
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  listItemTitle: {
    fontFamily: 'PingFangSC-Semibold',
    fontSize: 18,
    color: '#222',
    letterSpacing: 0,
  },
  categoryRow: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
    marginTop: 16,
  },
  categoryColumn: {
    flex: 1,
    flexDirection: 'column',
    justifyContent: 'flex-start',
    alignItems: 'flex-start',
  },
  btnQuestionImg: {
    marginLeft: 6,
  },
  questionImg: {
    width: 16,
    height: 16,
  },
  categoryTitleWrap: {
    height: 22,
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  categoryTitle: {
    fontFamily: 'PingFangSC-Regular',
    fontSize: 16,
    color: '#000000',
    letterSpacing: 0,
  },
  categoryCountRow: {
    marginTop: 12,
    height: 20,
  },
  categoryCount: {
    fontFamily: 'PingFangSC-Regular',
    fontSize: 14,
    color: '#999',
    letterSpacing: 0,
  },
  hidden: {
    display: 'none',
  },
});
