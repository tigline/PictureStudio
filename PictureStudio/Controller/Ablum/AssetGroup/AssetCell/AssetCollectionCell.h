//
//  CollectionViewCell.h
//  PictureStudio
//
//  Created by mickey on 2018/8/28.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"

@interface AssetCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) NSDictionary *assetsGroup;
@property (strong, nonatomic) HXAlbumModel *model;
@end
