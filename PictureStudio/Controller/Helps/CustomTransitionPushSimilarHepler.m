//
//  CustomTransitionPushSimilarHepler.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/9/5.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "CustomTransitionPushSimilarHepler.h"
#import "AlbumViewController.h"
#import "ScrollPictureViewController.h"
#import "CombinePictureViewController.h"
@implementation CustomTransitionPushSimilarHepler

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
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
    
    AlbumViewController *viewControllerOriginal; //= [[ViewController alloc] init];
    ScrollPictureViewController *scrollControllerOriginal; //= [[SharePictureViewController alloc] init];
    CombinePictureViewController *longControllerOriginal;
    
    if ([fromViewController isKindOfClass:UINavigationController.class]) {
        if ([fromViewController.topViewController isKindOfClass: ScrollPictureViewController.class]) {
            scrollControllerOriginal = (ScrollPictureViewController *)fromViewController.topViewController;
        } else if ([fromViewController.topViewController isKindOfClass: CombinePictureViewController.class]) {
            longControllerOriginal = (CombinePictureViewController *)fromViewController.topViewController;
        }
    } else {
        if ([fromViewController isKindOfClass: AlbumViewController.class]) {
            viewControllerOriginal = (AlbumViewController *)fromViewController;
        }
    }
    
    if ([toViewController isKindOfClass:UINavigationController.class]) {
        if ([toViewController.topViewController isKindOfClass: ScrollPictureViewController.class]) {
            scrollControllerOriginal = (ScrollPictureViewController *)toViewController.topViewController;
        } else if ([toViewController.topViewController isKindOfClass: CombinePictureViewController.class]) {
            longControllerOriginal = (CombinePictureViewController *)toViewController.topViewController;
        }
    } else {
        if ([toViewController isKindOfClass: AlbumViewController.class]) {
            viewControllerOriginal = (AlbumViewController *)toViewController;
        }
    }
    
    
    
    if (viewControllerOriginal == nil && scrollControllerOriginal == nil && longControllerOriginal == nil) {
        return;
    }
    
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
