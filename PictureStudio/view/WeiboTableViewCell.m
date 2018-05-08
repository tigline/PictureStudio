//
//  ArtAssetGroupCell.m
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "WeiboTableViewCell.h"
#import "UIView+HXExtension.h"

#import "HXPhotoTools.h"

@interface WeiboTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@property (weak, nonatomic) IBOutlet  UILabel     *assetsNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel     *assetsCountLabel;
@property (weak, nonatomic) IBOutlet  UIImageView   *checkImageView;
@property (assign, nonatomic) PHImageRequestID requestID;

@end


@implementation WeiboTableViewCell

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
    
    
    
    self.weiboIcon.layer.cornerRadius = _weiboIcon.hx_w/2;
    self.weiboIcon.layer.masksToBounds = YES;

//    if (_isSelected) {
//        [self.checkImageView setImage:[UIImage imageNamed:@"selected_selected"]];
//    }
    
}

- (void)buildUI
{
 

   
}



@end
