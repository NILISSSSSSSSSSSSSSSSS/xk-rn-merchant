import React, { Component } from 'react';
import {
  Text, Image, ImageBackground, View, TouchableOpacity,
} from 'react-native';

export default class SecurityCode extends Component {
  render() {
    const { securityCode, onPress, style = {} } = this.props;
    const Container = onPress ? TouchableOpacity : View;
    if (!securityCode) return null;
    return (
      <ImageBackground
        source={require('../../../images/my/securityCodeBg.png')}
        style={[{ width: 109, height: 32 }, style]}
      >
        <Container
          onPress={() => onPress && onPress()}
          style={{
            width: 99, height: 22, marginLeft: 5, marginTop: 3, flexDirection: 'row', justifyContent: 'flex-start', alignItems: 'center',
          }}
        >
          <Image source={require('../../../images/my/securityCodeQr.png')} style={{ width: 9, height: 9, marginLeft: 10 }} />
          <View style={{ marginLeft: 4, justifyContent: 'center', alignItems: 'center' }}>
            <Text style={{ fontSize: 10, color: '#fff' }}>
              {`安全码:${securityCode}`}
            </Text>
          </View>
        </Container>
      </ImageBackground>
    );
  }
}
