import React, { Component } from 'react';
import { View, Text } from 'react-native';
import { connect } from 'react-redux';
import XKText from './XKText';

const RedPoint = ({ count, maxNumber, showNumber }) => (
  <View style={{
    position: 'absolute',
    right: showNumber ? -9 : -2,
    top: showNumber ? -5 : -1,
    backgroundColor: '#EE6161',
    minWidth: showNumber ? 13 : 8,
    height: showNumber ? 13 : 8,
    borderRadius: showNumber ? 6 : 4,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  }}
  >
    <XKText fontFamily="Oswald" style={{ color: '#fff', fontSize: 10, marginHorizontal: 2 }}>{ showNumber ? count > maxNumber ? `${maxNumber}+` : count : ''}</XKText>
  </View>
);

class IconWithRedPoint extends Component {
  testMessageModules() {
    const { test, messageModules } = this.props;
    if (!test) return 0;
    return Object.keys(messageModules).filter((key) => {
      test.lastIndex = 0;
      return messageModules[key] && test.test(key);
    }).length;
  }

  render() {
    const {
      test, showNumber = false, maxNumber = 99, messageModules, ...others
    } = this.props;
    const count = this.testMessageModules();
    return (
      <View {...others}>
        {this.props.children}
        {count > 0 ? <RedPoint count={count} maxNumber={maxNumber} showNumber={showNumber} /> : null}
      </View>
    );
  }
}

export default connect(state => ({
  messageModules: state.application.messageModules || {},
}))(IconWithRedPoint);
