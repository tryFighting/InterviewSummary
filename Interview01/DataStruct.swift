//
//  DataStruct.swift
//  Interview01
//
//  Created by zrq on 2019/4/26.
//  Copyright © 2019 com.baidu.www. All rights reserved.
//

import UIKit

/*
 类和结构体的区别：
 1.内存管理方式不一样，引用类型分配在椎上（类），结构体分配在栈上（结构体）
 2.类有析构，结构体不能有析构
 3.结构体构造函数，会自动生成带参数的构造器。类不会对有初始化赋值的属性，生成带参数的构造器
 类有继承特性，结构体没有继承特性，自然不存在对成员属性和成员方法，类属性和类方法的重载
 
 相同点：
 操作符函数，泛型，协议采纳，观察器
*/



/*
 map函数，flatMap函数，filter函数，reduce函数
 使用高阶函数进行函数式编程不仅可以简化我们的代码，而且当数据比较大的时候，高阶函数会比传统实现更快，因为它可以并行执行(运行在多核上)/
 map函数获取一个闭包表达式作为其唯一的参数，数组中每一个元素调用一次该闭包函数，并返回该元素所映射的值
 简单来说就是数组中每个元素通过某个方法进行转换，最后返回一个新的数组
 
 
 flatMap函数
 flatMap方法同map方法比较类似,只不过它返回的数组中不存在nil,同时它会把Optional解包
 还能把数组中存有数组的数组一同打开变成一个新的一维数组
 
 
 filter函数
 filter方法用于过滤元素，即筛选出数组元素中满足某种条件的元素
 
 
 reduce函数
 reduce方法把数组元素组合计算为一个值，并且会接受一个初始值，这个初始值的类型可以和数组元素类型不同
 
 高阶函数的组合使用，链式调用
 
 1.组合使用：flatMap,filter/ map,reduce
 2.链式组合：filter,reduce / map,filter
 
 
 
 
 Swift：对于weak，unowned
 共同点:引用对象的自动引用计数都不会加1，不会造成对引用对象的强引用
 不同点:weak的对象，在block块内再次获取值可能为nil,相当于变成了一个可选值，调用属性或者方法需要加上？或者强制解析！，但是强制解析在对象已经释放了时肯定会造成强解错误，导致程序奔溃
 unowned的对象，在block块内再次获取值时依然是对象本身，只是该对象可能被释放了，因此调用者必须保证在执行block块时对象一定依然存在，不然调用对象的方法时会造成崩溃
 总结:
 weak修饰的属性，只能是var，同时只能是Optional类型，这个属性有可能是没有具体值的
 unowned修饰的属性，不能是Optional
 weak属性，初始化后也可以为nil
 unowned属性，初始化后一定有值
 weak比unowned更安全（其中一方什么时候赋值为nil,对对方都没有影响）
 unowned比weak性能更好一点（一个对象销毁，另一个对象也要跟着销毁，可以用unowned解决）
 
 加分回答:
 weak和unowned的使用差别：
 当访问对象时该对象可能已经释放了，则用weak,
 当访问对象确定不肯能释放，则用unowned
 
 
 Runtime是如何将weak修饰的属性置为nil
 1.weak实现的原理:Runtime维护了一个weak表，用于存储指向某个对象的所有weak指针。weak表其实就是一个哈希表，key是所指对象的地址，value是weak指针的地址(这个地址的值是所指对象的)数组
 具体步骤：
 1.初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址
 2.添加引用，objc_initWeak函数会调用objc_storeWeak()函数，作用是更新指针指向，创建对应的弱引用表
 3.释放时，调用clearDeallocating函数，作用会根据对象地址获取weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录
 
 weak引用指向的对象被释放时，如何处理weak指针
 1.调用objc_release
 2.引用计数为0，执行dealloc,_objc_rootDealloc      object_dispose,objc_destructInstance,最后objc_clear_deallocating
 
 
 
 不手动指定autoreleasepool的情况下 auotorelease对象会在什么时候释放
 没有手动干预自动释放池，autoRelease对象是在当前的runloop迭代结束时释放的，而它能够释放的原因是系统在每个runloop迭代中都加入自动释放池Push和Pop
 当RunloopMode切换Mode时，只能退出后再重新进入
 
 
 App启动优化
 在 Xcode 中 Edit scheme -> Run -> Auguments 将环境变量DYLD_PRINT_STATISTICS 设为1 ：
 Total pre-main time:  74.21 milliseconds (100.0%)
 dylib loading time:  51.76 milliseconds (69.7%)
 rebase/binding time: 411015771.6 seconds (146467923.0%)
 ObjC setup time:  12.84 milliseconds (17.3%)
 initializer time:  57.77 milliseconds (77.8%)
 slowest intializers :
 libSystem.B.dylib :   5.45 milliseconds (7.3%)
 libBacktraceRecording.dylib :   6.25 milliseconds (8.4%)
 libMainThreadChecker.dylib :  38.21 milliseconds (51.4%)
 libswiftCore.dylib :   2.16 milliseconds (2.9%)
 
 
 
 
 访问控制权限：
 
 open,public,internal,file-private,private
 
 Open具备最高的访问权限，其修饰的类和方法可以在任意Module中被访问和重写
 
 Public仅次于Open,与Open唯一的区别在于它修饰的对象可以在任意Module中访问，但不能重写
 
 Internal是默认的权限，它只能在当前定义的Module中访问和重写，它可以被一个Module中的多个文件访问，但不可以被其他的Module中被访问
 
 File-private 其修饰的对象只能在当前文件中被使用。例如它可以被一个文件中的不同class,extension,struct共同使用
 
 Private是最低的访问权限，它的对象只能在定义的作用域内及其对应的扩展内使用，离开了这个对象，即便是同一文件中的对象，也无法访问

 
 面向协议编程：POP/ 面向对象编程：OOP
 更加灵活，减少依赖，消除动态分发的风险，协议可以用于值类型
 */
class DataStruct: NSObject {
    
    

}
