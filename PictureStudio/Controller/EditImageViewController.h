//
//  EditImageViewController.h
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/8/23.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXPhotoModel;
@interface EditImageViewController : UIViewController
@property (nonatomic, strong) HXPhotoModel *model;
@property (nonatomic, strong) id asset;
@property (nonatomic, assign) int32_t imageRequestID;
@end
