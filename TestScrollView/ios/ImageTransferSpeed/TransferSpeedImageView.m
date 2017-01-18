//
//  TransferSpeedImageView.m
//  pptshell
//
//  Created by richsjeson on 17/1/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TransferSpeedImageView.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface TransferSpeedImageView(){
//    
    UIImage *currentImage;
}
@end
@implementation TransferSpeedImageView
- (instancetype)initWithFrame:(CGRect)frame dict:(UIImage *) image{
    
    if(self==[super initWithFrame:frame]){
        [self setImage:image];
        currentImage=image;
        [self setImageOrientation:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return self;
}

//设置方向的Frame
-(void)setImageOrientation:(CGRect) frame{
    CGFloat  imgWidth = currentImage.size.width;
    CGFloat  imgHeight = currentImage.size.height;
    CGFloat  ivWidth = frame.size.width;
    CGFloat  ivHeight = frame.size.height;
    CGFloat  imgScale = imgWidth / imgHeight;
    CGFloat  ivScalce = ivWidth / ivHeight;
    CGFloat  originX = 0;
    CGFloat  originY = 0;
    CGFloat  size_width = 0;
    CGFloat  size_height = 0;
    if (imgScale > ivScalce) {
        size_width = ivWidth;
        size_height = imgHeight * ivWidth / imgWidth;
        originX = 0;
        originY = (ivHeight - size_height) / 2;
        self.frame=CGRectMake(ivWidth*_currentPage, originY, size_width, size_height);
    } else {
        size_width = imgWidth * ivHeight / imgHeight;
        size_height = ivHeight;
        originX = (ivWidth - size_width) / 2;
        originY = 0;
        if(ivWidth>ivHeight){
            NSLog(@"滑动横屏后旋转后，横屏");
            self.frame=CGRectMake(originX+ivWidth*(_currentPage), originY, size_width, size_height);
        }else{
            NSLog(@"滑动横屏后旋转后，竖屏");
            self.frame=CGRectMake(ivWidth*_currentPage, originY, size_width, size_height);
        }
    
        NSLog(@"滑动横屏后旋转后，originX的值为:%f",originX);

    }
   

}

-(CGRect) getImageFrame{
    return self.frame;
}

//设置横屏竖屏时的旋转操作
-(void) setImageFrame:(NSInteger) count frame:(CGRect) rect{
    _currentPage=count;
    if(ScreenHeight > ScreenWidth){
        self.frame=CGRectMake(rect.size.width*_currentPage, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }else{
        self.frame=CGRectMake(self.frame.origin.x+rect.size.width*(_currentPage), self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
}



@end
