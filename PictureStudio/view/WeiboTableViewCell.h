//
//  ArtAssetGroupCell.h
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface WeiboTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *weiboIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *weiboName;
@property (strong, nonatomic) NSString *weiboLink;

@end
