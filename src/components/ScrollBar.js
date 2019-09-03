import React , { PureComponent,Component } from 'react'
import PropTypes from 'prop-types'
import {
    Animated,
    View,
    Text,
    Easing,
    StyleSheet,
    ViewStyle
 } from 'react-native'
import CommonStyles from '../common/Styles'
 export default class ScrollBar extends PureComponent {
     defaultProps = {
         text: '', // 显示的文本
         wrapStyle: {}, // 盒子样式
         textStyle: {}, // 文字样式
         speed: 30, // 速度
     }
     propTypes = {
        text: PropTypes.string,
        wrapStyle: PropTypes.ViewStyle,
        textStyle: PropTypes.ViewStyle,
        speed: PropTypes.number,
     }
     animated = null;
    x = new Animated.Value(0);
    state = {
        barWrapWidth: 0, // 盒子长度
        textWidth: 0, // 文本长度
     }
     componentDidMount () {
     }
     componentDidUpdate (prev, next) {
         console.log('prev',prev)
         console.log('next',next)
         if (next.barWrapWidth !== 0 && next.textWidth !== 0 && this.animated === null) {
            this.handlePlayAnim()
         }
     }
     handleChangeState = (key='',value='') => {
        this.setState({
            [key]: value
        }, () => {
            console.log('cahgneState', this.state)
        })
     }
     // 获取容器高宽
     getBarWrapLayout = (e) => {
        this.handleChangeState('barWrapWidth', e.nativeEvent.layout.width)
     }
     // 获取文本长度
     getTextLayout =(e) => {
        this.handleChangeState('textWidth', e.nativeEvent.layout.width)
     }
     handlePlayAnim = () => {
        const { textWidth,barWrapWidth } = this.state
        const { speed } = this.props
        let duration = ((barWrapWidth + textWidth) / speed) * 1000;
        console.log('barWrapWidth',barWrapWidth)
        console.log('textWidth',textWidth)
        console.log('speed',speed)
        this.animated =  Animated.timing(this.x, {
                toValue: -textWidth,
                duration: duration,
                useNativeDriver: true,
                easing: Easing.linear,
         }).start(() => {
            // this.animated = null
            // this.x = new Animated.Value(0);
            // this.handlePlayAnim()
             console.log('duration',duration)
         })
     }
     render () {
         const { text,wrapStyle,textStyle } = this.props
         let transform = [
            {
                translateX: this.x
            }
        ]
         console.log('this.state.x',this.x)
         console.log('this.state.x',transform)
         return (
             <View style={[{overflow: 'hidden'},wrapStyle]}>
                 <View style={[CommonStyles.flex_start_noCenter,styles.barWrap]} onLayout={(e) => {this.getBarWrapLayout(e)}}>
                    <Animated.Text style={[textStyle,{transform,}]}>{text}</Animated.Text>
                    <Text style={styles.text} onLayout={(e) => {this.getTextLayout(e)}}>{text}</Text>
                    {/* <Animated.Text style={[styles.text_Anim,textStyle]}>{text}</Animated.Text> */}
                </View>
             </View>
         )
     }
 }
const styles = StyleSheet.create({
    barWrap: {
        overflow: 'scroll',
    },
    text: {
        opacity: 0,
    },
    text_Anim: {
        color: CommonStyles.globalRedColor,
        backgroundColor: 'blue',
        width: 200,
        height: 40,
    },
})
