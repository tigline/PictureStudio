//
//  NSBundle+HXWeiboPhotoPicker.h
//  PictureStudio
//
//  Created by Aaron Hou on 30/01/2018.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (HXWeiboPhotoPicker)
+ (instancetype)hx_photoPickerBundle;
+ (NSString *)hx_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)hx_localizedStringForKey:(NSString *)key;
@end
