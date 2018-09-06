//
//  ArtAssetGroupsView.h
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HXAlbumModel.h"

@class AHAssetGroupsView;

@interface AHAssetGroupsView : UIView

@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, assign) NSInteger indexAssetsGroup;
@property (nonatomic, strong) NSArray *assetsGroups;
@property (nonatomic, strong) NSMutableDictionary *selectedAssetCount;

//@property (nonatomic, copy) void (^groupSelectedBlock)(HXAlbumModel *selectedAlbumModel);

@end


