import React, { Component, PureComponent } from 'react';
import {
  StyleSheet, View, TouchableOpacity, Image, Text,
} from 'react-native';
import moment from 'moment';
import {
  SmallMargin, BorderColor, RowStart, TextColor, RowEnd, WarningColor,
} from '../../../../components/theme';
import { ListItem } from '../../../../components/List';
import TextInputView from '../../../../components/TextInputView';
import { FormControl, createFormControl } from '../../../../components/form';
import Radio from '../../../../components/Radio';
import Picker from '../../../../components/Picker';
import * as Address from '../../../../const/address';

import {
  TakeTypeEnum, PickTypeEnum, TakeOrPickCropEnum, TakeOrPickParams,
} from '../../../../const/application';
import ImageView from '../../../../components/ImageView';
import { createDateDataFuture } from '../../../../const/date';

const deleteImg = require('../../../../images/index/delete.png');
const addImg = require('../../../../images/index/add_pic.png');

/**
 * TextInputFormControl 文本输入组件
 */
const TextInputFormControl = createFormControl()(class extends FormControl {
  render() {
    const {
      value, onChange, title, secureTextEntry, placeholder, unit, length, keyboardType, tips,
    } = this.props;
    return (
    <View style={{ flexDirection: 'column', justifyContent: 'center', alignItems: 'flex-start'}}>
      <ListItem
        style={[styles.formItem, tips ? { borderBottomWidth: 0 } : null ]}
        title={title}
        titleContainerStyle={styles.title}
        extraContainerStyle={styles.textContainer}
        extra={(
          <TextInputView
            rightIcon={unit ? <Text style={styles.unit}>{unit}</Text> : null}
            inputView={[{ flex: 1, flexDirection: 'row', paddingRight: 0 }]}
            placeholder={placeholder}
            style={styles.text}
            secureTextEntry={secureTextEntry}
            value={value}
            onChangeText={text => onChange(text)}
            maxLength={length}
            keyboardType={keyboardType}
          />
        )}
      />
      {
        tips ?  <View><Text style={styles.tips}>*{tips}</Text></View> : null
      }
    </View>
    );
  }
});

/**
 * 单选框组件
 */
const RadioFormControl = createFormControl()(class extends FormControl {
  render() {
    const {
      value, onChange, title, options,
    } = this.props;
    return (
      <ListItem
        style={styles.formItem}
        title={title}
        titleContainerStyle={styles.title}
        extraContainerStyle={styles.textContainer}
        extra={<Radio options={options} value={value} change={text => onChange(text)} />}
      />
    );
  }
});

/**
 * 下拉选择组件，点击后暴露给Form外部组件
 */
const SelectFormControl = createFormControl()(class extends FormControl {
  handlePress() {
    const {
      options = [], showActions, onChange, field, formData,
    } = this.props;
    const items = options.concat([{ title: '取消', value: null }]);
    showActions(index => onChange((items[index] || {}).value), items, field, formData);
  }
  render() {
    const {
      value, title, placeholder, options = [], editable = true,
    } = this.props;
    console.log(options);
    const item = (options || []).find(opt => opt.value === value) || {};

    return (
      <ListItem
        style={styles.formItem}
        title={title}
        titleContainerStyle={styles.title}
        extraContainerStyle={styles.textContainer}
        extra={item.value != null ? item.title : placeholder}
        onExtraPress={() => this.handlePress()}
        arrow={editable}
      />
    );
  }
});


const AddressPickerFormControl = createFormControl()(class extends FormControl {
  handlePress = () => {
    const { value, onChange } = this.props;
    Picker._showAreaPicker((data) => {
      if (data.codes && data.codes.length >= 3 && data.codes[2]) {
        onChange(data.codes[2]);
      }
    }, Address.getNamesByDistrictCode(value));
  }
  render() {
    const {
      value, title, placeholder, editable = true,
    } = this.props;
    return (
      <ListItem
        style={styles.formItem}
        title={title}
        titleContainerStyle={styles.title}
        extraContainerStyle={styles.textContainer}
        extra={!value ? placeholder : Address.getAddressByDistrictCode(value)}
        onExtraPress={() => this.handlePress()}
        arrow={editable}
      />
    );
  }
});

/** value 改时间戳 */
const DatePickerFormControl = createFormControl()(class extends FormControl {
  handlePress = () => {
    const {
      value, onChange, createDateData = createDateDataFuture,
    } = this.props;
    const decodeValue = value ? parseInt(value, 10) : '';
    const defaultDate = decodeValue ? moment()._d : moment(decodeValue * 1000)._d;
    Picker._showDatePicker((date) => {
      const timestamp = moment(date, 'YYYY-MM-DD').valueOf() / 1000;
      onChange(timestamp ? timestamp.toString() : '');
    }, createDateData, defaultDate);
  }
  render() {
    const {
      value, title, placeholder, editable = true, format = 'YYYY-MM-DD',
    } = this.props;
    const decodeValue = value ? parseInt(value, 10) : '';
    return (
      <ListItem
        style={styles.formItem}
        title={title}
        titleContainerStyle={styles.title}
        extraContainerStyle={styles.textContainer}
        extra={!decodeValue ? placeholder : moment(decodeValue * 1000).format(format)}
        onExtraPress={() => this.handlePress()}
        arrow={editable}
      />
    );
  }
});

export class ImageExtra extends PureComponent {
  render() {
    const {
      data = [], multi = false, max = 9, width = 68, height = 68, editable = true, onDelete = () => {}, onAdd = () => {}, onShow = () => {},
    } = this.props;
    const canAdd = (multi && data.length < max) || (!multi && data.length < 1);
    return (
      <View style={RowStart}>
        {
          data.map((img, index) => (
            <TouchableOpacity key={`${new Date().valueOf()}-${Math.random() * 1000}`} onPress={() => onShow(data, index)}>
              <ImageView
                resizeMode="cover"
                source={{ uri: img }}
                sourceWidth={width}
                sourceHeight={height}
                style={{ borderRadius: 6 }}
              />
              {
                editable ? (
                  <TouchableOpacity
                onPress={() => onDelete(index)}
                style={{
                  position: 'absolute', top: -9, right: -9,
                }}
                  >
                    <Image source={deleteImg} style={{ width: 18, height: 18 }} />
                  </TouchableOpacity>
                ) : null
              }
            </TouchableOpacity>
          ))
        }
        <TouchableOpacity
            onPress={() => onAdd()}
            style={{
              width, height, justifyContent: 'center', alignItems: 'center', display: canAdd && editable ? 'flex' : 'none',
            }}
        >
          <Image source={addImg} style={{ width, height }} />
        </TouchableOpacity>
      </View>
    );
  }
}

/**
 * value 多选是数组，单选是字符串
 */
const ImagePickerFormControl = createFormControl()(class extends FormControl {
  _uploadPicture = (index) => {
    if (index >= 2) return;
    const {
      takeOrPickImageAndVideo, onChange, multi, value,
    } = this.props;
    const params = new TakeOrPickParams({
      func: index === 0 ? 'take' : 'pick',
      type: index === 0 ? TakeTypeEnum.takeImage : PickTypeEnum.pickImage,
      crop: TakeOrPickCropEnum.NoCrop,
      totalNum: 1,
    });
    takeOrPickImageAndVideo(params.getOptions(), (res) => {
      let data = [];
      if (multi && Array.isArray(value)) data = value;
      if (!multi && typeof value === 'string') data = [value];
      data = data.concat(res.map(item => item.url));
      onChange(multi ? data : data[0]);
    });
  };

  handleDelete = (index) => {
    const { value, multi, onChange } = this.props;
    let data = [];
    if (multi && Array.isArray(value)) data = value;
    if (!multi) {
      data = [];
    } else {
      data.splice(index, 1);
    }
    onChange(multi ? data : data[0]);
  }

  handleAdd = () => {
    const { showActions } = this.props;
    showActions(this._uploadPicture, [{ title: '拍照', value: 0 }, { title: '相册', value: 1 }, { title: '取消', value: 2 }]);
  }

  handleShow = (data, index) => {
    const { showBigImages } = this.props;
    showBigImages(data, index);
  }

  render() {
    const {
      value = [], title, multi = false, video = false, max = 9, editable = true, size = 68,
    } = this.props;
    let data = [];
    if (multi && Array.isArray(value)) data = value;
    if (!multi && typeof value === 'string') data = [value];

    return (
      <ListItem
        style={styles.formItemVertical}
        horizontal={false}
        title={title}
        titleContainerStyle={[styles.title, { width: 200 }]}
        extraContainerStyle={[RowStart, { width: '100%', marginTop: 20 }]}
        extra={<ImageExtra onShow={this.handleShow} onDelete={this.handleDelete} onAdd={this.handleAdd} data={data} multi={multi} max={max} editable={editable} width={size} height={size} />}
      />
    );
  }
});

const CodeMapFormControl = createFormControl()(class extends FormControl {
  handlePress = () => {
    const {
      showCodeMap, onChange, field, formData,
    } = this.props;
    showCodeMap(field, formData, (res) => {
      onChange(res);
    });
  }
  render() {
    const {
      value, title, placeholder, filter = map => map.name, editable = true,
    } = this.props;
    return (
      <ListItem
        style={styles.formItem}
        title={title}
        titleContainerStyle={styles.title}
        extraContainerStyle={styles.textContainer}
        extra={!value ? placeholder : filter(value)}
        onExtraPress={() => this.handlePress()}
        arrow={editable}
      />
    );
  }
});

export default {
  radio: RadioFormControl,
  text: TextInputFormControl,
  address: AddressPickerFormControl,
  date: DatePickerFormControl,
  image: ImagePickerFormControl,
  select: SelectFormControl,
  code: CodeMapFormControl,
};

const styles = StyleSheet.create({
  formItem: {
    height: 48,
    borderBottomWidth: 1,
    borderBottomColor: BorderColor,
    paddingHorizontal: 15,
  },
  tips: {
    color: WarningColor,
    borderBottomColor:  BorderColor,
    borderBottomWidth: 1,
    paddingHorizontal: 15,
    paddingBottom: 10,
  },
  formItemVertical: {
    borderBottomWidth: 1,
    borderBottomColor: BorderColor,
    paddingHorizontal: 15,
  },
  textContainer: {
    flex: 1,
    height: 33,
  },
  text: {
    paddingLeft: SmallMargin,
    textAlign: 'right',
  },
  title: {
    width: 135,
  },
  unit: {
    color: TextColor,
    fontSize: 14,
  },
});
