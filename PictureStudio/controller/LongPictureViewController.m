//
//  LongPictureViewController.m
//  PictureStudio
//
//  Created by Aaron Hou on 11/02/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "LongPictureViewController.h"

@interface LongPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *longPictureView;

@end

@implementation LongPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_resultImage != nil ) {
        CGRect cgpos;
        if (_resultImage.size.width > _longPictureView.frame.size.width) {
            cgpos.origin.x = 0;
            cgpos.origin.y = 0;
            cgpos.size.width = _longPictureView.frame.size.width;
            cgpos.size.height = _resultImage.size.height * (_longPictureView.frame.size.width/_resultImage.size.width);
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, cgpos.size.height)];
        }else {
            cgpos.origin.x =(_longPictureView.frame.size.width - _resultImage.size.width)/2;
            cgpos.origin.y = 0;
            cgpos.size.width = _resultImage.size.width;
            cgpos.size.height = _resultImage.size.height;
            [_longPictureView setContentSize:CGSizeMake(_longPictureView.frame.size.width, _resultImage.size.height)];
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:cgpos];
        [imageView setImage:_resultImage];
        [_longPictureView addSubview:imageView];
        [_longPictureView setUserInteractionEnabled:YES];
        UITapGestureRecognizer* imgMsgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnImage:)];
        [_longPictureView addGestureRecognizer:imgMsgTap];
        
    }
    
}

-(void)touchOnImage:(UITapGestureRecognizer*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

