//
//  CombinePictureTest.h
//  PictureStudio
//
//  Created by mickey on 2018/4/22.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CombinePictureTest : NSObject
typedef void (^CombineCompletely)(UIImage* longPicture); // Connection block

@property (nonatomic, strong) CombineCompletely jointCompletelyBlock;

+(void)CombinePictures:(NSArray *)images complete:(CombineCompletely)state;
@end
