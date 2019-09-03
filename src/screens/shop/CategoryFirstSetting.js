/**
 * 品类管理
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    Modal,
    View,
    Text,
    Button,
    Image,
    Platform,
    RefreshControl,
    ScrollView,
    PanResponder,
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
const { width, height } = Dimensions.get('window');
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import TextInputView from '../../components/TextInputView';
import Content from '../../components/ContentItem';
import { NavigationComponent } from '../../common/NavigationComponent';
import OrderFlatList from '../../components/OrderFlatList';
import {sortLists} from '../../config/utils';
import Toast from '../../components/Toast';
class CategoryFirstSetting extends NavigationComponent {
    static navigationOptions = {
        header: null
    }
    constructor(props) {
        super(props)
        const params=props.navigation.state.params || {}
        this.state = {
            data: params.lists || [],
            callback:params.callback || (()=>{}),
            shopId:params.shopId,
            visible:false,
            refreshing:false,
            getIcon:params.getIcon || (()=>{}),
            oprateItem:{},
            canEdit:false,
        }
    }
    componentWillUnmount() {
      this.setState({visible:false})
    }
    _onRefresh=(refreshing)=>{
      refreshing?this.setState({refreshing:true}):null
      requestApi.shopCatalogAliasQueryAll({shopId:this.state.shopId}).then((data)=>{
        console.log(data)
        this.setState({data:sortLists(data || []),refreshing:false})
      }).catch((error)=>{
        console.log(error)
        refreshing?this.setState({refreshing:false}):null
      })

    }
    addType=()=>{
      const {data,alias,oprateItem}=this.state
      if(alias && alias.length>4){
        this.Toast && this.Toast.show('自定义名称最多四个字')
        return
      }
      data[oprateItem.itemIndex].alias=alias
      this.setState({
        visible:false,
        alias:'',
        data
      })
    }
    save=()=>{
      if(!this.state.canEdit){
        this.setState({canEdit:true})
        return
      }
      const list=JSON.parse(JSON.stringify(this.state.data))
      const newList=list.map((item,index)=>{
        item.index=index
        return item
      })
      Loading.show()
      requestApi.shopCatalogAliasUpdateAll({
        catalogAlias:newList
      }).then((res)=>{
        this.state.callback()
        this.props.navigation.goBack()
      }).catch(()=>{
          
      });
      console.log(newList)
    }

    renderItem = ({ item, index }) => {
        return (
          <View>
            <Content
              style={[styles.itemTop]}
              key={index}
            >
                <View style={{flexDirection:'row',alignItems:'center'}}>
                    <Image
                        style={{ width: 40, height: 40, borderRadius: 20 }}
                        source={this.state.getIcon(item.levelOneName)}
                    />
                    <View style={{marginLeft: 15}}>
                      <Text style={styles.ItemTitle}>{item.levelOneName}</Text>
                      <Text style={{color:'#999999',fontSize:12}}>自定义名称：{item.alias}</Text>
                    </View>
                </View>
            </Content>
          </View>

        )
    }
    onOrder=(res)=>{
      console.log(res)
      this.setState({data:res.list})
    }
    render() {
        const { navigation} = this.props;
        const { data,visible,alias,refreshing,oprateItem ,canEdit} = this.state
        return (
            <View style={styles.container}>
              <Header
                    navigation={navigation}
                    goBack={true}
                    title={'一级分类设置'}
                    rightView={
                        <TouchableOpacity style={{ width: 50 }} onPress={this.save}>
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                               {canEdit?'保存':'修改'}
                            </Text>
                        </TouchableOpacity>
                    }
                />
                <Text style={{color:'#666',marginTop:10,marginLeft:15}}>*长按拖动分类可更改排序</Text>
                <OrderFlatList
                  itemHeight={70}
                  isOrder={canEdit}
                  orderStyle={{position:'relative'}}
                  style={{width:width-20,marginLeft:10}}
                  renderItem={this.renderItem}
                  renderItemOtherView={({item,index})=>
                    this.state.canEdit?
                    <TouchableOpacity
                      style={{width:50,position:'absolute',right:0,height:70,alignItems:'center',justifyContent:'center'}}
                      onPress={()=>this.setState({
                        visible:true,
                        oprateItem:{...item,itemIndex:index},
                        alias:item.alias
                      })}
                    >
                      <Text style={{color:CommonStyles.globalHeaderColor}}>修改</Text>
                    </TouchableOpacity>:null
                  }
                  orderWidth={width-70}
                  data={data}
                  icon={0}
                  onOrder={this.onOrder}
                  refreshControl={
                    <RefreshControl
                        colors={['#2ba09d']}
                        refreshing={refreshing}
                        onRefresh={()=>this._onRefresh(1)}
                    />
                  }
                />
              <Modal
                  animationType="fade"
                  transparent
                  visible={visible}
                  onRequestClose={() => { }}
              >
                <View style={[styles.containerModal, { backgroundColor: 'rgba(0, 0, 0, 0.5)' }]}>
                  <View style={[styles.innerContainer, { backgroundColor: '#EFEFEF', paddingTop: 20 }]}>
                    <Text style={styles.title}>新建分类</Text>
                    <View style={{ height: 24, marginTop: 20 }}>
                      <TextInputView
                        placeholder="输入分类名"
                        placeholderTextColor="#ccc"
                        style={styles.modalInput}
                        value={alias}
                        maxLength={10}
                        onChangeText={data => this.setState({ alias: data })}
                        returnKeyType="done"
                      />
                    </View>
                    <View style={styles.row}>
                      <TouchableOpacity style={styles.btn}>
                        <Text onPress={() => this.setState({ visible: false, alias: '' })} style={[styles.btn_text,{color:'#222'}]}>取消</Text>
                      </TouchableOpacity>
                      <TouchableOpacity disabled={alias?false:true} style={[styles.btn, { borderColor: '#DDD', borderLeftWidth: 1 }]}>
                        <Text onPress={() => this.addType()} style={[styles.btn_text,{color:alias?'#4A90FA':'gray'}]}>确定</Text>
                      </TouchableOpacity>
                    </View>
                  </View>
                </View>
                <Toast
                  ref={(e) => {
                    e && (this.Toast = e);
                  }}
                  position="center"
                />
              </Modal>
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
    topTitle: {
        color: '#555555',
        fontSize: 14,
        marginRight: 5
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 5
    },
    ItemTitle: {
      color: '#000000',
      fontSize: 14,
      marginBottom:8
    },
    itemTop: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 15,
        height: 60,
        borderColor: '#F1F1F1',
        width: width - 20,
        justifyContent:'space-between'
    },
    containerModal: {
      flex: 1,
      justifyContent: 'center',
      paddingHorizontal: 40,
    },
    innerContainer: {
      borderRadius: 10,
      alignItems: 'center',
    },
    title: {
      color: '#030303',
      fontSize: 17,
    },
    modalInput: {
      width: width - 105 - 33,
      borderWidth: 1,
      borderColor: '#DDD',
      backgroundColor: 'white',
      paddingLeft: 5,

    },
    row: {
      alignItems: 'center',
      width: '100%',
      flexDirection: 'row',
      marginTop: 20,
      borderColor: '#DDD',
      borderTopWidth: 1,
    },
    btn: {
      width: '50%',
      height: '100%',
    },
    button: {
      backgroundColor: '#4A90FA',
      borderRadius: 8,
      width: '80%',
      marginBottom: 20,
    },
    btn_text: {
      textAlign: 'center',
      color: '#4A90FA',
      fontSize: 17,
      lineHeight: 50,
    },
    deleteView: {
      width: 30,
      height: 30,
      alignItems: 'center',
      justifyContent: 'center',
    },
    modalView: {
      width: 168,
      // borderWidth: 1,
      borderColor: '#DDDDDD',
      borderBottomLeftRadius: 10,
      marginLeft: 25,
      // overflow: 'hidden',
      position: 'relative',
      backgroundColor: 'white',
      maxHeight: 250,
      overflow: 'hidden',
    },
    line2: {
      paddingHorizontal: 15,
      borderBottomWidth: 1,
      borderColor: '#F1F1F1',
    },

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
)(CategoryFirstSetting);
