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
//#import "WXApi.h"
#import "AppDelegate.h"
#import "PhotoSaveBottomView.h"
#import "UIView+HXExtension.h"
#import "HXPhotoDefine.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

//#define URL_APPID @"wx3b864b92dca2bf8a"
//#define URL_SECRET @"e998d19d22428e70c520f36a9c6f0e41"
//static CGFloat shareAreaViewHeight = 73;//定义分享区域的高度


@interface SharePictureViewController ()<WXDelegate,PhotoSaveBottomViewDelegate>
{
    AppDelegate *appdelegate;
}
@property (assign, nonatomic) BOOL canOpenWeixin;
@property (assign, nonatomic) BOOL canOpenWeibo;
@property (assign, nonatomic) BOOL isShowShareBoardView;
@property (strong, nonatomic) UIScrollView *showImageScrollView;
@property (strong, nonatomic) UIScrollView *shareScrollView;
@property (strong, nonatomic) PhotoSaveBottomView *toolBarView;


@property (weak, nonatomic) IBOutlet UIVisualEffectView *shareBoardView;

@end

@implementation SharePictureViewController
#pragma mark - view life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CustomTitle];//处理标透明化题栏 也可app统一设置
    
    if (_resultImage) {
        [self CreateShowImgaeView:_resultImage];//创建图片显示区域
        //[self.view bringSubviewToFront:self.shareBoardView];
        [self.view addSubview:self.toolBarView];//创建保存图片区域
    }
    self.fd_prefersNavigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollFinish) name:@"scrollFinish" object:nil];

    //[self.view bringSubviewToFront:self.toolBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_manager.selectedCount > 3) {
        [self.view showLoadingHUDText:LocalString(@"scorll_ing")];
    }
//    [self.navigationController.navigationBar setHidden:YES];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}




- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //[self.shareBoardView setFrame:CGRectMake(0, self.toolBarView.originY, self.shareBoardView.hx_w, self.shareBoardView.hx_h)];
    [_shareBoardView setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_manager.isScrollSuccess) {
        [self showScrollError];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.manager setScrollImage:nil];

    //[self.navigationController.navigationBar setHidden:NO];
}

- (void)scrollFinish {
    [self.view handleLoading];
    [self CreateShowImgaeView:[self.manager getScrollImage]];
    [self.view bringSubviewToFront:self.shareBoardView];
    [self.view addSubview:self.toolBarView];
}

- (BOOL)prefersStatusBarHidden {
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
-(void)CustomTitle
{
    
}

- (void)CreateShowImgaeView:(UIImage *)_resultImage
{
//    self.showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10*ScreenWidthRatio, kTopMargin + 10*ScreenHeightRatio, 355*ScreenWidthRatio, 517*ScreenHeightRatio)];
    
    self.showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, kTopMargin + 10, self.view.hx_w - 20, self.view.hx_h - ButtomViewHeight - kBottomMargin - 10 - kTopMargin)];
    
    
    NSLog(@"%f",ScreenHeightRatio);
    
    [self.view addSubview:self.showImageScrollView];
    
    self.showImageScrollView.backgroundColor = [UIColor whiteColor];
    
    if (_resultImage != nil ){
        CGRect cgpos;
        if (_resultImage.size.width > _showImageScrollView.frame.size.width) {
            cgpos.origin.x = 0;
            cgpos.origin.y = 0;
            cgpos.size.width = _showImageScrollView.frame.size.width;
            cgpos.size.height = _resultImage.size.height * (_showImageScrollView.frame.size.width/_resultImage.size.width);
            [_showImageScrollView setContentSize:CGSizeMake(_showImageScrollView.frame.size.width, cgpos.size.height)];
        }else {
            cgpos.origin.x =(_showImageScrollView.frame.size.width - _resultImage.size.width)/2;
            cgpos.origin.y = 0;
            cgpos.size.width = _resultImage.size.width;
            cgpos.size.height = _resultImage.size.height;
            [_showImageScrollView setContentSize:CGSizeMake(_showImageScrollView.frame.size.width, _resultImage.size.height)];
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:cgpos];

        
        [imageView setImage:_resultImage];
        
        [_showImageScrollView addSubview:imageView];
        UITapGestureRecognizer* imgMsgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnImage:)];
        [_showImageScrollView addGestureRecognizer:imgMsgTap];
    }
    self.showImageScrollView.showsVerticalScrollIndicator = NO;
    self.showImageScrollView.showsHorizontalScrollIndicator = NO;
    self.showImageScrollView.layer.shadowColor = [UIColor blueColor].CGColor;
    self.showImageScrollView.layer.shadowOpacity = 0.8f;
    self.showImageScrollView.layer.shadowOffset = CGSizeMake(3, 3);
    _shareScrollView.userInteractionEnabled = YES;
}



- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:[self.manager getScrollImage]];
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


- (IBAction)onShareWechatClicked:(id)sender {
    //[self shareImageToPlatformType:UMSocialPlatformType_WechatSession];
    [self showTips];

}

- (IBAction)onShareMomentClicked:(id)sender {
    //[self shareImageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    [self showTips];

}

- (IBAction)onShareWeiboClicked:(id)sender {
    //[self shareImageToPlatformType:UMSocialPlatformType_Sina];
    [self showTips];

}

- (IBAction)onShareMoreClicked:(id)sender {
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
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY - _shareBoardView.hx_h, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         _isShowShareBoardView = YES;
                         
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

- (void)hideShareBoard {
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY + _shareBoardView.hx_h, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         [_shareBoardView setHidden:YES];
                         _isShowShareBoardView = NO;
                     }];
}

#pragma PhotoSaveBottomViewDelegate

- (void)savePhotoBottomViewDidBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)savePhotoBottomViewDidSaveBtn {
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
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view showImageHUDText:LocalString(@"save_failed")];
            });
            
        }
    }];
}

- (void)savePhotoBottomViewDidShareBtn {

//    if (_isShowShareBoardView) {
//        [self hideShareBoard];
//    } else {
//        [self showShareBoard];
//    }
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


- (PhotoSaveBottomView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[PhotoSaveBottomView alloc] initWithFrame:CGRectMake(0, self.view.hx_h - ButtomViewHeight - kBottomMargin, self.view.hx_w, ButtomViewHeight + kBottomMargin)];
        _toolBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _toolBarView.delegate = self;
    }
    return _toolBarView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
