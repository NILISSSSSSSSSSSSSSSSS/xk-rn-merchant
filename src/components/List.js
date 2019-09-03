import React, { Component } from 'react';
import {
  View, Text, StyleSheet, TouchableOpacity, Image,
} from 'react-native';

export default class List extends Component {
  render() {
    const {
      header, footer, children, style = {},
    } = this.props;
    return (
      <View style={[styles.list, style]}>
        {header}
        {children}
        {footer}
      </View>
    );
  }
}

export class ListItem extends Component {
  render() {
    const {
      title, subtitle, arrow = false, extra, icon, horizontal = true, onPress,
      iconContainerStyle, iconStyle, style, contentStyle, titleContainerStyle, titleStyle = {}, subtitleStyle = {},
      extraContainerStyle, extraStyle, arrowStyle, onExtraPress, onIconPress, extraProps = {},
      hidden = false,
    } = this.props;

    if (hidden) return null;

    const Container = onPress ? TouchableOpacity : View;
    const ExtraContainer = onExtraPress ? TouchableOpacity : View;
    const IconContainer = onIconPress ? TouchableOpacity : View;
    return (
      <Container style={[styles.listItem, style]} onPress={() => onPress && onPress()}>
        <IconContainer style={[styles.iconContainer, icon ? { marginRight: 10 } : { width: 0 }, iconContainerStyle]} onPress={() => onIconPress && onIconPress()}>
          {icon ? <Image style={[styles.icon, iconStyle]} source={icon} /> : null}
        </IconContainer>
        <View style={[horizontal ? styles.contentH : styles.contentV, contentStyle]}>
          <View style={[styles.titleContainer, titleContainerStyle]}>
            { typeof title === 'string' ? <View><Text style={[styles.title, titleStyle]}>{title}</Text></View> : title}
            { typeof subtitle === 'string' ? <View><Text style={[styles.subtitle, subtitleStyle]}>{subtitle}</Text></View> : subtitle}
          </View>
          <ExtraContainer style={[styles.extraContainer, extraContainerStyle]} onPress={() => onExtraPress && onExtraPress()}>
            { typeof extra === 'string' ? <Text style={[styles.extra, extraStyle]} {...extraProps}>{extra}</Text> : extra}
            { arrow ? <Image source={require('../images/index/expand.png')} style={[styles.arrow, arrowStyle]} /> : null}
          </ExtraContainer>
        </View>
      </Container>
    );
  }
}

export const ListTitle = (props) => {
  const { title, titleStyle, style } = props;
  return (
    <View style={[styles.listTitleContainer, style]}>
      { typeof title === 'string' ? <Text style={[styles.listTitle, titleStyle]}>{title}</Text> : title }
    </View>
  );
};

export const Splitter = props => <View style={[styles.splitter, props.style]} />;

const styles = StyleSheet.create({
  list: {
    flexDirection: 'column',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  listItem: {
    justifyContent: 'space-between',
    alignItems: 'center',
    flexDirection: 'row',
    paddingVertical: 10,
  },
  contentV: {
    flex: 1,
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'flex-start',
  },
  contentH: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  extraContainer: {
    justifyContent: 'flex-end',
    alignItems: 'center',
    flexDirection: 'row',
  },
  titleContainer: {
    flexDirection: 'column',
    alignItems: 'flex-start',
    justifyContent: 'center',
  },
  title: {
    color: '#222222',
    fontSize: 15,
  },
  subtitle: {
    color: '#222222',
    fontSize: 12,
  },
  extra: {
    color: '#9E9E9E',
    fontSize: 15,
  },
  listTitleContainer: {
    height: 50,
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  listTitle: {
    color: '#222222',
    fontSize: 15,
  },
  splitter: {
    height: 1,
    width: '100%',
    backgroundColor: '#F1F1F1',
  },
});
