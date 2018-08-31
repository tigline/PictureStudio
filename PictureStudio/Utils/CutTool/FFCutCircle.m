
#import "FFCutCircle.h"

@implementation FFCutCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.bounds;
    rct.origin.x = rct.size.width/3;
    rct.origin.y = rct.size.height/3;
    rct.size.width /= 3;
    rct.size.height /= 3;
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:68/255 green:159/255 blue:255/255 alpha:1].CGColor);
    CGContextFillEllipseInRect(context, rct);
    
    
    
//    CGRect bigRect = CGRectMake(rect.origin.x + kBorderWith,
//                                rect.origin.y+ kBorderWith,
//                                rect.size.width - kBorderWith*2,
//                                rect.size.height - kBorderWith*2);
    
//    //设置空心圆的线条宽度
//    CGContextSetLineWidth(context, 2);
//    //以矩形bigRect为依据画一个圆
//    CGContextAddEllipseInRect(context, rct);
//    //填充当前绘画区域的颜色
//    [[UIColor colorWithRed:68/255 green:159/255 blue:255/255 alpha:1] set];
//    //(如果是画圆会沿着矩形外围描画出指定宽度的（圆线）空心圆)/（根据上下文的内容渲染图层）
//    CGContextStrokePath(context);
}






@end
