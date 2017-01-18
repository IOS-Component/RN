// // TestScrollView.js

import React, { Component, PropTypes } from 'react';
import { requireNativeComponent } from 'react-native';

// requireNativeComponent 自动把这个组件提供给 "RCTScrollView"
var RCTScrollView = requireNativeComponent('RichsViewPager', RichsViewPager);

export default class RichsViewPager extends Component {

  render() {
    return <RCTScrollView {...this.props} />;
  }

}

RichsViewPager.propTypes = {
    autoScroll: PropTypes.bool
};

module.exports = RichsViewPager;