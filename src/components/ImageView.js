/**
 * Image 组件
 */
// 使用方法
{/* <ImageView
source={''}
// source={null}
// source={require('../images/timg.jpg')}
// source={{ uri: 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=4044958506,2732037263&fm=27&gp=0.jpg' }}
// source={{ uri: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533893135145&di=a6f95c7d535feb4810a4f671c7c3c693&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fbf096b63f6246b60a29909b1e7f81a4c500fa264.jpg' }}
sourceWidth={width}
sourceHeight={100}
resizeMode='cover'
isGetSize={true}
/> */}
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Image,
} from 'react-native';

const { width, height } = Dimensions.get('window');
const default_Image = require('../images/skeleton/skeleton_img.png')
const defaultImg = require('../images/default.png');

export default class ImageView extends Component {
    constructor(props) {
        super(props);
        this.state = {
            source: props.source,
            sourceWidth: props.sourceWidth,
            sourceHeight: props.sourceHeight,
            resizeMode: props.resizeMode,
            isGetSize: props.isGetSize,
            isError:false
        }
    }

    static getDerivedStateFromProps(props, state) {
        if (props !== state) {
            return {
                source: props.source,
                sourceWidth: props.sourceWidth,
                sourceHeight: props.sourceHeight,
                resizeMode: props.resizeMode,
                isGetSize: props.isGetSize,
                isError:false
            }
        }
        return null
    }

    componentDidMount() {
        this.ImageGetSize();
    }

    componentDidUpdate(prevProps, prevState) {
        if (prevProps !== this.props) {
            this.ImageGetSize();
        }
    }

    ImageGetSize = () => {
        const { source, sourceWidth, sourceHeight, isGetSize } = this.state;
        // 通过判断 source 是否是Object，来确定是否是网络图片
        let isNetImage = Object.prototype.toString.call(source) === "[object Object]";
        if (!isNetImage) {
            return
        }
        if (!isGetSize) {
            return
        }
        // 获取网络图片的宽高
        Image.getSize(source.uri, (imgWidth, imgHeight) => {
            let _imgWidth = imgWidth;
            let _imgHeight = imgHeight;
            if (imgWidth > sourceWidth) {
                _imgWidth = sourceWidth;
                _imgHeight = imgHeight * sourceWidth / imgWidth;
            }
            this.setState({
                sourceWidth: _imgWidth,
                sourceHeight: _imgHeight,
                isError:false
            });
        });
    }

    onError = (e) => {
        console.log('错误')
        this.setState({isError:true})
    }

    componentWillUnmount() {
        // 去除组件销毁时，异步的setState为完成的警告
        this.setState = (state, callback) => {
            return;
        };
    }

    render() {
        const { sourceWidth, sourceHeight, resizeMode, style,isError } = this.state;
        let defaultImage=sourceWidth>sourceHeight+20?require('../images/default/default_355_213.png'):require('../images/default/default_100.png')
        let errorImage=this.state.sourceWidth>this.state.sourceHeight+20?require('../images/default/break_long.png'):require('../images/default/break_100.png')
        let source=JSON.parse(JSON.stringify(this.state.source))
        if(source.uri){
            source.uri =  source.uri+''
        }
        return (
            <Image
                style={[this.props.style, { width: sourceWidth, height: sourceHeight }]}
                defaultSource={isError?errorImage:defaultImage}
                source={isError?errorImage: source.uri !== null ? source:defaultImage}
                resizeMode={resizeMode}
                onError={this.onError}
                fadeDuration={0}
            />
        );
    }
};

ImageView.defaultProps = {
    source: '',  // 传入的图片地址
    resizeMode: 'contain',
    sourceWidth: width,
    sourceHeight: width,
    isGetSize: false  // 是否需要获取网络图片的宽高,
};

const styles = StyleSheet.create({
});
