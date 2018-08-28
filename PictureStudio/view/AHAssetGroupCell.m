//
//  ArtAssetGroupCell.m
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "AHAssetGroupCell.h"
#import "UIView+HXExtension.h"

#import "HXPhotoTools.h"

@interface AHAssetGroupCell()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@property (weak, nonatomic) IBOutlet  UILabel     *assetsNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel     *assetsCountLabel;
@property (weak, nonatomic) IBOutlet  UIImageView   *checkImageView;
@property (assign, nonatomic) PHImageRequestID requestID;

@end


@implementation AHAssetGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        [self buildUI];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.thumbnailView.layer.cornerRadius = 3;
    self.thumbnailView.layer.masksToBounds = YES;
    _assetsCountLabel.textColor = [UIColor lightGrayColor];
//    if (_isSelected) {
//        [self.checkImageView setImage:[UIImage imageNamed:@"selected_selected"]];
//    }
    
}

- (void)buildUI
{
    self.backgroundColor = [UIColor clearColor];

    self.thumbnailView.layer.cornerRadius = 3;
    self.thumbnailView.layer.masksToBounds = YES;

//    CGFloat nameY = self.size.height/2;
//    CGFloat nameX = CGRectGetMaxX(self.thumbnailView.frame) + 20;
//    self.assetsNameLabel.frame = CGRectMake(nameX, nameY, 200, 20);
//
//    CGFloat countY = CGRectGetMaxY(self.assetsNameLabel.frame) + 10;
//    self.assetsCountLabel.frame = CGRectMake(nameX, countY, 100, 20);
}

- (void)setSelectedImage:(NSInteger)index {
    [self.checkImageView setImage:[UIImage imageNamed:@"album_selected"]];
    if (index == 0) {
        
    } else {
        
    }
    
    
    
}

- (void)setSelectedImagenil:(NSInteger)index {
    [self.checkImageView setImage:[UIImage imageNamed:@" "]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}

#pragma makr - setter


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
    
    self.assetsNameLabel.text = model.albumName;
    self.assetsCountLabel.text = @(model.result.count).stringValue;
}


#pragma makr - getter
- (UIImageView *)thumbnailView{
    if (!_thumbnailView) {
        //_thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 60, 60)];
        _thumbnailView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5f];
        _thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailView.clipsToBounds = YES;
        [self.contentView addSubview:_thumbnailView];
    }
    return _thumbnailView;
}

//- (UIImageView *)checkImageView{
//    if (!_checkImageView) {
//        //_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picker_photo_filter_checked"]];
//        [_checkImageView setImage:[UIImage imageNamed:@"selected_selected"]];
//        //_checkImageView.backgroundColor = [UIColor clearColor];
////        _checkImageView.rightTop = CGPointMake(self.thumbnailView.frame.size.width - 3, _checkImageView.rightTop.y);
////        _checkImageView.leftBottom = CGPointMake(_checkImageView.leftBottom.x, self.thumbnailView.size.height - 3);
////        [self.thumbnailView addSubview:_checkImageView];
//    }
//    return _checkImageView;
//}

- (UILabel *)assetsNameLabel{
    if (!_assetsNameLabel) {
        //_assetsNameLabel = [[UILabel alloc] init];
        _assetsNameLabel.backgroundColor = [UIColor clearColor];
        _assetsNameLabel.textColor = [UIColor blackColor];
        _assetsNameLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:_assetsNameLabel];
    }
    return _assetsNameLabel;
}

- (UILabel *)assetsCountLabel{
    if (!_assetsCountLabel) {
        //_assetsCountLabel = [[UILabel alloc] init];
        _assetsCountLabel.backgroundColor = [UIColor clearColor];
        _assetsCountLabel.textColor = [UIColor blackColor];
        _assetsCountLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_assetsCountLabel];
    }
    return _assetsCountLabel;
}
@end
