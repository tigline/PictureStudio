//
//  ViewController.h
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"
#import "HXPhotoManager.h"
#import "PhotoEditButtomView.h"

@class ViewController;

@protocol HXDatePhotoViewControllerDelegate <NSObject>
@optional

/**
 点击取消
 
 @param datePhotoViewController self
 */
- (void)datePhotoViewControllerDidCancel:(ViewController *)datePhotoViewController;

/**
 点击完成按钮
 
 @param datePhotoViewController self
 @param allList 已选的所有列表(包含照片、视频)
 @param photoList 已选的照片列表
 @param videoList 已选的视频列表
 @param original 是否原图
 */
- (void)datePhotoViewController:(ViewController *)datePhotoViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original;

/**
 改变了选择
 
 @param model 改的模型
 @param selected 是否选中
 */
- (void)datePhotoViewControllerDidChangeSelect:(HXPhotoModel *)model selected:(BOOL)selected;
@end

@interface ViewController : UIViewController
@property (weak, nonatomic) id<HXDatePhotoViewControllerDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) PhotoEditButtomView *bottomView;
@property (strong, nonatomic) HXAlbumModel *albumModel;

@end


