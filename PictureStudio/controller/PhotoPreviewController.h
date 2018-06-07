//
//  PhotoPreviewController.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/5/11.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoPreviewController,HXPhotoModel;

@protocol PhotoPreviewControllerDelegate <NSObject>
@optional
- (void)datePhotoPreviewControllerDidSelect:(PhotoPreviewController *)previewController model:(HXPhotoModel *)model;
- (void)datePhotoPreviewControllerDidDone:(PhotoPreviewController *)previewController;
- (void)datePhotoPreviewDidEditClick:(PhotoPreviewController *)previewController;
- (void)datePhotoPreviewSingleSelectedClick:(PhotoPreviewController *)previewController model:(HXPhotoModel *)model;

- (void)datePhotoPreviewSelectLaterDidEditClick:(PhotoPreviewController *)previewController beforeModel:(HXPhotoModel *)beforeModel afterModel:(HXPhotoModel *)afterModel;
@end

@class HXPhotoManager;
@interface PhotoPreviewController : UIViewController
@property (weak, nonatomic) id<PhotoPreviewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *models;                  ///< All photo models / 所有图片模型数组
@property (nonatomic, strong) NSMutableArray *photos;                  ///< All photos  / 所有图片数组
@property (nonatomic, assign) NSInteger currentIndex;           ///< Index of the photo user click / 用户点击的图片的索引
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;       ///< If YES,return original photo / 是否返回原图
@property (nonatomic, assign) BOOL isCropImage;
@property (nonatomic, strong) HXPhotoManager *manager;

/// Return the new selected photos / 返回最新的选中图片数组
@property (nonatomic, copy) void (^backButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlockCropMode)(UIImage *cropedImage,id asset);
@property (nonatomic, copy) void (^doneButtonClickBlockWithPreviewType)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);
@end
