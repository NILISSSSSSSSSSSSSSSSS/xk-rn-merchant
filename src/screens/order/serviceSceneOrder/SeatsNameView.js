/**
 * 服务+现场点单-席位查看
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Content from "../../../components/ContentItem";

const { width, height } = Dimensions.get("window")
const service = require('../../../images/shopOrder/service.png')

function getwidth(val) {
    return width * val / 375
}

export default class SeatsNameView extends Component {
    renderImages = () => {
        let data = this.props.navigation.state.params.images
        if (data.length > 9) {
            data = data.slice(0, 9)
        }
        return data.map((item, index) => {
            return (
                <View key={index} style={[styles.itemImage, { marginTop: 10 }]}>
                    <Image source={{ uri: item }} style={styles.itemImage} />
                </View>
            )
        })
    }
    render() {
        const { navigation } = this.props
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='席位名'
                />
                <View style={styles.mainView}>
                    <ScrollView>
                        {
                            this.renderImages()
                        }
                    </ScrollView>
                </View>
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
    mainView: {
        width: width,
        flex: 1,
        paddingHorizontal: 10,
        backgroundColor: '#fff'
    },
    itemImage: {
        width: getwidth(355),
        height: 178
    }
})
