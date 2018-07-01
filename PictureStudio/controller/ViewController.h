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

@protocol DatePhotoViewControllerDelegate <NSObject>
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
{
    NSMutableArray *lastArray; //记录当前一次操作的所有cell
    NSMutableArray *currentArray;//通过currentcell于firstcell计算出的应该显示的cell
    NSMutableArray *addArray;//计算出的差集
    NSMutableArray *minusArray;//计算出的差集
    
    NSInteger firstCell ; //用户选择第一个cell
    NSInteger currentCell ;//用户当前停留在的cell
    BOOL isFirstSelect;//记录用户首次选择的标记
    BOOL isGotoScrolldown;
    BOOL isGotoScroll; //是否开始滚动
    BOOL isFirstCellSelect;//用户选择的第一个cell 反向记录之前的状态，用于识别整个滑动过程是选择还是删除
}
@property (weak, nonatomic) id<DatePhotoViewControllerDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) PhotoEditButtomView *bottomView;
@property (strong, nonatomic) HXAlbumModel *albumModel;

@end


