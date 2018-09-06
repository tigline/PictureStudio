//
//  AssetTableViewCell.h
//  PictureStudio
//
//  Created by mickey on 2018/8/27.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HXAlbumModel.h"
#import "UIView+HXExtension.h"
@interface AssetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *assetTitle;
@property (weak, nonatomic) IBOutlet UILabel *imageCount;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@property (nonatomic, strong) NSDictionary *assetsGroup;
@property (strong, nonatomic) HXAlbumModel *model;
@property (nonatomic, assign) BOOL   isSelected;
- (void)setSelectedImage;
- (void)setSelectedImagenil;
@property (assign, nonatomic) PHImageRequestID requestID;

@end
