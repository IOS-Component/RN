//
//  TransferSpeedImageView.h
//  pptshell
//
//  Created by richsjeson on 17/1/16.
//  Copyright © 2017年 mac. All rights reserved.
//  图片快传的图片选择器，作用-横竖屏切换时纠正位置
//

#import <UIKit/UIKit.h>

@interface TransferSpeedImageView : UIImageView
- (instancetype)initWithFrame:(CGRect)frame dict:(UIImage *) dict;
-(void) setImageFrame:(NSInteger) count frame:(CGRect) rect;
-(CGRect) getImageFrame;
-(void)setImageOrientation:(CGRect) frame;
@property(nonatomic,assign) long currentPage;
@end
