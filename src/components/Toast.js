import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  View,
  Animated,
  Dimensions,
  Text,
} from 'react-native';
import PropTypes from 'prop-types';

const { height, width } = Dimensions.get('window');

const DURATION = {
  LENGTH_LONG: 1500,
  LENGTH_SHORT: 500,
  FOREVER: 0,
};


export default class Toast extends Component {
    isShow = false;
    constructor(props) {
      super(props);
      this.state = {
        isShow: false,
        text: '',
        opacityValue: new Animated.Value(this.props.opacity),
      };
    }

    componentDidMount() {
      this.__didmounted = true;
    }

    componentWillUnmount() {
      this.timer && clearTimeout(this.timer);
      this.__unmounted = true;
    }

    show(text, duration, callback) {
      if (this.__unmounted || !this.__didmounted) return;
      duration = typeof duration === 'number' ? duration : DURATION.LENGTH_LONG;
      this.setState({
        isShow: true,
        text,
      });

      Animated.timing(
        this.state.opacityValue,
        {
          toValue: this.props.opacity,
          duration: this.props.fadeInDuration,
          useNativeDriver: true,
        },
      ).start(() => {
        this.isShow = true;
        if (duration !== DURATION.FOREVER) this.close(duration, callback);
      });
    }

    close(duration, callback = () => { }) {
      if (this.__unmounted || !this.__didmounted) return;
      let delay = typeof duration === 'undefined' ? DURATION.LENGTH_LONG : duration;

      if (delay === DURATION.FOREVER) delay = this.props.defaultCloseDelay || 250;

      if (!this.isShow && !this.state.isShow) return;
      this.timer && clearTimeout(this.timer);
      this.timer = setTimeout(() => {
        Animated.timing(
          this.state.opacityValue,
          {
            toValue: 0,
            duration: this.props.fadeOutDuration,
            useNativeDriver: true,
          },
        ).start(() => {
          if (this.__unmounted || !this.__didmounted) return;
          this.setState({
            isShow: false,
          });
          this.isShow = false;
          callback();
        });
      }, delay);
    }

    render() {
      let pos;
      switch (this.props.position) {
        case 'top':
          pos = this.props.positionValue;
          break;
        case 'center':
          pos = height / 2;
          break;
        case 'bottom':
          pos = height - this.props.positionValue;
          break;
        default:
          break;
      }

      const view = this.state.isShow
        ? (
          <View style={[styles.container, { top: pos }]} pointerEvents="none">
            <Animated.View style={[styles.content, { opacity: this.state.opacityValue }, this.props.style]}>
              <Text style={this.props.textStyle}>
                {this.state.text}
              </Text>
            </Animated.View>
          </View>
        )
        : null;
      return view;
    }
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    left: width / 8,
    right: width / 8,
    alignItems: 'center',
    zIndex: 999999999999,
  },
  content: {
    backgroundColor: 'rgba(0,0,0,0.8)',
    borderRadius: 5,
    padding: 10,
  },
  text: {
    color: '#fff',
  },
});

Toast.propTypes = {
  position: PropTypes.oneOf([
    'top',
    'center',
    'bottom',
  ]),
  positionValue: PropTypes.number,
  fadeInDuration: PropTypes.number,
  fadeOutDuration: PropTypes.number,
  opacity: PropTypes.number,
  textStyle: PropTypes.oneOfType([PropTypes.number, PropTypes.object]),
};

Toast.defaultProps = {
  position: 'bottom',
  textStyle: styles.text,
  positionValue: 120,
  fadeInDuration: 500,
  fadeOutDuration: 500,
  opacity: 1,
};
