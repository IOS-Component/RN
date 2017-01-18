//
//  RCTMapManager.m
//  DemoNativeComponent
//
//  Created by richsjeson on 17/1/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTMapManager.h"

@implementation RCTMapManager
RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[RCTMapManager alloc] init];
}
@end
