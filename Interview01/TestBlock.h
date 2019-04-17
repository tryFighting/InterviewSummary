//
//  TestBlock.h
//  Interview01
//
//  Created by zrq on 2019/4/17.
//  Copyright © 2019年 com.baidu.www. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestBlock : NSObject
/**
 block作为一个参数使用

 @param block --有返回值有参数的block
 */
- (void)calculator:(int(^)(int result))block;

///参数值
@property(nonatomic,assign) int paras;

/**
 block作为返回值使用
 */
- (TestBlock *(^)(int a))add;
@end

NS_ASSUME_NONNULL_END
