/* eslint-disable react/no-unused-state */

import React, { Component } from 'react';
import {
  StyleSheet,
  View,
  Text,
  Image,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../common/Styles';
import Process from './Process';
import CountDown from './CountDown';

export default class WMPrizeType extends Component {
    static defaultProps = {
      type: 'bymember',
      height: 4,
      processValue: 0,
      processLabel: '进度：',
      timeLabel: '时间：',
      showText: '',
      timeValue: moment().format('MM-DD HH:mm'),
      itemWrapStyle: {},
      useCountDown: false, // 是否时间显示为倒计时
      valueStyle: {},
    }

    constructor(props) {
      super(props);
      this.state = {
        countDownTimeOutLabel: '', // 倒计时 时间到了显示文字
      };
    }

    // 显示倒计时
    renderCountDownComponent = () => {
      const { countDownTimeValue, countDownText } = this.props;
      const { countDownTimeOutLabel } = this.state;
      if (countDownTimeOutLabel) {
        return (
          <Text style={styles.countDownText}>{countDownTimeOutLabel}</Text>
        );
      }
      return (
        <CountDown
          // date={new Date(parseInt(endTime))}
          date={!countDownTimeOutLabel ? countDownTimeValue : ''}
          days={{ plural: ' ', singular: ' ' }}
          hours=":"
          mins=":"
          segs="  "
          type="orderApply"
          label={countDownTimeOutLabel}
          daysStyle={[styles.countDownText, countDownText]}
          hoursStyle={[styles.countDownText, countDownText]}
          minsStyle={[styles.countDownText, countDownText]}
          secsStyle={[styles.countDownText, countDownText]}
          firstColonStyle={[styles.countDownText, countDownText]}
          secondColonStyle={[styles.countDownText, countDownText]}
          onEnd={() => {
            this.setState({ countDownTimeOutLabel: '等待开奖中' });
          }}
        />
      );
    }

    /**
     * 后台约定好的四个type
     * bymember 进度满开奖
     * bytime_or_bymember 进度满 或者 时间到再开奖
     * bytime 时间到开奖
     * bytime_and_bymember 时间和进度一起满足再开奖
     */
    getProcessView = (drawType) => {
      const {
        timeLabel, timeValue, labelStyle, itemWrapStyle, useCountDown, countDownTimeValue, countDownText,valueStyle
      } = this.props;
      const { countDownTimeOutLabel } = this.state;
      switch (drawType) {
        case 'bymember':
          return (
            <View style={[styles.processItem, styles.bgBlue, itemWrapStyle]}>
              <Process {...this.props} />
            </View>
          );
        case 'bytime_or_bymember':
          return (
            <React.Fragment>
              <View style={[styles.processItem, styles.bgBlue, itemWrapStyle]}>
                <Process {...this.props} />
              </View>
              <View style={[styles.processItem, styles.flexStart, styles.bgYellow, { marginTop: 2 }, itemWrapStyle]}>
                <Text style={[styles.labelStyle, labelStyle]}>{timeLabel}</Text>
                {
                  !useCountDown // 是否使用倒计时，如果使用判断时间是否到，如果不使用则显示开奖时间
                    ? <Text style={[styles.labelStyle, labelStyle, styles.deepYellow]}>{timeValue}</Text>
                    : this.renderCountDownComponent()
                }
              </View>
            </React.Fragment>
          );
        case 'bytime':
          return (
            <React.Fragment>
              <View style={[styles.processItem, styles.flexStart, styles.bgBlue, itemWrapStyle]}>
                <Text style={[styles.labelStyle, labelStyle]}>{timeLabel}</Text>
                {
                  !useCountDown // 是否使用倒计时，如果使用判断时间是否到，如果不使用则显示开奖时间
                    ? <Text style={[styles.labelStyle, labelStyle, styles.bgDeepBlue, valueStyle]}>{timeValue}</Text>
                    : this.renderCountDownComponent()
                }
              </View>
            </React.Fragment>
          );
        case 'bytime_and_bymember':
          return (
            <React.Fragment>
              <View style={[styles.processItem, styles.bgBlue, itemWrapStyle]}>
                <Process {...this.props} />
              </View>
              <View style={[styles.processItem1, styles.flexStart, styles.bgBlue]}>
                <Text style={[styles.labelStyle, labelStyle]}>{timeLabel}</Text>
                {
                  !useCountDown // 是否使用倒计时，如果使用判断时间是否到，如果不使用则显示开奖时间
                    ? <Text style={[styles.labelStyle, labelStyle, { color: CommonStyles.globalHeaderColor }]}>{timeValue}</Text>
                    : this.renderCountDownComponent()
                }
              </View>
            </React.Fragment>
          );
        default: return null;
      }
    }

    render() {
      const { type } = this.props;
      return (
        <React.Fragment>
          {
            this.getProcessView(type)
          }
        </React.Fragment>
      );
    }
}

const styles = StyleSheet.create({
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexStart_noCenter: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
  },
  flex_1: {
    flex: 1,
  },
  processItem: {
    marginTop: 5,
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 4,
  },
  processItem1: {
    paddingHorizontal: 10,
    paddingBottom: 6,
  },
  labelStyle: {
    fontSize: 12,
    color: '#777',
    paddingRight: 5,
  },
  bgBlue: {
    backgroundColor: '#f0f6ff',
  },
  bgYellow: {
    backgroundColor: '#FFF4E1',
  },
  bgDeepYellow: {
    backgroundColor: '#F5A623',
  },
  deepYellow: {
    color: '#F5A623',
  },
  bgDeepBlue: {
    color: '#4A90FA',
  },
  countDownText: {
    fontSize: 12,
    color: CommonStyles.globalHeaderColor,
  },
});
