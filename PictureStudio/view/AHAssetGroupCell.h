//
//  ArtAssetGroupCell.h
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HXAlbumModel.h"
static const NSString *kPHImage = @"PHImage";
static const NSString *kPHTitle = @"PHTitle";
static const NSString *kPHCount = @"PHCount";


@interface AHAssetGroupCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *assetsGroup;
@property (strong, nonatomic) HXAlbumModel *model;
@property (nonatomic, assign) BOOL   isSelected;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
- (void)setSelectedImage:(NSInteger)index;
- (void)setSelectedImagenil:(NSInteger)index;
@end
