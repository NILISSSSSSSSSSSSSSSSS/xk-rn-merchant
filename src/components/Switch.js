import React from 'react';
import { PanResponder, View, TouchableHighlight, Animated, Text, Easing } from 'react-native';

class Switch extends React.Component {
  constructor(props) {
    super(props);
    const w = this.props.width - Math.min(this.props.height, this.props.buttonRadius * 2);
    this.state = {
      width: w,
      state: this.props.value,
      position: new Animated.Value(this.props.value ? w : 0),
    };
    this.start = {};
  }

  componentWillMount = () => {
    this._panResponder = PanResponder.create({
      onStartShouldSetPanResponder: (evt, gestureState) => true,
      onStartShouldSetPanResponderCapture: (evt, gestureState) => true,
      onMoveShouldSetPanResponder: (evt, gestureState) => true,
      onMoveShouldSetPanResponderCapture: (evt, gestureState) => true,

      onPanResponderGrant: (evt, gestureState) => {
        if (!this.props.disabled) return;

        this.setState({ pressed: true });
        this.start.x0 = gestureState.x0;
        this.start.pos = this.state.position._value;
        this.start.moved = false;
        this.start.state = this.state.state;
        this.start.stateChanged = false;
      },
      onPanResponderMove: (evt, gestureState) => {
        if (!this.props.disabled) return;

        this.start.moved = true;
        if (this.start.pos == 0) {
          if (gestureState.dx <= this.state.width && gestureState.dx >= 0) {
            this.state.position.setValue(gestureState.dx);
          }
          if (gestureState.dx > this.state.width) {
            this.state.position.setValue(this.state.width);
          }
          if (gestureState.dx < 0) {
            this.state.position.setValue(0);
          }
        }
        if (this.start.pos == this.state.width) {
          if (gestureState.dx >= -this.state.width && gestureState.dx <= 0) {
            this.state.position.setValue(this.state.width + gestureState.dx);
          }
          if (gestureState.dx > 0) {
            this.state.position.setValue(this.state.width);
          }
          if (gestureState.dx < -this.state.width) {
            this.state.position.setValue(0);
          }
        }
        let currentPos = this.state.position._value;
        this.onSwipe(currentPos, this.start.pos,
          () => {
            if (!this.start.state) this.start.stateChanged = true;
            this.setState({ state: true })
          },
          () => {
            if (this.start.state) this.start.stateChanged = true;
            this.setState({ state: false })
          });
      },
      onPanResponderTerminationRequest: (evt, gestureState) => true,
      onPanResponderRelease: (evt, gestureState) => {
        this.setState({ pressed: false });
        let currentPos = this.state.position._value;
        if (!this.start.moved || (Math.abs(currentPos - this.start.pos) < 5 && !this.start.stateChanged)) {
          this.toggle();
          return;
        }
        this.onSwipe(currentPos, this.start.pos, this.activate, this.deactivate);
      },
      onPanResponderTerminate: (evt, gestureState) => {
        let currentPos = this.state.position._value;
        this.setState({ pressed: false });
        this.onSwipe(currentPos, this.start.pos, this.activate, this.deactivate);
      },
      onShouldBlockNativeResponder: (evt, gestureState) => true,
    });
  };

  componentWillReceiveProps = (nextProps) => {
    if (this.state.state !== nextProps.value) {
      if (nextProps.value) {
        this.activate();
      } else {
        this.deactivate();
      }
    }
  }

  onSwipe = (currentPosition, startingPosition, onChange, onTerminate) => {
    if (currentPosition - startingPosition >= 0) {
      if (currentPosition - startingPosition > this.state.width / 2 || startingPosition == this.state.width) {
        onChange();
      } else {
        onTerminate();
      }
    } else {
      if (currentPosition - startingPosition < -this.state.width / 2) {
        onTerminate();
      } else {
        onChange();
      }
    }
  };

  activate = () => {
    Animated.timing(
      this.state.position,
      {
        toValue: this.state.width,
        duration: this.props.switchAnimationTime,
        easing: Easing.linear,
        useNativeDriver: true
      }
    ).start();
    this.changeState(true);
  };

  deactivate = () => {
    Animated.timing(
      this.state.position,
      {
        toValue: 0,
        duration: this.props.switchAnimationTime,
        easing: Easing.linear,
        useNativeDriver: true
      }
    ).start();
    this.changeState(false);
  };

  changeState = (state) => {
    let callHandlers = this.start.state != state;
    setTimeout(() => {
      this.setState({ state: state });
      if (callHandlers) {
        this.callback();
      }
    }, this.props.switchAnimationTime / 2);
  };

  callback = () => {
    let state = this.state.state;
    if (state) {
      this.props.onActivate();
    } else {
      this.props.onDeactivate();
    }
    this.props.onChangeState(state);
  };

  toggle = () => {
    if (!this.props.disabled) return;

    if (this.state.state) {
      this.deactivate();
    } else {
      this.activate();
    }
  };

  render() {
    let doublePadding = this.props.padding * 2 - 2;
    let halfPadding = doublePadding / 2;
    let bgViewBackgroundColor = this.props.value ? this.props.activeBackgroundColor : this.props.inactiveBackgroundColor;
    let backgroundColor = this.props.value
    ? (this.state.pressed? this.props.activeButtonPressedColor : this.props.activeButtonColor)
    : (this.state.pressed? this.props.inactiveButtonPressedColor : this.props.inactiveButtonColor);
    return (
      <View
        {...this._panResponder.panHandlers}
        style={{padding: this.props.padding, position: 'relative'}}>
        <View
          style={{
            backgroundColor: bgViewBackgroundColor,
            height: this.props.height,
            width: this.props.width,
            borderRadius: this.props.height / 2,
            borderWidth: this.props.borderWidth,
            borderColor: this.props.borderColor,
          }}/>
        <TouchableHighlight underlayColor='transparent' activeOpacity={1} style={{
            height: Math.max(this.props.buttonRadius*2+doublePadding, this.props.height+doublePadding),
            width: this.props.width+doublePadding,
            position: 'absolute',
            top: 1,
            left: 1,
          }}>
          <Animated.View style={[{
              backgroundColor: backgroundColor,
              height: this.props.buttonRadius*2,
              width: this.props.buttonRadius*2,
              borderRadius: this.props.buttonRadius,
              alignItems: 'center',
              justifyContent: 'center',
              flexDirection: 'row',
              position: 'absolute',
              top: halfPadding + this.props.height/2 - this.props.buttonRadius,
              left: this.props.height/2 > this.props.buttonRadius ? halfPadding : halfPadding + this.props.height/2 - this.props.buttonRadius,
              transform: [{ translateX: this.state.position }]
            },
            this.props.buttonShadow]}
          >
            {this.props.buttonContent}
          </Animated.View>
        </TouchableHighlight>
      </View>
    );
  }
}
Switch.defaultProps = {
  value: false,
  padding: 2,
  inactiveButtonColor: '#fff',
  inactiveButtonPressedColor: '#fff',
  activeButtonColor: '#fff',
  activeButtonPressedColor: '#fff',
  buttonShadow: {
    shadowColor: '#000',
    shadowOpacity: 0.5,
    shadowRadius: 1,
    shadowOffset: { height: 1, width: 0 },
    borderWidth: 1,
    borderColor: '#ddd'
  },
  activeBackgroundColor: '#43d551',
  inactiveBackgroundColor: '#ddd',
  buttonRadius: 12,
  width: 40,
  height: 20,
  buttonContent: null,
  disabled: true,
  switchAnimationTime: 0,
  borderWidth: 1,
  borderColor: '#ddd',
  onActivate: () => {
  },
  onDeactivate: () => {
  },
  onChangeState: () => {
  },
};

export default Switch;