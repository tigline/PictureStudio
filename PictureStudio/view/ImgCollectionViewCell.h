//
//  ImgTableViewCell.h
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoModel.h"

@class ImgCollectionViewCell;

@protocol ImgCollectionViewCellDelegate <NSObject>
@optional
- (void)imgCollectionViewCell:(ImgCollectionViewCell *)cell didSelectBtn:(UIButton *)selectBtn;
- (void)imgCollectionViewCellRequestICloudAssetComplete:(ImgCollectionViewCell *)cell;
@end


@interface ImgCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<ImgCollectionViewCellDelegate> collectionViewCelldelegate;
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger item;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic) CALayer *selectMaskLayer;
@property (strong, nonatomic) HXPhotoModel *model;
@property (assign, nonatomic) BOOL singleSelected;
@property (strong, nonatomic) UIColor *selectBgColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;
@property (strong, nonatomic) UIButton *selectBtn;

- (void)bottomViewPrepareAnimation;
- (void)bottomViewStartAnimation;
@end


