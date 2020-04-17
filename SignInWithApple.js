import React, { Component } from 'react';
import { requireNativeComponent, NativeModules, findNodeHandle } from 'react-native';

const SignInWithAppleView = requireNativeComponent('SignInWithAppleModule', SignInWithApple);
type Props = {
  onComplete?: Function
};

export default class SignInWithApple extends Component<Props> {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <SignInWithAppleView
        {...this.props}
      />
    );
  }
}