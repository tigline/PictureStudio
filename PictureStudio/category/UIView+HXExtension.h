//
//  UIView+HXExtension.h
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXPhotoManager;
@interface UIView (HXExtension)

@property (assign, nonatomic) CGFloat hx_x;
@property (assign, nonatomic) CGFloat hx_y;
@property (assign, nonatomic) CGFloat hx_w;
@property (assign, nonatomic) CGFloat hx_h;
@property (assign, nonatomic) CGSize hx_size;
@property (assign, nonatomic) CGPoint hx_origin;
@property (assign, nonatomic) CGFloat hx_centerY;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGPoint leftTop;
@property (nonatomic, assign) CGPoint rightTop;
@property (nonatomic, assign) CGPoint leftBottom;
@property (nonatomic, assign) CGPoint rightBottom;

/**
 获取当前视图的控制器
 
 @return 控制器
 */
- (UIViewController *)viewController;

- (void)showImageHUDText:(NSString *)text;
- (void)showLoadingHUDText:(NSString *)text;
- (void)handleLoading;

/* <HXAlbumListViewControllerDelegate> */
- (void)hx_presentAlbumListViewControllerWithManager:(HXPhotoManager *)manager delegate:(id)delegate;

/* <HXCustomCameraViewControllerDelegate> */
- (void)hx_presentCustomCameraViewControllerWithManager:(HXPhotoManager *)manager delegate:(id)delegate;

@end


@interface HXHUD : UIView
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text;
- (void)showloading;
@end
