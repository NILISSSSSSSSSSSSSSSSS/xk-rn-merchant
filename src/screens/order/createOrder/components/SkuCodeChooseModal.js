import React, { Component } from 'react'
import PropTypes from 'prop-types';
import { View, Text } from 'react-native'
import BaseModal from '../../../../components/Modals/BaseModal';

export default class SkuCodeChooseModal extends Component {
    static defaultProps = {
        visible: false,
        multiple: false,
        goodName: "商品规格选择",
        goodSkuData: [],
        value: {
            skuCodes: [],
            count: 0
        },
        onChange: ()=> {}
    }
    static propTypes = {
        visible: PropTypes.bool,
        multiple: PropTypes.bool,
        goodName: PropTypes.string,
        goodSkuData: PropTypes.arrayOf(PropTypes.shape({
            name: PropTypes.string, // 规格类型
            code: PropTypes.string, // 编号
            skuList: PropTypes.arrayOf(PropTypes.shape({
                name: PropTypes.string, // 规格名称
                code: PropTypes.string, // 编号
            }))
        })),
        value: {
            skuCodes: PropTypes.arrayOf(PropTypes.string),
            count: PropTypes.number,
            price: PropTypes.number,
        },
        onChange: PropTypes.func,
    }
    render() {
        const { visible, multiple, goodName, goodSkuData, values, onChange } = this.props;
        return (
            <BaseModal
                visible={visible}
            >
                <View style={styles.header}>
                
                </View>
                <View style={styles.body}>
                
                </View>
                <View style={styles.footer}>
                
                </View>
            </BaseModal>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center'
    },
    header: {
        color: '#999'
    },
    body: {
        color: '#999'
    },
    footer: {
        color: '#999'
    }
})