import React, {
    Component,
} from 'react';
import PropTypes from 'prop-types';
import {
    Animated,
    PanResponder,
    Platform,
    StyleSheet,
    TouchableOpacity,
    ViewPropTypes,
    View,
    Text
} from 'react-native';

export default class SwipeRow extends Component {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this._panResponder = PanResponder.create({
            onMoveShouldSetPanResponderCapture: this._handleMoveShouldSetPanResponderCapture.bind(this),
            onPanResponderGrant: this._handlePanResponderGrant.bind(this),
            onPanResponderMove: this._handlePanResponderMove.bind(this),
            onPanResponderRelease: this._handlePanResponderEnd.bind(this),
            onPanResponderTerminate: this._handlePanResponderEnd.bind(this),
            onShouldBlockNativeResponder: (event, gestureState) => false,//表示是否用 Native 平台的事件处理，默认是禁用的，全部使用 JS 中的事件处理，注意此函数目前只能在 Android 平台上使用
        });
        //上一次滑动最后的left偏移量
        this._previousLeft = 0;
        //left偏移动画
        this.state = {
            currentLeft: new Animated.Value(this._previousLeft),
            rightWidth: this.props.children[0].props.style.width ? this.props.children[0].props.style.width : 100,
            swipeIndex:''
        };
        this._isOpen = false;
    }

    render() {
        return (
            <View style={[styles.swipeContainer, this.props.style]}>
                <View style={styles.swipeActions}>
                    {this.props.children[0]}
                </View>
                {this.renderRowContent()}
            </View>
        );
    }

    renderRowContent() {
        return (
            <Animated.View
                {...this._panResponder.panHandlers}
                style={{
                    transform: [
                        { translateX: this.props.index===this.state.swipeIndex?this.state.currentLeft:0 }
                    ]
                }}
            >
                {this.props.children[1]}
            </Animated.View>
        );
    }

    /**
     * 是否需要成为move事件响应者，返回true直接走onPanResponderMove
     * @param event
     * @param gestureState
     * @returns {boolean}
     * @private
     */
    _handleMoveShouldSetPanResponderCapture(event: Object, gestureState: Object, ): boolean {
        //当垂直滑动的距离<10 水平滑动的距离>10的时候才让捕获事件
        // console.log('_handleMoveShouldSetPanResponderCapture',this.props.index);
        this.setState({swipeIndex:this.props.index})
        return Math.abs(gestureState.dy) < 10 && Math.abs(gestureState.dx) > 10;
    }

    /**
     * 表示申请成功，组件成为了事件处理响应者
     * @param event
     * @param gestureState
     * @private
     */
    _handlePanResponderGrant(event: Object, gestureState: Object): void {
        // console.log('_handlePanResponderGrant');
    }

    /**
     * 处理滑动事件
     * @param event
     * @param gestureState
     * @private
     */
    _handlePanResponderMove(event: Object, gestureState: Object): void {
        if (this._previousLeft === null) {
            this._previousLeft = this.state.currentLeft._value
        }
        let nowLeft = this._previousLeft + gestureState.dx * 1;
        //右滑最大距离为0（边界值）
        nowLeft = Math.min(nowLeft, 0);
        this.state.currentLeft.setValue(
            nowLeft,
        );
    }

    /**
     * 结束事件的时候回调
     * @param event
     * @param gestureState
     * @private
     */
    _handlePanResponderEnd(event: Object, gestureState: Object): void {
        if (this._isOpen) {
            if (Math.abs(this.state.currentLeft._value) >= this.state.rightWidth) {
                this._animateToOpenPosition();
            } else {
                this._animateToClosedPosition();
            }
        } else {
            if (Math.abs(this.state.currentLeft._value) >= this.state.rightWidth / 3) {
                this._animateToOpenPosition();
            } else {
                this._animateToClosedPosition();
            }
        }
        this._previousLeft = null;
    }

    _shouldAnimateRemainder(gestureState: Object): boolean {
        /**
         * If user has swiped past a certain distance, animate the rest of the way
         * if they let go
         */
        return (
            Math.abs(gestureState.dx) > this.state.rightWidth / 3 ||
            gestureState.vx > 0.3
        );
    }

    _animateToOpenPosition(): void {
        this._isOpen = true;
        this._animateTo(-this.state.rightWidth);
    }

    _animateToClosedPosition(duration: number = this.state.rightWidth * 3): void {
        this._isOpen = false;
        this._animateTo(0, duration);
    }

    _animateTo(toValue, duration = this.state.rightWidth * 3, callback): void {
        Animated.spring(
            this.state.currentLeft,
            {
                toValue,
            }
        ).start((value) => {
        });
    }
}
const styles = StyleSheet.create({
    swipeContainer: {
        width: '100%',
    },
    swipeActions: {
        // backgroundColor: 'white',
        width: '100%',
        overflow: 'hidden',
        ...StyleSheet.absoluteFillObject,
        flexDirection: 'row',
        justifyContent: 'flex-end'
    },
});
