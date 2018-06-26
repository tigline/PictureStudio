//
//  PhotoCutModel.h
//  PictureStudio
//
//  Created by mickey on 2018/6/26.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhotoCutModel : NSObject

@property (strong, nonatomic) UIImage *originPhoto;
@property (strong, nonatomic) UIImage *cutPhoto;
@property (assign, nonatomic) CGFloat beginY;
@property (assign, nonatomic) CGFloat endY;

@end
