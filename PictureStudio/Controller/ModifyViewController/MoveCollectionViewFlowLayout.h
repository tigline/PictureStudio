//
//  MoveCollectionViewFlowLayout.h
//  PictureStudio
//
//  Created by mickey on 2018/11/7.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MoveInfoModel;
@protocol MoveCellDelegate <NSObject>

- (void)beginMoveCellAt:(MoveInfoModel *)model moveDistance:(CGFloat)distance;
- (void)endMoveCellAt:(MoveInfoModel *)model moveDistance:(CGFloat)distance;
- (void)updateMoveOffset:(MoveInfoModel *)model moveOffset:(CGFloat)offset;
- (void)updateCellState:(MoveInfoModel *)model;
@end

@interface MoveCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (assign, nonatomic) BOOL canPress;
@property (weak, nonatomic) id<MoveCellDelegate> modifyDelegate;
- (void)setup;
@end

NS_ASSUME_NONNULL_END
