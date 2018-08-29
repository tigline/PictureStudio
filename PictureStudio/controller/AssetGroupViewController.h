//
//  MyCollectionViewController.h
//  PictureStudio
//
//  Created by mickey on 2018/8/28.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"

@interface AssetGroupViewController : UICollectionViewController
@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, assign) NSInteger indexAssetsGroup;
@property (nonatomic, strong) NSArray *assetsGroups;
@property (nonatomic, strong) NSMutableDictionary *selectedAssetCount;

@property (nonatomic, copy) void (^groupSelectedBlock)(HXAlbumModel *selectedAlbumModel);
@end
