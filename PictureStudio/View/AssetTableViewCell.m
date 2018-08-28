//
//  AssetTableViewCell.m
//  PictureStudio
//
//  Created by mickey on 2018/8/27.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AssetTableViewCell.h"
#import "HXPhotoTools.h"

@implementation AssetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.thumbnailView.layer.cornerRadius = 3;
    self.thumbnailView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXAlbumModel *)model {
    _model = model;
    if (!model.asset) {
        model.asset = model.result.lastObject;
    }
    __weak typeof(self) weakSelf = self;
    self.requestID = [HXPhotoTools getImageWithAlbumModel:model size:CGSizeMake(self.hx_w * 1.5, self.hx_w * 1.5) completion:^(UIImage *image, HXAlbumModel *model) {
        if (weakSelf.model == model) {
            weakSelf.thumbnailView.image = image;
        }
    }];
    
    self.assetTitle.text = model.albumName;
    self.imageCount.text = @(model.result.count).stringValue;
}

@end
