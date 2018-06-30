//
//  CombinePictureTest.h
//  PictureStudio
//
//  Created by mickey on 2018/4/22.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CombinePicture : NSObject
typedef void (^CombineCompletely)(NSArray* resultModels); // Connection block
typedef void (^ScrollSuccess)(BOOL success);

@property (nonatomic, strong) CombineCompletely jointCompletelyBlock;
@property (nonatomic, strong) ScrollSuccess scrollSuccessBlock;

+(void)CombinePictures:(NSArray *)images complete:(CombineCompletely)state success:(ScrollSuccess)success;
@end
