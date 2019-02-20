//
//  InfoTableCell.h
//  PictureStudio
//
//  Created by mickey on 2019/1/21.
//  Copyright © 2019 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

NS_ASSUME_NONNULL_END
