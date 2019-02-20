//
//  UIImageView+HXExtension.m
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "UIImageView+HXExtension.h"

#import "HXPhotoModel.h"

//#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
//#import <SDWebImage/UIImageView+WebCache.h>
//#else
//#import "UIImageView+WebCache.h"
//#endif

@implementation UIImageView (HXExtension)
- (void)hx_setImageWithModel:(HXPhotoModel *)model progress:(void (^)(CGFloat progress, HXPhotoModel *model))progressBlock completed:(void (^)(UIImage * image, NSError * error, HXPhotoModel * model))completedBlock {
//    __weak typeof(self) weakSelf = self;
//    [self sd_setImageWithURL:model.networkPhotoUrl placeholderImage:model.thumbPhoto options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        model.receivedSize = receivedSize;
//        model.expectedSize = expectedSize;
//        CGFloat progress = (CGFloat)receivedSize / expectedSize;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (progressBlock) {
//                progressBlock(progress, model);
//            }
//        });
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (error != nil) {
//            model.downloadError = YES;
//            model.downloadComplete = YES;
//        }else {
//            if (image) {
//                weakSelf.image = image;
//                model.imageSize = image.size;
//                model.thumbPhoto = image;
//                model.previewPhoto = image;
//                model.downloadComplete = YES;
//                model.downloadError = NO;
//            }
//        }
//        if (completedBlock) {
//            completedBlock(image,error,model);
//        }
//    }];
}
+ (UIImage *)addBorderForImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor beginY:(CGFloat)beginY bottomHeight:(CGFloat)bottomHeight {
    CGSize size = CGSizeMake(image.size.width + 2 * borderWidth, image.size.height + beginY + bottomHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [borderColor set];
    [path fill];
    path = [UIBezierPath bezierPathWithRect:CGRectMake(borderWidth, beginY, image.size.width, image.size.height)];
    [path addClip];
    [image drawInRect:CGRectMake(borderWidth, beginY, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
