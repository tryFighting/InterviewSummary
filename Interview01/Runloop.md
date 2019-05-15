#  Runloop
运行循环，在这个循环内部不断地处理各种任务。一个线程对应一个Runloop,主线程默认已经启动。子线程的runloop需要手动开启

Runloop只能选择一个Mode启动，如果当前Mode中没有任何Source(source0,source1),Timer,那么就直接r退出Runloop

基本的作用就是保证程序的持续运行，处理app中的各种事情
iOS中有2套API来访问和使用Runloop

Runloop与线程的关系:
每条线程都有唯一的一个与之对应的Runloop对象
主线程的Runloop已经自动创建好了，子线程的Runloop需要手动创建
Runloop在线程结束时销毁

CoreFoundation中关于Runloop的5个类
CFRunloopRef,



CFRunloopModeRef,
一个Runloop包含若干个Mode,每个Mode又包含若干个(set)Source/(array)Timer/(array)Observer


CFRunloopSourceRef,
事件源（输入源）
Port-Based Source基于端口的
Custom Input Sources
Source0:非基于Port
Source1:基于Port的,通过内核和其他线程通信，接收分发系统事件

CFRunloopTimeRef,
基于时间的触发器，基本上说就是Timer，它受Runloop的Mode影响


CFRunloopObserverRef
观察者，能够监听Runloop的状态改变

Runloop处理逻辑:
通知Observer：即将进入Loop,将要处理Timer,将要处理Source0,处理Source0,有就处理未处理的  没有线程就即将休眠


Runloop处理的输入事件有两种不同的来源：输入源和定时源

autorelease对象:手动干预释放和系统自动释放

一个线程一次只能执行一个任务，执行完任务后就会退出线程。但对于主线程是不能退出的，因此我们需要让主线程即使执行完任务，也可以继续等待是接收事件不退出，那么Runloop就是关键法宝

Timer页面滚动定时器希望有回调  选Runloop的Common模式  ，否则使用默认模式

NSTimer必要时要销毁Timer,否则Timer就会一直占有内存而不会释放，不需要的时候调用invalidate方法使定时器失效，否则得不到释放
