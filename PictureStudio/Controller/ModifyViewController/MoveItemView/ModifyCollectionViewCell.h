//
//  ModifyCollectionViewCell.h
//  PictureStudio
//
//  Created by mickey on 2018/10/24.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoCutModel;
NS_ASSUME_NONNULL_BEGIN



@interface ModifyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) BOOL eidtMove;
@property (strong, nonatomic) UIImageView *moveUpItem;
@property (strong, nonatomic) UIImageView *moveDownItem;
@property (strong, nonatomic) PhotoCutModel *model;

- (void)configCell:(PhotoCutModel *)model isEditMove:(BOOL)editMove isEditBorder:(BOOL)editBorder width:(CGFloat)width color:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
