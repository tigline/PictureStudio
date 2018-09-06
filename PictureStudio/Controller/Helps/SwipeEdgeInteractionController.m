//
//  SwipeEdgeInteractionController.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/9/5.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "SwipeEdgeInteractionController.h"




@interface SwipeEdgeInteractionController()

@property (assign, nonatomic) BOOL shouldCompleteTransition;
@property (weak, nonatomic) UIViewController *viewController;
//@property (weak, nonatomic)



@end

@implementation SwipeEdgeInteractionController

- (instancetype)initWithViewController:(UIViewController *)VC interationDirection:(InterationDirection)interationDirection completion:(ActionHandler)completion {
    if (self) {
        self = [super init];
        self.viewController = VC;
        self.animationDirection = interationDirection;
        self.actionHandlerBlock = completion;
        [self prepareGestureRecognizer:VC.view];
    }
    return self;
}

- (void)prepareGestureRecognizer:(UIView*)view {
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
    switch (self.animationDirection) {
        case left:
            gesture.edges = UIRectEdgeLeft;
            break;
        case right:
            gesture.edges = UIRectEdgeRight;
            break;
        default:
            break;
    }
}

- (void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    CGFloat progress = 0;
    switch (self.animationDirection) {
        case left:
            progress = (translation.x / SCREEN_W);
            break;

        default:
            progress = (-translation.x / SCREEN_W);
            break;
    }
    progress = fabs(progress);//(CGFloat)(fminf(fmaxf(Float(fabs(progress)), 0.0), 1.0));
    //NSLog(@"progress = %f ", progress);
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (_actionHandlerBlock != nil) {
                _actionHandlerBlock();
            }
            
            break;
        case UIGestureRecognizerStateChanged:
            _shouldCompleteTransition = progress > 0.5;
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
            [self cancelInteractiveTransition];
            break;
        case UIGestureRecognizerStateEnded:
            if (_shouldCompleteTransition) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
            
        default:
            break;
    }

}



@end
