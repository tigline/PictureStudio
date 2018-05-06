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
#import "WXApi.h"
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
@property (strong, nonatomic) UIScrollView *showImageScrollView;
@property (strong, nonatomic) UIScrollView *shareScrollView;
@property (strong, nonatomic) PhotoSaveBottomView *toolBarView;

@end

@implementation SharePictureViewController
#pragma mark - view life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CustomTitle];//处理标透明化题栏 也可app统一设置
    [self CreateShowImgaeView];//创建图片显示区域
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
//    // 1、设置视图背景颜色
//    self.view.backgroundColor = [UIColor whiteColor];
//    // 2、设置导航栏标题属性：设置标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    // 3、设置导航栏前景色：设置item指示色
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    // 4、设置导航栏半透明
//    self.navigationController.navigationBar.translucent = true;
//    // 5、设置导航栏背景图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics: UIBarMetricsDefault];
//    // 6、设置导航栏阴影图片
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
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



- (void)CreateShareView
{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    self.canOpenWeixin = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url  [[UIApplication sharedApplication] openURL:url];
    
    //b.配置微博的白皮书
    url = [NSURL URLWithString:@"weibo://"];
    self.canOpenWeibo = [[UIApplication sharedApplication] canOpenURL:url];
    //根据是否可以跳转来区分页面上需要显示 几个子view按钮。
    int sum = 0;
    if (self.canOpenWeixin && self.canOpenWeibo)
    {
        sum = 4;
    }
    else if (!self.canOpenWeixin && self.canOpenWeibo)
    {
        //显示微博+更多
        sum = 2;
    }
    else if (self.canOpenWeixin && !self.canOpenWeibo)
    {
        //显示微信+更多 3个
        sum = 3;
    }
    else if (!self.canOpenWeixin && !self.canOpenWeibo)
    {
        //显示更多
        sum = 1;
    }
    //创建4个按钮
    
    self.shareScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.showImageScrollView.frame.size.height + self.showImageScrollView.frame.origin.y, self.view.frame.size.width, shareAreaViewHeight*ScreenHeightRatio)];
    for (int i = 0; i < sum; i++)
    {
        [self.shareScrollView addSubview:[self CreateShareButtonWithTag:i]];
    }
    [self.view addSubview:self.shareScrollView];
    //添加一条华丽的分割线
    
    //绘制下边界
    CALayer* distanceBorder = [CALayer layer];
    distanceBorder.frame = CGRectMake(0, self.shareScrollView.frame.origin.y+self.shareScrollView.frame.size.height, self.view.frame.size.width, 1*ScreenHeightRatio);
    distanceBorder.backgroundColor = [[UIColor colorWithRed:151/255.0f green:151/255.0f blue:151/255.0f alpha:1.0f] CGColor];
    [self.view.layer addSublayer:distanceBorder];
}

-(UIImageView*)CreateShareButtonWithTag:(int)indexnum
{
    UIImageView *mImageView;
    //icon距离左边的距离
    float distanceLeftByScreen = 43.0f;
    float distanceLeftByIcon = 35.0f;
    float distanceLeft = 0.0f;
    if (indexnum == 0)
    {
        distanceLeft = distanceLeftByScreen;
    }
    else
    {
        distanceLeft = (SHARE_IMAGE_VIEW_HEIGHT +distanceLeftByIcon)*indexnum + distanceLeftByScreen;
    }
    
    mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(distanceLeft*ScreenWidthRatio, (shareAreaViewHeight-SHARE_IMAGE_VIEW_HEIGHT)*ScreenHeightRatio/2, SHARE_IMAGE_VIEW_HEIGHT*ScreenHeightRatio, SHARE_IMAGE_VIEW_HEIGHT*ScreenHeightRatio)];
    mImageView.tag = indexnum;
    // 圆角指定为长度一半
    mImageView.layer.cornerRadius = mImageView.frame.size.width / 2;
    // image还需要加上这一句, 不然无效
    mImageView.layer.masksToBounds = true;
    mImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap;
    if (self.canOpenWeixin && self.canOpenWeibo)
    {
        switch (indexnum)
        {
            case 0://创建微信好友列表分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareFriendListImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_wechat"];
                break;
            case 1://创建微信朋友圈分享分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMomentsImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_moments"];
                break;
            case 2://创建微博分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareWeiboImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_weibo"];
                break;
            case 3://创建更多分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMoreImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_more"];
                break;
                
            default:
                break;
        }
    }
    else if (!self.canOpenWeixin && self.canOpenWeibo)
    {
        //显示微博+更多
        switch (indexnum)
        {
            case 0://创建微博分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareWeiboImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_weibo"];
                break;
            case 1://创建更多分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMoreImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_more"];
                break;
            default:
                break;
        }
        
    }
    else if (self.canOpenWeixin && !self.canOpenWeibo)
    {
        //显示微信+更多 3个
        switch (indexnum)
        {
            case 0://创建微信好友列表分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareFriendListImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_wechat"];
                break;
            case 1://创建微信朋友圈分享分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMomentsImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_moments"];
                break;
            case 2://创建更多分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMoreImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_more"];
                break;
                
            default:
                break;
        }
    }
    else if (!self.canOpenWeixin && !self.canOpenWeibo)
    {
        //显示更多
        switch (indexnum)
        {
            case 0://创建更多分享
                singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMoreImageOnClick:)];
                mImageView.image = [UIImage imageNamed:@"share_more"];
                break;
            default:
                break;
        }
    }
    [mImageView addGestureRecognizer:singleTap];
    return mImageView;
}



- (void)CreateSaveView
{
    UIView *saveAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.shareScrollView.frame.origin.y+self.shareScrollView.frame.size.height+1*ScreenHeightRatio, self.view.frame.size.width, SAVE_VIEW_HEIGHT*ScreenHeightRatio)];
    //创建箭头图标
    UIImageView *blackimageView = [[UIImageView alloc] initWithFrame:[self AdaptationCGRectMake:CGRectMake(20, 17, 20, 20)]];
    blackimageView.image = [UIImage imageNamed:@"back"];
    UITapGestureRecognizer *blackimageViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BcakImageViewOnClick:)];
    [blackimageView addGestureRecognizer:blackimageViewSingleTap];
    blackimageView.userInteractionEnabled = YES;
    [saveAreaView addSubview:blackimageView];
    //创建分割线
    CALayer* segmentingLineFrist = [CALayer layer];
    segmentingLineFrist.frame = [self AdaptationCGRectMake:CGRectMake(106, 16, 0.6, 18)];
    segmentingLineFrist.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [saveAreaView.layer addSublayer:segmentingLineFrist];
    //创建保存图标
    UIImageView *saveimageView = [[UIImageView alloc] initWithFrame:[self AdaptationCGRectMake:CGRectMake(128, 17, 20, 20)]];
    UITapGestureRecognizer *saveimageViewViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SaveImageViewOnClick:)];
    [saveimageView addGestureRecognizer:saveimageViewViewSingleTap];
    saveimageView.userInteractionEnabled = YES;
    saveimageView.image = [UIImage imageNamed:@"download"];
    [saveAreaView addSubview:saveimageView];
    //计算中间区域的大小，图标+文字描述的宽度

    UILabel * saveDesLabel = [[UILabel alloc] init];
    saveDesLabel.font = [UIFont systemFontOfSize:AdaptedWidthValue(10)];
    NSString *titleContent = @"Save image to album";
    saveDesLabel.text = titleContent;
    CGSize size = [saveDesLabel.text boundingRectWithSize:saveDesLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:saveDesLabel.font} context:nil].size;
    [saveDesLabel setFrame:CGRectMake(saveimageView.frame.origin.x + saveimageView.frame.size.width +10*ScreenWidthRatio, (saveAreaView.frame.size.height - size.height)/2, size.width, size.height)];
    [saveAreaView addSubview:saveDesLabel];
    
    //创建分割线
    CALayer* segmentingLineSecond = [CALayer layer];
    segmentingLineSecond.frame = [self AdaptationCGRectMake:CGRectMake(271, 16, 0.6, 18)];
    segmentingLineSecond.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [saveAreaView.layer addSublayer:segmentingLineSecond];
    
    //创建返回主页面按钮
    UIImageView *noimageView = [[UIImageView alloc] initWithFrame:[self AdaptationCGRectMake:CGRectMake(335, 17, 20, 20)]];
    noimageView.image = [UIImage imageNamed:@"backtomainscreen"];
    [saveAreaView addSubview:noimageView];
    [self.view addSubview:saveAreaView];
    
//    //绘制下边界  --- 测试线
//    CALayer* distanceBorder = [CALayer layer];
//    distanceBorder.frame = CGRectMake(0,saveAreaView.frame.origin.y+saveAreaView.frame.size.height, self.view.frame.size.width, 1*ScreenHeightRatio);
//    distanceBorder.backgroundColor = [[UIColor colorWithRed:151/255.0f green:151/255.0f blue:151/255.0f alpha:1.0f] CGColor];
//    [self.view.layer addSublayer:distanceBorder];
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
    //__weak typeof(self) weakSelf = self;
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

#pragma mark - Click
- (void)shareFriendListImageOnClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"shareFriendListImageOnClick");
    [self IsShareToFriendList:NO];
}

- (void)shareMomentsImageOnClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"shareMomentsImageOnClick");
    [self IsShareToFriendList:YES];
}


-(void)IsShareToFriendList:(BOOL)isMoments
{
    
    /** 标题
     * @note 长度不能超过512字节
     */
    // @property (nonatomic, retain) NSString *title;
    /** 描述内容
     * @note 长度不能超过1K
     */
    //@property (nonatomic, retain) NSString *description;
    /** 缩略图数据
     * @note 大小不能超过32K
     */
    //  @property (nonatomic, retain) NSData   *thumbData;
    /**
     * @note 长度不能超过64字节
     */
    // @property (nonatomic, retain) NSString *mediaTagName;
    /**
     * 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
     */
    // @property (nonatomic, retain) id        mediaObject;
    
    /*! @brief 设置消息缩略图的方法
     *
     * @param image 缩略图
     * @note 大小不能超过32K
     */
    //- (void) setThumbImage:(UIImage *)image;
    
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    //2.创建多媒体消息中包含的图片数据对象
    WXImageObject *imgObj = [WXImageObject object];
//    UIImage *image = [UIImage imageNamed:@"消息中心 icon"];
     UIImage *image = self.resultImage;
    //图片真实数据
    imgObj.imageData =UIImagePNGRepresentation(image);
    //多媒体数据对象
    mediaMsg.mediaObject = imgObj;
    
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(聊天界面)
    if (isMoments)
    {
        req.scene = WXSceneTimeline;
    }
    else
    {
        req.scene = WXSceneSession;
    }
    
    //发送请求到微信,等待微信返回onResp
    [WXApi sendReq:req];
    
    //        如果我们想要监听是否成功分享，我们就要去appdelegate里面 找到他的回调方法
    //         -(void) onResp:(BaseResp*)resp .我们可以自定义一个代理方法，然后把分享的结果返回回来。
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //添加对appdelgate的微信分享的代理
    appdelegate.wxDelegate = self;
}


- (void)shareWeiboImageOnClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"shareWeiboImageOnClick");
    //do something....
}

- (void)shareMoreImageOnClick:(UIGestureRecognizer *)gestureRecognizer
{
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

- (void)BcakImageViewOnClick:(UIGestureRecognizer *)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)SaveImageViewOnClick:(UIGestureRecognizer *)gestureRecognizer
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    //写入图片到相册
    [PHAssetChangeRequest creationRequestForAssetFromImage:self.resultImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
    }];
    
    //需要进一步完善 保存完成后 需要通知主页面 刷新已显示出保存的图片
    
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
                                                              NSLog(@"action = %@", action);
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
