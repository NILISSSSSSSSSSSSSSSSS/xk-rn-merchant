const React = require('react');
const ReactNative = require('react-native');
const {
    TouchableNativeFeedback,
    View,
    TouchableOpacity
} = ReactNative;

const Button = (props) => {
    return <TouchableOpacity
        activeOpacity={0.5}
        {...props}
    >
        {props.children}
    </TouchableOpacity>;
};

module.exports = Button;
