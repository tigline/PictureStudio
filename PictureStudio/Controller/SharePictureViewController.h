//
//  SharePictureViewController.h
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/5/3.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"

@interface SharePictureViewController : UIViewController
@property (nonatomic,strong) NSArray *resultModels;
@property (nonatomic,strong) UIImage *resultImage;
@property (nonatomic,strong) HXPhotoManager * manager;
@end
