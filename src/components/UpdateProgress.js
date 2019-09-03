
// 更新时候的进度条显示
import React, {Component}from 'react'
import {View, StyleSheet, Animated, Easing}from 'react-native'

import PropTypes from 'prop-types'

export default class CusProgressBar extends Component {

  static propTypes = {
    ...View.propTypes,
    // 当前进度
    progress: PropTypes.number,
    // second progress进度
    buffer: PropTypes.number,
    // 进度条颜色
    progressColor: PropTypes.string,
    // buffer进度条颜色
    bufferColor: PropTypes.string,
    // 进度动画时长
    progressAniDuration: PropTypes.number,
    // buffer动画时长
    bufferAniDuration: PropTypes.number
  }

  static defaultProps = {
    // 进度条颜色
    progressColor: 'white',
    // buffer进度条颜色
    bufferColor: 'rgba(255,0,0,0.7)',
    // 进度条动画时长
    progressAniDuration: 100,
    // buffer进度条动画时长
    bufferAniDuration: 100
  }

  constructor(props) {
    super(props)
    this._progressAni = new Animated.Value(0)
    this._bufferAni = new Animated.Value(0)
  }

  componentWillReceiveProps(nextProps) {
    this._progress = nextProps.progress
    this._buffer = nextProps.buffer
  }

  componentWillMount() {
    this._progress = this.props.progress
    this._buffer = this.props.buffer
  }

  render() {
    return (
        <View
            style={[styles.container,this.props.style]}
            onLayout={this._onLayout.bind(this)}>
          <Animated.View
              ref="progress"
              style={{
                position:'absolute',
                width: this._progressAni,
                backgroundColor:this.props.progressColor,
                borderRadius: 10
              }}/>
          <Animated.View
              ref="buffer"
              style={{
                position:'absolute',
                width: this._bufferAni,
                backgroundColor:this.props.bufferColor,
                borderRadius: 10,
              }}/>
        </View>
    )
  }

  _onLayout({nativeEvent: {layout:{width, height}}}) {
    // 防止多次调用,当第一次获取后,后面就不再去获取了
    if (width > 0 && this.totalWidth !== width) {
      // 获取progress控件引用
      let progress = this._getProgress()
      // 获取buffer控件引用
      let buffer = this._getBuffer()
      // 获取父布局宽度
      this.totalWidth = width
      //给progress控件设置高度
      progress.setNativeProps({
        style: {
          height: height
        }
      })

      // 给buffer控件设置高度
      buffer.setNativeProps({
        style: {
          height: height
        }
      })

      // 开始执行进度条动画
      this._startAniProgress(this.progress)
      // 开始执行buffer动画
      this._startAniBuffer(this.buffer)
    }
  }

  _startAniProgress(progress) {
    if (this._progress >= 0 && this.totalWidth !== 0) {
      Animated.timing(this._progressAni, {
        toValue: progress * this.totalWidth,
        duration: this.props.progressAniDuration,
        easing: Easing.linear
      }).start()
    }
  }

  _startAniBuffer(buffer) {
    if (this._buffer >= 0 && this.totalWidth !== 0) {
      Animated.timing(this._bufferAni, {
        toValue: buffer * this.totalWidth,
        duration: this.props.bufferAniDuration,
      }).start()
    }
  }

  _getProgress() {
    if (typeof this.refs.progress.refs.node !== 'undefined') {
      return this.refs.progress.refs.node
    }
    return this.refs.progress._component
  }

  _getBuffer() {
    if (typeof this.refs.buffer.refs.node !== 'undefined') {
      return this.refs.buffer.refs.node;
    }
    return this.refs.buffer._component;
  }
}

Object.defineProperty(CusProgressBar.prototype, 'progress', {
  set(value){
    if (value >= 0 && this._progress !== value) {
      this._progress = value;
      this._startAniProgress(value);
    }
  },
  get() {
    return this._progress;
  },
  enumerable: true,
})

Object.defineProperty(CusProgressBar.prototype, 'buffer', {
  set(value){
    if (value >= 0 && this._buffer !== value) {
      this._buffer = value;
      this._startAniBuffer(value);
    }
  },
  get() {
    return this._buffer;
  },
  enumerable: true,
})

const styles = StyleSheet.create({
  container: {
    height: 4,
  }
})
