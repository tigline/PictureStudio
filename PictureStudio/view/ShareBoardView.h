//
//  ShareBoardView.h
//  PictureStudio
//
//  Created by mickey on 2018/5/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareBoardViewDelegate <NSObject>
@optional
- (void)shareBoardViewDidWeChatBtn;
- (void)shareBoardViewDidWeiboBtn;
- (void)shareBoardViewDidMomentBtn;
- (void)shareBoardViewDidMoreBtn;
@end

@interface ShareBoardView : UIView

@property (weak, nonatomic) id <ShareBoardViewDelegate> shareDelegate;

@end
