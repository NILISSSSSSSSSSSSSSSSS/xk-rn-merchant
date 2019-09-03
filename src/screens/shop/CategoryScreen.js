/**
 * 品类管理
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    Platform,
    RefreshControl,
    ScrollView,
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
const { width, height } = Dimensions.get('window');
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import { NavigationComponent } from '../../common/NavigationComponent';
import {sortLists} from '../../config/utils';
function getwidth(val) {
    return width * val / 375
}

class CategoryScreen extends NavigationComponent {
    static navigationOptions = {
        header: null
    }
    constructor(props) {
        super(props)
        this.state = {
            serviceCatalogList: props.serviceCatalogList,  //所有服务类数据
            currentShop:props.userShop,
            refreshing:false,
            lists:[],
        }
    }
    _onRefresh=(refreshing)=>{
      refreshing?this.setState({refreshing:true}):null
      requestApi.shopCatalogAliasQueryAll({shopId:this.state.currentShop.id}).then((data)=>{
        this.setState({
          lists:sortLists(data || []),
          refreshing:false
        })
      }).catch((error)=>{
        console.log(error)
        refreshing?this.setState({refreshing:false}):null
      })

    }

    componentDidMount() {
      Loading.show()
      this._onRefresh()
    }

    componentWillUnmount() {
        RightTopModal.hide()
    }
    editerItem = (item) => {
        const { navigation,} = this.props
        navigation.navigate('CategoryEditer', {
          item,
          page:'edit',
          lists:this.state.lists,
          callback: ()=>this._onRefresh(1)
        })
    }
    renderItem = ({ item, index }) => {
        return (
            <Content style={{ width: width - 20, marginLeft: 10 }} key={index}>
                <View style={styles.itemTop}>
                    <Image
                        style={{ width: 40, height: 40, borderRadius: 20 }}
                        source={this.getIcon(item.levelOneName)}
                    />
                    <View style={{marginLeft: 15}}>
                      <Text style={styles.ItemTitle}>{item.levelOneName}</Text>
                      <Text style={{color:'#999999',fontSize:12}}>自定义名称：{item.alias}</Text>
                    </View>

                </View>
                <View style={{ paddingLeft: 54 }}>
                    {
                        item.goodsCatalogList.map((item2, index) => {
                            return (
                                <Line
                                    type='horizontal'
                                    key={index}
                                    title={item2.name}
                                    point={null}
                                    onPress={() => this.editerItem({...item2,levelOneName:item.levelOneName})}
                                />
                            )
                        })
                    }
                </View>
            </Content>
        )
    }
    showPopover() {
        let options=[]
        options=[...this.props.juniorShops]
        options.map(item=>{
            item.title=item.name
            item.onPress=()=>{
                this.setState({  currentShop: item }, () => {
                  ()=>this._onRefresh(1)
                })
            }
        })
        RightTopModal.show({
           options,
            children:<View style={{position:'absolute',top:Platform.OS=='ios'? 0:-CommonStyles.headerPadding}}>{this.renderHeader()}</View>,
            sanjiaoStyle:{right:60}
        })
    }
    getIcon=(serviceCatalogName)=>{
      switch(serviceCatalogName){
        case '服务类':return require('../../images/categroy/fuwulei.png');
        case '商品类':return require('../../images/categroy/shangpinglei.png');
        case '住宿类':return require('../../images/categroy/zhusule.png');
        case '外卖类':return require('../../images/categroy/waimeilei.png');
        case '在线购物':return require('../../images/categroy/online.png');
        default :return ''
      }
    }
    renderHeader=()=>{
        const { navigation, } = this.props;
        const { lists, currentShop} = this.state
        return(
            <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                            <Text style={{ fontSize: 17, color: '#fff' }}>品类管理</Text>
                            <TouchableOpacity
                                onPress={() => this.showPopover()}
                                style={{ width: 50, position: 'absolute', right: 0, top: 0, }}
                            >
                                <Text style={{ fontSize: 17, color: '#fff' }}>筛选</Text>
                            </TouchableOpacity>
                        </View>
                    }
                    rightView={
                        <TouchableOpacity
                            onPress={() => navigation.navigate('CategoryEditer', {
                                page: 'add',
                                mShopId: currentShop.id,
                                lists,
                                callback: ()=>this._onRefresh(1)
                            })}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                                新增
                            </Text>
                        </TouchableOpacity>
                    }
                />
        )
    }

    render() {
        const { navigation} = this.props;
        const {  currentShop,  lists,refreshing } = this.state
        return (
            <View style={styles.container}>
                {this.renderHeader()}
                <View style={styles.topLine}>
                    <Text style={styles.topTitle}>{currentShop.name}</Text>
                    <TouchableOpacity
                      onPress={()=>navigation.navigate('CategoryFirstSetting',{
                        lists,
                        shopId:this.state.currentShop.id,
                        getIcon:this.getIcon,
                        callback:()=>this._onRefresh(1)
                        })}>
                      <Text style={{color:CommonStyles.globalHeaderColor}}>一级分类设置</Text>
                    </TouchableOpacity>
                </View>
                <ScrollView
                showsHorizontalScrollIndicator={false}
                showsVerticalScrollIndicator={false}
                contentContainerStyle={{paddingBottom:CommonStyles.footerPadding+20}}
                refreshControl={(
                  <RefreshControl
                    refreshing={refreshing}
                    onRefresh={()=>this._onRefresh(1)}
                  />
                )}
              >
                {
                  lists.map((item,index)=>{
                    return this.renderItem({item,index},lists)
                  })
                }
                </ScrollView>
            </View >
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
        position: 'relative'
    },
    modal: {
        width: width,
        height: height - 44 - CommonStyles.headerPadding,
        marginTop: 44 + CommonStyles.headerPadding,
        alignItems: 'flex-end',
        backgroundColor: 'rgba(0,0,0,0.5)',
        position: 'absolute',
        top: 0,
        left: 0
    },
    topLine: {
        backgroundColor: '#fff',
        height: 38,
        alignItems: 'center',
        flexDirection: 'row',
        width: width,
        paddingHorizontal: 25,
        borderBottomWidth: 1,
        borderColor: '#F1F1F1',
        justifyContent:'space-between'
    },
    topTitle: {
        color: '#555555',
        fontSize: 14,
        marginRight: 5
    },
    flatListView: {
        backgroundColor:CommonStyles.globalBgColor,
        flex: 1,
        width: width,
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 5
    },
    sanjiao: {
        width: 20,
        height: 20,
        marginLeft: getwidth(70),
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
        width: 168,
        borderColor: '#DDDDDD',
        borderBottomLeftRadius: 10,
        marginLeft: 25,
        overflow: 'hidden',
        backgroundColor: 'white',
        maxHeight: 250,
        overflow:'hidden'
    },
    ItemTitle: {
        color: '#000000',
        fontSize: 14,
        marginBottom:8
    },
    itemTop: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingLeft: 15,
        height: 60,
        borderBottomWidth: 1,
        borderColor: '#F1F1F1'
    }

});

export default connect(
    state => ({
        longLists:state.shop.longLists || {},
        userShop:state.user.userShop || {},
        serviceCatalogList:state.shop.serviceCatalogList || [],
        user:state.user.user || {},
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
    }),
    dispatch=>({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params})
    })
)(CategoryScreen);
