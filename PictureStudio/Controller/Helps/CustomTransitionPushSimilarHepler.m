//
//  CustomTransitionPushSimilarHepler.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/9/5.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "CustomTransitionPushSimilarHepler.h"
#import "ViewController.h"
#import "SharePictureViewController.h"

@implementation CustomTransitionPushSimilarHepler

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
//    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! UINavigationController
//    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! UINavigationController
    UINavigationController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = fromViewController.view.frame;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (_isPush) {
        [containerView addSubview:fromViewController.view];
        [containerView addSubview:toViewController.view];
        fromViewController.view.frame = CGRectMake(0, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
        toViewController.view.frame = CGRectMake(toViewController.view.frame.size.width, 0, toViewController.view.frame.size.width,  toViewController.view.frame.size.height);
        
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.frame = CGRectMake(0, 0, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
            fromViewController.view.frame = CGRectMake(-fromViewController.view.frame.size.width, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    } else {
        [containerView addSubview:toViewController.view];
        [containerView addSubview:fromViewController.view];
        fromViewController.view.frame = CGRectMake(0, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
        toViewController.view.frame = CGRectMake(-toViewController.view.frame.size.width, 0, toViewController.view.frame.size.width,  toViewController.view.frame.size.height);
        
        [UIView animateWithDuration:duration animations:^{
            fromViewController.view.frame = CGRectMake(fromViewController.view.frame.size.width, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
            toViewController.view.frame = CGRectMake(0, 0, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    
    ViewController *viewControllerOriginal; //= [[ViewController alloc] init];
    SharePictureViewController *scrollControllerOriginal; //= [[SharePictureViewController alloc] init];
    
    if ([fromViewController isKindOfClass:UINavigationController.class]) {
        if ([fromViewController.topViewController isKindOfClass: SharePictureViewController.class]) {
            scrollControllerOriginal = (SharePictureViewController *)fromViewController.topViewController;
        } else if ([fromViewController isKindOfClass: ViewController.class]) {
            viewControllerOriginal = (ViewController *)fromViewController.topViewController;
        }
    } else {
        if ([fromViewController isKindOfClass: SharePictureViewController.class]) {
            scrollControllerOriginal = (SharePictureViewController *)fromViewController;
        } else if ([fromViewController isKindOfClass: ViewController.class]) {
            viewControllerOriginal = (ViewController *)fromViewController;
        }
    }
    
    if ([toViewController isKindOfClass:UINavigationController.class]) {
        if ([toViewController.topViewController isKindOfClass: SharePictureViewController.class]) {
            scrollControllerOriginal = (SharePictureViewController *)toViewController.topViewController;
        } else if ([toViewController.topViewController isKindOfClass: ViewController.class]) {
            viewControllerOriginal = (ViewController *)toViewController.topViewController;
        }
    } else {
        if ([toViewController isKindOfClass: SharePictureViewController.class]) {
            scrollControllerOriginal = (SharePictureViewController *)toViewController;
        } else if ([toViewController isKindOfClass: ViewController.class]) {
            viewControllerOriginal = (ViewController *)toViewController;
        }
    }
    
    
    
    if (viewControllerOriginal == nil && scrollControllerOriginal == nil) {
        return;
    }
    
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
