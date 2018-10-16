//
//  AboutViewTableViewCell.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/5/8.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *weiboIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *weiboName;
@property (strong, nonatomic) NSString *weiboLink;

@end
