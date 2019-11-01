//
//  ViewController.m
//  Interview_01
//
//  Created by zrq on 2019/4/16.
//  Copyright © 2019年 com.baidu.www. All rights reserved.
//

#import "ViewController.h"
#import "TestStruct.h"
#import "TestBlock.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "JLKeyChain.h"
#define KEY_IN_KEYCHAIN @"com.yck.app.allinfo"
#define KEY_PASSWORD  @"com.yck.app.password"
@interface ViewController ()
{
    UIImageView *imageV ;
}
@end


@implementation ViewController
///kCFRunLoopCommonModes  kCFRunLoopDefaultMode
#pragma mark---存储用户的x一些敏感信息
+(void)savePassWord:(NSString *)password
{
    NSMutableDictionary *passwordDict = [NSMutableDictionary
                                         dictionary];
    [passwordDict setObject:password forKey:KEY_PASSWORD];
    [JLKeyChain save:KEY_IN_KEYCHAIN data:passwordDict];
}
+(id)readPassWord
{
    NSMutableDictionary *passwordDict = (NSMutableDictionary *)
    [JLKeyChain load:KEY_IN_KEYCHAIN];
    return [passwordDict objectForKey:KEY_PASSWORD];
}
+(void)deletePassWord
{
    [JLKeyChain delete:KEY_IN_KEYCHAIN];
}

#pragma mark --keychain获取UUID
- (NSString *)getKeychain {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper
                                          alloc]
                                         initWithIdentifier:@"UUID" accessGroup:@"com.xxx.www"];
    NSString *strUUID = [keychainItem objectForKey:
                         (id)kSecValueData];
    return strUUID;
}
#pragma mark---保存uuid
- (void)saveUuidWithKeyChain {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper
                                          alloc]
                                         initWithIdentifier:@"UUID" accessGroup:@"com.xxx.www"];
    NSString *strUUID = [keychainItem objectForKey:
                         (id)kSecValueData];
    if (strUUID == nil || [strUUID isEqualToString:@""])
    {
        [keychainItem setObject:[self uuid] forKey:
         (id)kSecValueData];
    }
    
}

#pragma mark  -----获取UUID
/**
 这个方法无法保证每一次的唯一，卸载了，UUID会重新生成一个不同的，这个时候keychain就起到了作用
 逻辑:先从keychain取UUID,如果能取到，就用这个比对，如果娶不到就重新生成一个保存起来，keychain独立于App之外，和系统统一等级
 
 @return <#return value description#>
 */
- (NSString*)uuid {
CFUUIDRef uuid = CFUUIDCreate( nil );
CFStringRef uuidString = CFUUIDCreateString( nil, uuid );
NSString * result = (NSString
*)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
CFRelease(uuid);
CFRelease(uuidString);
return result;
}
#pragma mark 方法找不到的流程
///1.是否动态添加方法
+ (BOOL)resolveClassMethod:(SEL)sel{
    return YES;//NO下一步，YES则通过class_addMethod函数动态添加方法
}
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return YES;
}
///2.指定那个对象响应selector
- (id)forwardingTargetForSelector:(SEL)aSelector{
    return nil;
}
///通过该方法获得方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return nil;
}
///拿到方法签名后，就会调用invocation方法，比如修改实现方法，修改响应对象，若没有实现，就会报找不到响应方法
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
}
#pragma mark ---建圆角
- (UIImage *)jl_imageWithCornerRadius:(CGFloat)radius{
    CGRect rect = (CGRect){0.f,0.f,200.f,50.f};
    CGSize mySize = CGSizeMake(200.f, 50.f);
    UIGraphicsBeginImageContextWithOptions(mySize, NO, UIScreen.mainScreen.scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [imageV drawRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
    
    imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    imageV.frame = CGRectMake(50, 100, 200, 50);
    imageV.opaque = YES;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    
   imageV.image = [self jl_imageWithCornerRadius:25];
    
    int array[5] = {1,2,3,4,5};
    //p整型指针指向了数组array的首地址，也就是第一个元素
    int *p = &array[0];
    //*p++ *(++p) 加号在前，需要先加法后运算，其后就是相反
    int max1 = MAX(*p++, 1);
    //int max = MAX(*(++p), 1);
    printf("max1==%d----*p====%d",max1,*p);
    
    
    //函数操作的对象是字符串，完成从源字符串到目的字符串的字符串拷贝功能
    //strcpy(<#char *__dst#>, <#const char *__src#>)
    
    //这个函数主要用来实现向字符串的转换功能
    //sprintf(<#char *restrict#>, <#const char *restrict, ...#>)
    //内存拷贝  实现一个内存块的内容复制到另一个内存块
    //memcpy(<#void *__dst#>, <#const void *__src#>, <#size_t __n#>)
    
    
    ///椎栈
    /**
     1.栈空间一般很小，申请空间超过栈剩余空间，就会提示overflow 连续的内存y区域
     2.椎空间是向高地址扩展的数据结构，是不连续的内存区域，这是由于系统用链表来存储的空闲内存地址，自然是不连续的，链表的遍历方向从低地址到高地址，椎的大小受限于计算机系统中的有效内存
     
     碎片问题：椎频繁的new/delete势必会造成内存空间的不连续，从而造成大量碎片，栈就不会存在这个问题先进后出的队列
     分配方式：椎是动态分配的，没有静态分配的椎  栈都有  需要编译器完成并完成释放
     分配效率：栈是机器系统提供的数据结构，计算机会在底层对栈提供支持，分配专门的寄存器存放栈的地址，压栈出栈都有专门的指令执行，这就决定栈的效率比较高，椎则是C/C++函数库提供的，她的机制比较复杂
     */
    
    //面向对象的特性：封装，继承，多态
    //多态是指允许不同子类型的对象对同一消息做出不同的响应
    //方法重载实现了编译时的多态性，方法重写实现的是运行时的多态
    
    //创建一个对象需要三个步骤：1.开辟内存空间，初始化参数，返回内存地址值
    
    //id类型：万能指针，能作为参数，方法的返回类型
    //instancetype：只能作为方法的范围类型，并且返回的类型是当前定义类的类类型
    
    //isKindOfClass,作用是某个对象属于某个类型或者继承自某类型
    //isMemberOfClass:某个对象确切属于某个类型
    //selector 通过方法名，获取在内存中的函数的入口地址
    
    
    //苹果实现autoreleasepool以一个队列数组的形式出现，由3个函数完成objc_autoreleasepoolPush，objc_autoreleasepoolPop，objc_autorelease
    
    //内存管理的原因：移动设备的内存及其有限，当一个程序所占内存达到一定值时，系统会发生内存警告。当程序达到更大的值时，程序会闪退，影响用户体验。为了保证程序的运行流畅，必须进行内存管理
    //内存管理所有继承自NSObject的对象，对基本数据类型无效，及其他数据类型主要存储在椎中，当代码块涉及到所有的局部变量会自动弹栈清空，指向对象的指针也会被回收，这时对象就没有指针指向，但依然存在椎内存中，造成内存泄漏
    
    //内存管理研究的对象：  野指针:指针没有进行初始化或者指向的控件已经被释放
    //内存泄漏： 没用的对象 没有及时得到释放
    
    //KVO:基于runtime机制实现
    //使用了isa混写，当一个对象的属性值发生改变时，系统会自动生成一个类，继承自NSKVONotifying_ClassName
    //KVO 键值观察机制，它提供了观察某一属性变化的方法  KVC:键值编码  使用字符串直接访问对象的属性
    
    //Test Block
    test();
    
    test2();
    
    test3();
    
    test4();
    
    
    //BLOCK的循环引用
    __weak typeof (self)weakSelf = self;
    __strong typeof (self)strongSelf = self;
    
    //测试结构体
    my_struct struct1 = (my_struct)(malloc(sizeof(my_struct)));
    
    struct1->a = 1;
    struct1->b = 22;
    TestStruct *test = [TestStruct new];
    test.str1 = @"1111";
    test.str2 = @"22222";
    test.arg1 = struct1;
    [self performSelector:@selector(call:) withObject:test];
    
    
    TestBlock *testBlock = [TestBlock new];
    [testBlock calculator:^int(int result) {
        result += 5;
        NSLog(@"result==%d",result);
        return result;
    }];
    
    testBlock.add(1).add(2).add(3);
    NSLog(@"paras====%d",testBlock.paras);
    
    //UIView的block动画块
    [UIView animateWithDuration:1 animations:^{
        ///block强引用着self,单向的强引用没有问题
    }];
    
    //block是基于指针和函数指针
    //block块中的循环引用 也会导致循环引用
    
    
    /**
     Swift与OC比较
     
     优势:Swift容易阅读，更易于维护，更加安全，代码更少，速度更快
    */
    
    /**
     响应者链条：responser chain
     视图栈  UIApplication队列
     
     
     UITableview重用机制：tableview要求不同的数据源以及不同的样式
     visiableCells,reuseableTableCells两个结构
     
     tableview的复用情况：
     1.依据屏幕大小显示的cell个数加入到visiableCells数组，reusableTableCells为空
     2.向下拖到时，cell移除屏幕，移除visiableCells数组，加入到reusableTableCells
     3.接着往下拖动tableview,reusableTableCells已经有值复用，加入visiableCells,在华加入到reusableTableCells
     重用的cell需要重新赋值，不要遗留老数据
     
     UITableView的性能优化
     1.使用不透明视图opaque=YES
     2.不要重复创建不必要的cell
     3.减少动画效果的使用
     4.减少视图的数目
     5.不需要与用户交互的使用CALayer
     6.不做多余的绘制工作，rect参数是绘制的区域，这个区域之外的不需要绘制
     7.预渲染图像  图形上下文进行绘制，以提高性能，异步绘制
     8.不要阻塞主线程  最多使用2个线程
     9.提前计算好单元格高度
     10.选择正确的数据结构：
     学会选择对业务场景最合适的数组结构是写出高效代码的基础，索引查询快，值查询慢，插入删除很慢
     字典存储键值对，用键来查找比较快
     集合：无序的一组值，用值来查找很快，插入删除很快
     
     如何实现cell的动态的行高
     设置两个属性  预估行高，自定义行高
     
     webview应用：活动页，新功能，富文本，多配置
     
     
     图片轮播图
     设置3个imageview，默认显示中间的
     根据移动情况，迅速变化3个imageview中图片数据
     imageview更新完毕，偷偷把scrollview拉回到中间的IMageview位置，这样视觉效果达到无限循环效果
     
     
     xib文件构成3个图标
     File's Owner是所有nib文件中的每个图标，它表示从磁盘加载nib文件的对象
     First Responder就是用户当前正在与之交互的对象
     View显示用户界面；完成用户交互；是UIview类或其子类
     
     
     加载VC内容:
     -[mainViewController viewDidLoad] -[mainViewController
     viewWillAppear:] -[mainViewController viewWillLayoutSubviews] -
     [mainViewController viewDidLayoutSubviews] -[mainViewController
     viewDidAppear:]
     
     
     
     函数中错误不是必现  需要检查分支，检测函数的参数 ，用断言检测参数的正确性是很重要性
     检测函数中每个分支所调用的函数返回结果是正确的
     线上bug可以用Bugly,友盟统计，  测试就复现bug进行逻辑检查
     
     */
           


}
- (void)call:(TestStruct *)objc{
    NSLog(@"%d---%@",objc.arg1->a,objc.str1);
}
//Block底层实现 传值和传地址
void test(){
    int a = 10;
    void (^block)(void) = ^{
        NSLog(@"a1 is %d",a);
    };
    a = 20;
    block();
}
void test2(){
    __block int a = 10;
    void (^block)(void) = ^{
        NSLog(@"a2 is %d",a);
    };
    a = 20;
    block();
}
void test3(){
    static int a = 10;
    void (^block)(void) = ^{
        NSLog(@"a3 is %d",a);
    };
    a = 20;
    block();
}
int a = 10;
void test4(){
    void (^block)(void) = ^{
        NSLog(@"a4 is %d",a);
    };
    a = 20;
    block();
}
#pragma mark----编写一个函数，实现递归删除指定路径下的文件
+ (void)deleteFiles:(NSString *)path{
    //1.判断文件还是目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        //2.判断是不是目录
        if (isDir) {
            NSArray *dirArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
            NSString *subPath = nil;
            for (NSString *str in dirArray) {
                subPath = [path stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManager fileExistsAtPath:subPath isDirectory:&issubDir];
                [self deleteFiles:subPath];
            }
        }else{
            [fileManager removeItemAtPath:path error:nil];
        }
    }else{
        NSLog(@"你打印的是目录或者不存在");
    }
}
@end
