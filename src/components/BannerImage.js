/**
 * 拼接图片
 */
// 引用方法
// {/* <BannerImage
//     navigation={navigation}
//     style={{ width: 200, height: 200 }}
//     data={}
// /> */}
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Image,
    Text,
    Button,
    TouchableOpacity,
} from 'react-native';

import ImageView from './ImageView';
import { bannerJumpFun } from '../config/utils'

const { width, height } = Dimensions.get('window');
const defaultWidth = width;
const defaultHeight = 275;

export default class BannerImage extends Component {
    constructor(props) {
        super(props)
        this.state = {
            data: props.data || null,
            bannerTotalWidth: props.style.width || defaultWidth,
            bannerTotalHeight: props.style.height || defaultHeight,
        }
    }

    static getDerivedStateFromProps(props, state) {
        if (props !== state) {
            return {
                data: props.data || null,
                bannerTotalWidth: props.style.width || defaultWidth,
                bannerTotalHeight: props.style.height || defaultHeight,
            }
        }
        return null
    }

    componentDidMount() {
    }

    componentWillUnmount() {
    }

    render() {
        const { data, bannerTotalWidth, bannerTotalHeight } = this.state;
        let bannerLineWidth = bannerTotalWidth / data.x;
        let bannerLineHeight = bannerTotalHeight / data.y;

        return (
            <View style={[styles.bannerView, this.props.style, { width: bannerTotalWidth, height: bannerTotalHeight }]}>
                {
                    data && data.arr && data.arr.length !== 0 && data.arr.map((item, index) => {
                        let _gridStart = item.gridStart.split(',');
                        let _gridEnd = item.gridEnd.split(',');
                        let w = bannerLineWidth * (_gridEnd[0] - _gridStart[0]);
                        let h = bannerLineHeight * (_gridEnd[1] - _gridStart[1]);
                        let _top = bannerLineHeight * _gridStart[1];
                        let _left = bannerLineWidth * _gridStart[0];

                        let textStyle = null;
                        if (item.position === '1') {
                            textStyle = { top: 0, left: 0, borderBottomRightRadius: 8 };
                        } else if (item.position === '2') {
                            textStyle = { top: 0, right: 0, borderBottomLeftRadius: 8 };
                        } else if (item.position === '3') {
                            textStyle = { bottom: 0, left: 0, borderTopRightRadius: 8 };
                        } else if (item.position === '4') {
                            textStyle = { bottom: 0, right: 0, borderTopLeftRadius: 8 };
                        }

                        return (
                            <TouchableOpacity
                                key={index}
                                activeOpacity={0.8}
                                style={[styles.bannerItem, { top: _top, left: _left, width: w, height: h }]}
                                onPress={() => {
                                    if (bannerJumpFun(item).uri === '') return
                                    if (item.type === 1) {
                                        this.props.navigation.navigate('WebView', { source: bannerJumpFun(item) });
                                    }
                                    if (item.type === 2) {
                                        this.props.navigation.navigate(bannerJumpFun(item).router,bannerJumpFun(item).params)
                                    }
                                }}
                            >
                                <Image
                                    // resizeMode='cover'
                                    // resizeMode='contain'
                                    source={item.src ? { uri: item.src } : require('../images/default.png')}
                                    style={{height: h,width: w}}
                                    fadeDuration={0}

                                />
                                {/* {
                                    item.txt
                                    ?<View style={[styles.banner_Text, textStyle]}>
                                        <Text style={styles.banner_Text_text}>{item.txt}</Text>
                                    </View>
                                    : null
                                } */}

                            </TouchableOpacity>
                        );
                    })
                }
                {this.props.children}
            </View>
        );
    }
};

const styles = StyleSheet.create({
    bannerView: {
        position: 'relative',
        backgroundColor: '#fff',
        overflow: 'hidden',

    },
    bannerItem: {
        position: 'absolute',
    },
    banner_Text: {
        position: 'absolute',
        padding: 5,
        backgroundColor: 'rgba(74,144,250,0.60)',
    },
    banner_Text_text: {
        fontSize: 10,
        color: '#fff',
    },
});
