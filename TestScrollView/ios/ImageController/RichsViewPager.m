//
//  RichsViewPager.m
//  DemoNativeComponent
//
//  Created by richsjeson on 17/1/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RichsViewPager.h"

@interface RichsViewPager(){
  NSInteger currentPage;
  UIButton * mButton;
  //缩放前保留contentOffset.x ,回弹后回归初始化操作
  CGPoint contentOffset;
  CGSize  contentSize;
  BOOL    isRoate;
  CGFloat minimumZoomScale;
  CGFloat maximumZoomScale;
  CGFloat currentZoomScale;
  CGPoint passMaxScaleAnchorPoint;
  CGRect normalLandscapeImageFrame;
}
@property(nonatomic, assign) CGPoint touchStart;
@property(nonatomic,strong) TransferSpeedImageScrollView * mPhotoScrollView;
@property(nonatomic,strong) TransferSpeedImageView *cropperImage;
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@end
@implementation RichsViewPager

-(instancetype) init{
  
  if(self==[super init]){
    //设置缩放倍数
    NSLog(@"jinlai le ");
    minimumZoomScale = 1.0;
    maximumZoomScale = 4.0;
    currentZoomScale = 1.0;
    isRoate=NO;
    mButton=[[UIButton alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
    mButton.backgroundColor=[UIColor redColor];
    _mPhotoScrollView=[[TransferSpeedImageScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds count:4];
    _mPhotoScrollView.delegate=self;
    _mPhotoScrollView.pagingEnabled = YES;
    _mPhotoScrollView.bounces=YES;
    _mPhotoScrollView.bouncesZoom=YES;
    _mPhotoScrollView.showsHorizontalScrollIndicator=NO;
    _mPhotoScrollView.showsVerticalScrollIndicator=NO;
    _mPhotoScrollView.alwaysBounceHorizontal=YES;
    _mPhotoScrollView.contentSize=CGSizeMake(ScreenWidth*4, ScreenHeight);
    _mPhotoScrollView.scrollDelegate=self;
    [self addSubview:_mPhotoScrollView];
    [self addSubImageView];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(stickerViewHandlePinch:)];
    pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 双击放大缩小
    UITapGestureRecognizer *scaleBigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    scaleBigTap.numberOfTapsRequired = 2;
    scaleBigTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:scaleBigTap];

  }
  return  self;
}
-(void) addSubImageView{
  NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"ImageTransfer" ofType:@"bundle"];
  // 找到对应images夹下的图片
  for(int i=0;i<4;i++){
    NSString *strC = [[NSBundle bundleWithPath:strResourcesBundle] pathForResource:[NSString stringWithFormat:@"%d",i+1] ofType:@"png"];
    UIImage *imgC = [UIImage imageWithContentsOfFile:strC];
    TransferSpeedImageView * imgView=[[TransferSpeedImageView alloc] initWithFrame:CGRectZero dict:imgC];
    if(i==0){
      if(_cropperImage==nil){
        _cropperImage=imgView;
        //                [_cropperImage addSubview:mButton];
        [imgView setImageFrame:0 frame:_mPhotoScrollView.frame];
        normalLandscapeImageFrame=_cropperImage.frame;
      }
    }else{
      [imgView setImageFrame:i frame:_mPhotoScrollView.frame];
    }
    [_mPhotoScrollView addSubview:imgView];
  }
  
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
  return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return UIInterfaceOrientationPortrait;
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
  NSLog(@"viewWillTransitionToSize");
  isRoate=YES;
}


#pragma marker
-(void) setImageOrientation:(CGRect) frame{
  if(_cropperImage != nil){
    //设置到指定的页面
    if(_mPhotoScrollView.subviews.count>0){
      //旋转后，需要重置所有的frame
      for(int i=0;i<4;i++){
        TransferSpeedImageView *mage=[_mPhotoScrollView.subviews objectAtIndex:i];
        mage.currentPage=i;
        [mage setImageOrientation:_mPhotoScrollView.frame];
      }
      _mPhotoScrollView.contentOffset=CGPointMake(_mPhotoScrollView.frame.size.width*currentPage,0);
      //读取当前页数
      if(_mPhotoScrollView.subviews.count>0){
        _cropperImage=[_mPhotoScrollView.subviews objectAtIndex:currentPage];
        _cropperImage.currentPage=currentPage;
        //该出解决画布问题
        [_cropperImage setImageOrientation:_mPhotoScrollView.frame];
        normalLandscapeImageFrame=_cropperImage.frame;
      }
      isRoate=NO;
      
    }
  }
  
}


//双击放大缩小手势
- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
  CGPoint anchorPoint = [self correctAnchorPointBaseOnGestureRecognizer:gesture];
  [self setAnchorPoint:anchorPoint forView:gesture.view];
  if (currentZoomScale > minimumZoomScale) {   //缩小
    [self scale:minimumZoomScale/currentZoomScale hScaleFactor:minimumZoomScale/currentZoomScale checkMaxScaleFactor:YES gestureTag:1];
    currentZoomScale = minimumZoomScale;
  } else {    //放大
    [self scale:maximumZoomScale hScaleFactor:maximumZoomScale checkMaxScaleFactor:YES gestureTag:1];
    currentZoomScale = maximumZoomScale;
  }
  
}


// 缩放手势
- (void)stickerViewHandlePinch:(UIPinchGestureRecognizer *)gesture {
  if (gesture.numberOfTouches > 2) {
    return;
  }
  if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
    if (gesture.scale != 1.0 ) {
      _mPhotoScrollView.userInteractionEnabled=NO;
      CGPoint anchorPoint = [self correctAnchorPointBaseOnGestureRecognizer:gesture];
      [self setAnchorPoint:anchorPoint forView:_cropperImage];
      //            view.transform = CGAffineTransformScale(view.transform, gesture.scale, gesture.scale);
      BOOL canScale = [self scale:gesture.scale - 1.0 hScaleFactor:gesture.scale - 1.0 checkMaxScaleFactor:YES gestureTag:2];
      if (canScale) {
         CGSize factor = CGSizeMake(gesture.scale, gesture.scale);
         //此处需要进行数据连接
      }
      gesture.scale = 1;
    }
  } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled ||gesture.state == UIGestureRecognizerStateFailed ) {
    //缩放处理-放大
    if (currentZoomScale >= maximumZoomScale) {
      _mPhotoScrollView.userInteractionEnabled=NO;
      [UIView animateWithDuration:0.4 animations:^{
        [self setAnchorPoint:passMaxScaleAnchorPoint forView:_cropperImage];
        _cropperImage.transform = CGAffineTransformScale(_cropperImage.transform, maximumZoomScale/currentZoomScale, maximumZoomScale/currentZoomScale);
        currentZoomScale = maximumZoomScale;
      }];
      return;
    }
    //缩放处理-缩小
    if (currentZoomScale <= minimumZoomScale) {
      _mPhotoScrollView.userInteractionEnabled=YES;
      [UIView animateWithDuration:0.4 animations:^{
        [self scale:minimumZoomScale/currentZoomScale hScaleFactor:minimumZoomScale/currentZoomScale checkMaxScaleFactor:YES gestureTag:1];
        currentZoomScale = minimumZoomScale;
      }];
      return;
    }
    // 缩放结束后恢复锚点
    CGPoint anchorPoint = CGPointMake(0.5f, 0.5f);
    [self setAnchorPoint:anchorPoint forView:_cropperImage];
    
  }
}




/**
 *  Correct  UIGestureRecognizer 's view 's anchor point , make the view scale or rotate correctly.
 */
- (CGPoint)correctAnchorPointBaseOnGestureRecognizer:(UIGestureRecognizer *)gesture {
  CGPoint anchorPoint;
  if (gesture.numberOfTouches == 2) { //两指缩放的情况
    CGPoint onePoint = [gesture locationOfTouch:0 inView:_cropperImage];
    CGPoint twoPoint = [gesture locationOfTouch:1 inView:_cropperImage];
    anchorPoint.x = (onePoint.x + twoPoint.x) / 2 / _cropperImage.bounds.size.width;
    anchorPoint.y = (onePoint.y + twoPoint.y) / 2 / _cropperImage.bounds.size.height;
    if (currentZoomScale >= maximumZoomScale) {
      passMaxScaleAnchorPoint = anchorPoint;
    }
  }else{
    if (currentZoomScale == minimumZoomScale) {   //放大
      CGPoint onePoint = [gesture locationInView:_cropperImage];
      anchorPoint.x = onePoint.x / _cropperImage.bounds.size.width;
      anchorPoint.y = onePoint.y / _cropperImage.bounds.size.height;
    }else {
      anchorPoint = CGPointMake(0.5f, 0.5f);
    }
  }
  return anchorPoint;
}


- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
  UIView *inView = view;
  
  CGPoint oldOrigin = inView.frame.origin;
  inView.layer.anchorPoint = anchorPoint;
  CGPoint newOrigin = inView.frame.origin;
  
  CGPoint transition;
  transition.x = newOrigin.x - oldOrigin.x;
  transition.y = newOrigin.y - oldOrigin.y;
  
  view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}


// 缩放
-(BOOL)scale:(CGFloat)wFactor hScaleFactor:(CGFloat)hFactor checkMaxScaleFactor:(BOOL)checkFactor gestureTag:(NSInteger)tag{
  if (wFactor == 0.0 && hFactor == 0.0) {
    return NO;
  }
  if (tag == 1) {
    [UIView animateWithDuration:0.4 animations:^{
      _cropperImage.transform = CGAffineTransformScale(_cropperImage.transform, wFactor, hFactor);
      if (currentZoomScale != minimumZoomScale) {
        _cropperImage.center = CGPointMake(normalLandscapeImageFrame.origin.x+normalLandscapeImageFrame.size.width/2, normalLandscapeImageFrame.origin.y+normalLandscapeImageFrame.size.height/2);
      }
      [self getIsPassEdge];
    }];
  } else {
    _cropperImage.transform = CGAffineTransformScale(_cropperImage.transform, wFactor + 1.0, hFactor + 1.0);
    currentZoomScale = _cropperImage.frame.size.height/normalLandscapeImageFrame.size.height;
  }
  
  return YES;
}


-(BOOL)shouldAutorotate{
  return YES;
}
//滚动时，获取页数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (scrollView == self.mPhotoScrollView) {
    
    NSLog(@"viewWillTransitionToSize 2");
    if(!isRoate){
      currentPage= _mPhotoScrollView.contentOffset.x/ScreenWidth;
      contentOffset=_mPhotoScrollView.contentOffset;
      NSLog(@"滑动横屏后旋转后，currentPage 2 的值为:%ld",currentPage);
      //横竖屏判断，滑动时，根据页面的键值取出对应的image
      if(_mPhotoScrollView.subviews.count>0){
        _cropperImage=[_mPhotoScrollView.subviews objectAtIndex:currentPage];
        _cropperImage.currentPage=currentPage;
        //该出解决画布问题
        //                [_cropperImage addSubview:mButton];
        [_cropperImage setImageOrientation:_mPhotoScrollView.frame];
        normalLandscapeImageFrame=_cropperImage.frame;
      }
    }
    
    
  }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  //    [self enableTransluceny:YES];
  
  UITouch *touch = [touches anyObject];
  self.touchStart = [touch locationInView:_cropperImage.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  CGPoint touch = [[touches anyObject] locationInView:_cropperImage.superview];
  [self translateUsingTouchLocation:touch];
  self.touchStart = touch;
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  
  [self getIsPassEdge];
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
  CGPoint newCenter = CGPointMake(_cropperImage.center.x + touchPoint.x - self.touchStart.x,
                                  _cropperImage.center.y + touchPoint.y - self.touchStart.y);
  _cropperImage.center = newCenter;
}

- (void)getIsPassEdge{
  CGRect currentLandScapeImgFrame = _cropperImage.frame;
  //顶部情况 y=0时，再往下拉 松手时往回弹
  if (currentLandScapeImgFrame.origin.y > normalLandscapeImageFrame.origin.y) {
    currentLandScapeImgFrame.origin.y = normalLandscapeImageFrame.origin.y;
  }
  //左边情况 x=self.normalLandscapeImageFrame.origin.x时，再往右拉 松手时往回弹
  if (currentLandScapeImgFrame.origin.x > normalLandscapeImageFrame.origin.x) {
    currentLandScapeImgFrame.origin.x = normalLandscapeImageFrame.origin.x;
  }
  //底部情况 currentLandScapeImgFrame.size.height+currentLandScapeImgFrame.origin.y<normalF时，再往上拉 松手时往回弹
  if (currentLandScapeImgFrame.size.height+currentLandScapeImgFrame.origin.y < normalLandscapeImageFrame.size.height+normalLandscapeImageFrame.origin.y) {
    currentLandScapeImgFrame.origin.y = normalLandscapeImageFrame.size.height+normalLandscapeImageFrame.origin.y-currentLandScapeImgFrame.size.height;
  }
  //右边情况 currentLandScapeImgFrame.size.width+currentLandScapeImgFrame.origin.x<normalF时，再往左拉 松手时往回弹
  if (currentLandScapeImgFrame.origin.x + currentLandScapeImgFrame.size.width < normalLandscapeImageFrame.size.width+normalLandscapeImageFrame.origin.x) {
    currentLandScapeImgFrame.origin.x = normalLandscapeImageFrame.size.width+normalLandscapeImageFrame.origin.x - currentLandScapeImgFrame.size.width;
  }
  [UIView animateWithDuration:0.3 animations:^{
    _cropperImage.frame = currentLandScapeImgFrame;
  }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
}

@end
