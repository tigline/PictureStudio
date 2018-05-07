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

#define URL_APPID @"wx3b864b92dca2bf8a"
#define URL_SECRET @"e998d19d22428e70c520f36a9c6f0e41"
static CGFloat shareAreaViewHeight = 73;//定义分享区域的高度

#define SHARE_IMAGE_VIEW_HEIGHT         45     //定义分享图片的直径
#define SAVE_VIEW_HEIGHT         45     //定义保存区域的高度
#define SAVE_IMAGE_VIEW_HEIGHT         20    //定义保存图片3个小icon的高度

#define ScreenWidthRatio  ([UIScreen mainScreen].bounds.size.width / 375.0)
#define ScreenHeightRatio (kDevice_Is_iPhoneX ? (([UIScreen mainScreen].bounds.size.height - kBottomMargin -44)/ (667.0-20)) : ([UIScreen mainScreen].bounds.size.height / 667.0))
#define AdaptedWidthValue(x)  (ceilf((x) * ScreenWidthRatio))
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
    [self CreateShowImgaeView];//创建图片显示区域
    [self.view bringSubviewToFront:_shareBoardView];
    [_shareBoardView setHidden:YES];
    //[self CreateShareView];//创建分享区域
    //[self CreateSaveView];//创建保存图片区域
    [self.view addSubview:self.toolBarView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGRect)AdaptationCGRectMake:(CGRect)mCGRect;
{
    return CGRectMake(mCGRect.origin.x*ScreenWidthRatio,mCGRect.origin.y*ScreenHeightRatio, mCGRect.size.width*ScreenWidthRatio, mCGRect.size.height*ScreenHeightRatio);
}

#pragma mark - init view
-(void)CustomTitle
{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)CreateShowImgaeView
{
//    self.showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10*ScreenWidthRatio, kTopMargin + 10*ScreenHeightRatio, 355*ScreenWidthRatio, 517*ScreenHeightRatio)];
    
    self.showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopMargin, self.view.hx_w, self.view.hx_h)];
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
    }
    self.showImageScrollView.showsVerticalScrollIndicator = NO;
    self.showImageScrollView.showsHorizontalScrollIndicator = NO;
}



- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:self.resultImage];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);

            [self shareReturnByCode:0];
            
        }
    }];
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
    UIImage *imageToShare = self.resultImage;
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
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY - self.toolBarView.hx_h, _shareBoardView.size.width, _shareBoardView.size.height)];
                         
                     }completion:^(BOOL finished) {
                         _isShowShareBoardView = YES;
                         
                     }];
}

- (void)hideShareBoard {
    [_shareBoardView setHidden:NO];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY + self.toolBarView.hx_h, _shareBoardView.size.width, _shareBoardView.size.height)];
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
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.resultImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view showImageHUDText:@"save success"];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view showImageHUDText:@"save failed"];
            });
            
        }
    }];
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
        _toolBarView = [[PhotoSaveBottomView alloc] initWithFrame:CGRectMake(0, self.view.hx_h - ButtomViewHeight - kBottomMargin, self.view.hx_w, ButtomViewHeight + kBottomMargin)];
        _toolBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        _toolBarView.delegate = self;
    }
    return _toolBarView;
}

#pragma mark delegate 监听微信分享是否成功
-(void)shareReturnByCode:(int)code
{
    NSString *strTitle = @"分享成功";
    
    if (code != 0)
    {
        strTitle = @"分享失败";
    }
    UIAlertController* successAlertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              //NSLog(@"action = %@", action);
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
