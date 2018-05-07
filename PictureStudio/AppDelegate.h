//
//  AppDelegate.h
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXDelegate <NSObject>

-(void)loginSuccessByCode:(NSString *)code;
-(void)shareReturnByCode:(int) code;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) id<WXDelegate> wxDelegate;
@end
