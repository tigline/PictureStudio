//
//  HX_PhotoManager.m
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "HXPhotoManager.h"
#import <mach/mach_time.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


@interface HXPhotoManager ()<PHPhotoLibraryChangeObserver>
@property (strong, nonatomic) NSMutableArray *allPhotos;
@property (strong, nonatomic) NSMutableArray *allObjs;
//@property (assign, nonatomic) BOOL hasLivePhoto;
//------// 当要删除的已选中的图片或者视频的时候需要在对应的end数组里面删除
// 例如: 如果删除的是通过相机拍的照片需要在 endCameraList 和 endCameraPhotos 数组删除对应的图片模型
@property (strong, nonatomic) NSMutableArray *selectedList;
@property (strong, nonatomic) NSMutableArray *selectedPhotos;
@property (strong, nonatomic) NSMutableArray *cameraList;
@property (strong, nonatomic) NSMutableArray *cameraPhotos;
@property (strong, nonatomic) NSMutableArray *endCameraList;
@property (strong, nonatomic) NSMutableArray *endCameraPhotos;
@property (strong, nonatomic) NSMutableArray *selectedCameraList;
@property (strong, nonatomic) NSMutableArray *selectedCameraPhotos;
@property (strong, nonatomic) NSMutableArray *endSelectedCameraList;
@property (strong, nonatomic) NSMutableArray *endSelectedCameraPhotos;
@property (strong, nonatomic) NSMutableArray *endSelectedList;
@property (strong, nonatomic) NSMutableArray *endSelectedPhotos;
//------//
@property (assign, nonatomic) BOOL isOriginal;
@property (assign, nonatomic) BOOL endIsOriginal;
@property (copy, nonatomic) NSString *photosTotalBtyes;
@property (copy, nonatomic) NSString *endPhotosTotalBtyes;
@property (strong, nonatomic) NSMutableArray *iCloudUploadArray;
@property (strong, nonatomic) NSMutableArray *albums;
@property (strong, nonatomic) UIImage *resultImage;
@property (assign, nonatomic) CGFloat screenShotWidth;
@end

@implementation HXPhotoManager
#pragma mark - < 初始化 >
- (instancetype)initWithType:(HXPhotoManagerSelectedType)type {
    if (self = [super init]) {
        self.type = type;
        [self setup];
    }
    return self;
}
- (instancetype)init {
    if ([super init]) {
        self.type = HXPhotoManagerSelectedTypePhoto;
        [self setup];
    }
    return self;
}
- (void)setup {
    self.albums = [NSMutableArray array];
    self.selectedList = [NSMutableArray array];
    self.selectedPhotos = [NSMutableArray array];
    self.endSelectedList = [NSMutableArray array];
    self.endSelectedPhotos = [NSMutableArray array];
    self.cameraList = [NSMutableArray array];
    self.cameraPhotos = [NSMutableArray array];
    self.endCameraList = [NSMutableArray array];
    self.endCameraPhotos = [NSMutableArray array];
    self.selectedCameraList = [NSMutableArray array];
    self.selectedCameraPhotos = [NSMutableArray array];
    self.endSelectedCameraList = [NSMutableArray array];
    self.endSelectedCameraPhotos = [NSMutableArray array];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}
- (HXPhotoConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[HXPhotoConfiguration alloc] init];
    }
    return _configuration;
}

- (BOOL)shouldShowTipView
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    if ([[defaults objectForKey:@"isFirstLaunch"] isEqualToString:@"NO"]) {
        return NO;
    } else {
        [defaults setObject:@"NO" forKey:@"isFirstLaunch"];
        return YES;
    }
}

- (void)setLocalImageList:(NSArray *)localImageList {
    _localImageList = localImageList;
    if (![localImageList.firstObject isKindOfClass:[UIImage class]]) {
        NSSLog(@"请传入装着UIImage对象的数组");
        return;
    }
    for (UIImage *image in localImageList) {
        HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImage:image];
        photoModel.selected = YES;
        [self.endCameraPhotos addObject:photoModel];
        [self.endSelectedCameraPhotos addObject:photoModel];
        [self.endCameraList addObject:photoModel];
        [self.endSelectedCameraList addObject:photoModel];
        [self.endSelectedPhotos addObject:photoModel];
        [self.endSelectedList addObject:photoModel];
    }
}
- (void)addNetworkingImageToAlbum:(NSArray<NSString *> *)imageUrls selected:(BOOL)selected {
    if (![imageUrls.firstObject isKindOfClass:[NSString class]]) {
        NSSLog(@"请传入装着NSString对象的数组");
        return;
    }
    self.configuration.deleteTemporaryPhoto = NO;
    for (NSString *imageUrlStr in imageUrls) {
        HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImageURL:[NSURL URLWithString:imageUrlStr]];
        photoModel.selected = selected;
        if (selected) {
            [self.endCameraPhotos addObject:photoModel];
            [self.endSelectedCameraPhotos addObject:photoModel];
            [self.endCameraList addObject:photoModel];
            [self.endSelectedCameraList addObject:photoModel];
            [self.endSelectedPhotos addObject:photoModel];
            [self.endSelectedList addObject:photoModel];
        }else {
            [self.endCameraPhotos addObject:photoModel];
            [self.endCameraList addObject:photoModel];
        }
    }
}
- (void)setNetworkPhotoUrls:(NSArray<NSString *> *)networkPhotoUrls {
    _networkPhotoUrls = networkPhotoUrls;
    if (![networkPhotoUrls.firstObject isKindOfClass:[NSString class]]) {
        NSSLog(@"请传入装着NSString对象的数组");
        return;
    }
    self.configuration.deleteTemporaryPhoto = NO;
    for (NSString *imageUrlStr in networkPhotoUrls) {
        HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImageURL:[NSURL URLWithString:imageUrlStr]];
        photoModel.selected = NO;
        [self.endCameraPhotos addObject:photoModel];
        [self.endCameraList addObject:photoModel];
    }
}
- (void)addLocalImage:(NSArray *)images selected:(BOOL)selected {
    if (![images.firstObject isKindOfClass:[UIImage class]]) {
        NSSLog(@"请传入装着UIImage对象的数组");
        return;
    }
    self.configuration.deleteTemporaryPhoto = NO;
    for (UIImage *image in images) {
        HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImage:image];
        photoModel.selected = selected;
        if (selected) {
            [self.endCameraPhotos addObject:photoModel];
            [self.endSelectedCameraPhotos addObject:photoModel];
            [self.endCameraList addObject:photoModel];
            [self.endSelectedCameraList addObject:photoModel];
            [self.endSelectedPhotos addObject:photoModel];
            [self.endSelectedList addObject:photoModel];
        }else {
            [self.endCameraPhotos addObject:photoModel];
            [self.endCameraList addObject:photoModel];
        }
    }
}
- (void)addLocalImageToAlbumWithImages:(NSArray *)images {
    if (![images.firstObject isKindOfClass:[UIImage class]]) {
        NSSLog(@"请传入装着UIImage对象的数组");
        return;
    }
    self.configuration.deleteTemporaryPhoto = NO;
    for (UIImage *image in images) {
        HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImage:image];
        [self.endCameraPhotos addObject:photoModel];
        [self.endCameraList addObject:photoModel];
    }
}

- (int32_t)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    CGFloat fullScreenWidth = SCREEN_W;
    if (fullScreenWidth > 600) {
        fullScreenWidth = 600;
    }
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:progressHandler networkAccessAllowed:networkAccessAllowed];
}

- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        CGSize imageSize;
        if (photoWidth < SCREEN_W && photoWidth < 600) {
            imageSize =  CGSizeMake((SCREEN_W/3 - 10) * 2, (SCREEN_W/3 - 10) * 2);;
        } else {
            PHAsset *phAsset = (PHAsset *)asset;
            CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
            CGFloat pixelWidth = photoWidth * 2 * 1.5;
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
        
        __block UIImage *image;
        // 修复获取图片时出现的瞬间内存过高问题
        // 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                image = result;
            }
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [self fixOrientation:result];
                if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            
        }];
        return imageRequestID;
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)asset;
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            CGImageRef thumbnailImageRef = alAsset.thumbnail;
            UIImage *thumbnailImage = [UIImage imageWithCGImage:thumbnailImageRef scale:2.0 orientation:UIImageOrientationUp];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(thumbnailImage,nil,YES);
                
                if (photoWidth == SCREEN_W || photoWidth == 600) {
                    dispatch_async(dispatch_get_global_queue(0,0), ^{
                        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
                        CGImageRef fullScrennImageRef = [assetRep fullScreenImage];
                        UIImage *fullScrennImage = [UIImage imageWithCGImage:fullScrennImageRef scale:2.0 orientation:UIImageOrientationUp];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) completion(fullScrennImage,nil,NO);
                        });
                    });
                }
            });
        });
    }
    return 0;
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
/**
 获取所有相册，并返回当前相册
 */

- (void)getAllPhotoAndCurrentAlbums:(void(^)(HXAlbumModel *currentAlbumModel))currentModel albums:(void(^)(NSArray *albums))albums AlbumName:(NSString *)AlbumName {
    
    if (self.albums.count > 0) [self.albums removeAllObjects];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    
    
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (AlbumName) {
            
        
            if ([collection.localizedTitle isEqualToString:AlbumName]) {
                
                // 是否按创建时间排序
                PHFetchOptions *option = [[PHFetchOptions alloc] init];
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                
                // 获取照片集合
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                
                HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
                albumModel.count = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                albumModel.index = idx;
                if (currentModel) {
                    currentModel(albumModel);
                }
                *stop = YES;
            }
        }else {
            // 是否按创建时间排序
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            
            // 获取照片集合
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            // 过滤掉空相册
            if (result.count > 0 && ![[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近删除"]) {
                HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
                albumModel.count = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                if ([[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] || [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"]) {
                    [self.albums insertObject:albumModel atIndex:0];
                }else {
                    [self.albums addObject:albumModel];
                }
            }
        }
    }];
    // 获取用户相册

    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        

            // 是否按创建时间排序
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            
            // 获取照片集合
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            // 过滤掉空相册
            if (result.count > 0) {
                HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
                albumModel.count = result.count;
                albumModel.albumName = [HXPhotoTools transFormPhotoTitle:collection.localizedTitle];
                albumModel.result = result;
                [self.albums addObject:albumModel];
            }
        
        
    }];
    for (int i = 0 ; i < self.albums.count; i++) {
        HXAlbumModel *model = self.albums[i];
        model.index = i;
        //        NSPredicate *pred = [NSPredicate predicateWithFormat:@"currentAlbumIndex = %d", i];
        //        NSArray *newArray = [self.selectedList filteredArrayUsingPredicate:pred];
        //        model.selectedCount = newArray.count;
    }
    if (albums) {
        albums(self.albums);
    }
}

/**
 获取系统所有相册
 
 @param albums 相册集合
 */


- (void)getAllPhotoAlbums:(void(^)(HXAlbumModel *firstAlbumModel))firstModel albums:(void(^)(NSArray *albums))albums isFirst:(BOOL)isFirst {
    if (self.albums.count > 0) [self.albums removeAllObjects];

    // 获取系统智能相册
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    
    
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isFirst) {
            if ([[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] || [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"]) {
                
                // 是否按创建时间排序
                PHFetchOptions *option = [[PHFetchOptions alloc] init];
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

                    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                
                // 获取照片集合
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                
                HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
                albumModel.count = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                albumModel.index = 0;
                if (firstModel) {
                    firstModel(albumModel);
                }
                *stop = YES;
            }
        }else {
            // 是否按创建时间排序
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];

            // 获取照片集合
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            // 过滤掉空相册
            if (result.count > 0 && ![[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近删除"]) {
                HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
                albumModel.count = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                if ([[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] || [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"]) {
                    [self.albums insertObject:albumModel atIndex:0];
                }else {
                    [self.albums addObject:albumModel];
                }
            }
        }
    }];
    if (isFirst) {
        return;
    }
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];

        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = [HXPhotoTools transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            [self.albums addObject:albumModel];
        }
    }];
    for (int i = 0 ; i < self.albums.count; i++) {
        HXAlbumModel *model = self.albums[i];
        model.index = i;
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"currentAlbumIndex = %d", i];
//        NSArray *newArray = [self.selectedList filteredArrayUsingPredicate:pred];
//        model.selectedCount = newArray.count;
    }
    if (albums) {
        albums(self.albums);
    }
}

- (BOOL)isAllScreenShotPhoto {
    
    BOOL isALLScreenShot = NO;
    for (int i = 0; i < _selectedList.count; i++) {
        HXPhotoModel *model = [[HXPhotoModel alloc] init];
        model = [_selectedList objectAtIndex:i];
        if (model.asset.pixelWidth != _screenShotWidth) {
            return NO;
        }
        if (!model.isScreenShot) {
            return NO;
        } else {
            isALLScreenShot = model.isScreenShot;
        }
    }
    
    return isALLScreenShot;
}

- (void)combinePhotosWithDirection:(BOOL)isVertical resultImage:(void(^)(UIImage *combineImage))combineImage completeIndex:(void(^)(NSInteger index))completeIndex {
    
    CGFloat combineValueSize;

    NSArray *imagesArray = [self getSelectImages];
    if (isVertical) {
        combineValueSize = [self getSelectPhotosMinWidth];
//        if (combineValueSize > 800) {
//            combineValueSize = 800;
//        }
        UIImage *masterImage = [imagesArray objectAtIndex:0];
        for (int i = 1; i < imagesArray.count; i ++) {

            UIImage *slaveImage = [imagesArray objectAtIndex:i];
            CGSize size;
            size.width = combineValueSize;
            CGFloat masterHeight;
            if (masterImage.size.width > combineValueSize) {
                masterHeight = (combineValueSize/masterImage.size.width) * masterImage.size.height;
            } else {
                masterHeight = masterImage.size.height;
            }
            CGFloat slaveHeight = (combineValueSize/slaveImage.size.width) * slaveImage.size.height;
            size.height = masterHeight + slaveHeight;

            UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
            //Draw masterImage
            [masterImage drawInRect:CGRectMake(0, 0, combineValueSize, masterHeight)];
            //Draw slaveImage
            
            [slaveImage drawInRect:CGRectMake(0, masterHeight, combineValueSize, slaveHeight)];
            UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
            masterImage = nil;
            masterImage = resultImage;
            UIGraphicsEndImageContext();
            completeIndex(i);
            
        }
        combineImage(masterImage);
        
        
    } else {
        combineValueSize = [self getSelectPhotosMinHeight];
//        if (combineValueSize > 1600) {
//            combineValueSize = 1600;
//        }
        UIImage *masterImage = [imagesArray objectAtIndex:0];
        for (int i = 1; i < imagesArray.count; i ++) {
            
            UIImage *slaveImage = [imagesArray objectAtIndex:i];
            CGSize size;
            CGFloat masterWidth;
            if (masterImage.size.height > combineValueSize) {
                masterWidth = (combineValueSize/masterImage.size.height) * masterImage.size.width;
            } else {
                masterWidth = masterImage.size.width;
            }
            CGFloat slaveWidth = (combineValueSize/slaveImage.size.height) * slaveImage.size.width;
            size.width = masterWidth + slaveWidth;
            size.height = combineValueSize;
            
            UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
            //Draw masterImage
            [masterImage drawInRect:CGRectMake(0, 0, masterWidth, combineValueSize)];
            //Draw slaveImage
            [slaveImage drawInRect:CGRectMake(masterWidth, 0, slaveWidth, combineValueSize)];
            UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
            masterImage = nil;
            masterImage = resultImage;
            UIGraphicsEndImageContext();
            completeIndex(i);
        }
        combineImage(masterImage);
        
    }


}

- (NSArray *)getSelectImages {

    __block NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    for (int i = 0; i < _selectedList.count; i++) {
        HXPhotoModel *model;
        model = [_selectedList objectAtIndex:i];
        PHAsset *phAsset = model.asset;
        PHImageRequestOptions * options=[[PHImageRequestOptions alloc]init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous=YES;
    
        [imageManager requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize
                               contentMode:PHImageContentModeDefault
                                   options:options
                             resultHandler:^(UIImage *result, NSDictionary *info)
         {
             [photoArray addObject:result];
         }];
        
    }
    return photoArray;
}


- (CGFloat)getSelectPhotosMinWidth {
    
    HXPhotoModel *mode = [self.selectedList objectAtIndex:0];
    UIImage *image =  mode.previewPhoto;
    CGFloat minWidth = image.size.width;
    for (int i = 1; i <_selectedList.count; i++) {
        HXPhotoModel *mode = [self.selectedList objectAtIndex:i];
        UIImage *image =  mode.previewPhoto;
        if (image.size.width < minWidth) {
            minWidth = image.size.width;
        }
    }
    return minWidth;
}

- (CGFloat)getSelectPhotosMinHeight {
    
    HXPhotoModel *mode = [self.selectedList objectAtIndex:0];
    UIImage *image =  mode.previewPhoto;
    CGFloat minHeight = image.size.height;
    for (int i = 1; i <_selectedList.count; i++) {
        HXPhotoModel *mode = [self.selectedList objectAtIndex:i];
        UIImage *image =  mode.previewPhoto;
        if (image.size.height < minHeight) {
            minHeight = image.size.height;
        }
    }
    return minHeight;
}

/**
 *  是否为同一天
 */
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
- (void)getPhotoListWithAlbumModel:(HXAlbumModel *)albumModel complete:(void (^)(NSArray *allList , NSArray *previewList,NSArray *photoList ,NSArray *videoList ,NSArray *dateList , HXPhotoModel *firstSelectModel))complete {
    NSMutableArray *allArray = [NSMutableArray array];
    NSMutableArray *previewArray = [NSMutableArray array];
    NSMutableArray *videoArray = [NSMutableArray array];
    NSMutableArray *photoArray = [NSMutableArray array];
    NSMutableArray *dateArray = [NSMutableArray array];

    __block HXPhotoModel *firstSelectModel;
    //__block BOOL already = NO;
    NSMutableArray *selectList = [NSMutableArray arrayWithArray:self.selectedList];
    
    NSInteger index = 0;
    for (PHAsset *asset in albumModel.result) {
        HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
        photoModel.asset = asset;
        photoModel.clarityScale = self.configuration.clarityScale;

        if (selectList.count > 0) {
            NSString *property = @"asset";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@", property, asset];
            NSArray *newArray = [selectList filteredArrayUsingPredicate:pred];
            if (newArray.count > 0) {
                HXPhotoModel *model = newArray.firstObject;
                [selectList removeObject:model];
                photoModel.selected = YES;
//                if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypeCameraPhoto)) {
//                    if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
//                        [self.selectedCameraPhotos replaceObjectAtIndex:[self.selectedCameraPhotos indexOfObject:model] withObject:photoModel];
//                    }else {
//                        [self.selectedPhotos replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
//                    }
//                }
                [self.selectedList replaceObjectAtIndex:[self.selectedList indexOfObject:model] withObject:photoModel];
                photoModel.thumbPhoto = model.thumbPhoto;
                photoModel.previewPhoto = model.previewPhoto;
                photoModel.selectIndexStr = model.selectIndexStr;
                if (!firstSelectModel) {
                    firstSelectModel = photoModel;
                }
            }
        }
        if (asset.mediaType == PHAssetMediaTypeImage) {
            photoModel.type = HXPhotoModelMediaTypePhoto;
            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoScreenshot) {
                photoModel.subType = HXPhotoModelMediaSubTypePhoto;
                photoModel.isScreenShot = YES;
            } else {
                photoModel.subType = HXPhotoModelMediaSubTypePhoto;
                photoModel.isScreenShot = NO;
            }
            
            
            
            
            //                if (!photoModel.isICloud) {
            [photoArray addObject:photoModel];
            //                }
        }
        
        photoModel.currentAlbumIndex = albumModel.index;
        BOOL canAddPhoto = YES;
        if (self.configuration.filtrationICloudAsset) {
            if (!photoModel.isICloud) {
                [allArray addObject:photoModel];
                [previewArray addObject:photoModel];
            }else {
                canAddPhoto = NO;
            }
        }else {
            [allArray addObject:photoModel];
            
            [previewArray addObject:photoModel];
            
        }
        
        photoModel.dateItem = allArray.count - 1;
        photoModel.dateSection = 0;
        
        index++;
    }
    
    if (complete) {
        complete(allArray,previewArray,photoArray,videoArray,dateArray,firstSelectModel);
    }
}

- (NSString *)maximumOfJudgment:(HXPhotoModel *)model {
    if ([self beforeSelectCountIsMaximum]) {
        // 已经达到最大选择数 [NSString stringWithFormat:@"最多只能选择%ld个",manager.maxNum]
        return [NSString stringWithFormat:[NSBundle hx_localizedStringForKey:@"最多只能选择%ld张图片"],self.configuration.maxNum];
    }
    if (self.type == HXPhotoManagerSelectedTypePhotoAndVideo) {
        if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif) || (model.type == HXPhotoModelMediaTypeCameraPhoto || model.type == HXPhotoModelMediaTypeLivePhoto)) {

            if (self.selectedPhotos.count == self.configuration.photoMaxNum) {
                // 已经达到图片最大选择数
                
                return [NSString stringWithFormat:[NSBundle hx_localizedStringForKey:@"最多只能选择%ld张图片"],self.configuration.photoMaxNum];
            }
        }
    }else if (self.type == HXPhotoManagerSelectedTypePhoto) {
        if ([self beforeSelectPhotoCountIsMaximum]) {
            // 已经达到图片最大选择数
            return [NSString stringWithFormat:[NSBundle hx_localizedStringForKey:@"最多只能选择%ld张图片"],self.configuration.photoMaxNum];
        }
    }
    
    return nil;
}
#pragma mark - < 关于选择完成之前的一些方法 > 
- (NSInteger)selectedCount {
    return self.selectedList.count;
}
- (NSInteger)selectedPhotoCount {
    return self.selectedPhotos.count;
}

- (void)deleteItemAtFirst {
    [self.selectedList removeObjectAtIndex:0];
}

- (NSArray *)selectedArray {
    return self.selectedList;
}
- (NSArray *)selectedPhotoArray {
    return self.selectedPhotos;
}

- (BOOL)original {
    return self.isOriginal;
}
- (void)setOriginal:(BOOL)original {
    self.isOriginal = original;
}
- (BOOL)beforeSelectCountIsMaximum {
    if (self.selectedList.count >= self.configuration.maxNum) {
        return YES;
    }
    return NO;
}
- (BOOL)beforeSelectPhotoCountIsMaximum {
    if (self.selectedPhotos.count >= self.configuration.photoMaxNum) {
        return YES;
    }
    return NO;
}

- (void)beforeSelectedListdeletePhotoModel:(HXPhotoModel *)model {
    model.selected = NO;
    model.selectIndexStr = @"";
    model.previewPhoto = nil;
    [self.selectedList removeObject:model];
}
- (void)beforeSelectedListAddPhotoModel:(HXPhotoModel *)model {

    [self.selectedList addObject:model];
    model.selected = YES;
    model.selectIndexStr = [NSString stringWithFormat:@"%ld",[self.selectedList indexOfObject:model] + 1];
    
//    __weak typeof(self) weakSelf = self;
//    __block HXPhotoModel *bModel = model;
    [HXPhotoTools getPhotoForPHAsset:model.asset size:CGSizeMake(model.previewViewSize.width*1.5, model.previewViewSize.height*1.5) completion:^(UIImage *image, NSDictionary *info) {
        model.previewPhoto = image;

    }];
//    model.selected = YES;
//    model.selectIndexStr = [NSString stringWithFormat:@"%ld",[weakSelf.selectedList indexOfObject:bModel] + 1];
    
    
}
- (void)beforeSelectedListAddEditPhotoModel:(HXPhotoModel *)model {
    [self beforeSelectedListAddPhotoModel:model];
    [self.cameraPhotos addObject:model];
    [self.cameraList addObject:model];
}
- (void)beforeListAddCameraTakePicturesModel:(HXPhotoModel *)model {
    model.dateCellIsVisible = YES;
    if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
        [self.cameraPhotos addObject:model];
        if (![self beforeSelectPhotoCountIsMaximum]) {
            
                if (self.selectedList.count > 0) {
                    HXPhotoModel *phMd = self.selectedList.firstObject;
                    if (phMd.subType == HXPhotoModelMediaSubTypePhoto) {
                        [self.selectedCameraPhotos insertObject:model atIndex:0];
                        [self.selectedPhotos addObject:model];
                        [self.selectedList addObject:model];
                        [self.selectedCameraList addObject:model];
                        model.selected = YES;
                        model.selectIndexStr = [NSString stringWithFormat:@"%ld",[self.selectedList indexOfObject:model] + 1];
                    }
                }else {
                    [self.selectedCameraPhotos insertObject:model atIndex:0];
                    [self.selectedPhotos addObject:model];
                    [self.selectedList addObject:model];
                    [self.selectedCameraList addObject:model];
                    model.selected = YES;
                    model.selectIndexStr = [NSString stringWithFormat:@"%ld",[self.selectedList indexOfObject:model] + 1];
                }
            
        }
    }
    //    NSInteger cameraIndex = self.configuration.openCamera ? 1 : 0;
    if (self.configuration.reverseDate) {
        [self.cameraList insertObject:model atIndex:0];
    }else {
        [self.cameraList addObject:model];
    }
}
#pragma mark - < 关于选择完成之后的一些方法 >
- (BOOL)afterSelectCountIsMaximum {
    if (self.endSelectedList.count >= self.configuration.maxNum) {
        return YES;
    }
    return NO;
}

- (BOOL)afterSelectPhotoCountIsMaximum {
    if (self.endSelectedPhotos.count >= self.configuration.photoMaxNum) {
        return YES;
    }
    return NO;
}

- (NSInteger)afterSelectedCount {
    return self.endSelectedList.count;
}
- (NSArray *)afterSelectedArray {
    return self.endSelectedList;
}
- (NSArray *)afterSelectedPhotoArray {
    return self.endSelectedPhotos;
}

- (void)setAfterSelectedPhotoArray:(NSArray *)array {
    self.endSelectedPhotos = [NSMutableArray arrayWithArray:array];
}

- (BOOL)afterOriginal {
    return self.endIsOriginal;
}
- (void)afterSelectedArraySwapPlacesWithFromModel:(HXPhotoModel *)fromModel fromIndex:(NSInteger)fromIndex toModel:(HXPhotoModel *)toModel toIndex:(NSInteger)toIndex {
    [self.endSelectedList removeObject:toModel];
    [self.endSelectedList insertObject:toModel atIndex:toIndex];
    [self.endSelectedList removeObject:fromModel];
    [self.endSelectedList insertObject:fromModel atIndex:fromIndex];
}
- (void)afterSelectedArrayReplaceModelAtModel:(HXPhotoModel *)atModel withModel:(HXPhotoModel *)model {
    atModel.selected = NO;
    model.selected = YES;
    [self.endSelectedList replaceObjectAtIndex:[self.endSelectedList indexOfObject:atModel] withObject:model];
    if (atModel.type == HXPhotoModelMediaTypeCameraPhoto) {
        [self.endSelectedCameraPhotos removeObject:atModel];
        [self.endSelectedCameraList removeObject:atModel];
        [self.endCameraList removeObject:atModel];
        [self.endCameraPhotos removeObject:atModel];
    }
}
- (void)afterSelectedListAddEditPhotoModel:(HXPhotoModel *)model {
    [self.endCameraPhotos addObject:model];
    [self.endCameraList addObject:model];
    [self.endSelectedCameraList addObject:model];
    [self.endSelectedCameraPhotos addObject:model];
}
- (void)afterListAddCameraTakePicturesModel:(HXPhotoModel *)model {
    if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
        [self.endCameraPhotos addObject:model];
        // 当选择图片个数没有达到最大个数时就添加到选中数组中
        if (![self afterSelectPhotoCountIsMaximum]) {
                if (self.endSelectedList.count > 0) {
                    HXPhotoModel *phMd = self.endSelectedList.firstObject;
                    if ((phMd.type == HXPhotoModelMediaTypePhoto || phMd.type == HXPhotoModelMediaTypeLivePhoto) || (phMd.type == HXPhotoModelMediaTypePhotoGif || phMd.type == HXPhotoModelMediaTypeCameraPhoto)) {
                        [self.endSelectedCameraPhotos insertObject:model atIndex:0];
                        [self.endSelectedPhotos addObject:model];
                        [self.endSelectedList addObject:model];
                        [self.endSelectedCameraList addObject:model];
                        model.selected = YES;
                        model.selectIndexStr = [NSString stringWithFormat:@"%ld",[self.endSelectedList indexOfObject:model] + 1];
                    }
                }else {
                    [self.endSelectedCameraPhotos insertObject:model atIndex:0];
                    [self.endSelectedPhotos addObject:model];
                    [self.endSelectedList addObject:model];
                    [self.endSelectedCameraList addObject:model];
                    model.selected = YES;
                    model.selectIndexStr = [NSString stringWithFormat:@"%ld",[self.endSelectedList indexOfObject:model] + 1];
                }
            }
        
    }
    [self.endCameraList addObject:model];
}
- (void)afterSelectedListdeletePhotoModel:(HXPhotoModel *)model {
    if (model.subType == HXPhotoModelMediaSubTypePhoto) {
        if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
            [self.endCameraPhotos removeObject:model];
            [self.endCameraList removeObject:model];
            [self.endSelectedCameraPhotos removeObject:model];
            [self.endSelectedCameraList removeObject:model];
        }
        [self.endSelectedPhotos removeObject:model];
    }
    [self.endSelectedList removeObject:model];
    
    int i = 0;
    for (HXPhotoModel *model in self.selectedList) {
        model.selectIndexStr = [NSString stringWithFormat:@"%d",i + 1];
        i++;
    }
}
- (void)afterSelectedListAddPhotoModel:(HXPhotoModel *)model {
    
}
#pragma mark - < others >
- (void)selectedListTransformBefore {
    if (self.type == HXPhotoManagerSelectedTypePhoto) {
        self.configuration.maxNum = self.configuration.photoMaxNum;

    }else {
        if (self.configuration.videoMaxNum + self.configuration.photoMaxNum != self.configuration.maxNum) {
            self.configuration.maxNum = self.configuration.videoMaxNum + self.configuration.photoMaxNum;
        }
    }
    // 上次选择的所有记录
    self.selectedList = [NSMutableArray arrayWithArray:self.endSelectedList];
    self.selectedPhotos = [NSMutableArray arrayWithArray:self.endSelectedPhotos];

    self.cameraList = [NSMutableArray arrayWithArray:self.endCameraList];
    self.cameraPhotos = [NSMutableArray arrayWithArray:self.endCameraPhotos];

    self.selectedCameraList = [NSMutableArray arrayWithArray:self.endSelectedCameraList];
    self.selectedCameraPhotos = [NSMutableArray arrayWithArray:self.endSelectedCameraPhotos];

    self.isOriginal = self.endIsOriginal;
    self.photosTotalBtyes = self.endPhotosTotalBtyes;
}
- (void)selectedListTransformAfter {
    // 如果通过相机拍的数组为空 则清空所有关于相机的数组
    if (self.configuration.deleteTemporaryPhoto) {
        if (self.selectedCameraList.count == 0) {
            [self.cameraList removeAllObjects];
            [self.cameraPhotos removeAllObjects];
        }
    }
    if (!self.configuration.singleSelected) {
        // 记录这次操作的数据
        self.endSelectedList = [NSMutableArray arrayWithArray:self.selectedList];
        self.endSelectedPhotos = [NSMutableArray arrayWithArray:self.selectedPhotos];
        self.endCameraList = [NSMutableArray arrayWithArray:self.cameraList];
        self.endCameraPhotos = [NSMutableArray arrayWithArray:self.cameraPhotos];
        self.endSelectedCameraList = [NSMutableArray arrayWithArray:self.selectedCameraList];
        self.endSelectedCameraPhotos = [NSMutableArray arrayWithArray:self.selectedCameraPhotos];
        self.endIsOriginal = self.isOriginal;
        self.endPhotosTotalBtyes = self.photosTotalBtyes;
    }
}
- (void)cancelBeforeSelectedList {
    [self.selectedList removeAllObjects];
    [self.selectedPhotos removeAllObjects];
    self.isOriginal = NO;
    self.photosTotalBtyes = nil;
    [self.selectedCameraList removeAllObjects];
    [self.selectedCameraPhotos removeAllObjects];
    [self.cameraPhotos removeAllObjects];
    [self.cameraList removeAllObjects];
}
- (void)clearSelectedList {
    [self.endSelectedList removeAllObjects];
    [self.endCameraPhotos removeAllObjects];
    [self.endSelectedCameraPhotos removeAllObjects];
    [self.endCameraList removeAllObjects];
    [self.endSelectedCameraList removeAllObjects];
    [self.endSelectedPhotos removeAllObjects];
    [self.endCameraList removeAllObjects];
    [self.endSelectedCameraList removeAllObjects];
    [self.endSelectedPhotos removeAllObjects];
    self.endIsOriginal = NO;
    self.endPhotosTotalBtyes = nil;
    
    [self.selectedList removeAllObjects];
    [self.cameraPhotos removeAllObjects];
    [self.selectedCameraPhotos removeAllObjects];
    [self.cameraList removeAllObjects];
    [self.selectedCameraList removeAllObjects];
    [self.selectedPhotos removeAllObjects];
    [self.cameraList removeAllObjects];
    [self.selectedCameraList removeAllObjects];
    [self.selectedPhotos removeAllObjects];
    self.isOriginal = NO;
    self.photosTotalBtyes = nil;
    
    [self.albums removeAllObjects];
    [self.iCloudUploadArray removeAllObjects];
}

#pragma mark - < PHPhotoLibraryChangeObserver >
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.albums];
    for (HXAlbumModel *albumModel in array) {
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:albumModel.result];
        if ([collectionChanges hasIncrementalChanges]) {
            if (self.configuration.saveSystemAblum) {
//                if (!self.cameraList.count) {
//                    self.albums = nil;
//                }
            }
            return;
        }
    }
}
- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    NSSLog(@"dealloc");
}

- (void)setScrollImage:(UIImage *)resultImage {
    _resultImage = resultImage;
}

- (UIImage *)getScrollImage {
    return self.resultImage;
}

- (void)setScreenWidthSize:(CGFloat)size {
    _screenShotWidth = size;
}

- (CGFloat)getScreenWithSize {
    return self.screenShotWidth;
}


- (void)changeAfterCameraArray:(NSArray *)array {
    self.endCameraList = array.mutableCopy;
}
- (void)changeAfterCameraPhotoArray:(NSArray *)array {
    self.endCameraPhotos = array.mutableCopy;
}

- (void)changeAfterSelectedCameraArray:(NSArray *)array {
    self.endSelectedCameraList = array.mutableCopy;
}
- (void)changeAfterSelectedCameraPhotoArray:(NSArray *)array {
    self.endSelectedCameraPhotos = array.mutableCopy;
}

- (void)changeAfterSelectedArray:(NSArray *)array {
    self.endSelectedList = array.mutableCopy;
}
- (void)changeAfterSelectedPhotoArray:(NSArray *)array {
    self.endSelectedPhotos = array.mutableCopy;
}

- (void)changeICloudUploadArray:(NSArray *)array {
    self.iCloudUploadArray = array.mutableCopy;
}
- (NSArray *)afterCameraArray {
    return self.endCameraList;
}
- (NSArray *)afterCameraPhotoArray {
    return self.endCameraPhotos;
}
- (NSArray *)afterSelectedCameraArray {
    return self.endSelectedCameraList;
}
- (NSArray *)afterSelectedCameraPhotoArray {
    return self.endSelectedCameraPhotos;
}
- (NSArray *)afterICloudUploadArray {
    return self.iCloudUploadArray;
}

@end
