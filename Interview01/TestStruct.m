//
//  TestStruct.m
//  MultiUpload
//
//  Created by zrq on 2019/4/16.
//  Copyright © 2019年 com.baidu.www. All rights reserved.
//

#import "TestStruct.h"

@implementation TestStruct
- (void)dealloc{
    free(self.arg1);
}
@end
