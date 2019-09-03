/**
 * 交易记录
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
} from 'react-native'

import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import moment from 'moment'
import Content from '../../components/ContentItem'
import FlatListView from '../../components/FlatListView'

const { width, height } = Dimensions.get('window')
function getwidth(val) {
    return width * val / 375
}

export default class TransactionRecord extends Component {
    state = {
        data: [1, 2, 3],
        store: {
            refreshing: false,
            loading: false,
            hasMore: true,
            isFirstLoad: true
        }
    }
    requestFirst = () => {
        const { store } = this.state
        store.refreshing = true
        this.setState({
            store
        })
        let newdata = []
        for (let i = 0; i < 10; i++) {
            newdata.push(i)
        }
        let hasMore = true
        if (newdata.length < 10) {
            hasMore = false
        }
        store.hasMore = hasMore
        store.refreshing = false
        store.isFirstLoad = false
        this.setState({
            data: newdata,
            store
        })
    }
    componentDidMount() {
        this.requestFirst()
    }
    renderSeparator = () => {
        return <View style={styles.separator} />
    }
    refreshData = () => {
        this.requestFirst()
    }
    loadMoreData = () => {
        const { data, store } = this.state
        let newdata = []
        for (let i = 0; i < 9; i++) {
            newdata.push(i)
        }
        let hasMore = true
        if (newdata.length < 10) {
            hasMore = false
        }
        store.hasMore = hasMore
        store.loading = false
        this.setState({
            data: data.concat(newdata),
            store
        })
    }
    renderItem = () => {
        let txtcolor = '#EE6161'
        return (
            <View style={styles.listItem}>
                <View style={styles.topItem}>
                    <Text style={styles.tixianTxt}>提现</Text>
                    <Text style={{ color: txtcolor, fontSize: 20 }}>-20</Text>
                </View>
                <View style={styles.bottomItem}>
                    <Text style={styles.itemdate}>2018-10-10</Text>
                    <Text style={styles.tixianStatus}>流水号：EC22541646465</Text>
                </View>
            </View>
        )
    }
    render() {
        const { navigation } = this.props
        const { data, store } = this.state
        const param = navigation.state.params
        // console.log('====param', param)
        return (
            <View style={styles.container} >
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={param.title}
                />
                <FlatListView
                    data={data}
                    style={{ width: getwidth(355), height: height - CommonStyles.headerPadding }}
                    renderItem={this.renderItem}
                    store={store}
                    ItemSeparatorComponent={this.renderSeparator}
                    refreshData={this.refreshData}
                    loadMoreData={this.loadMoreData}
                    footerStyle={{ backgroundColor: '#fff' }}
                />
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    separator: {
        borderColor: '#F1F1F1',
        width: width,
        height: 0,
        borderWidth: 0.5
    },
    listItem: {
        width: getwidth(355),
        height: 65,
        paddingVertical: 10
    },
    topItem: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 45 / 2,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    bottomItem: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 45 / 2,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    tixianTxt: {
        color: '#222222',
        fontSize: 14
    },
    tixianStatus: {
        color: '#999999',
        fontSize: 12
    },
    itemdate: {
        color: '#999999',
        fontSize: 12
    }
})
