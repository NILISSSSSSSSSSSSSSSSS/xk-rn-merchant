// 任务中心===>预委派
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    StatusBar,
    TouchableOpacity,
} from 'react-native';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';

const { width, height } = Dimensions.get('window');
export default class PreAppointScreen extends Component {
    static navigationOptions = {
        header: null,
    };
    _didFocusSubscription;
    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('didFocus', async (payload) =>{
            this.getPreAppointCount();
            StatusBar.setBarStyle('light-content');
        });
        this.state = {
            preAppointType : [
                {
                    title: '任务预委派',
                    count: 0,
                    route: 'PreAppointList',
                    type: 'task',
                },
                {
                    title: '验收任务预委派',
                    count: 0,
                    route: 'PreAppointList',
                    type: 'check',
                },
                {
                    title: '审核任务预委派',
                    count: 0,
                    route: 'PreAppointList',
                    type: 'audit',
                },
            ],
        };
    }

    componentDidMount() {

    }
    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
    }
    getPreAppointCount = () => {
        let { preAppointType } = this.state;
        requestApi.merchantDelegateList().then(res => {
            console.log('统计结果',res);
            if (res) {
                preAppointType[0].count = res.jobDelegate || 0;
                preAppointType[1].count = res.checkDelegate || 0;
                preAppointType[2].count = res.auditDelegate || 0;
            }
            this.setState({
                preAppointType,
            });
        }).catch(err => {
            console.log(err);
        });
    }
    render() {
        const { navigation } = this.props;
        const { preAppointType } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    goBack={true}
                    navigation={navigation}
                    title={'预委派'}
                />
                <View style={styles.preAppointInfo}>
                    <Text style={styles.preAppointInfoTitle}>预委派说明</Text>
                    <Text style={styles.preAppointInfoText}>
                        为了更好的帮助您完成任务，您可以预先将任务委派给您的分号进行完成，设置完成之后平台会将新的任务自动分配给分号。
                    </Text>
                </View>
                <View style={styles.preAppointTypeWrap}>
                    {
                        preAppointType && preAppointType.length > 0 && preAppointType.map((item, index) => {
                            let noPaddingBottom = index === preAppointType.length - 1 ? null : { paddingBottom: 30 };
                            return (
                                <TouchableOpacity
                                key={index}
                                style={[styles.preAppintTypeItem,noPaddingBottom]}
                                activeOpacity={0.65}
                                onPress={() => {
                                    navigation.navigate(item.route,
                                        {
                                            title: item.title,
                                            type: item.type,
                                        });
                                }}
                                >
                                    <View style={[CommonStyles.flex_between]}>
                                        <Text style={styles.itemTitle}>
                                        {(item.count !== undefined && item.count !== null) && item.count !== 0 ? `${item.title}(${item.count}人)` : item.title}
                                        </Text>
                                        <Image source={require('../../images/task/right_arrow.png')} />
                                    </View>
                                </TouchableOpacity>
                            );
                        })
                    }
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    preAppointInfo: {
        margin: 10,
        padding: 15,
        backgroundColor: '#fff',
        borderRadius: 8,
    },
    preAppointInfoTitle: {
        color: '#222',
        fontSize: 14,
        paddingBottom: 6,
    },
    preAppointInfoText: {
        fontSize: 12,
        color: '#999',
        lineHeight: 18,
        textAlign: 'left',
    },
    preAppointTypeWrap: {
        marginHorizontal: 10,
        backgroundColor: '#fff',
        paddingHorizontal: 15,
        paddingVertical: 20,
        borderRadius: 8,
    },
    preAppintTypeItem: {
        backgroundColor: '#fff',
    },
    itemTitle: {
        fontSize: 14,
        color: '#222',
    },
});

