//
//  RecentScrollView.h
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/8/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentScrollView : UIView
{
    UIImageView *thumbPhotoImageView;
    UIImageView *imageView;
    UILabel *mUILabel;
}
@property (strong, nonatomic) UIImage *image;
@end
