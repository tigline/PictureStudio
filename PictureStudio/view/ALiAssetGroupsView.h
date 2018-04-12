//
//  ArtAssetGroupsView.h
//  DesignBox
//
//  Created by leoliu on 15/8/28.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HXAlbumModel.h"

@class ALiAssetGroupsView;

@interface ALiAssetGroupsView : UIView

@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, assign) NSInteger indexAssetsGroup;
@property (nonatomic, strong) NSArray *assetsGroups;
@property (nonatomic, strong) NSMutableDictionary *selectedAssetCount;

@property (nonatomic, copy) void (^groupSelectedBlock)(HXAlbumModel *selectedAlbumModel);

@end


