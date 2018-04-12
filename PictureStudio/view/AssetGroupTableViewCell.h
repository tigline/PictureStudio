//
//  AssetGroupTableViewCell.h
//  PictureStudio
//
//  Created by mickey on 2018/4/8.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"



static const NSString *kPHImage = @"PHImage";
static const NSString *kPHTitle = @"PHTitle";
static const NSString *kPHCount = @"PHCount";

@interface AssetGroupTableViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *assetsGroup;
@property (strong, nonatomic) HXAlbumModel *model;

@property (nonatomic, assign) BOOL   isSelected;
@end
