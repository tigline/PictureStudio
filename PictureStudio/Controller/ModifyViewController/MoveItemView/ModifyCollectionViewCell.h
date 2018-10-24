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
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *moveUpItem;
@property (weak, nonatomic) IBOutlet UIImageView *moveDownItem;
- (void)configCell:(PhotoCutModel *)model;
@end

NS_ASSUME_NONNULL_END
