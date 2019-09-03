import React, { Component, PureComponent } from "react";
import { requireNativeComponent, View, UIManager, findNodeHandle, } from 'react-native';
const fragmentIFace = {
    name: "Fragment",
    propTypes: {
        ...View.propTypes,
    }
};
const NativeFragment = requireNativeComponent("MerchantFriendFrameLayout", fragmentIFace);


class MerchantFriendFrameLayout extends Component {
    fragment;
    componentDidMount () {

    }
    render() {
        return <NativeFragment
            ref={c => this.fragment = c}
            {...this.props} style={{ flex: 1 }} />
    }

    create = () => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.fragment),
            1001, // 命令code
            []
        )
    }
}
export default MerchantFriendFrameLayout
