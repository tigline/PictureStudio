//
//  MoveItemCell.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/10/30.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoveInfoModel;
NS_ASSUME_NONNULL_BEGIN

@protocol MoveCellDelegate <NSObject>

- (void)beginMoveCellAt:(MoveInfoModel *)model moveDistance:(CGFloat)distance;
- (void)endMoveCellAt:(MoveInfoModel *)model moveDistance:(CGFloat)distance;

@end

@interface MoveItemCell : UICollectionViewCell
@property (weak, nonatomic) id<MoveCellDelegate> moveDelegate;
@property (strong, nonatomic) MoveInfoModel *moveModel;
- (void)configCell:(MoveInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
