import React, { Component, } from 'react'
import { View, Text, StyleSheet, StatusBar } from 'react-native'
import CommonStyles from '../../common/Styles'
import Header from '../../components/Header';

export default class TaskQuestionScreen extends Component {
    renderHeader() {
        const { navigation } = this.props;
        return (<Header
            headerStyle={styles.header}
            navigation={navigation}
            goBack={true}
            title="任务说明"
            backStyle={{tintColor: "#222"}}
            titleTextStyle={{color: "#222"}}
        />)
    }
    renderContent() {
        return <View style={styles.contentView}>
            <View style={styles.contentRow}>
                <Text style={styles.title}>培训任务说明</Text>
                <Text style={styles.content}>为了更好的帮助您入驻晓可联盟商，我们提供了一些简单的培训任务需要您完成</Text>
            </View>
            <View style={styles.contentRow}>
                <Text style={styles.title}>审核任务说明</Text>
                <Text style={styles.content}>为了更好的帮助您发展下级联盟商，我们提供了一些任务需要您审核</Text>
            </View>
        </View>
    }
    render() {
        return (
            <View style={styles.container}>
                <StatusBar barStyle={'dark-content'} />
                {this.renderHeader()}
                {this.renderContent()}
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: "#FFF"
    },
    header: {
        backgroundColor: "#FFF",
        borderColor: "rgba(0,0,0,0.08)",
        borderWidth: 1,
    },
    contentView: {

    },
    contentRow: {
        paddingVertical: 26,
        paddingHorizontal: 25,
    },
    title: {
        height: 25,
        lineHeight: 25,
        fontFamily: "PingFangSC-Regular",
        fontSize: 18,
        color: "#000000",
        letterSpacing: 0,
    },
    content: {
        lineHeight: 20,
        fontFamily: "PingFangSC-Regular",
        fontSize: 14,
        color: "#999999",
        letterSpacing: 0,
        marginTop: 20,
    }
})