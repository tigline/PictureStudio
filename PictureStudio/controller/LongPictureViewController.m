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
//    _longPictureView.maximumZoomScale = 2.5;
//    _longPictureView.minimumZoomScale = 1.0;
//    _longPictureView.multipleTouchEnabled = YES;
    _longPictureView.delegate = self;
//    _longPictureView.scrollsToTop = NO;
    _longPictureView.showsHorizontalScrollIndicator = NO;
    _longPictureView.showsVerticalScrollIndicator = NO;
//    _longPictureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _longPictureView.delaysContentTouches = NO;
//    _longPictureView.canCancelContentTouches = YES;
//    _longPictureView.alwaysBounceVertical = NO;
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//    [self.view addGestureRecognizer:tap1];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
//    tap2.numberOfTapsRequired = 2;
//    [tap1 requireGestureRecognizerToFail:tap2];
//    [self.view addGestureRecognizer:tap2];
    _shareBoardHeight.constant = 73*ScreenHeightRatio;
    _shareBtnWidth.constant = 46*ScreenWidthRatio;
    if (@available(iOS 11.0, *)) {
        _longPictureView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    [self.view bringSubviewToFront:self.shareBoardView];
    [_shareBoardView setHidden:YES];
    [self.view addSubview:self.toolBarView];//创建保存图片区域
    

    
    
    
    [self.manager combinePhotosWithDirection:_manager.isCombineVertical resultImage:^(UIImage *combineImage) {
        _resultImage = combineImage;
        [self resetImageView:combineImage];
        
    }];
    

    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    if (!_manager.isCombineVertical) {
//        _scrollMaginBottom.constant = kBottomMargin + ButtomViewHeight;
//    }
}

- (void)resetImageView:(UIImage *)combineImage
{
    BOOL isCombineVertical = _manager.isCombineVertical;
    CGRect cgpos;
    if (combineImage != nil && isCombineVertical) {


        if (combineImage.size.width > _longPictureView.frame.size.width - 20) {
            cgpos.origin.x = 10;
            cgpos.origin.y = 10;
            cgpos.size.width = _longPictureView.frame.size.width - 20;
            cgpos.size.height = combineImage.size.height * (cgpos.size.width/combineImage.size.width);
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, cgpos.size.height+20)];
        }else {
            cgpos.origin.x =(_longPictureView.frame.size.width - 20 - combineImage.size.width)/2;
            cgpos.origin.y = 10;
            cgpos.size.width = combineImage.size.width;
            cgpos.size.height = combineImage.size.height;
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, cgpos.size.height + 20)];
        }
        
        
    } else {

        CGFloat longPictureViewHeight = _longPictureView.frame.size.height - 20 - ButtomViewHeight;
        if (combineImage.size.height > longPictureViewHeight) {
            cgpos.origin.x = 10;
            cgpos.origin.y = 10;
            cgpos.size.width =  (combineImage.size.width) * ((longPictureViewHeight)/combineImage.size.height);
            cgpos.size.height = longPictureViewHeight;
            if(cgpos.size.width < _longPictureView.frame.size.width - 20) {
                cgpos.origin.x = (_longPictureView.frame.size.width - cgpos.size.width)/2;
                [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, longPictureViewHeight)];
            } else {
                [_longPictureView setContentSize:CGSizeMake(cgpos.size.width + 20, longPictureViewHeight)];
            }
            
        }else {
            cgpos.origin.x = 10;
            cgpos.origin.y = (longPictureViewHeight - (combineImage.size.height-20)/2)/2;
            cgpos.size.width = combineImage.size.width/2;
            cgpos.size.height = combineImage.size.height/2;
            [_longPictureView setContentSize:CGSizeMake(cgpos.size.width + 20,  (longPictureViewHeight + 20)/2)];
        }
        
    }
        _imageView = [[UIImageView alloc]initWithFrame:cgpos];
        [_imageView setImage:combineImage];
        [_longPictureView addSubview:_imageView];
        [_longPictureView setUserInteractionEnabled:YES];
        _imageView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;;
        _imageView.layer.shadowOpacity = 0.8f;
        _imageView.layer.shadowOffset = CGSizeMake(0, 0);
        UITapGestureRecognizer* imgMsgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnImage:)];
        [_longPictureView addGestureRecognizer:imgMsgTap];
    
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
        __weak typeof(self) weakSelf = self;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            UIImage *saveImage = _resultImage;
            if (saveImage == nil) {
                saveImage = [self.manager getScrollImage];
            }
            
            [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.view showImageHUDText:LocalString(@"save_success")];
                    [button setTitle:LocalString(@"open_ablum") forState:UIControlStateNormal];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[weakSelf.view showImageHUDText:LocalString(@"save_failed")];
                    [button setTitle:LocalString(@"save_failed") forState:UIControlStateNormal];
                });
                
            }
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
        [self resetImageView:_resultImage];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
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
    return _imageView;
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
    self.imageView.center = CGPointMake(_longPictureView.contentSize.width * 0.5 + offsetX, _longPictureView.contentSize.height * 0.5 + offsetY);
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

