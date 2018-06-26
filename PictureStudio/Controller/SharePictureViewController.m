//
//  SharePictureViewController.m
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/5/3.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "SharePictureViewController.h"
#import <Photos/Photos.h>
#import "HXPhotoDefine.h"
#import "AppDelegate.h"
#import "PhotoSaveBottomView.h"
#import "UIView+HXExtension.h"
#import "HXPhotoDefine.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ToastView.h"
#import "ShareBoardView.h"

//#define URL_APPID @"wx3b864b92dca2bf8a"
//#define URL_SECRET @"e998d19d22428e70c520f36a9c6f0e41"
//static CGFloat shareAreaViewHeight = 73;//定义分享区域的高度


@interface SharePictureViewController ()<WXDelegate,PhotoSaveBottomViewDelegate,UIScrollViewDelegate,ShareBoardViewDelegate>
{
    AppDelegate *appdelegate;
}
@property (assign, nonatomic) BOOL canOpenWeixin;
@property (assign, nonatomic) BOOL canOpenWeibo;
@property (assign, nonatomic) BOOL isShowShareBoardView;
@property (strong, nonatomic) UIScrollView *showImageScrollView;
@property (strong, nonatomic) UIScrollView *shareScrollView;
@property (strong, nonatomic) PhotoSaveBottomView *toolBarView;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) BOOL isFinish;

@property (strong, nonatomic) UIView *containImageView;
@property (strong, nonatomic) ShareBoardView *shareBoardView;



@end

@implementation SharePictureViewController
#pragma mark - view life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createScrollView];

    if (_resultImage) {
        [self CreateShowImgaeView:_resultImage];//创建图片显示区域
        _isShowShareBoardView = NO;
        [self.view addSubview:self.shareBoardView];
        [self.view addSubview:self.toolBarView];//创建保存图片区域
        
    }
    self.fd_prefersNavigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollFinish) name:@"scrollFinish" object:nil];

    //[self.view bringSubviewToFront:self.toolBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_manager.selectedCount > 3 && !_isFinish) {
        [self.view showLoadingHUDText:LocalString(@"scroll_ing")];
    }
//    [self.navigationController.navigationBar setHidden:YES];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}




//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_manager.isScrollSuccess) {
        [self showScrollError];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.manager setScrollResult:nil];

    //[self.navigationController.navigationBar setHidden:NO];
}

- (void)scrollFinish {
    _isFinish = YES;
    [self.view handleLoading];
    [self CreateShowImgaeView:[self.manager getScrollImage]];
    [self.view addSubview:self.shareBoardView];
    [self.view addSubview:self.toolBarView];
}

- (BOOL)prefersStatusBarHidden {
    if (kDevice_Is_iPhoneX) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGRect)AdaptationCGRectMake:(CGRect)mCGRect; {
    return CGRectMake(mCGRect.origin.x*ScreenWidthRatio,mCGRect.origin.y*ScreenHeightRatio, mCGRect.size.width*ScreenWidthRatio, mCGRect.size.height*ScreenHeightRatio);
}

#pragma mark - init view


- (void)createScrollView {
    _showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopMargin, self.view.hx_w, self.view.hx_h - kBottomMargin - kTopMargin)];
    _showImageScrollView.delegate = self;
    [self.view addSubview:_showImageScrollView];
    _showImageScrollView.backgroundColor = [UIColor whiteColor];
    _showImageScrollView.bouncesZoom = YES;
    _showImageScrollView.maximumZoomScale = 2.5;
    _showImageScrollView.minimumZoomScale = 1.0;
    _showImageScrollView.multipleTouchEnabled = YES;
    _showImageScrollView.scrollsToTop = NO;
    _showImageScrollView.showsHorizontalScrollIndicator = NO;
    _showImageScrollView.showsVerticalScrollIndicator = NO;
    _showImageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _showImageScrollView.delaysContentTouches = NO;
    _showImageScrollView.canCancelContentTouches = YES;
    _showImageScrollView.alwaysBounceVertical = NO;
    _shareScrollView.userInteractionEnabled = YES;
    
    _containImageView = [[UIView alloc] init];
    _containImageView.clipsToBounds = YES;

    _containImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_showImageScrollView addSubview:_containImageView];
    
    if (@available(iOS 11.0, *)) {
        _showImageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self.view addGestureRecognizer:tap2];
}

- (void)CreateShowImgaeView:(UIImage *)_resultImage
{
//    self.showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10*ScreenWidthRatio, kTopMargin + 10*ScreenHeightRatio, 355*ScreenWidthRatio, 517*ScreenHeightRatio)];
    
    
    
    CGFloat maginTop = kDevice_Is_iPhoneX ? 10 : 10;
    
    if (_resultImage != nil ){
        CGRect cgpos;
        if (_resultImage.size.width > _showImageScrollView.frame.size.width - 20) {
            cgpos.origin.x = 10;
            cgpos.origin.y = maginTop;
            cgpos.size.width = _showImageScrollView.frame.size.width - 20;
            cgpos.size.height = _resultImage.size.height * (cgpos.size.width/_resultImage.size.width);
            [_showImageScrollView setContentSize:CGSizeMake(_showImageScrollView.frame.size.width, cgpos.size.height+20)];
        }else {
            cgpos.origin.x =(_showImageScrollView.frame.size.width - 20 - _resultImage.size.width)/2;
            cgpos.origin.y = maginTop;
            cgpos.size.width = _resultImage.size.width;
            cgpos.size.height = _resultImage.size.height;
            [_showImageScrollView setContentSize:CGSizeMake(_showImageScrollView.frame.size.width, cgpos.size.height + 20)];
        }
        _containImageView.size = CGSizeMake(cgpos.size.width+20, cgpos.size.height+20);
        
        UIImageView *imageView  = [[UIImageView alloc] initWithFrame:cgpos];
        imageView.image = _resultImage;
        
        [_containImageView addSubview:imageView];
        imageView.layer.borderWidth = 1*ScreenWidthRatio;
        imageView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
//        imageView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;;
//        imageView.layer.shadowOpacity = 0.8f;
//        imageView.layer.shadowOffset = CGSizeMake(0, 0);
//        UITapGestureRecognizer* imgMsgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnImage:)];
//        [_showImageScrollView addGestureRecognizer:imgMsgTap];
    }
    
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
    if (saveImage == nil) {
        saveImage = [self.manager getScrollImage];
    }
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


- (void)shareBoardViewDidWeChatBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatSession];

}

- (void)shareBoardViewDidMomentBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine];

}

- (void)shareBoardViewDidWeiboBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_Sina];

}

- (void)shareBoardViewDidMoreBtn {
    NSLog(@"shareMoreImageOnClick");
    UIImage *imageToShare = _resultImage;
    if (imageToShare == nil) {
        imageToShare = [self.manager getScrollImage];
    }
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

- (void)showShareBoard {
    _shareBoardView.hidden = NO;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY - ShareBoardHeight+1, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         _isShowShareBoardView = YES;
                         
                     }];
}

- (void)hideShareBoard {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY + ShareBoardHeight-1, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         _shareBoardView.hidden = YES;
                         _isShowShareBoardView = NO;
                     }];
}

-(void)touchOnImage:(UITapGestureRecognizer*)sender{
    if (!_shareBoardView.isHidden) {
        [self hideShareBoard];
    }
}
//点击无效 待解决
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.shareScrollView];
    if ([self.shareScrollView.layer containsPoint:currentPoint]) {
        if (!_shareBoardView.isHidden) {
            [self hideShareBoard];
        }
    }
    
}



#pragma PhotoSaveBottomViewDelegate

- (void)savePhotoBottomViewDidBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)savePhotoBottomViewDidSaveBtn:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    if([button.titleLabel.text isEqualToString:LocalString(@"open_ablum")]) {
        NSURL *url = [NSURL URLWithString:@"photos-redirect://"];
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    } else {
        
        
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


- (PhotoSaveBottomView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[PhotoSaveBottomView alloc] initWithFrame:CGRectMake(0, self.view.hx_h - SaveViewHeight - kBottomMargin, self.view.hx_w, ButtomViewHeight + kBottomMargin)];
        _toolBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _toolBarView.delegate = self;
    }
    return _toolBarView;
}

- (ShareBoardView *)shareBoardView {
    if (!_shareBoardView) {
        _shareBoardView = [[ShareBoardView alloc] initWithFrame:CGRectMake(0, self.view.hx_h - SaveViewHeight - kBottomMargin, self.view.hx_w, ShareBoardHeight)];
        _shareBoardView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _shareBoardView.shareDelegate = self;
        _shareBoardView.hidden = YES;
    }
    return _shareBoardView;
}

#pragma mark scrollView delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentHeight = scrollView.contentSize.height - self.view.hx_h;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    if (contentOffsetY < 0) {
        //self.showImageScrollView.frame = CGRectMake(0, kTopMargin + contentOffsetY, self.view.hx_w, self.view.hx_h);
    } else if (contentOffsetY < kTopMargin && contentOffsetY > 0) {
        self.showImageScrollView.frame = CGRectMake(0, kTopMargin - contentOffsetY, self.view.hx_w, self.view.hx_h);
    } else if (contentOffsetY < contentHeight && contentOffsetY > kTopMargin) {
        //向下
        //if (_canDetectScroll) {
        

        self.showImageScrollView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h);
        
        //}
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        
    } else if (scrollView.contentOffset.y > contentHeight) {
        

        //向上
        CGFloat bottomMargin = 0.0;
        if (kDevice_Is_iPhoneX) {
            bottomMargin = self.toolBarView.hx_h;
        } else {
            bottomMargin = ButtomViewHeight;
        }
        if (contentOffsetY > contentHeight && contentOffsetY < contentHeight+bottomMargin) {
            self.showImageScrollView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h - bottomMargin);
        }
        //[self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
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

- (void)showScrollError
{
    NSString *strTitle = LocalString(@"scroll_error");
    
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                                    message:LocalString(@"scroll_operate_tips")
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
}

- (void)showTips
{
    //NSString *strTitle = LocalString(@"scroll_error");
    
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:nil
                                                                                    message:@"Coming soon"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
}

-(void)loginSuccessByCode:(NSString *)code
{}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_showImageScrollView.zoomScale > 1.0) {
        _showImageScrollView.contentInset = UIEdgeInsetsZero;
        [_showImageScrollView setZoomScale:1.0 animated:YES];
        
    } else {
        CGPoint touchPoint = [tap locationInView:self.containImageView];
        CGFloat newZoomScale = _showImageScrollView.maximumZoomScale;
        CGFloat xsize = self.view.frame.size.width / newZoomScale;
        CGFloat ysize = self.view.frame.size.height / newZoomScale;
        [_showImageScrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    //    if (self.singleTapGestureBlock) {
    //        self.singleTapGestureBlock();
    //    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containImageView;
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
    CGFloat offsetX = (_showImageScrollView.hx_w > _showImageScrollView.contentSize.width) ? ((_showImageScrollView.hx_w - _showImageScrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_showImageScrollView.hx_h > _showImageScrollView.contentSize.height) ? ((_showImageScrollView.hx_h - _showImageScrollView.contentSize.height) * 0.5) : 0.0;
    self.containImageView.center = CGPointMake(_showImageScrollView.contentSize.width * 0.5 + offsetX, _showImageScrollView.contentSize.height * 0.5 + offsetY);
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
