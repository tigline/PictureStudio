

#import "FFCutImageLayer.h"

@implementation FFCutImageLayer


- (void)drawInContext:(CGContextRef)context
{
    CGRect rct = self.bounds;
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextFillRect(context, rct);
    
    //清除范围（截图范围）
    CGContextClearRect(context, _clippingRect);
    
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextSetLineWidth(context, 0.8);
    
    rct = self.clippingRect;
    
    CGContextBeginPath(context);
    CGFloat dW = 0;
    //画竖线
    //左边线
    CGContextMoveToPoint(context, rct.origin.x+dW, rct.origin.y);
    CGContextAddLineToPoint(context, rct.origin.x+dW, rct.origin.y+rct.size.height);
    //右边线
    dW += _clippingRect.size.width;
    CGContextMoveToPoint(context, rct.origin.x+dW, rct.origin.y);
    CGContextAddLineToPoint(context, rct.origin.x+dW, rct.origin.y+rct.size.height);
//
////    for(int i=0;i<4;++i){
////        CGContextMoveToPoint(context, rct.origin.x+dW, rct.origin.y);
////        CGContextAddLineToPoint(context, rct.origin.x+dW, rct.origin.y+rct.size.height);
////        dW += _clippingRect.size.width/3;
////    }
//
    dW = 0;
    //画横线
    //上横线
    CGContextMoveToPoint(context, rct.origin.x, rct.origin.y+dW);
    CGContextAddLineToPoint(context, rct.origin.x+rct.size.width, rct.origin.y+dW);
    //下横线
    dW += rct.size.height;
    CGContextMoveToPoint(context, rct.origin.x, rct.origin.y+dW);
    CGContextAddLineToPoint(context, rct.origin.x+rct.size.width, rct.origin.y+dW);
////    for(int i=0;i<4;++i){
////        CGContextMoveToPoint(context, rct.origin.x, rct.origin.y+dW);
////        CGContextAddLineToPoint(context, rct.origin.x+rct.size.width, rct.origin.y+dW);
////        dW += rct.size.height/3;
////    }
    CGContextStrokePath(context);
}

@end
