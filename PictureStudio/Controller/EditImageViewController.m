//
//  EditImageViewController.m
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/8/23.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "EditImageViewController.h"
#import "HXPhotoModel.h"
#import "FFCutImageView.h"
#import "EditImageBottomView.h"
#import "ShareBoardView.h"
#define BottomViewHight 96 * ScreenHeightRatio
@interface EditImageViewController ()<UIScrollViewDelegate,EditImageBottomViewDelegate,ShareBoardViewDelegate>
@property (assign, nonatomic) BOOL isShowShareBoardView;
@property (strong, nonatomic) ShareBoardView *shareBoardView;
@end

@implementation EditImageViewController
{
    UIImageView *imageView;
    UIView *imageContainerView;
    UIScrollView *scrollView;
    //裁剪view
    FFCutImageView *_cutImageView;
    EditImageBottomView *_mEditImageBottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    scrollView = [[UIScrollView alloc] init];
    scrollView.bouncesZoom = YES;
//    scrollView.maximumZoomScale = 3.0;
//    scrollView.minimumZoomScale = 1.0;
    scrollView.multipleTouchEnabled = YES;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = YES;
    scrollView.alwaysBounceVertical = NO;
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
    [self.view addSubview:scrollView];
    
    scrollView.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, self.view.frame.size.height - BottomViewHight - kBottomMargin -[[UIApplication sharedApplication] statusBarFrame].size.height);
    
    imageContainerView = [[UIView alloc] init];
    imageContainerView.clipsToBounds = YES;
    imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    [scrollView addSubview:imageContainerView];
    
    imageView = [[UIImageView alloc] init];
    [imageContainerView addSubview:imageView];
    
    _mEditImageBottomView = [[EditImageBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomMargin - BottomViewHight, self.view.frame.size.width, BottomViewHight)];
    [self.view addSubview:_mEditImageBottomView];
    
    _mEditImageBottomView.delegate = self;
    
    [scrollView setZoomScale:1.0 animated:NO];
    imageView.image = self.model.thumbPhoto;
    self.model.tempImage = nil;
    self.asset = self.model.asset;
    
    [self.view addSubview:self.shareBoardView];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
}


- (void)setAsset:(id)asset {
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    __weak typeof(self) weakSelf = self;
    _asset = asset;
    PHAsset *phAsset = (PHAsset *)asset;
    CGFloat screenScale = 2;
    CGFloat fullScreenWidth = phAsset.pixelWidth/2;
    if (fullScreenWidth > 750) {
        screenScale = 1.5;
    }

    if ([asset isKindOfClass:[PHAsset class]]) {

        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        //option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = NO;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        //        option.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(self.model.previewViewSize.width*1.5, self.model.previewViewSize.height*1.5) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined ) {
                imageView.image = [self fixOrientation:result];
                [weakSelf resizeSubviews];
            }
            
        }];
        
    }
    
}

- (void)recoverSubviews {
    [scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

-(void)resizeSubviews{
    
    CGFloat contantHeight = scrollView.frame.size.height;
    UIImage *image = imageView.image;
    if (image.size.height / image.size.width > contantHeight / scrollView.frame.size.width) {
        if (image.size.height >=contantHeight)
        {
            CGFloat hight = contantHeight-20*ScreenHeightRatio;
            CGFloat width = contantHeight/(image.size.height / image.size.width);
            CGFloat x = (scrollView.frame.size.width - width)/2;
            CGFloat y = 10*ScreenHeightRatio;
            imageContainerView.frame = CGRectMake(x, y, width, hight);
        }
        else
        {
            CGFloat hight = image.size.height-20*ScreenHeightRatio;
            CGFloat width = image.size.height/(image.size.height / image.size.width);
            CGFloat x = (scrollView.frame.size.width - width)/2;
            CGFloat y = (scrollView.frame.size.height - hight)/2;
            imageContainerView.frame = CGRectMake(x, y, width, hight);
        }
    } else {
        if (image.size.width >= scrollView.frame.size.width)
        {
            CGFloat x = 10*ScreenWidthRatio;
            CGFloat width = self.view.frame.size.width - 20*ScreenWidthRatio;
            CGFloat hight = image.size.height*(width/image.size.width);
            CGFloat y = (scrollView.frame.size.height - hight)/2;
            imageContainerView.frame = CGRectMake(x, y, width, hight);
        }
        else
        {
            CGFloat width = image.size.width;
            CGFloat hight = image.size.height*(width/image.size.width);
            CGFloat x = (self.view.frame.size.width - width)/2;
            CGFloat y = (scrollView.frame.size.height - hight)/2;
            imageContainerView.frame = CGRectMake(x, y, width, hight);
        }
        
    }
    imageView.frame = imageContainerView.bounds;
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    //if (!self.shouldFixOrientation) return aImage;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



-(UIImage *)getCutImageFromImage:(UIImage*)bigImage withFrame:(CGRect)myImageRect
{

    CGImageRef imageRef = bigImage.CGImage;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    CGSize size;
    
    size.width = myImageRect.size.width;
    
    size.height = myImageRect.size.height;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

-(void)CutButtonClick
{
    NSLog(@"11111");
    if (_cutImageView == nil)
    {
        
        NSLog(@"初始状态 imageContainerView  %f --%f -- %f -- %f --  ",imageContainerView.frame.origin.x, imageContainerView.frame.origin.y, imageContainerView.frame.size.width, imageContainerView.frame.size.height);
        
        _cutImageView = [[FFCutImageView alloc] initWithSuperview:scrollView frame:CGRectMake(imageContainerView.frame.origin.x, imageContainerView.frame.origin.y, imageContainerView.frame.size.width, imageContainerView.frame.size.height)];
        _cutImageView.backgroundColor = [UIColor clearColor];
        _cutImageView.bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _cutImageView.gridColor = [UIColor colorWithRed:68/255 green:159/255 blue:255/255 alpha:1];
        _cutImageView.clipsToBounds = NO;
    }
}
-(void)HighLightButtonClick{
    
}
-(void)DoodelButtonClick{
    
}


-(void)CancelButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)ConfirmButtonClick
{
    if (_isShowShareBoardView) {
        [self hideShareBoard];
    } else {
        [self showShareBoard];
    }
}

-(void)ResetButtonClick{
    NSLog(@"11111");
    if (_cutImageView != nil)
    {
        [_cutImageView removeFromSuperview];
        _cutImageView = nil;
    }
}

-(void)CutViewButtonClick
{
    CGRect rct = _cutImageView.clippingRect;
    if (rct.size.width != 0 && rct.size.height != 0)
    {
        CGFloat zoomScale = imageView.frame.size.width / imageView.image.size.width;
        rct.size.width  /= zoomScale;
        rct.size.height /= zoomScale;
        rct.origin.x    /= zoomScale;
        rct.origin.y    /= zoomScale;
        
        CGPoint origin = CGPointMake(-rct.origin.x, -rct.origin.y);
        UIGraphicsBeginImageContextWithOptions(rct.size, NO, imageView.image.scale);
        [imageView.image drawAtPoint:origin];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //返回剪裁后的图片
        imageView.image = img;
        [self resizeSubviews];
        if (_cutImageView != nil)
        {
            [_cutImageView removeFromSuperview];
            _cutImageView = nil;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"变化后的 imageContainerView%f --%f -- %f -- %f --  ",imageContainerView.frame.origin.x, imageContainerView.frame.origin.y, imageContainerView.frame.size.width, imageContainerView.frame.size.height);
    [_cutImageView setFrameWithSize:scrollView.zoomScale withFrame:imageContainerView.frame];
    [self refreshImageContainerViewCenter];
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    //[self refreshScrollViewContentSize];
    [scrollView setZoomScale:scale animated:NO];
//    NSLog(@"最终的 imageContainerView%f --%f -- %f -- %f --  ",imageContainerView.frame.origin.x, imageContainerView.frame.origin.y, imageContainerView.frame.size.width, imageContainerView.frame.size.height);
    [_cutImageView setFrameWithSize:scrollView.zoomScale withFrame:imageContainerView.frame];
    
    
    [self refreshImageContainerViewCenter];
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? ((scrollView.frame.size.width - scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? ((scrollView.frame.size.height - scrollView.contentSize.height) * 0.5) : 0.0;
    imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - share

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    
    NSURL *url;
    switch (platformType) {
        case UMSocialPlatformType_Sina://新浪  判断手机是否安装新浪
            url = [NSURL URLWithString:@"sinaweibo://"];
            if (![[UIApplication sharedApplication] canOpenURL:url])
            {
                [self showAlertView:@"请先安装微博"];
                return;
            }
            break;
        case UMSocialPlatformType_WechatSession://微信聊天 判断手机是否安装微信
        case UMSocialPlatformType_WechatTimeLine://微信朋友圈
            url = [NSURL URLWithString:@"weixin://"];
            if (![[UIApplication sharedApplication] canOpenURL:url])
            {
                [self showAlertView:@"请先安装微信"];
                return;
            }
            break;
        default:
            break;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    UIImage *saveImage = imageView.image;
    if (saveImage == nil) {
        return;
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


-(void)showAlertView:(NSString*)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *open = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:open];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
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
    UIImage *imageToShare = imageView.image;
    if (imageToShare == nil) {
        return;
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
- (ShareBoardView *)shareBoardView {
    if (!_shareBoardView) {
        _shareBoardView = [[ShareBoardView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BottomViewHight/2 - kBottomMargin, self.view.frame.size.width, ShareBoardHeight)];
        _shareBoardView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _shareBoardView.shareDelegate = self;
        _shareBoardView.hidden = YES;
    }
    return _shareBoardView;
}
- (void)showShareBoard {
    _shareBoardView.hidden = NO;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
//                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.originX, _shareBoardView.originY - ShareBoardHeight+1, _shareBoardView.size.width, _shareBoardView.size.height)];
                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.frame.origin.x, _shareBoardView.frame.origin.y - ShareBoardHeight + 1, _shareBoardView.frame.size.width, _shareBoardView.frame.size.height)];
                         
                     }completion:^(BOOL finished) {
                         _isShowShareBoardView = YES;
                         
                     }];
}

- (void)hideShareBoard {
    [UIView animateWithDuration:0.3f
                     animations:^{

                         [_shareBoardView setFrame:CGRectMake(_shareBoardView.frame.origin.x, _shareBoardView.frame.origin.y + ShareBoardHeight-1, _shareBoardView.frame.size.width, _shareBoardView.frame.size.height)];

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

//- (void)doubleTap:(UITapGestureRecognizer *)tap {
//    if (_showImageScrollView.zoomScale > 1.0) {
//        _showImageScrollView.contentInset = UIEdgeInsetsZero;
//        [_showImageScrollView setZoomScale:1.0 animated:YES];
//
//    } else {
//        CGPoint touchPoint = [tap locationInView:self.containImageView];
//        CGFloat newZoomScale = _showImageScrollView.maximumZoomScale;
//        CGFloat xsize = self.view.frame.size.width / newZoomScale;
//        CGFloat ysize = self.view.frame.size.height / newZoomScale;
//        [_showImageScrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
