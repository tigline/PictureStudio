//
//  PhotoPreviewCell.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/5/11.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "PhotoPreviewCell.h"
#import "HXPhotoManager.h"
#import "HXPhotoModel.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation PhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self configSubviews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoPreviewCollectionViewDidScroll) name:@"photoPreviewCollectionViewDidScroll" object:nil];
    }
    return self;
}

- (void)photoPreviewCollectionViewDidScroll {
    
}

- (void)configSubviews {
    self.previewView = [[PhotoPreviewView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [self.previewView setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.singleTapGestureBlock) {
            strongSelf.singleTapGestureBlock();
        }
    }];
    [self.previewView setImageProgressUpdateBlock:^(double progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.imageProgressUpdateBlock) {
            strongSelf.imageProgressUpdateBlock(progress);
        }
    }];
    [self addSubview:self.previewView];
}

- (void)setModel:(HXPhotoModel *)model {
    _model = model;
    _previewView.model = model;
    _previewView.asset = model.asset;
}

- (void)recoverSubviews {
    [_previewView recoverSubviews];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewView.frame = self.bounds;
}

@end


@interface PhotoPreviewView ()<UIScrollViewDelegate>

@end

@implementation PhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        if (iOS11Later) {
            //if (@available(iOS 11.0, *)) {
                _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            //} else {
                // Fallback on earlier versions
            //}
        }
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        

    }
    return self;
}



- (void)setModel:(HXPhotoModel *)model {
    _model = model;
    [_scrollView setZoomScale:1.0 animated:NO];
    _imageView.image = model.thumbPhoto;
    model.tempImage = nil;
    self.asset = model.asset;
    
}

- (void)setAsset:(id)asset {
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    __weak typeof(self) weakSelf = self;
    _asset = asset;
    
//    [HXPhotoTools getHighQualityFormatPhotoForPHAsset:_model.asset size:CGSizeMake(_model.endImageSize.width * 0.8, _model.endImageSize.height * 0.8) completion:^(UIImage *image, NSDictionary *info) {
//        //[weakSelf pushAnim:transitionContext image:image model:model fromVC:fromVC toVC:toVC];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.imageView.image = image;
//        });
//    } error:^(NSDictionary *info) {
//        //[weakSelf pushAnim:transitionContext image:model.thumbPhoto model:model fromVC:fromVC toVC:toVC];
//    }];
//    self.photoWidth = 828.0;
//    self.photoPreviewMaxWidth = 600;
//
//    CGFloat fullScreenWidth = phAsset.pixelWidth/2;
//    if (fullScreenWidth > 600) {
//        fullScreenWidth = 600;
//    }
    PHAsset *phAsset = (PHAsset *)asset;
    CGFloat screenScale = 2;
    CGFloat fullScreenWidth = phAsset.pixelWidth/2;
    if (fullScreenWidth > 700) {
        screenScale = 1.5;
    }
    if (fullScreenWidth > 600) {
        fullScreenWidth = 600;
    }
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        CGSize imageSize;
        if (fullScreenWidth < SCREEN_W && fullScreenWidth < 600) {
            imageSize =  CGSizeMake(((SCREEN_W-41)/3) * screenScale, ((SCREEN_W-41)/3) * screenScale);;
        } else {
            //PHAsset *phAsset = (PHAsset *)asset;
            CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
            CGFloat pixelWidth = fullScreenWidth * 2 * screenScale;
            // 超宽图片
            if (aspectRatio > 1.8) {
                pixelWidth = pixelWidth * aspectRatio;
            }
            // 超高图片
            if (aspectRatio < 0.2) {
                pixelWidth = pixelWidth * 0.5;
            }
            CGFloat pixelHeight = pixelWidth / aspectRatio;
            imageSize = CGSizeMake(pixelWidth, pixelHeight);
        }
        
//        self.imageRequestID = [HXPhotoTools getHighQualityFormatPhoto:asset size:imageSize startRequestIcloud:^(PHImageRequestID cloudRequestId) {
//
//
//        } progressHandler:^(double progress) {
//
//        } completion:^(UIImage *image) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//
//                weakSelf.imageView.image = image;
//            });
//        } failed:^(NSDictionary *info) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//
//            });
//        }];
        //__block UIImage *image;
        // 修复获取图片时出现的瞬间内存过高问题

        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        //option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = NO;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
//        option.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {

            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined ) {
                weakSelf.imageView.image = [self fixOrientation:result];
            }

        }];

    }
    
    /*
    PHImageRequestOptions * options=[[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous=YES;
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeDefault
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info)
     {
         if (![asset isEqual:weakSelf.asset]) return;
         weakSelf.imageView.image = result;
         [weakSelf resizeSubviews];
         
         if (weakSelf.imageProgressUpdateBlock) {
             weakSelf.imageProgressUpdateBlock(1);
         }
     }];
    
*/
    
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.hx_origin = CGPointZero;
    _imageContainerView.hx_w = self.scrollView.hx_w;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.hx_h / self.scrollView.hx_w) {
        _imageContainerView.hx_h = floor(image.size.height / (image.size.width / self.scrollView.hx_w));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.hx_w;
        if (height < 1 || isnan(height)) height = self.hx_w;
        height = floor(height);
        _imageContainerView.hx_w = height;
        _imageContainerView.hx_centerY = self.hx_h / 2;
    }
    if (_imageContainerView.hx_h > self.hx_h && _imageContainerView.hx_h - self.hx_h <= 1) {
        _imageContainerView.hx_h = self.hx_h;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.hx_h, self.hx_h);
    _scrollView.contentSize = CGSizeMake(self.scrollView.hx_w, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.hx_h <= self.hx_h ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;

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


- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(10, 0, self.hx_w - 20, self.hx_h);
//    static CGFloat progressWH = 40;
//    CGFloat progressX = (self.hx_w - progressWH) / 2;
//    CGFloat progressY = (self.hx_h - progressWH) / 2;
//    _progressView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    
    [self recoverSubviews];
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
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
    CGFloat offsetX = (_scrollView.hx_w > _scrollView.contentSize.width) ? ((_scrollView.hx_w - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.hx_h > _scrollView.contentSize.height) ? ((_scrollView.hx_h - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

@end



