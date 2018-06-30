//
//  StitchePicture.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/7/1.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StitchePicture : NSObject
typedef void (^StitcheCompletely)(NSArray* resultModels); // Connection block
typedef void (^ScrollSuccess)(BOOL success);

@property (nonatomic, strong) StitcheCompletely jointCompletelyBlock;
@property (nonatomic, strong) ScrollSuccess scrollSuccessBlock;

+(void)StitchePictures:(NSArray *)images complete:(StitcheCompletely)state success:(ScrollSuccess)success;
@end
