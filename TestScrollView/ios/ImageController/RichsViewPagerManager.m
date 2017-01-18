//
//  RCTRichsImageManager.m
//  DemoNativeComponent
//
//  Created by richsjeson on 17/1/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RichsViewPagerManager.h"
#import "RichsViewPager.h"

@implementation RichsViewPagerManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(autoScroll, BOOL);

- (UIView *)view
{
  return [[RichsViewPager alloc] init];
}

RCT_EXPORT_METHOD(testResetTime:(RCTResponseSenderBlock)callback) {
  
  callback(@[@(234)]);
}

@end
