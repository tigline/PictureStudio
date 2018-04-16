//
//  JointPicture.h
//  PictureStudio
//
//  Created by Aaron Hou on 24/02/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CombinePicture : NSObject

//@property (nonatomic, assign) NSArray *imageAsset
typedef void (^CombineCompletely)(UIImage* longPicture); // Connection block

@property (nonatomic, strong) CombineCompletely jointCompletelyBlock;

+(void)CombinePictures:(NSArray *)images complete:(CombineCompletely)state;



@end

