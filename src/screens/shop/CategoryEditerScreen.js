/**
 * 品类管理
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,

    View,
    Text,
    Image,
    Alert,
    Modal,
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as regular from '../../config/regular';
import ImageView from '../../components/ImageView';
import FlatListView from '../../components/FlatListView';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import TextInputView from '../../components/TextInputView';
import ModalDemo from '../../components/Model'
import { NavigationPureComponent } from '../../common/NavigationComponent';
import CommonButton from '../../components/CommonButton';

const { width, height } = Dimensions.get('window');
function getwidth(val) {
    return width * val / 375
}

class CategoryEditerScreen extends NavigationPureComponent {
    constructor(props) {
        super(props)
        const {item={},callback=()=>{},lists=[],page='add',mShopId}=this.props.navigation.state.params || {}
        this.state = {
            visible: false,
            title: item.levelOneName || '请选择分类',
            mShopId:mShopId || item.mShopId,
            page,
            cateName: item.name,  //分类名称，
            itemid:item.id,
            serviceCatalogCode: item.serviceCatalogCode,
            lists,
            alertVisible: false,
            callback:callback || (()=>{})
        }
    }
    blurState = {
        visible: false,
        alertVisible: false
    }
    saveData = () => {
        //保存数据
        const { cateName, serviceCatalogCode, title, mShopId,page } = this.state
        const { navigation } = this.props
        if (page === 'add') {
            let param = {
                name: cateName,
                mShopId,
                serviceCatalogCode: serviceCatalogCode
            }
            if (!cateName) {
                Toast.show('请输入品类名称', 2000)
                return;
            }
            if (title == '请选择分类') {
                Toast.show('请选择分类数据', 2000)
                return;
            }
            if (cateName.length > 5) {
                Toast.show('品类名称长度不得大于5个字', 2000)
                return;
            } else {
                Loading.show()
                requestApi.goodsCatalogCreate(param).then((res) => {
                    //请求列表数据
                    this.state.callback()
                    navigation.goBack()
                }).catch(()=>{
          
                });
            }
        } else {
            this.setState({
                alertVisible: true
            })
        }
    }
    //保存修改的数据
    saveEditor = () => {
        const { cateName,mShopId,itemid,serviceCatalogCode } = this.state
        const { navigation } = this.props
        let param = {
            name: cateName,
            mShopId,
            serviceCatalogCode,
            goodsCatalogId: itemid //自定义分类id
        }
        if (!cateName) {
            Toast.show('请输入品类名称', 2000)
            return;
        }
        if (cateName.length > 5) {
            Toast.show('品类名称长度不得大于5个字', 2000)
            return;
        } else {
            Loading.show()
            requestApi.goodsCatalogUpdate(param).then((res) => {
                this.state.callback()
                navigation.goBack()
            }).catch(()=>{
          
            })
        }
    }
    handleClickCate = () => {
        this.setState({
            visible: true
        })
    }
    categroyName = (val) => {
        this.setState({
            cateName: val
        })
    }
    render() {
        const { navigation } = this.props
        const { title, cateName, alertVisible ,lists,page,  itemid} = this.state
        // state.params.data   下拉选择的服务的数据
        // data  选择的分类
        // mShopId 当前店铺的id
        // page  增加还是修改
        let headerTitle = '新增品类'
        let rightTxt = '确定'
        let editorBtn = null
        let ismodal = true
        if (page === 'edit'){
            ismodal = false
            headerTitle = '编辑品类'
            rightTxt = '删除'
            editorBtn = (
                <CommonButton onPress={this.saveEditor} title='保存'/>
            )
        }
        return (
            <View style={styles.container}>
                <Header
                    title={headerTitle}
                    navigation={navigation}
                    goBack={true}
                    rightView={<TouchableOpacity
                        onPress={this.saveData}
                        // disabled={!canpress}
                        style={{ width: 50 }}
                    >
                        <Text style={{ fontSize: 17, color: '#fff' }}>{rightTxt}</Text>
                    </TouchableOpacity>}
                />
                <ModalDemo
                    title='确定删除该品类?'
                    visible={alertVisible}
                    onConfirm={() => {
                        this.setState({ alertVisible: false })
                        requestApi.goodsCatalogDelete({ goodsCatalogId: itemid }).then((res) => {
                            this.state.callback()
                            navigation.goBack()
                        }).catch(()=>{
          
                        });
                    }}
                    onClose={() => { this.setState({ alertVisible: false }) }} type='confirm' />
                <Content>
                    <View style={styles.mainview}>
                        <View style={styles.topcontent}>
                            <Text style={{ fontWeight: '500', color: '#222' }}>品类</Text>
                            <TouchableOpacity disabled={page === 'edit'?true:false} onPress={this.handleClickCate} >
                                <Text style={styles.choseVal}>{title}</Text>
                            </TouchableOpacity>
                        </View>
                        <View style={styles.line}></View>
                        <TextInputView
                            leftIcon={null}
                            rightIcon={null}
                            inputView={styles.inputVewStyle}
                            value={cateName}
                            placeholder='请输入品类名称'
                            onChangeText={this.categroyName}
                        />
                    </View>
                </Content>
                {
                    editorBtn
                }
                {
                    ismodal && (
                        <Modal
                            animationType={'none'}
                            transparent={true}
                            visible={this.state.visible}
                            style={{ width: width }}
                            onRequestClose={() => { this.setState({ visible: false }) }}
                        >
                            <TouchableOpacity style={{ position: 'absolute', right: getwidth(30), height: height, width: width, flexDirection: 'row', justifyContent: 'flex-end' }} onPress={() => { this.setState({ visible: false }) }}>
                                <View style={styles.modalView}>
                                    <View style={{ borderWidth: 1, borderColor: '#DDDDDD', borderRadius: 10, paddingHorizontal: 10, backgroundColor: 'white',width:'100%' }}>
                                        <View style={styles.sanjiao}></View>
                                        {
                                            lists.map((item, index) => {
                                                return (
                                                    <Line
                                                        title={item.levelOneName}
                                                        key={index}
                                                        style={{ paddingHorizontal: 0, backgroundColor: '#fff',height:50 ,paddingRight:0,paddingLeft:0}}
                                                        leftStyle={{ width: '100%', textAlign: 'center'}}
                                                        onPress={() => {
                                                            this.setState({ visible: false, optionKey: index, title: item.levelOneName, serviceCatalogCode: item.levelOneCode })
                                                        }}
                                                        point={null}
                                                    />
                                                )
                                            })
                                        }
                                    </View>
                                </View>


                            </TouchableOpacity>
                        </Modal>
                    )
                }
            </View >
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor
    },
    mainview: {
        width: getwidth(355),
        alignItems: 'center',
    },
    sanjiao: {
        width: 20,
        height: 20,
        marginLeft: getwidth(40),
        borderWidth: 1,
        marginTop: -10,
        backgroundColor: 'white',
        borderLeftColor: '#DDDDDD',
        borderTopColor: '#DDDDDD',
        borderRightColor: 'white',
        borderBottomColor: 'white',
        transform: [{ rotateZ: '45deg' }],
    },
    modalView: {
        width: getwidth(120),
        top: 98 + CommonStyles.headerPadding,
    },
    inputVewStyle: {
        width: getwidth(355),
        height: 50,
        paddingHorizontal:20
    },
    topcontent: {
        height: 50,
        width: getwidth(355),
        paddingHorizontal:20,
        flexDirection: 'row',
        flexWrap: 'nowrap',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    choseVal: {
        paddingRight: getwidth(20)
    },
    line: {
        width: getwidth(325),
        marginLeft:20,
        marginRight:20,
        height: 0,
        borderWidth: 0.5,
        borderColor: '#CCCCCC'
    },
    createQrcodeBtn: {
        width: '100%',
        height: 44,
        backgroundColor: '#4A90FA',
        borderRadius: 10,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    createQrcodeBtntxt: {
        color: '#FFFFFF',
        letterSpacing: 0,
        fontSize: 17,
        marginRight: 10
    }
})


export default connect(
    (state) => ({ store: state }),
)(CategoryEditerScreen);
