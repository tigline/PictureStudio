//
//  MoveInfoModel.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/10/30.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoveInfoModel : NSObject

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) BOOL isMoveUp;
@property (assign, nonatomic) BOOL isMoveDown;
@property (assign, nonatomic) CGFloat canMoveHeight;
@property (strong, nonatomic) NSArray* photoArray;
@property (assign, nonatomic) CGFloat itemHeight;
@end

NS_ASSUME_NONNULL_END
