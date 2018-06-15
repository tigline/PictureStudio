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
#import "ShareBoardView.h"

@interface LongPictureViewController () <UIScrollViewDelegate,PhotoSaveBottomViewDelegate, ShareBoardViewDelegate>
@property (strong, nonatomic)  UIScrollView *longPictureView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) ShareBoardView *shareBoardView;
@property (strong, nonatomic) PhotoSaveBottomView *toolBarView;
@property (assign, nonatomic) BOOL canOpenWeixin;
@property (assign, nonatomic) BOOL canOpenWeibo;
@property (assign, nonatomic) BOOL isShowShareBoardView;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, assign) BOOL isFromShare;
@property (nonatomic, assign) NSInteger shareType;



@end

@implementation LongPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    [self createScrollView];
    _isShowShareBoardView = NO;
    [self.view addSubview:self.shareBoardView];
    [self.view addSubview:self.toolBarView];
    

}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//
//}

- (void)createScrollView {
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
    [_longPictureView setUserInteractionEnabled:YES];
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    
    _imageContainerView.contentMode = UIViewContentModeScaleAspectFit;
    [_longPictureView addSubview:_imageContainerView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self.view addGestureRecognizer:tap2];
    if (@available(iOS 11.0, *)) {
        _longPictureView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
    CGFloat scrollViewSizeValue;
    if (_manager.isCombineVertical) {
        scrollViewSizeValue = [_manager getSelectPhotosMinWidth]/[UIScreen mainScreen].scale;
    } else {
        scrollViewSizeValue = [_manager getSelectPhotosMinHeight]/[UIScreen mainScreen].scale;
    }
    
    [self resetImageView:scrollViewSizeValue];
}

- (void)resetImageView:(CGFloat)scrollViewSizeValue
{

    BOOL isCombineVertical = _manager.isCombineVertical;
    CGRect cgpos;
    if (isCombineVertical) {
        NSInteger count = _manager.selectedArray.count;
        for (int i = 0; i < count; i++) {
            HXPhotoModel *mode = [_manager.selectedArray objectAtIndex:i];
            UIImage *image = mode.previewPhoto;
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            
            CGFloat contentViewOffset;
            if(i == 0) {
                contentViewOffset = _imageContainerView.hx_h + 10;
            } else {
                contentViewOffset = _imageContainerView.hx_h;
            }
            if (scrollViewSizeValue > _longPictureView.frame.size.width - 20) {
                cgpos.origin.x = 10;
                cgpos.origin.y = contentViewOffset;
                cgpos.size.width = _longPictureView.frame.size.width - 20;
                cgpos.size.height = imageView.size.height * (cgpos.size.width/imageView.size.width);
            }else {
                cgpos.origin.x = 10;
                cgpos.origin.y = contentViewOffset;
                cgpos.size.width = _longPictureView.frame.size.width - 20;
                cgpos.size.height = imageView.size.height * (cgpos.size.width/image.size.width);
            }
            CGFloat lastOffset;
            if (i == _manager.selectedArray.count - 1) {
                lastOffset = cgpos.size.height + 10;
            } else {
                lastOffset = cgpos.size.height;
            }
            
            _imageContainerView.size = CGSizeMake(cgpos.size.width + 20, contentViewOffset + lastOffset);
            imageView.frame = cgpos;
            [self addLayerBorder:imageView count:count index:i direction:isCombineVertical];
            [_imageContainerView addSubview:imageView];
            
            
        }
        
        if (_imageContainerView.hx_h < _longPictureView.hx_h - ButtomViewHeight) {
            CGFloat offsetY = (_longPictureView.hx_h - ButtomViewHeight - _imageContainerView.hx_h)/2;
            _imageContainerView.frame = CGRectMake(0, offsetY, _imageContainerView.hx_w, _imageContainerView.hx_h);
            
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, _imageContainerView.hx_h)];
        } else if (_imageContainerView.hx_h < _longPictureView.hx_h){
            CGFloat offsetY = (_longPictureView.hx_h - _imageContainerView.hx_h)/2;
            //_imageContainerView.frame = CGRectMake(0, offsetY, _imageContainerView.hx_w, _imageContainerView.hx_h);
            _longPictureView.frame = CGRectMake(_longPictureView.originX, _longPictureView.originY + offsetY, _imageContainerView.hx_w, _longPictureView.hx_h - 2*offsetY-1);
            _imageContainerView.frame = CGRectMake(0, 0, _imageContainerView.hx_w, _imageContainerView.hx_h);
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, _imageContainerView.hx_h)];
        } else {
            _imageContainerView.frame = CGRectMake(0, 0, _imageContainerView.hx_w, _imageContainerView.hx_h);
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, _imageContainerView.hx_h)];
        }
        
        
    } else {
        NSInteger count = _manager.selectedArray.count;
        for (int i = 0; i < count; i++) {
            
            HXPhotoModel *mode = [_manager.selectedArray objectAtIndex:i];
            UIImage *image = mode.previewPhoto;
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            CGFloat contentViewOffset;
            if(i == 0) {
                contentViewOffset = _imageContainerView.hx_w + 10;
            } else {
                contentViewOffset = _imageContainerView.hx_w;
            }
            

            CGFloat longPictureViewHeight = _longPictureView.frame.size.height- 20 - ButtomViewHeight;
            if (scrollViewSizeValue > longPictureViewHeight) {
                cgpos.origin.x = contentViewOffset;
                cgpos.origin.y = 10;
                cgpos.size.width =  (imageView.size.width) * (longPictureViewHeight/imageView.size.height);
                cgpos.size.height = longPictureViewHeight;
                
            }else {
                cgpos.origin.x = contentViewOffset;
                cgpos.origin.y = 10;
                cgpos.size.width = (imageView.size.width) * (scrollViewSizeValue/imageView.size.height);
                cgpos.size.height = scrollViewSizeValue;
            }
            
            
            
            CGFloat lastOffset;
            if (i == _manager.selectedArray.count - 1) {
                lastOffset = cgpos.size.width + 10;
            } else {
                lastOffset = cgpos.size.width;
            }
            _imageContainerView.size = CGSizeMake(_imageContainerView.hx_w + lastOffset, cgpos.size.height + 20);
            
            imageView.frame = cgpos;
            [_imageContainerView addSubview:imageView];
            [self addLayerBorder:imageView count:count index:i direction:isCombineVertical];

        }
        CGRect cgPos;
        if (_imageContainerView.hx_w < _longPictureView.hx_w) {
            
            cgPos.origin.x = (_longPictureView.hx_w - _imageContainerView.hx_w)/2;
            cgPos.size.width = _imageContainerView.hx_w;
        } else {
            cgPos.origin.x = 0;
            cgPos.size.width = _imageContainerView.hx_w;
        }

        if (_imageContainerView.hx_h < _longPictureView.hx_h - ButtomViewHeight) {
            CGFloat offsetY = (_longPictureView.hx_h - ButtomViewHeight - _imageContainerView.hx_h)/2;
            cgPos.origin.y = offsetY;
            cgPos.size.height = _imageContainerView.hx_h;
        } else {
            cgPos.origin.y = 0;
            cgPos.size.height = _longPictureView.hx_h - ButtomViewHeight;
        }
        _imageContainerView.frame = cgPos;
        [_longPictureView setContentSize:CGSizeMake(_imageContainerView.hx_w, _imageContainerView.hx_h)];

    }

}

-(void)addLayerBorder:(UIImageView *)imageView count:(NSInteger)count index:(NSInteger)index direction:(BOOL)isVertical {
    UIColor *color = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    CGFloat width = 1*ScreenWidthRatio;
    if (isVertical) {
        if (index == 0) {
            [imageView addTopBorderWithColor:color andWidth:width];
            [imageView addLeftBorderWithColor:color andWidth:width];
            [imageView addRightBorderWithColor:color andWidth:width];
        } else if (index == count - 1) {
            [imageView addLeftBorderWithColor:color andWidth:width];
            [imageView addRightBorderWithColor:color andWidth:width];
            [imageView addBottomBorderWithColor:color andWidth:width];
        } else {
            [imageView addLeftBorderWithColor:color andWidth:width];
            [imageView addRightBorderWithColor:color andWidth:width];
        }
    } else {
        if (index == 0) {
            [imageView addTopBorderWithColor:color andWidth:width];
            [imageView addLeftBorderWithColor:color andWidth:width];
            [imageView addBottomBorderWithColor:color andWidth:width];
        } else if (index == count - 1) {
            [imageView addTopBorderWithColor:color andWidth:width];
            [imageView addRightBorderWithColor:color andWidth:width];
            [imageView addBottomBorderWithColor:color andWidth:width];
        } else {
            [imageView addTopBorderWithColor:color andWidth:width];
            [imageView addBottomBorderWithColor:color andWidth:width];
        }
    }
    
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



- (void)shareBoardViewDidWeChatBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatSession];
    _shareType = UMSocialPlatformType_WechatSession;
}

- (void)shareBoardViewDidMomentBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    _shareType = UMSocialPlatformType_WechatTimeLine;
}

- (void)shareBoardViewDidWeiboBtn {
    [self shareImageToPlatformType:UMSocialPlatformType_Sina];
    _shareType = UMSocialPlatformType_Sina;
}

- (void)shareBoardViewDidMoreBtn {
    NSLog(@"shareMoreImageOnClick");
    _shareType = 100;
    if(_resultImage == nil) {
        _isFromShare = YES;
        [self savePhotoBottomViewDidSaveBtn:nil];
        
    } else {

        NSArray *activityItems = @[_resultImage];
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
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    if(_resultImage == nil) {
        _isFromShare = YES;
        [self savePhotoBottomViewDidSaveBtn:nil];
        
    } else {
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

- (void)showShareBoard {
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY - ShareBoardHeight+1, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         _isShowShareBoardView = YES;
                         
                     }];
}

- (void)hideShareBoard {
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY + ShareBoardHeight-1, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
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
    
    if(contentHeight < 0)
    {
        return;
        
    }
    
    
    if (contentOffsetY < 0) {
        
    } else if (contentOffsetY < kTopMargin && contentOffsetY > 0) {
        self.longPictureView.frame = CGRectMake(0, kTopMargin - contentOffsetY, self.view.hx_w, self.view.hx_h);
    } else if (contentOffsetY < contentHeight && contentOffsetY > kTopMargin) {
        
        self.longPictureView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h);

    } else if (contentOffsetY > contentHeight) {


        //向上
        CGFloat bottomMargin = 0.0;
        CGFloat bottomOffset = 0.0;
        if (kDevice_Is_iPhoneX) {
            bottomMargin = self.toolBarView.hx_h;
        } else {
            bottomMargin = ButtomViewHeight;
        }
        if (contentHeight < bottomMargin) {
            bottomOffset = bottomMargin - contentHeight;
        } else {
            bottomOffset = bottomMargin;
        }
        if (contentOffsetY > contentHeight && contentOffsetY < contentHeight+bottomOffset) {
            self.longPictureView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h - bottomOffset);
        }
//        else if (contentOffsetY > contentHeight+bottomOffset) {
//            self.longPictureView.frame = CGRectMake(0, 0, self.view.hx_w, self.view.hx_h - bottomMargin);
//        }
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
        //dispatch_async(dispatch_get_main_queue(), ^{
            [self.toolBarView setProgressLength:_manager.selectedArray.count];
            [self.toolBarView setSaveBtnsHiddenValue:YES];
            [self.toolBarView setSaveLabelHidden:NO];
            [self.toolBarView setProgressViewValue:0];
        
        if(_isFromShare) {
            [self.toolBarView setSaveText:LocalString(@"share_init")];
        } else {
            [self.toolBarView setSaveText:LocalString(@"save_ing")];
        }
        //});
        
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.manager combinePhotosWithDirection:_manager.isCombineVertical resultImage:^(UIImage *combineImage) {
                weakSelf.resultImage = combineImage;
                if(weakSelf.isFromShare) {
                    weakSelf.isFromShare = NO;
                    [weakSelf.toolBarView setSaveBtnsHiddenValue:NO];
                    [weakSelf.toolBarView setSaveLabelHidden:YES];
                    [weakSelf savePhotoBottomViewDidShareBtn];
                } else {
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetChangeRequest creationRequestForAssetFromImage:combineImage];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    NSLog(@"success = %d, error = %@", success, error);
                    
                    if (success) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.toolBarView setSaveBtnsHiddenValue:NO];
                            [weakSelf.toolBarView setSaveLabelHidden:YES];
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
                }
            } completeIndex:^(NSInteger index) {
                //dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.toolBarView setProgressViewValue:index];
                //});
            }];
            
        });
            
        
    }
                       
}

- (void)showTips
{
    //NSString *strTitle = LocalString(@"scroll_error");
    
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:nil
                                                                                    message:LocalString(@"save_first")
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self savePhotoBottomViewDidSaveBtn:nil];
                                                          }];
    [successAlertController addAction:defaultAction];
    [self presentViewController:successAlertController animated:YES completion:nil];
}


- (void)savePhotoBottomViewDidShareBtn {
    
    if (_resultImage == nil) {
        _isFromShare = YES;
        [self savePhotoBottomViewDidSaveBtn:nil];
    } else {
        if (_isShowShareBoardView) {
            [self hideShareBoard];
        } else {
            [self showShareBoard];
        }
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
    CGFloat longPictureViewHeight;
//    if (_imageContainerView.hx_h < _longPictureView.hx_h - ButtomViewHeight) {
        longPictureViewHeight = _longPictureView.hx_h - ButtomViewHeight;
//    } else {
//        longPictureViewHeight = _longPictureView.hx_h;
//    }
    CGFloat offsetX = (_longPictureView.hx_w > _longPictureView.contentSize.width) ? ((_longPictureView.hx_w - _longPictureView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (longPictureViewHeight > _longPictureView.contentSize.height) ? ((longPictureViewHeight - _longPictureView.contentSize.height) * 0.5) : 0.0;
    
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

