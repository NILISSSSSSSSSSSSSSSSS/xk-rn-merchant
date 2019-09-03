const React = require('react');
const { ViewPropTypes } = ReactNative = require('react-native');
const PropTypes = require('prop-types');
const createReactClass = require('create-react-class');
const {
    StyleSheet,
    Text,
    View,
    Animated,
} = ReactNative;
import CommonStyles from '../../common/Styles';
const Button = require('./Button');

const DefaultTabBar = createReactClass({
    propTypes: {
        goToPage: PropTypes.func,
        activeTab: PropTypes.number,
        tabs: PropTypes.array,
        backgroundColor: PropTypes.string,
        activeTextColor: PropTypes.object,
        inactiveTextColor: PropTypes.object,
        textStyle: Text.propTypes.style,
        tabStyle: ViewPropTypes.style,
        renderTab: PropTypes.func,
        underlineStyle: ViewPropTypes.style,
    },

    getDefaultProps() {
        return {
            activeTextColor: 'navy',
            inactiveTextColor: 'black',
            backgroundColor: null,
        };
    },

    renderTabOption(name, page) {
    },

    renderTab(name, page, isTabActive, onPressHandler) {
        const { activeTextColor, inactiveTextColor, textStyle, leftBtn, RightBtn, topBtnWrap, } = this.props;
        const textColor = isTabActive ? activeTextColor : inactiveTextColor;
        const fontWeight = isTabActive ? 'bold' : 'normal';
        const btnDirection = page === 1 ? styles.RightBtn : styles.leftBtn
        return <Button
            key={name}
            accessible={true}
            accessibilityLabel={name}
            accessibilityTraits='button'
            onPress={() => onPressHandler(page)}
        >
            <View style={[topBtnWrap]}>
                <View style={[btnDirection,styles.border]}>
                    <Text style={[styles.topBtn, textColor, textStyle]}>{name}</Text>
                </View>
            </View>
        </Button>;
    },

    render() {
        const containerWidth = this.props.containerWidth;
        const numberOfTabs = this.props.tabs.length;
        const tabUnderlineStyle = {
            position: 'absolute',
            width: containerWidth / numberOfTabs,
            height: 4,
            backgroundColor: 'navy',
            bottom: 0,
        };

        const translateX = this.props.scrollValue.interpolate({
            inputRange: [0, 1],
            outputRange: [0, containerWidth / numberOfTabs],
        });
        return (
            <View style={[styles.tabs, { backgroundColor: this.props.backgroundColor, }, this.props.style,]}>
                {this.props.tabs.map((name, page) => {
                    const isTabActive = this.props.activeTab === page;
                    const renderTab = this.props.renderTab || this.renderTab;
                    return renderTab(name, page, isTabActive, this.props.goToPage);
                })}
                <Animated.View
                    style={[
                        tabUnderlineStyle,
                        {
                            transform: [
                                { translateX },
                            ]
                        },
                        this.props.underlineStyle,
                    ]}
                />
            </View>
        );
    },
});

const styles = StyleSheet.create({
    tab: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        paddingBottom: 10,
    },
    tabs: {
        height: 50,
        flexDirection: 'row',
        justifyContent: 'space-around',
        // borderWidth: 1,
        // borderTopWidth: 0,
        // borderLeftWidth: 0,
        // borderRightWidth: 0,
        // borderColor: '#ccc',
    },
    topBtn: {
        height: 30,
        width: 87,
        textAlign: 'center',
        lineHeight: 30,
    },
    border: {
        borderWidth: 1,
        borderColor: CommonStyles.globalHeaderColor,
        overflow: 'hidden'
    },
    leftBtn: {
        borderTopLeftRadius: 30,
        borderBottomLeftRadius: 30,
        backgroundColor: '#fff',
        color: '#fff',
        fontSize: 12
    },
    RightBtn: {
        borderTopRightRadius: 30,
        borderBottomRightRadius: 30,
        fontSize: 12,
        backgroundColor: '#fff',
        color: '#fff',
    },
});

module.exports = DefaultTabBar;