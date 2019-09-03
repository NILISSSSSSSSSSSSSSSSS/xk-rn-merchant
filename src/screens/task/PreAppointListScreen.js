// 任务中心===>预委派
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    StatusBar,
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import AppointPicker from '../../components/AppointPicker';
import SwipeListView from '../../components/SwipeListView';
import ListEmptyCom from '../../components/ListEmptyCom';
import ModelView from '../../components/Model';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import { NavigationComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');
class PreAppointListScreen extends NavigationComponent {
    static navigationOptions = {
        header: null,
    };
    flatListRef = null
    constructor(props) {
        super(props);
        this.state = {
            visible: false,
            refreshing: false,
            loading: false,
            isFirstLoad: true,
            confimVis1:false,
            deleteData: {},
        };
    }

    blurState = {
        visible: false,
        confimVis1:false,
    }

    screenDidFocus = (payload)=> {
        super.screenDidFocus(payload);
        StatusBar.setBarStyle('light-content');
    }

    componentDidMount() {
        this.getList();
    }

    getList = (page = 1,limit = 10) => {
        const { navigation } = this.props;
        // 获取预委派列表，task,任务预委派,check,验收任务预委派,audit,审核任务预委派
        const type = navigation.getParam('type','task');
        let params = {page,limit};
        this.props.dispatch({type:'task/getPreAppointList',payload:{type,params}});
    }
    // 保存预委派选择的员工
    handleSave = (res = [], isDelete = false) => {
        const { navigation } = this.props;
        const type = navigation.getParam('type','task');
        let dataSource = this.getListData();
        let request = requestApi.preJobDelegateSetting;
        switch (type) { // 获取保存，不同类型的接口
            case 'task': request = requestApi.preJobDelegateSetting; break;
            case 'check': request = requestApi.preCheckDelegateSetting; break;
            case 'audit': request = requestApi.preAuditDelegateSetting; break;
            default : request = requestApi.preJobDelegateSetting; break;
        }
        let params = {
            userIds: [],
        };
        let temp = [];
        // 获取列表已存在的数据id
        if (dataSource.data.length !== 0 && !isDelete) {
            dataSource.data.map(item => {
                temp.push(item.id);
            });
        }
        // 获取选择的数据id
        res.map(item => {
            temp.push(item.id);
        });
        // 过滤重复选择的Id
        let selectuserIds = [...new Set(temp)];
        params.userIds = selectuserIds;
        request(params).then(res => {
            console.log('保存结果');
            this.getList();
        }).catch(err => {
            console.log(err);
        });
    }
    // 删除预委派员工
    handleDelete = (item) => {
        let _dataList = this.getListData();
        let temp = [];
         _dataList.data.map(listItem => listItem.id !== item.id ? temp.push(listItem) : null);
        this.handleSave(temp,true);
        this.flatListRef.safeCloseOpenRow();
        this.changeState('confimVis1', false);
    }
    // 获取当前预委派类型列表数据
    getListData = () => {
        const { navigation,appointedList } = this.props;
        const type = navigation.getParam('type','task');
        let dataSource = [];
        switch (type) {
            case 'task':dataSource = appointedList[0]; break;
            case 'check':dataSource = appointedList[1]; break;
            case 'audit':dataSource = appointedList[2]; break;
            default: dataSource = appointedList[0]; break;
        }
        return dataSource || [];
    }
    renderHiddenItem = ({item,index}) => {
        let dataSource = this.getListData();
        let topBorderRadius = index == 0 ? styles.topBorderRadius : null;
        let bottomBorderRadius = index == dataSource.data.length - 1 ? styles.bottomBorderRadius : null;
        let br = null;
        if (index === 0){
            br = {
                borderTopRightRadius:8,
            };
        }
        if (index === dataSource.data.length - 1){
            br = {
                borderBottomRightRadius:8,
            };
        }
        if (dataSource.data.length === 1){
            br = {
                borderTopLeftRadius:8,
                borderTopRightRadius:8,
                borderBottomRightRadius:8,
                borderBottomLeftRadius:8,
            };
        }
        return (
            <View style={[styles.hideContaner,topBorderRadius,bottomBorderRadius,CommonStyles.flex_1,CommonStyles.flex_end,br]}>
                <TouchableOpacity
                    style={[styles.hideItemDelete,br]}
                    onPress={() => {
                        this.setState({
                            confimVis1: true,
                            deleteData: item,
                        });
                    }}
                >
                    <Text style={{ color: '#FFFFFF', fontSize: 17 }}>删除</Text>
                </TouchableOpacity>
            </View>
        );
    }
    changeState = (key,value) => {
        this.setState({
            [key]: value,
        });
    }
    onRowDidOpen = (rowKey, rowMap) => {
        setTimeout(() => {
            this.closeRow(rowMap, rowKey);
        }, 2000);
    }
    closeRow(rowMap, rowKey) {
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }
    }
    render() {
        const { navigation} = this.props;
        const { visible,confimVis1 } = this.state;
        let title = navigation.getParam('title','预委派列表');
        const type = navigation.getParam('type','task');
        let dataSource = this.getListData();
        console.log('dataSource',dataSource);
        return (
            <View style={styles.container}>
                <Header
                    goBack={true}
                    navigation={navigation}
                    title={dataSource.data.length === 0 ? title : `${title}(${dataSource.data.length}人)`}
                    titleTextStyle={styles.headerTitleText}
                    rightView={
                        <TouchableOpacity
                        activeOpacity={0.6}
                        style={[styles.addApponiterBtn,CommonStyles.flex_center]}
                        onPress={() => {
                            this.setState({
                                visible: true,
                            });
                        }}
                        >
                            <Text style={styles.addApponiterBtnText}>添加</Text>
                        </TouchableOpacity>
                    }
                />
                {

                    <SwipeListView
                        ListEmptyComponent={<ListEmptyCom type="PreAppointList" />}
                        useFlatList
                        ref={(e) => { e && (this.flatListRef = e); }}
                        data={dataSource.data}
                        style={styles.flatListView}
                        keyExtractor={item=> item.id}
                        renderItem={({item, index}) => {
                            let topBorderRadius = index === 0 ? styles.topBorderRadius : null;
                            let bottomBorderRadius = index == dataSource.data.length - 1 ? styles.bottomBorderRadius : null;
                            return (
                                <TouchableOpacity key={index} activeOpacity={1} style={[styles.appointItem,topBorderRadius,bottomBorderRadius,CommonStyles.flex_start]}>
                                    <Image source={{uri: item.avatar}} style={{width: 50,height:50,borderRadius: 25}} />
                                    <View style={{paddingLeft: 10}}>
                                        <Text style={{color:'#222',fontSize: 14}}>{item.realName || item.nickname}</Text>
                                        <Text style={{color:'#999',fontSize: 12,paddingTop: 5}}>{item.phone}</Text>
                                    </View>
                                </TouchableOpacity>
                            );
                        }}
                        renderHiddenItem={this.renderHiddenItem}
                        ItemSeparatorComponent={()=> null}
                        footerStyle={styles.flatList_footer}
                        store={dataSource}
                        stopLeftSwipe={0.1}
                        stopRightSwipe={-68}
                        leftOpenValue={0.1}
                        rightOpenValue={-68}
                        previewRowKey={'0'}
                        onRowDidOpen={this.onRowDidOpen}
                        refreshData={() => {this.getList(1);}}
                        loadMoreData={() => { this.getList(dataSource.page + 1); }}
                    />
                }


                <AppointPicker
                    type={type}
                    taskId=""
                    visible={visible}
                    onClose={() => {this.setState({visible:false});}}
                    getAppointArr={(res) => {
                        this.handleSave(res);
                    }}
                />
                {/* 删除时候弹窗 */}
                <ModelView
                    noTitle={true}
                    leftBtnText="否"
                    rightBtnText="是"
                    visible={confimVis1}
                    title="是否取消该分号的预委派？"
                    type="confirm"
                    onClose={() => {
                        this.changeState('confimVis1', false);
                    }}
                    onConfirm={() => {
                        this.handleDelete(this.state.deleteData);
                    }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    headerTitleText: {
        color: '#fff',
        fontSize: 17,
    },
    flatListView: {
        backgroundColor: CommonStyles.globalBgColor,
        margin: 10,
        marginTop: 0,
    },
    addApponiterBtn: {
        // marginRight: 25,
        height: '100%',
        width: 50,
        // position:'absolute',
        // top: CommonStyles.headerPadding,
        // right: 25,
    },
    addApponiterBtnText: {
        fontSize:17,
        color: '#fff',
        position:'absolute',
        right: 25,
    },
    hideItemDelete: {
        width: 68,
        height: '100%',
        backgroundColor: '#EE6161',
        justifyContent: 'center',
        alignItems: 'center',
        // marginRight: 10,
    },
    rowBack: {
        width: 68,
        height: '100%',
        backgroundColor: '#EE6161',
        justifyContent: 'center',
        alignItems: 'center',
        position: 'absolute',
        right: 4,
        top: 1,
    },
    flatList: {
        // flex: 1,
        margin: 10,
        backgroundColor: CommonStyles.globalBgColor,
        marginBottom: 10 + CommonStyles.footerPadding,
        // borderRadius: 18,
        // overflow: 'hidden',
        // backgroundColor: 'blue'
    },
    cf14: {
        color: '#FFFFFF',
        fontSize: 14,
    },
    flatList_footer: {
        height: CommonStyles.footerPadding,
    },
    topBorderRadius: {
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
    },
    bottomBorderRadius: {
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
    },
    appointItem: {
        paddingHorizontal:15,
        paddingBottom: 10,
        paddingTop: 15,
        backgroundColor: '#fff',
    },
    hideContaner: {
        backgroundColor: CommonStyles.globalBgColor,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        position: 'absolute',
        top: 0,
        left: 25,
        // backgroundColor:'blue',
    },
    left: {
        // width: 50
        // backgroundColor:'blue',
    },
});
export default connect(
    state => ({
        appointedList:state.task.appointedList || [],
     })
)(PreAppointListScreen);
