//
//  PhotoEditButtomView.h
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"

//@class PhotoEditButtomView;

@protocol PhotoEditBottomViewDelegate <NSObject>
@optional
- (void)datePhotoBottomViewDidCombineBtn;
- (void)datePhotoBottomViewDidScrollBtn;
- (void)datePhotoBottomViewDidEditBtn;
- (void)datePhotoBottomViewDidClearBtn;
@end

@interface PhotoEditButtomView : UIView

@property (weak, nonatomic) id<PhotoEditBottomViewDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (assign, nonatomic) BOOL previewBtnEnabled;
@property (assign, nonatomic) BOOL doneBtnEnabled;
@property (assign, nonatomic) NSInteger selectCount;
@property (strong, nonatomic) UIToolbar *bgView;
@end

