//
//  ArtAssetGroupCell.h
//  DesignBox
//
//  Created by leoliu on 15/8/28.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HXAlbumModel.h"
static const NSString *kPHImage = @"PHImage";
static const NSString *kPHTitle = @"PHTitle";
static const NSString *kPHCount = @"PHCount";


@interface ALiAssetGroupCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *assetsGroup;
@property (strong, nonatomic) HXAlbumModel *model;
@property (nonatomic, assign) BOOL   isSelected;
- (void)setSelectedImage;
- (void)setSelectedImagenil;
@end
