//
//  JLKeyChain.h
//  Interview01
//
//  Created by zrq on 2019/4/25.
//  Copyright © 2019 com.baidu.www. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLKeyChain : NSObject
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+(void)save:(NSString *)service data:(id)data;
+(id)load:(NSString *)service;
+(void)delete:(NSString *)service;
@end

NS_ASSUME_NONNULL_END
