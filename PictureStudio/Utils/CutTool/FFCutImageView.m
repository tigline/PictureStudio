

#import "FFCutImageView.h"
#import "FFCutCircle.h"
#import "FFCutImageLayer.h"

static const NSUInteger kLeftTopCircleView = 1;
static const NSUInteger kLeftBottomCircleView = 2;
static const NSUInteger kRightTopCircleView = 3;
static const NSUInteger kRightBottomCircleView = 4;

static const NSUInteger kLeftCenterCircleView = 5;
static const NSUInteger kRightCenterCircleView = 6;
static const NSUInteger kTopCenterCircleView = 7;
static const NSUInteger kBottomCenterCircleView = 8;


@implementation FFCutImageView{
    FFCutImageLayer *_gridLayer;
    
    //4个角
    FFCutCircle *_ltView;
    FFCutCircle *_lbView;
    FFCutCircle *_lcView;
    FFCutCircle *_tcView;
    FFCutCircle *_rtView;
    FFCutCircle *_rbView;
    FFCutCircle *_rcView;
    FFCutCircle *_bcView;
    
    CGSize size;
    CGRect initCutFrame;
    CGRect initViewFrame;
}

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [superview addSubview:self];
        size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _gridLayer = [[FFCutImageLayer alloc] init];
        _gridLayer.frame = self.bounds;
        
        NSLog(@"初始背景区域大小：宽：%f----高:%f 宽：%f----高:%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
        
        
        [self.layer addSublayer:_gridLayer];
        
        _ltView = [self clippingCircleWithTag:kLeftTopCircleView];
        _lbView = [self clippingCircleWithTag:kLeftBottomCircleView];
        _lcView = [self clippingCircleWithTag:kLeftCenterCircleView];
        _rtView = [self clippingCircleWithTag:kRightTopCircleView];
        _rbView = [self clippingCircleWithTag:kRightBottomCircleView];
        _rcView = [self clippingCircleWithTag:kRightCenterCircleView];
        _tcView = [self clippingCircleWithTag:kTopCenterCircleView];
        _bcView = [self clippingCircleWithTag:kBottomCenterCircleView];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGridView:)];
        [self addGestureRecognizer:panGesture];
        
        self.clippingRect = self.bounds;
        initCutFrame = self.bounds;
        initViewFrame = self.frame;
    }
    return self;
}


//4个角的拖动圆球
- (FFCutCircle*)clippingCircleWithTag:(NSInteger)tag
{
    FFCutCircle *view = [[FFCutCircle alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    view.tag = tag;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCircleView:)];
    [view addGestureRecognizer:panGesture];
    
    [self.superview addSubview:view];
    
    return view;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [_ltView removeFromSuperview];
    [_lbView removeFromSuperview];
    [_rtView removeFromSuperview];
    [_rbView removeFromSuperview];
    [_lcView removeFromSuperview];
    [_tcView removeFromSuperview];
    [_rcView removeFromSuperview];
    [_bcView removeFromSuperview];
}

- (void)setBgColor:(UIColor *)bgColor
{
    _gridLayer.bgColor = bgColor;
}

- (void)setGridColor:(UIColor *)gridColor
{
    _gridLayer.gridColor = gridColor;
    
}
- (void)setFrameWithSize:(CGFloat)scale  withFrame:(CGRect)cgframe
{
    
//    NSLog(@"cgframe  --- %f---%f----%f---%f",cgframe.origin.x,cgframe.origin.y,cgframe.size.width,cgframe.size.height);
    
//    self.frame = cgframe;
//    [self layoutIfNeeded];
    
    
//
//    NSLog(@"%f ---%f --- %f --- %f ---  ",initFrame.origin.x * scale, initFrame.origin.y * scale, initFrame.size.width * scale, initFrame.size.height * scale);
    
//    NSLog(@"缩放后的区域大小：宽：%f----高:%f",size.width*scale,size.height*scale);
    
//    _gridLayer.frame = self.bounds;
//    [_gridLayer layoutIfNeeded];
    
    
    
//    NSLog(@"初始化定位：%f---%f",initCutFrame.origin.x,initCutFrame.origin.y);
    
    
    NSLog(@"frame1 -- : %f ---  %f------%f",cgframe.origin.x,initViewFrame.origin.x,initCutFrame.origin.x);
    NSLog(@"frame2 -- : %f ---  %f------%f",cgframe.origin.y,initViewFrame.origin.y,initCutFrame.origin.y);
    CGFloat x = (cgframe.origin.x  - initViewFrame.origin.x + initCutFrame.origin.x)*scale;
    CGFloat y = (cgframe.origin.y  - initViewFrame.origin.y + initCutFrame.origin.y)*scale;
    if (initCutFrame.origin.x == 0 && initCutFrame.origin.y == 0)
    {
        x = cgframe.origin.x  - initViewFrame.origin.x;
        y = cgframe.origin.y  - initViewFrame.origin.y;
    }
    CGRect frame =CGRectMake(x,y, initCutFrame.size.width * scale, initCutFrame.size.height * scale);
    NSLog(@"frame3 ----scale : %f ---  %f---%f----%f---%f",scale,frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    if (scale == 1)
    {
        if(initViewFrame.size.width >= frame.size.width + frame.origin.x)
        {
            [self setClippingRect:frame];
        }
        else
        {
            [self setClippingRect:self.bounds];
        }
    }
    else
    {
        [self setClippingRect:frame];
    }
    
}


- (void)setClippingRect:(CGRect)clippingRect
{
    _clippingRect = clippingRect;
    
    _ltView.center = [self.superview convertPoint:CGPointMake(_clippingRect.origin.x, _clippingRect.origin.y) fromView:self];
    _lbView.center = [self.superview convertPoint:CGPointMake(_clippingRect.origin.x, _clippingRect.origin.y+_clippingRect.size.height) fromView:self];
    _lcView.center = [self.superview convertPoint:CGPointMake(_clippingRect.origin.x, _clippingRect.origin.y+_clippingRect.size.height/2) fromView:self];
    _rtView.center = [self.superview convertPoint:CGPointMake(_clippingRect.origin.x+_clippingRect.size.width, _clippingRect.origin.y) fromView:self];
    _rbView.center = [self.superview convertPoint:CGPointMake(_clippingRect.origin.x+_clippingRect.size.width, _clippingRect.origin.y+_clippingRect.size.height) fromView:self];
    _rcView.center = [self.superview convertPoint:CGPointMake(_clippingRect.origin.x+_clippingRect.size.width, _clippingRect.origin.y+_clippingRect.size.height/2) fromView:self];
    _tcView.center = [self.superview convertPoint:CGPointMake(_clippingRect.origin.x+_clippingRect.size.width/2, _clippingRect.origin.y) fromView:self];
    _bcView.center = [self.superview convertPoint:CGPointMake(_clippingRect.origin.x+_clippingRect.size.width/2, _clippingRect.origin.y+_clippingRect.size.height) fromView:self];
    
    _gridLayer.clippingRect = clippingRect;
    [self setNeedsDisplay];
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [_gridLayer setNeedsDisplay];
}

//拖动4个角
- (void)panCircleView:(UIPanGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self];
    CGPoint dp = [sender translationInView:self];
    
    CGRect rct = self.clippingRect;
    
    const CGFloat W = self.frame.size.width;
    const CGFloat H = self.frame.size.height;
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = W;
    CGFloat maxY = H;
    
    CGFloat ratio = (sender.view.tag == kLeftBottomCircleView || sender.view.tag == kRightTopCircleView) ? -0 : 0;
    
    switch (sender.view.tag) {
        case kLeftTopCircleView: // upper left
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = rct.origin.y - ratio * rct.origin.x;
                CGFloat x0 = -y0 / ratio;
                minX = MAX(x0, 0);
                minY = MAX(y0, 0);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y > 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.x = point.x;
            rct.origin.y = point.y;
            break;
        }
        case kLeftBottomCircleView: // lower left
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = (rct.origin.y + rct.size.height) - ratio* rct.origin.x ;
                CGFloat xh = (H - y0) / ratio;
                minX = MAX(xh, 0);
                maxY = MIN(y0, H);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y < 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.size.height = point.y - rct.origin.y;
            rct.origin.x = point.x;
            break;
        }
        case kLeftCenterCircleView: // left center
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = (rct.origin.y + rct.size.height) - ratio* rct.origin.x ;
                CGFloat xh = (H - y0) / ratio;
                minX = MAX(xh, 0);
                maxY = MIN(y0, H);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y < 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.origin.x = point.x;
            break;
        }
        case kTopCenterCircleView: // left center
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = (rct.origin.y + rct.size.height) - ratio* rct.origin.x ;
                CGFloat xh = (H - y0) / ratio;
                minX = MAX(xh, 0);
                maxY = MIN(y0, H);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y < 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.y = point.y;
            
            NSLog(@"%f---%f",rct.origin.y,rct.size.height);
            break;
        }
        case kRightTopCircleView: // upper right
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = rct.origin.y - ratio * (rct.origin.x + rct.size.width);
                CGFloat yw = ratio * W + y0;
                CGFloat x0 = -y0 / ratio;
                maxX = MIN(x0, W);
                minY = MAX(yw, 0);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y > 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = point.x - rct.origin.x;
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.y = point.y;
            break;
        }
        case kRightBottomCircleView: // lower right
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = (rct.origin.y + rct.size.height) - ratio * (rct.origin.x + rct.size.width);
                CGFloat yw = ratio * W + y0;
                CGFloat xh = (H - y0) / ratio;
                maxX = MIN(xh, W);
                maxY = MIN(yw, H);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y < 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            
            rct.size.width  = point.x - rct.origin.x;
            rct.size.height = point.y - rct.origin.y;
            break;
        }
        case kRightCenterCircleView: // right center
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = (rct.origin.y + rct.size.height) - ratio * (rct.origin.x + rct.size.width);
                CGFloat yw = ratio * W + y0;
                CGFloat xh = (H - y0) / ratio;
                maxX = MIN(xh, W);
                maxY = MIN(yw, H);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y < 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            rct.size.width  = point.x - rct.origin.x;
            break;
        }
        case kBottomCenterCircleView: // bottom center
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            if(ratio!=0){
                CGFloat y0 = (rct.origin.y + rct.size.height) - ratio * (rct.origin.x + rct.size.width);
                CGFloat yw = ratio * W + y0;
                CGFloat xh = (H - y0) / ratio;
                maxX = MIN(xh, W);
                maxY = MIN(yw, H);
                
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
                
                if(-dp.x*ratio + dp.y < 0){ point.x = (point.y - y0) / ratio; }
                else{ point.y = point.x * ratio + y0; }
            }
            else{
                point.x = MAX(minX, MIN(point.x, maxX));
                point.y = MAX(minY, MIN(point.y, maxY));
            }
            rct.size.height = point.y - rct.origin.y;
            break;
        }
        default:
            break;
    }
    
    
    NSLog(@"self.clippingRect  --- %f --- %f --- %f --- %f --- ",self.clippingRect.origin.x,self.clippingRect.origin.y,self.clippingRect.size.width,self.clippingRect.size.height);
    
    self.clippingRect = rct;
    initCutFrame = self.clippingRect;
}

//移动裁剪view
- (void)panGridView:(UIPanGestureRecognizer*)sender
{
    static BOOL dragging = NO;
    static CGRect initialRect;
    
    if(sender.state==UIGestureRecognizerStateBegan){
        CGPoint point = [sender locationInView:self];
        dragging = CGRectContainsPoint(_clippingRect, point);
        initialRect = self.clippingRect;
    }
    else if(dragging){
        CGPoint point = [sender translationInView:self];
        CGFloat left  = MIN(MAX(initialRect.origin.x + point.x, 0), self.frame.size.width-initialRect.size.width);
        CGFloat top   = MIN(MAX(initialRect.origin.y + point.y, 0), self.frame.size.height-initialRect.size.height);
        
        CGRect rct = self.clippingRect;
        rct.origin.x = left;
        rct.origin.y = top;
        NSLog(@"self.clippingRect  ---- %f --- %f --- %f --- %f --- ",self.clippingRect.origin.x,self.clippingRect.origin.y,self.clippingRect.size.width,self.clippingRect.size.height);
        self.clippingRect = rct;
        initCutFrame = self.clippingRect;
    }
}


//-(UIImage*)CutImageView
//{
//
//    
//    //将UIImage转换成CGImageRef
//    CGImageRef sourceImageRef = [ CGImage];
//    
//    //按照给定的矩形区域进行剪裁
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
//    
//    //将CGImageRef转换成UIImage
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    
//    //返回剪裁后的图片
//    return newImage;
//}

@end
