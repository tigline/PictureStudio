

#import <UIKit/UIKit.h>

/**
 网格视图
 */
@interface FFCutImageLayer : CALayer
@property (nonatomic, assign) CGRect clippingRect; //裁剪范围
@property (nonatomic, strong) UIColor *bgColor;    //背景颜色
@property (nonatomic, strong) UIColor *gridColor;  //线条颜色
@end
