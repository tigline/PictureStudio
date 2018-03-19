//
//  JointPicture.h
//  PictureStudio
//
//  Created by Aaron Hou on 24/02/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JointPicture : NSObject

//@property (nonatomic, assign) NSArray *imageAsset
typedef void (^JointCompletely)(UIImage* longPicture); // Connection block

@property (nonatomic, strong) JointCompletely jointCompletelyBlock;

+(void)jointPictures:(NSArray *)images complete:(JointCompletely)state;



@end

