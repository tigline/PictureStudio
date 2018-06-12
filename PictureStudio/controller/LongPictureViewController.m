//
//  LongPictureViewController.m
//  PictureStudio
//
//  Created by Aaron Hou on 11/02/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "LongPictureViewController.h"
#import <Photos/Photos.h>
#import "HXPhotoDefine.h"
#import "AppDelegate.h"
#import "PhotoSaveBottomView.h"
#import "UIView+HXExtension.h"
#import "HXPhotoDefine.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface LongPictureViewController () <UIScrollViewDelegate,PhotoSaveBottomViewDelegate>
@property (strong, nonatomic)  UIScrollView *longPictureView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *shareBoardView;
@property (strong, nonatomic) PhotoSaveBottomView *toolBarView;
@property (assign, nonatomic) BOOL canOpenWeixin;
@property (assign, nonatomic) BOOL canOpenWeibo;
@property (assign, nonatomic) BOOL isShowShareBoardView;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (nonatomic, strong) UIView *imageContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBoardHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnWidth;




@end

@implementation LongPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    _longPictureView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopMargin, self.view.hx_w, self.view.hx_h - kBottomMargin - kTopMargin)];
    [self.view addSubview:_longPictureView];
    _longPictureView.bouncesZoom = YES;
    _longPictureView.maximumZoomScale = 2.5;
    _longPictureView.minimumZoomScale = 1.0;
    _longPictureView.multipleTouchEnabled = YES;
    _longPictureView.delegate = self;
    _longPictureView.scrollsToTop = NO;
    _longPictureView.showsHorizontalScrollIndicator = NO;
    _longPictureView.showsVerticalScrollIndicator = NO;
    _longPictureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _longPictureView.delaysContentTouches = NO;
    _longPictureView.canCancelContentTouches = YES;
    _longPictureView.alwaysBounceVertical = NO;
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    
    _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    [_longPictureView addSubview:_imageContainerView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self.view addGestureRecognizer:tap2];
    _shareBoardHeight.constant = 73*ScreenHeightRatio;
    _shareBtnWidth.constant = 46*ScreenWidthRatio;
    if (@available(iOS 11.0, *)) {
        _longPictureView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    [self.view bringSubviewToFront:self.shareBoardView];
    [_shareBoardView setHidden:YES];
    [self.view addSubview:self.toolBarView];//创建保存图片区域
    CGFloat scrollViewSizeValue;
    if (_manager.isCombineVertical) {
        scrollViewSizeValue = [_manager getSelectPhotosMinWidth]/[UIScreen mainScreen].scale;
    } else {
        scrollViewSizeValue = [_manager getSelectPhotosMinHeight]/[UIScreen mainScreen].scale;
    }
    
    [self resetImageView:scrollViewSizeValue];
    
//    [self.manager combinePhotosWithDirection:_manager.isCombineVertical resultImage:^(UIImage *combineImage) {
//        _resultImage = combineImage;
//        [self resetImageView:combineImage];
//
//    }];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    if (!_manager.isCombineVertical) {
//        _scrollMaginBottom.constant = kBottomMargin + ButtomViewHeight;
//    }
}



- (void)resetImageView:(CGFloat)scrollViewSizeValue
{

    BOOL isCombineVertical = _manager.isCombineVertical;
    CGRect cgpos;
    if (isCombineVertical) {
        for (int i = 0; i < _manager.selectedArray.count; i++) {
            HXPhotoModel *mode = [_manager.selectedArray objectAtIndex:i];
            UIImage *image = mode.previewPhoto;
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            CGFloat contentViewOffset;
 
                contentViewOffset = _imageContainerView.hx_h;
            
            
            if (scrollViewSizeValue > _longPictureView.frame.size.width) {
                cgpos.origin.x = 0;
                cgpos.origin.y = contentViewOffset;
                cgpos.size.width = _longPictureView.frame.size.width;
                cgpos.size.height = imageView.size.height * (cgpos.size.width/imageView.size.width);
            }else {
                cgpos.origin.x = 0;
                cgpos.origin.y = contentViewOffset;
                cgpos.size.width = _longPictureView.frame.size.width;
                cgpos.size.height = imageView.size.height * ((_longPictureView.frame.size.width)/image.size.width);
            }
            
            _imageContainerView.size = CGSizeMake(cgpos.size.width, contentViewOffset + cgpos.size.height);
            
            imageView.frame = cgpos;
            [_imageContainerView addSubview:imageView];
            
        }

        [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, _imageContainerView.hx_h)];
        if (_imageContainerView.hx_h < _longPictureView.hx_h - ButtomViewHeight) {
            CGFloat offsetY = (_longPictureView.hx_h - ButtomViewHeight - _imageContainerView.hx_h)/2;
            _imageContainerView.frame = CGRectMake(10, 10 + offsetY, _imageContainerView.hx_w - 20, _imageContainerView.hx_h - 20);
        } else {
            _imageContainerView.frame = CGRectMake(10, 10, _imageContainerView.hx_w - 20, _imageContainerView.hx_h - 20);
        }

        
    } else {
        
        for (int i = 0; i < _manager.selectedArray.count; i++) {
            
            HXPhotoModel *mode = [_manager.selectedArray objectAtIndex:i];
            UIImage *image = mode.previewPhoto;
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            CGFloat contentViewOffset;
    
            contentViewOffset = _imageContainerView.hx_w;

            CGFloat longPictureViewHeight = _longPictureView.frame.size.height - ButtomViewHeight;
            if (scrollViewSizeValue > longPictureViewHeight) {
                cgpos.origin.x = contentViewOffset;
                cgpos.origin.y = 0;
                cgpos.size.width =  (imageView.size.width) * (longPictureViewHeight/imageView.size.height);
                cgpos.size.height = longPictureViewHeight;
                

            }else {
                cgpos.origin.x = contentViewOffset;
                cgpos.origin.y = (longPictureViewHeight - scrollViewSizeValue)/2;
                cgpos.size.width = (imageView.size.width) * (scrollViewSizeValue/imageView.size.height);
                cgpos.size.height = scrollViewSizeValue;
            }
            _imageContainerView.size = CGSizeMake(contentViewOffset + cgpos.size.width, cgpos.size.height);
            imageView.frame = cgpos;
            [_imageContainerView addSubview:imageView];

        }
        [_longPictureView setContentSize:CGSizeMake(_imageContainerView.hx_w, _longPictureView.frame.size.height - ButtomViewHeight)];
        
        CGRect cgPos;
        
        if (_imageContainerView.hx_w < _longPictureView.hx_w) {
            CGFloat offsetX = (_longPictureView.hx_w - _imageContainerView.hx_w)/2;
            cgPos.origin.x = 10 + offsetX;
            cgPos.size.width = _imageContainerView.hx_w - 20;
        } else {
            cgPos.origin.x = 10;
            cgPos.size.width = _imageContainerView.hx_w - 20;
        }
        
        if (_imageContainerView.hx_h < _longPictureView.hx_h - ButtomViewHeight) {
            CGFloat offsetY = (_longPictureView.hx_h - ButtomViewHeight - _imageContainerView.hx_h)/2;
            cgPos.origin.y = offsetY + 10;
            cgPos.size.height = _imageContainerView.hx_h - 20;
        } else {
            cgPos.origin.y = 10;
            cgPos.size.height = _imageContainerView.hx_h - 20;
        }

        _imageContainerView.frame = cgPos;
        
        
        

    }

    [_longPictureView setUserInteractionEnabled:YES];


    
}

- (BOOL)prefersStatusBarHidden {
    if (kDevice_Is_iPhoneX) {
        return NO;
    }
    return YES;
}

-(void)touchOnImage:(UITapGestureRecognizer*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onShareWechatClicked:(id)sender {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatSession];
    
}

- (IBAction)onShareMomentClicked:(id)sender {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    
}

- (IBAction)onShareWeiboClicked:(id)sender {
    [self shareImageToPlatformType:UMSocialPlatformType_Sina];
    
}

- (IBAction)onShareMoreClicked:(id)sender {
    NSLog(@"shareMoreImageOnClick");
    UIImage *imageToShare = _resultImage;

    NSArray *activityItems = @[imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    UIImage *saveImage = _resultImage;

    [shareObject setShareImage:saveImage];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            if ([error.localizedDescription containsString:@"2008"]) {
                [self showShareError:platformType];
            }
        }else{
            NSLog(@"response data is %@",data);
            [self shareReturnByCode:0];
        }
    }];
}

#pragma mark delegate 监听微信分享是否成功
-(void)shareReturnByCode:(int)code
{
    
    NSString *strTitle = LocalString(@"share_success");
    
    if (code != 0)
    {
        strTitle = LocalString(@"share_failed");
    }
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              //NSLog(@"action = %@", action);
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
    
}

- (PhotoSaveBottomView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[PhotoSaveBottomView alloc] initWithFrame:CGRectMake(0, self.view.hx_h - ButtomViewHeight - kBottomMargin, self.view.hx_w, ButtomViewHeight + kBottomMargin)];
        _toolBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _toolBarView.delegate = self;
    }
    return _toolBarView;
}

- (void)showShareBoard {
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY - _toolBarView.hx_h + kBottomMargin, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         _isShowShareBoardView = YES;
                         
                     }];
}

- (void)hideShareBoard {
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY + _toolBarView.hx_h - kBottomMargin, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         [_shareBoardView setHidden:YES];
                         _isShowShareBoardView = NO;
                     }];
}

#pragma mark scrollView delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentHeight = scrollView.contentSize.height - self.view.hx_h;
    CGFloat contentOffsetY = scrollView.contentOffset.y;

    
    if (contentOffsetY < kTopMargin && contentOffsetY > -kTopMargin) {
        self.longPictureView.frame = CGRectMake(0, kTopMargin, self.view.hx_w, self.view.hx_h);
    } else if (contentOffsetY < contentHeight && contentOffsetY > kTopMargin) {
        //向下
        //if (_canDetectScroll) {

        self.longPictureView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h);
        
        
        
        //}
        //[self.navigationController setNavigationBarHidden:NO animated:YES];

    } else if (contentOffsetY > contentHeight) {


        //向上
        CGFloat bottomMargin = 0.0;
        if (kDevice_Is_iPhoneX) {
            bottomMargin = self.toolBarView.hx_h;
        } else {
            bottomMargin = ButtomViewHeight;
        }
        if (contentOffsetY > contentHeight && contentOffsetY < contentHeight+bottomMargin) {
            self.longPictureView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h - bottomMargin);
        }
        //[self.navigationController setNavigationBarHidden:YES animated:YES];

    }
}

#pragma PhotoSaveBottomViewDelegate

- (void)savePhotoBottomViewDidBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)savePhotoBottomViewDidSaveBtn:(UIButton *)button {
    
    
    if([button.titleLabel.text isEqualToString:LocalString(@"open_ablum")]) {
        NSURL *url = [NSURL URLWithString:@"photos-redirect://"];
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view showLoadingHUDText:LocalString(@"scroll_ing")];
        });
        
        [self.manager combinePhotosWithDirection:_manager.isCombineVertical resultImage:^(UIImage *combineImage) {
            __weak typeof(self) weakSelf = self;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //写入图片到相册
//                UIImage *saveImage = _resultImage;
//                if (saveImage == nil) {
//                    saveImage = [self.manager getScrollImage];
//                }
                
                [PHAssetChangeRequest creationRequestForAssetFromImage:combineImage];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"success = %d, error = %@", success, error);
                
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.view handleLoading];
                        [weakSelf.view showImageHUDText:LocalString(@"save_success")];
                        [button setTitle:LocalString(@"open_ablum") forState:UIControlStateNormal];
                    });
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.view handleLoading];
                        //[weakSelf.view showImageHUDText:LocalString(@"save_failed")];
                        [button setTitle:LocalString(@"save_failed") forState:UIControlStateNormal];
                    });
                    
                }
            }];
        }];
        
        
    }
    
}

- (void)savePhotoBottomViewDidShareBtn {
    
    if (_isShowShareBoardView) {
        [self hideShareBoard];
    } else {
        [self showShareBoard];
    }
    
}
- (void)showShareError:(UMSocialPlatformType)platformType
{
    NSString *strTitle = LocalString(@"no_install_app");
    if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_WechatTimeLine) {
        strTitle = LocalString(@"no_install_wechat");
    } else if(platformType == UMSocialPlatformType_Sina) {
        strTitle = LocalString(@"no_install_weibo");
    }
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
}
#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_longPictureView.zoomScale > 1.0) {
        _longPictureView.contentInset = UIEdgeInsetsZero;
        [_longPictureView setZoomScale:1.0 animated:YES];

    } else {
        CGPoint touchPoint = [tap locationInView:self.imageContainerView];
        CGFloat newZoomScale = _longPictureView.maximumZoomScale;
        CGFloat xsize = self.view.frame.size.width / newZoomScale;
        CGFloat ysize = self.view.frame.size.height / newZoomScale;
        [_longPictureView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    //    if (self.singleTapGestureBlock) {
    //        self.singleTapGestureBlock();
    //    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    //[self refreshScrollViewContentSize];
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_longPictureView.hx_w > _longPictureView.contentSize.width) ? ((_longPictureView.hx_w - _longPictureView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_longPictureView.hx_h > _longPictureView.contentSize.height) ? ((_longPictureView.hx_h - _longPictureView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_longPictureView.contentSize.width * 0.5 + offsetX, _longPictureView.contentSize.height * 0.5 + offsetY);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

