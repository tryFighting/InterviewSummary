//
//  TestBlock.m
//  Interview01
//
//  Created by zrq on 2019/4/17.
//  Copyright © 2019年 com.baidu.www. All rights reserved.
//

#import "TestBlock.h"

@implementation TestBlock
- (instancetype)init{
    if (self = [super init]) {
        self.paras = 10;
    }
    return self;
}
- (void)calculator:(int (^)(int))block{
    self.paras = block(self.paras);
}
- (TestBlock * _Nonnull (^)(int a))add{
    return ^(int a){
        self->_paras += a;
        return self;
    };
}
@end
