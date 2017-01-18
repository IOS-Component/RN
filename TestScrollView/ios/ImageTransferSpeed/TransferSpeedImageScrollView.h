//
//  TransferSpeedImageScrollView.h
//  pptshell
//
//  Created by richsjeson on 17/1/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TransferSpeedImageScrollViewDelegate
@required
//设置横屏竖屏时的旋转操作
-(void) setImageOrientation:(CGRect) frame;
@end


@protocol TransferSpeedImageScrollImageViewDelegate
@required
//设置横屏竖屏时的旋转操作
-(void) setImageFrame:(NSInteger) count;
@end


@interface TransferSpeedImageScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger) count;

@property(weak,nonatomic) id<TransferSpeedImageScrollViewDelegate>  scrollDelegate;


@end
