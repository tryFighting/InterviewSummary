//
//  TestStruct.h
//  MultiUpload
//
//  Created by zrq on 2019/4/16.
//  Copyright © 2019年 com.baidu.www. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct TestSt{
    int a;
    int b;
}*my_struct;
NS_ASSUME_NONNULL_BEGIN

@interface TestStruct : NSObject
@property(nonatomic,assign)my_struct arg1;
///string不改变时使用strong修饰  copy要先判断可变不可变性能稍微差点
@property(nonatomic,strong)NSString *str1;
@property(nonatomic,strong)NSString *str2;
@end

NS_ASSUME_NONNULL_END
