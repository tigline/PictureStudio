//
//  AppDelegate.m
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
//#import "WXApi.h"



#define UMeng_AppKey @"5b17ea27f29d9868c800002d"

#define WX_APP_KEY @"wxe1f34216d2552447"
#define WX_APP_SECRET @"a188a22d52c6e7791a0a3a53617aae9a"
#define WB_APP_KEY @"2207598112"
#define WB_APP_SECRET @"b3fa8253665ef403f6fb4dce96a67a48"

void uncaughtExceptionHandler(NSException *exception) {
    NSSLog(@"CRASH: %@", exception);
    NSSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //向微信注册应用。
    //[WXApi registerApp:URL_APPID ];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    return YES;
}

- (void)confitUShareSettings
{
    [UMConfigure initWithAppkey:UMeng_AppKey channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_KEY appSecret:WX_APP_SECRET redirectURL:nil];
    /* 设置微博的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WB_APP_KEY  appSecret:WB_APP_SECRET redirectURL:nil];

}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {

    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    //return [WXApi handleOpenURL:url delegate:self];
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //return [WXApi handleOpenURL:url delegate:self];
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    //return [WXApi handleOpenURL:url delegate:self];
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp 具体的回应内容，是自动释放的
 */
//-(void) onResp:(BaseResp*)resp{
//    NSLog(@"resp %d",resp.errCode);
//
//    /*
//     enum  WXErrCode {
//     WXSuccess           = 0,    成功
//     WXErrCodeCommon     = -1,  普通错误类型
//     WXErrCodeUserCancel = -2,    用户点击取消并返回
//     WXErrCodeSentFail   = -3,   发送失败
//     WXErrCodeAuthDeny   = -4,    授权失败
//     WXErrCodeUnsupport  = -5,   微信不支持
//     };
//     */
//
//    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //微信分享 微信回应给第三方应用程序的类
//        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
//        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
//        //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
//        if (_wxDelegate) {
//            if([_wxDelegate respondsToSelector:@selector(shareReturnByCode:)]){
//                [_wxDelegate shareReturnByCode:response.errCode];
//            }
//        }
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
