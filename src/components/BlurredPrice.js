
import React, { PureComponent } from 'react';
import { Image } from 'react-native';
import { connect } from 'rn-dva';

class BlurredPrice extends PureComponent {
    static defaultProps = {
      color: 'red'
    }
    state = {
      blurred: true,
    }

    componentDidMount() {
      this.getMerchantAduitStatus();
    }

    getMerchantAduitStatus = () => {
      try {
        const { identityStatuses } = this.props.userInfo;
        const temp = identityStatuses.map(item => (item.auditStatus === 'active' ? true : false));
        this.changeState('blurred', !temp.includes(true));
      } catch (error) {
        this.changeState('blurred', true);
      }
    }

    changeState = (key, value) => {
      this.setState({
        [key]: value,
      });
    }

    render() {
      const { blurred } = this.state;
      const { color, style } = this.props
      let img = color === 'red' 
        ? <Image style={{ height: 14, width: 50}} source={require('../images/mall/price_blurred.png')} />
        : <Image style={{ height: 14, width: 50}} source={require('../images/mall/price_blurred_black.png')} />;
      return (
        <React.Fragment>
          {
                blurred
                  ? img
                  : this.props.children
            }
        </React.Fragment>
      );
    }
}
export default connect(
  state => ({ userInfo: state.user.user }),
)(BlurredPrice);
