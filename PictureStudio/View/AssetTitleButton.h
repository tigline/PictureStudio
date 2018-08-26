//
//  AssetTitleButton.h
//  PictureStudio
//
//  Created by mickey on 2018/8/26.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTitleButton : UIButton
- (CGFloat)updateTitleConstraints:(BOOL)isFirst;
- (void)buildUI;
@end
