//
//  HXPhoto3DTouchViewController.m
//  微博照片选择
//
//  Created by 洪欣 on 2017/9/25.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "HXPhoto3DTouchViewController.h"
#import <PhotosUI/PhotosUI.h>
#import "UIImage+HXExtension.h"

@interface HXPhoto3DTouchViewController ()

@property (assign, nonatomic) PHImageRequestID requestId;
@end

@implementation HXPhoto3DTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.hx_size = self.model.previewViewSize;
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self loadPhoto];


}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PHImageManager defaultManager] cancelImageRequest:self.requestId];


    [self.view addSubview:self.imageView];
}

- (void)loadPhoto {
    if (self.model.type == HXPhotoModelMediaTypeCameraPhoto) {
        self.imageView.image = self.model.thumbPhoto;
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.requestId = [HXPhotoTools getHighQualityFormatPhoto:self.model.asset size:CGSizeMake(self.model.previewViewSize.width*1.5, self.model.previewViewSize.height*1.5) startRequestIcloud:^(PHImageRequestID cloudRequestId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.requestId = cloudRequestId;
           
        });
    } progressHandler:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } completion:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{

            weakSelf.imageView.image = image;
        });
    } failed:^(NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.progressView showError];
        });
    }];
    //    requestId = [HXPhotoTools fetchPhotoWithAsset:self.model.asset photoSize:CGSizeMake(self.model.previewViewSize.width * 1.5, self.model.previewViewSize.height * 1.5) completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
    //        weakSelf.imageView.image = photo;
    //    }];
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.hx_x = 0;
        _imageView.hx_y = 0;
    }
    return _imageView;
}

//- (PHLivePhotoView *)livePhotoView {
//    if (!_livePhotoView) {
//        _livePhotoView = [[PHLivePhotoView alloc] init];
//        _livePhotoView.clipsToBounds = YES;
//        _livePhotoView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _livePhotoView;
//}
@end

