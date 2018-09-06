//
//  LongPictureViewController.h
//  PictureStudio
//
//  Created by mickey on 2018/3/6.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"
@class SwipeEdgeInteractionController;
@interface LongPictureViewController : UIViewController
@property (nonatomic,strong) UIImage *resultImage;
@property (nonatomic,strong) HXPhotoManager * manager;
@property (strong, nonatomic) SwipeEdgeInteractionController *interactionController;
@end
