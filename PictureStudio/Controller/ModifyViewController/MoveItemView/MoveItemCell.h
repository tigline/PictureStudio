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



typedef void (^MoveOffset)(CGFloat offset);

@interface MoveItemCell : UICollectionViewCell

@property (strong, nonatomic) MoveInfoModel *moveModel;
@property (copy, nonatomic) MoveOffset moveOffsetBlock;
@property (weak, nonatomic) IBOutlet UIScrollView *moveItemScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *showToUpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *showToDownImageView;
- (void)configCell:(MoveInfoModel *)model;
- (void)setDragItemHidden:(BOOL)hidden;
- (void)setContentOffset:(CGFloat)offset;
- (CGFloat)getContentOffset;
@end

NS_ASSUME_NONNULL_END
