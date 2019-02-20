//
//  ReplyTableCell.h
//  PictureStudio
//
//  Created by mickey on 2019/1/21.
//  Copyright © 2019 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplyTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *arowImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
- (void)configCell:(NSDictionary *)cellData;
@end

NS_ASSUME_NONNULL_END
