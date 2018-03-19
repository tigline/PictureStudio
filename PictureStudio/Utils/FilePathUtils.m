//
//  FileUtils.m
//  PictureStudio
//
//  Created by mickey on 2018/3/6.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "FilePathUtils.h"

@implementation FilePathUtils
#pragma mark save file
+(NSString*)pathOfDocumentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+(NSString*)pathOfLibraryDirectory
{
    //需优化，不能每次都判断
    NSString* SaveMediaPath= [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MediaFileLib"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:SaveMediaPath])
    {
        [fileManager createDirectoryAtPath:SaveMediaPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return SaveMediaPath;
}

+(NSString*)pathOfCachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
@end
