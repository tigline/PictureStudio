//
//  CustomTransitionPushSimilarHepler.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/9/5.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SwipeEdgeInteractionController;

@interface CustomTransitionPushSimilarHepler : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) BOOL isPush;
@property (assign, nonatomic) SwipeEdgeInteractionController* interactionController;

@end
