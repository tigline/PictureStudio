//
//  ReplyTableCell.m
//  PictureStudio
//
//  Created by mickey on 2019/1/21.
//  Copyright © 2019 Aaron Hou. All rights reserved.
//

#import "ReplyTableCell.h"

@implementation ReplyTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCell:(NSDictionary *)cellData {
    if ( [[cellData objectForKey:@"type"]  isEqual: @"top"]) {
        _bgView.image = [UIImage imageNamed:@"setting__mid_list"];
    } else if ([[cellData objectForKey:@"type"]  isEqual: @"mid"]) {
        //_bgView.image = [UIImage imageNamed:@"setting_list_mid_p"];
        _bgView.image = [UIImage imageNamed:@"setting__mid_list"];
    } else {
        _bgView.image = [UIImage imageNamed:@"setting__mid_list"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        
    } else {
        
    }
    // Configure the view for the selected state
}

@end
