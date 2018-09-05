//
//  BaseViewController.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/9/5.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStatusBarStyleNavigationBarHide:(BOOL)isHideNavigationBar  statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _isHideNavigationBar = isHideNavigationBar;
    _theStatusBarStyle = statusBarStyle;
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
