//
//  SwipeEdgeInteractionController.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/9/5.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionHandler)(void);

@interface SwipeEdgeInteractionController : UIPercentDrivenInteractiveTransition
@property (assign, nonatomic) InterationDirection animationDirection;
@property (copy, nonatomic)ActionHandler actionHandlerBlock;

- (instancetype)initWithViewController:(UIViewController *)VC interationDirection:(InterationDirection)interationDirection completion:(ActionHandler)completion;

@end
