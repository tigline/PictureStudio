//
//  PhotoSaveBottomView.h
//  PictureStudio
//
//  Created by mickey on 2018/5/6.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoSaveBottomViewDelegate <NSObject>
@optional
- (void)savePhotoBottomViewDidBackBtn;
- (void)savePhotoBottomViewDidSaveBtn:(UIButton *)button;
- (void)savePhotoBottomViewDidShareBtn;
@end

@interface PhotoSaveBottomView : UIView
@property (weak, nonatomic) id<PhotoSaveBottomViewDelegate> delegate;
@property (strong, nonatomic) UIToolbar *bgView;
- (void)setProgressLength:(NSInteger)length;
- (void)setSaveLabelHidden:(BOOL)value;
- (void)setProgressViewValue:(NSInteger)index;
- (void)setSaveBtnsHiddenValue:(BOOL)value;
- (void)setSaveText:(NSString *)text;
@end
