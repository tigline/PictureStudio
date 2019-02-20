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
@property (assign, nonatomic) CGFloat scaleRatio;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) BOOL editBorder;
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) BOOL isEND;
@end
