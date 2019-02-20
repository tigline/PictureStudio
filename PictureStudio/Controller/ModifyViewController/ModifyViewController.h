//
//  ModifyViewController.h
//  PictureStudio
//
//  Created by mickey on 2018/9/9.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class HXPhotoManager;
@class SwipeEdgeInteractionController;

@interface ModifyViewController : BaseViewController
@property (nonatomic,strong) NSMutableArray *resultModels;
@property (nonatomic,strong) UIImage *resultImage;
@property (nonatomic,strong) HXPhotoManager * manager;
@property (strong, nonatomic) SwipeEdgeInteractionController *interactionController;
@property (assign, nonatomic) BOOL isCombineView;
@end
