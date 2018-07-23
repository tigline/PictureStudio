//
//  ImageIOModel.h
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/7/12.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageIOModel : NSObject
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) NSInteger imageIOType;
@end
