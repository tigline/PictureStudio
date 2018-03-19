//
//  FileUtils.h
//  PictureStudio
//
//  Created by mickey on 2018/3/6.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePathUtils : NSObject
#pragma mark save file
+(NSString*)pathOfDocumentDirectory;
+(NSString*)pathOfLibraryDirectory;
+(NSString*)pathOfCachesDirectory;
@end
