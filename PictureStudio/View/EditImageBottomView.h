//
//  EditImageBottomView.h
//  PictureStudio
//
//  Created by Zhenfeng Wu on 2018/8/29.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditImageBottomViewDelegate <NSObject>
@optional
-(void)CutButtonClick;
-(void)HighLightButtonClick;
-(void)DoodelButtonClick;
-(void)CancelButtonClick;
-(void)ConfirmButtonClick;
-(void)CutViewButtonClick;
-(void)ResetButtonClick;
@end

@interface EditImageBottomView : UIView
@property (weak, nonatomic) id<EditImageBottomViewDelegate> delegate;

@end
