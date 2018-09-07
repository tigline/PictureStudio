//
//  CollectionViewCell.m
//  PictureStudio
//
//  Created by mickey on 2018/8/28.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AssetCollectionCell.h"
#import "UIView+HXExtension.h"
#import "HXPhotoTools.h"

@interface AssetCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (assign, nonatomic) PHImageRequestID requestID;
@end

@implementation AssetCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self buildUI];
}

- (void)buildUI
{
    self.backgroundColor = [UIColor clearColor];
    
//    self.layer.shadowColor = UIColor.navShadowColor.CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 4);
//    self.layer.shadowOpacity = 0.99;
//    self.layer.shadowRadius = 12;
    
    self.albumView.layer.cornerRadius = 3;
    self.albumView.layer.masksToBounds = YES;
    
}


- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.titleLabel.textColor = UIColor.cellTitleSelectedColor;
        self.countLabel.textColor = UIColor.cellCountColor;
        self.timeLabel.textColor = UIColor.cellCountColor;
    } else {
        self.titleLabel.textColor = UIColor.cellTitleNormalColor;
        self.countLabel.textColor = UIColor.cellTimeColor;
        self.timeLabel.textColor = UIColor.cellTimeColor;
    }
}

//- (void)setSelected:(BOOL)selected {
//    if (selected) {
//        self.titleLabel.textColor = UIColor.cellTitleSelectedColor;
//        self.countLabel.textColor = UIColor.cellCountColor;
//        self.timeLabel.textColor = UIColor.cellCountColor;
//    } else {
//        self.titleLabel.textColor = UIColor.cellTitleNormalColor;
//        self.countLabel.textColor = UIColor.cellTimeColor;
//        self.timeLabel.textColor = UIColor.cellTimeColor;
//    }
//}



- (void)setModel:(HXAlbumModel *)model {
    _model = model;
    if (!model.asset) {
        model.asset = model.result.lastObject;
    }
    __weak typeof(self) weakSelf = self;
    self.requestID = [HXPhotoTools getImageWithAlbumModel:model size:CGSizeMake(self.hx_w * 1.5, self.hx_w * 1.5) completion:^(UIImage *image, HXAlbumModel *model) {
        if (weakSelf.model == model) {
            weakSelf.albumView.image = image;
        }
    }];
    
    self.titleLabel.text = model.albumName;
    self.countLabel.text = @(model.result.count).stringValue;
}

@end
