import React, { Component } from 'react';
import {
  Text, View, StyleSheet, TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import List, { ListItem } from '../../../../components/List';
import { ImageExtra } from '../components/formMap';
import {
  BorderRadius, WhiteColor, BorderColor, TextSecondColor, TextColor,
} from '../../../../components/theme';

const FilterValue = ({
  formData, field, type, onShow, options = [],
}) => {
  if (field === 'firstIndustry') {
    console.log('firstIndustry', options);
  }
  if (['select', 'radio'].includes(type)) {
    const findItem = options.find(item => item.value === formData[field]);
    return <Text style={styles.itemExtra}>{findItem ? findItem.title : ''}</Text>;
  }
  if (['code'].includes(type)) {
    const title = (formData[field] || {}).name || '';
    return <Text style={styles.itemExtra}>{title}</Text>;
  }
  if (['image'].includes(type)) {
    const imgUrl = formData[field];
    return <View style={{ marginBottom: 15 }}><ImageExtra data={imgUrl ? [imgUrl] : []} multi={false} editable={false} onShow={onShow} /></View>;
  }
  return <Text style={styles.itemExtra}>{formData[field]}</Text>;
};

class ActiveShopInfo extends Component {
  componentDidMount() {
    this.props.fetchAccountShopStatus();
    this.props.fetchShopActiveInfo();
  }

  showBigImages = (_data, _showIndex) => {
    console.log('查看大图', _data, _showIndex);
    const state = {
      showIndex: _showIndex,
      showBigPicArr: _data.map(d => ({ type: 'images', url: d })),
    };
    this.props.onShowBigModal(state.showBigPicArr, state.showIndex);
  }
  render() {
    const { activeShopInfo, shopInfo } = this.props;
    const { formInfoList = [] } = activeShopInfo || {};
    const { optionsMap = {}, formData } = shopInfo || {};

    return (
      <View>
        {
          formInfoList.map(item => (
            <List style={styles.list}>
              <ListItem title={item.title} titleStyle={styles.title} />
              <View style={styles.card}>
                {
                  item.fields.map(({
                    title, type, field, options,
                  }) => (
                    <ListItem
                      title={title}
                      horizontal={!['image'].includes(type)}
                      extra={(
                        <FilterValue
                          options={options || optionsMap[field]}
                          formData={formData}
                          field={field}
                          type={type}
                          onShow={this.showBigImages}
                        />
                      )}
                      style={styles.listItem}
                      titleStyle={styles.itemTitle}
                      extraStyle={styles.itemExtra}
                    />
                  ))
                }
              </View>
            </List>
          ))
        }
      </View>
    );
  }
}

export default connect(state => ({
  activeShopInfo: state.userActive.activeShopInfo || {},
  shopInfo: state.userActive.shopInfo || {},
}), {
  fetchShopActiveInfo: () => ({ type: 'userActive/fetchShopActiveInfo' }), // 获取表单模版数据
  fetchAccountShopStatus: () => ({ type: 'userActive/fetchAccountShopStatus' }), // 获取表单数据
})(ActiveShopInfo);

const styles = StyleSheet.create({
  list: {
    paddingHorizontal: 15,
    backgroundColor: 'transparent',
  },
  title: {
    color: '#777',
    fontSize: 14,
    marginLeft: 10,
  },
  card: {
    borderRadius: BorderRadius,
    backgroundColor: WhiteColor,
    justifyContent: 'space-between',
    alignItems: 'center',
    flexDirection: 'column',
  },
  listItem: {
    paddingHorizontal: 15,
    borderBottomColor: BorderColor,
    borderBottomWidth: 1,
    paddingVertical: 0,
  },
  itemTitle: {
    color: TextSecondColor,
    fontSize: 14,
    paddingVertical: 15,
  },
  itemExtra: {
    color: TextColor,
    fontSize: 14,
  },
});
