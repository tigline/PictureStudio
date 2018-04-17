//
//  CombineIndicatorView.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/4/16.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CombineIndicatorView : UIView
{
    UIActivityIndicatorView* indicator;

    UILabel* label;

    BOOL visible,blocked;

    UIView* maskView;

    CGRect rectHud,rectSuper,rectOrigin;//外壳区域、父视图区域

    UIView* viewHud;//外壳

}

@property (assign) BOOL visible;



-(id)initWithFrame:(CGRect)frame superView:(UIView*)superView;

-(void)show:(BOOL)block;// block:是否阻塞父视图

-(void)hide;

-(void)setMessage:(NSString*)newMsg;

-(void)alignToCenter;


@end
