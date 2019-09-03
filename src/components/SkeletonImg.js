// 图片骨架屏幕
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Image,
} from 'react-native';

export default class SkeletonImg extends PureComponent {
    static defaultProps = {
      imgStyle: { width: 80, height: 80 },
      url: '',
    }

    render() {
      const { imgStyle, url } = this.props;
      return (
        <React.Fragment>
          <Image
                    style={[styles.skeletonImg, imgStyle]}
                    source={require('../images/skeleton/skeleton_img.png')}
          />
          {
            this.props.children
          }
        </React.Fragment>
      );
    }
}
const styles = StyleSheet.create({
  skeletonImg: {
    width: '100%',
    height: '100%',
  },
});
