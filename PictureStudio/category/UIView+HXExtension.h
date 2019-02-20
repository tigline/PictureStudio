//
//  UIView+HXExtension.h
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXPhotoManager;
@class HXHUD;
@interface UIView (HXExtension)

@property (assign, nonatomic) CGFloat hx_x;
@property (assign, nonatomic) CGFloat hx_y;
@property (assign, nonatomic) CGFloat hx_w;
@property (assign, nonatomic) CGFloat hx_h;
@property (assign, nonatomic) CGSize hx_size;
@property (assign, nonatomic) CGPoint hx_origin;
@property (assign, nonatomic) CGFloat hx_centerY;
@property (assign, nonatomic) CGFloat hx_centerX;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGPoint leftTop;
@property (nonatomic, assign) CGPoint rightTop;
@property (nonatomic, assign) CGPoint leftBottom;
@property (nonatomic, assign) CGPoint rightBottom;
@property (strong, nonatomic) HXHUD *hud;

- (void)setCurveAnimation:(id)delegate startPoint:(CGPoint)startPoint controlPoint:(CGPoint)controlPoint endPoint:(CGPoint)endPoint duration:(CGFloat)duration;
/**
 获取当前视图的控制器
 
 @return 控制器
 */
- (UIViewController *)viewController;

- (void)showImageHUDText:(NSString *)text;
- (void)showLoadingHUDText:(NSString *)text;
- (void)handleLoading;

- (void) setOrigin:(float)x :(float)y;

- (void) resetOriginToTopLeft;
- (void) resetOriginToTopRight;

- (void) resetOriginToBottomLeft;

/* <HXAlbumListViewControllerDelegate> */
- (void)hx_presentAlbumListViewControllerWithManager:(HXPhotoManager *)manager delegate:(id)delegate;

/* <HXCustomCameraViewControllerDelegate> */
- (void)hx_presentCustomCameraViewControllerWithManager:(HXPhotoManager *)manager delegate:(id)delegate;

-(void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

@end


@interface HXHUD : UIView
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text;
- (void)showloading;
@end
