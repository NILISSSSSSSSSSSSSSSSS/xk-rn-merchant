import { Component, PureComponent } from 'react';

/**
 * class PageScreen extends NavigationComponent {
 *
 *      blurState = {
 *          modalVisible: false,
 *      }
 *
 *      screenDidFocus = (payload)=> {
 *          super.screenDidFocus(payload)
 *          //  do something
 *      }
 *
 *      componentWillUnmount = ()=> {
 *          super.componentWillUnmount()
 *          // do something
 *      }
 * }
 */
export class NavigationComponent extends Component {
    blurState = {}
    focusState = {}
    constructor(props) {
      super(props);
      if (this.props.navigation) {
        this.__addListener();
      }
    }

    componentWillUnmount() {
      console.log('NavigationComponent.componentWillUnmount');
      this.__unmount = true;
    }

    __addListener = () => {
      this.didFocusListener && this.didFocusListener.remove();
      this.willFocusListener && this.willFocusListener.remove();
      this.willBlurListener && this.willBlurListener.remove();
      this.didBlurListener && this.didBlurListener.remove();
      this.didFocusListener = this.props.navigation.addListener('didFocus', payload => this.screenDidFocus(payload));
      this.willFocusListener = this.props.navigation.addListener('willFocus', payload => this.screenWillFocus(payload));
      this.willBlurListener = this.props.navigation.addListener('willBlur', payload => this.screenWillBlur(payload));
      this.didBlurListener = this.props.navigation.addListener('didBlur', payload => this.screenDidBlur(payload));
    }

    __removeListener = () => {
      this.didFocusListener && this.didFocusListener.remove();
      this.willFocusListener && this.willFocusListener.remove();
      this.willBlurListener && this.willBlurListener.remove();
      this.didBlurListener && this.didBlurListener.remove();
      this.didFocusListener = null;
      this.willFocusListener = null;
      this.willBlurListener = null;
      this.didBlurListener = null;
    }

    screenDidFocus(payload) {
      console.log('NavigationComponent.screenDidFocus', payload);
    }
    screenWillFocus(payload) {
      console.log('NavigationComponent.screenWillFocus', payload);
      this.setState(this.focusState);
    }
    screenWillBlur(payload) {
      console.log('NavigationComponent.screenWillBlur', payload);
      this.setState(this.blurState);
    }
    screenDidBlur(payload) {
      console.log('NavigationComponent.screenDidBlur', payload);
      /** 如果组件已经被移除，需要移除监听 */
      if (this.__unmount) {
        this.__removeListener();
      }
    }
}

export class NavigationPureComponent extends PureComponent {
    blurState = {}
    focusState = {}
    constructor(props) {
      super(props);
      if (this.props.navigation) {
        this.__addListener();
      }
    }

    componentWillUnmount() {
      console.log('NavigationPureComponent.componentWillUnmount');
      this.__unmount = true;
    }

    __addListener = () => {
      this.didFocusListener && this.didFocusListener.remove();
      this.willFocusListener && this.willFocusListener.remove();
      this.willBlurListener && this.willBlurListener.remove();
      this.didBlurListener && this.didBlurListener.remove();
      this.didFocusListener = this.props.navigation.addListener('didFocus', payload => this.screenDidFocus(payload));
      this.willFocusListener = this.props.navigation.addListener('willFocus', payload => this.screenWillFocus(payload));
      this.willBlurListener = this.props.navigation.addListener('willBlur', payload => this.screenWillBlur(payload));
      this.didBlurListener = this.props.navigation.addListener('didBlur', payload => this.screenDidBlur(payload));
    }

    __removeListener = () => {
      this.didFocusListener && this.didFocusListener.remove();
      this.willFocusListener && this.willFocusListener.remove();
      this.willBlurListener && this.willBlurListener.remove();
      this.didBlurListener && this.didBlurListener.remove();
      this.didFocusListener = null;
      this.willFocusListener = null;
      this.willBlurListener = null;
      this.didBlurListener = null;
    }

    screenDidFocus(payload) {
      console.log('NavigationPureComponent.screenDidFocus', payload);
    }
    screenWillFocus(payload) {
      console.log('NavigationPureComponent.screenWillFocus', payload);
      this.setState(this.focusState);
    }
    screenWillBlur(payload) {
      console.log('NavigationPureComponent.screenWillBlur', payload);
      this.setState(this.blurState);
    }
    screenDidBlur(payload) {
      console.log('NavigationPureComponent.screenDidBlur', payload);
      /** 如果组件已经被移除，需要移除监听 */
      if (this.__unmount) {
        this.__removeListener();
      }
    }
}
