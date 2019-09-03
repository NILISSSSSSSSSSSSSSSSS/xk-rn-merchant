import moment from 'moment'
import React, { Component } from 'react'
import { Text, View, StyleSheet } from 'react-native'
import Header from '../../components/Header';

export default class MessageDetails extends Component {
  render() {
    const { msgContent, updatedAt } = this.props.navigation.state.params;
    return (
      <View>
          <Header title="消息详情" goBack />
          <View style={styles.layoutContainer}>
            <View style={styles.layoutTime}>
              <Text style={styles.time}>{moment(updatedAt * 1000).format("YYYY-MM-DD")}</Text>
            </View>
            <View style={styles.layoutContent}>
              <Text style={styles.content}>{msgContent}</Text>
            </View>
          </View>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  layoutContainer: {
    padding: 15,
    margin: 10,
    borderRadius: 8,
    backgroundColor: '#fff',
  },
  layoutTime: {
    marginBottom: 13
  },
  layoutContent: {
    marginBottom: 5
  },
  time: {
    color: '#999',
    fontSize: 12,
  },
  content: {
    fontSize: 14,
    color: '#444'
  }
})