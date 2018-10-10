//
//  MoveItemView.h
//  PictureStudio
//
//  Created by mickey on 2018/9/18.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PhotoCutModel;

typedef enum : NSUInteger {
    moveUp,
    moveDown,
} moveState;

@interface MoveItemView : UIScrollView
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UIImageView *upDragView;
@property (nonatomic, strong) UIImageView *downDragView;
@property (nonatomic, strong) PhotoCutModel *cutModel;
- (void)setNewModel:(PhotoCutModel *)model;

- (void)setDragButtomHidden:(BOOL)hidden;

- (void)setMoveState:(moveState)state;
@end

NS_ASSUME_NONNULL_END
