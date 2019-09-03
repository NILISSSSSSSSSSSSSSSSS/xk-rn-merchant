import React, { Component } from 'react';
import { View, Animated, Easing, Text,Dimensions } from 'react-native';
const { width, height } = Dimensions.get("window");
export default class MarqueeLabel extends Component {
  state = {
    textWidth: 0,
    textHeight: 0,
    bgViewWidth: 0,
    duration: 0,
    text: '',
    animation: null
  };

  componentWillMount() {
    this.setState({
      text: this.props.text || this.props.children || ''
    });
    this.animation = null;
    this.animatedTransformX = new Animated.Value(0);
  }

  componentWillUnmount() {
    if (this.state.animation !== null) {
        this.state.animation.stop && this.state.animation.stop();
    }
  }

  componentWillReceiveProps(nextProps) {
    let newText = nextProps.text || nextProps.children || '';
    let oldText = this.props.text || this.props.children || '';
    if (newText !== oldText) {
        if (this.state.animation !== null) {
            this.state.animation.stop && this.state.animation.stop();
        }
      this.setState({
        text: newText,
        textWidth: 0,
        textHeight: 0,
        duration: 0,
        animation: null,
      });
    }
  }

  componentDidUpdate(prevProps, prevState) {
    let { textWidth, bgViewWidth, duration, animation } = this.state;
    const { duration : durationProp , speed } = this.props;
    if(durationProp !==undefined) duration = durationProp
    else if (textWidth === 0 || bgViewWidth === 0){
      return
    } else {
      if (speed !== undefined) {
        duration = ((bgViewWidth + textWidth) / speed) * 1000;
      }
    }

    if (duration !== 0){
      if (animation === null) {
        this.animatedTransformX.setValue(bgViewWidth);
        this.setState({
          animation: Animated.timing(this.animatedTransformX, {
            toValue: -textWidth,
              duration: duration,
              useNativeDriver: true,
              easing: Easing.linear,
          }),
        }, () => {
          this.state.animation.start(() => {
            this.setState({
              animation: null,
            });
          });
        });
      }
    }
  }

  textOnLayout(e) {
    this.setState({
      textWidth: e.nativeEvent.layout.width,
      textHeight: e.nativeEvent.layout.height,
    });
  }

  bgViewOnLayout(e) {
    this.setState({
      bgViewWidth: e.nativeEvent.layout.width,
    });
  }

  render() {
    
    const {
      bgViewStyle, // Background View Custom Styles
      textStyle, // Text Custom Styles
      // Text Container Width:
      // to make the text shown in one line, this value should be larger than text width
      textContainerWidth,

      // Text Container Height:
      // to make the text shown in one line, this value should be larger than text height
      // usually increase this value when text has a large font size.
      textContainerHeight = 100,
      maxWidth,
      wrapStyle,
      textContainerStyle, // Text Container Custom Styles, not recommended to use
    } = this.props;

    const { textWidth, textHeight, text, animation } = this.state;
    return (
      <View style={wrapStyle}>
          <View
            style={{ ...styles.bgViewStyle, ...bgViewStyle }}
            onLayout={(event) => this.bgViewOnLayout(event)}
        >
            <View
            style={{
                ...styles.textContainerStyle,
                width: textContainerWidth,
                height: textContainerHeight,
                opacity: animation === null ? 0 : 1, // Make sure the view only shows when it's animating
                ...textContainerStyle,
            }}
            >
            <Animated.Text
                style={{
                fontSize: 20,
                transform: [{ translateX: this.animatedTransformX }],
                width: textWidth,
                height: textHeight,
                ...textStyle,
                // width:maxWidth
                }}
            >
                {text}
            </Animated.Text>
            </View>
            <Text
            numberOfLines={1}
            style={{
                ...styles.textSizeMeasuringViewStyle,
                ...textStyle,
                width:maxWidth
            }}
            onLayout={(event) => this.textOnLayout(event)}
            >
            {text}
            </Text>
        </View>
      </View>
    );
  }
}

const styles = {
  bgViewStyle: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-start',
    overflow: 'scroll',
  },
  textContainerStyle: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-start',
  },
  textSizeMeasuringViewStyle: {
    opacity: 0,
    fontSize: 20,
  },
};
