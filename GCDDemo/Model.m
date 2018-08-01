//
//  Model.m
//  GCDDemo
//
//  Created by 天空吸引我 on 2018/7/31.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//

#import "Model.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;


@interface Model()
@property (nonatomic,assign) int a;
@end

@implementation Model

-(void)getDataSuccess:(Success)success failure:(Failure)failure
{
    NSArray *array = @[
                       @{
                           @"title":@"1.并行队列",
                           @"method":@"queueConcurrent"
                           
                           },
                       @{
                           @"title":@"2.串行队列",
                           @"method":@"queueSerial"
                        
                           },
                       @{
                           @"title":@"3.dispatch_set_target_queue",
                           @"method":@"setCustomerQueuePriority"
                           },
                       @{
                           @"title":@"4.dispatch_group",
                           @"method":@"queueGroup"
                           },
                       @{
                           @"title":@"5.dispatch_barrier_async",
                           @"method":@"barrierAsync"
                           },
                       @{
                           @"title":@"6.dispatch_suspendAnddispatch_resume",
                           @"method":@"queueSuspendAndresume"
                           },
                       @{
                           @"title":@"7.dispatch_after",
                           @"method":@"queueAfter"
                           },
                       @{
                           @"title":@"8.dispatch_once",
                           @"method":@"queueOnce"
                           },
                       @{
                           @"title":@"9.dispatch_group_enter",
                           @"method":@"queueGroupEnterAndLeave"
                           },
                       @{
                           @"title":@"10.dispatch_group_wait",
                           @"method":@"queueGroupWait"
                           },
                       @{
                           @"title":@"11.dispatch_semaphore_t",
                           @"method":@"semaphore"
                           },
                       @{
                           @"title":@"12.dispatch_apply",
                           @"method":@"queueApply"
                           }
                       
                       ];
    if (array) {
        success(array);

    }else{
        failure(nil);
    }
}
//执行队列
-(void)queueImplementWithMethod:(NSString *)method{
    
   SEL sel = NSSelectorFromString(method);

    if ([self respondsToSelector:sel]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel];
#pragma clang diagnostic pop
        
    }

}
//并行队列
-(void)queueConcurrent
{
    dispatch_queue_t concurrentQueueT = dispatch_queue_create("com.tiankong.GCDDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"创建并行的异步队列%@",[NSThread currentThread]);
    });
}
//串行队列
-(void)queueSerial
{
    dispatch_queue_t serialQueueT = dispatch_queue_create("com.tiankong.GCDDemo", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueueT, ^{
        NSLog(@"创建串行的异步队列%@",[NSThread currentThread]);
    });
}
//设置自定义队列优先级
-(void)setCustomerQueuePriority
{
    dispatch_queue_t concurrentQueueT1 = dispatch_queue_create("com.tiankong.GCDDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t global_queue_low = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_set_target_queue(concurrentQueueT1, global_queue_low);
    dispatch_async(concurrentQueueT1, ^{
        NSLog(@"concurrentQueueT1我设置了最低优先级");
    });
    
    dispatch_queue_t concurrentQueueT2 = dispatch_queue_create("com.tiankong.GCDDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t global_queue_High = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_set_target_queue(concurrentQueueT2, global_queue_High);
    dispatch_async(concurrentQueueT2, ^{
        
        NSLog(@"concurrentQueueT2最先执行，因为把我的优先级设为了最高");
    });
    
}
-(void)queueGroup
{
    /*
     关灯，哥哥学习10分钟、姐姐学习20分钟、我学习15分钟，最后关灯睡觉(下面的例子1s = 1m)
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group_t = dispatch_group_create();
    dispatch_group_async(group_t, queue, ^{
        //任务执行
        sleep(10);
        NSLog(@"哥哥学习10分钟");
    });
    
    dispatch_group_async(group_t, queue, ^{
        sleep(20);
        NSLog(@"姐姐学习20分钟");
    });
    
    dispatch_group_async(group_t, queue, ^{
        sleep(15);
        NSLog(@"我学习15分钟");
    });
    
    dispatch_group_notify(group_t, queue, ^{
        //上面的线程全部完成
        NSLog(@"关灯睡觉");
    });
    
    
}

//栅栏操作（并行队列可以和栅栏异步操作实现高效的数据访问和文件访问）
-(void)barrierAsync
{
    
    WS(weakself);
    weakself.a = 5;
    dispatch_queue_t concurrentQueueT = dispatch_queue_create("com.tiankong.GCDDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"读取第一次a == %d",weakself.a);
    });
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"读取第二次a == %d",weakself.a);
        
    });
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"读取第三次a == %d",weakself.a);
    });
    
    dispatch_barrier_async(concurrentQueueT, ^{
        weakself.a = 8;
        NSLog(@"写入a = 8");
    });
    dispatch_async(concurrentQueueT, ^{
        
        NSLog(@"读取第四次a == %d",weakself.a);
    });
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"读取第五次a == %d",weakself.a);
    });
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"读取第六次a == %d",weakself.a);
    });
    
    
}
//队列暂停和重新开始(成对出现)
-(void)queueSuspendAndresume
{
    
    dispatch_queue_t concurrentQueueT = dispatch_queue_create("com.tiankong.GCDDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"读取第一次");
    });
    
    dispatch_suspend(concurrentQueueT);
    sleep(10);
    dispatch_resume(concurrentQueueT);
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"读取第二次");
        
    });
    
}

-(void)queueAfter
{
    dispatch_time_t  time = dispatch_time(DISPATCH_TIME_NOW, 10ull * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"time时间后执行的代码");
    });
}
-(void)queueOnce
{
    //一次性执行
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSLog(@"我只打印一次");
    });
}
-(void)queueGroupEnterAndLeave
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group_t = dispatch_group_create();
    
    
    dispatch_group_enter(group_t);
    
    dispatch_group_async(group_t, queue, ^{
        dispatch_async(queue1, ^{
            sleep(3);
            NSLog(@"我学习15分钟");
            dispatch_group_leave(group_t);
            
        });
        
    });
    
    dispatch_group_notify(group_t, queue, ^{
        //上面的线程全部完成
        NSLog(@"关灯睡觉");
    });
    
}
//线程组等待
-(void)queueGroupWait
{
    /*
     关灯，哥哥学习10分钟、姐姐学习20分钟、我学习15分钟，最后关灯睡觉(下面的例子1s = 1m)
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group_t = dispatch_group_create();
    dispatch_group_async(group_t, queue, ^{
        //任务执行
        sleep(10);
        NSLog(@"哥哥学习10分钟");
    });
    
    dispatch_group_async(group_t, queue, ^{
        sleep(20);
        NSLog(@"姐姐学习20分钟");
    });
    
    dispatch_group_async(group_t, queue, ^{
        sleep(15);
        NSLog(@"我学习15分钟");
    });
    
    dispatch_group_notify(group_t, queue, ^{
        //上面的线程全部完成
        NSLog(@"关灯睡觉");
    });
    
    
    dispatch_async(queue, ^{
        dispatch_group_wait(group_t, dispatch_time(DISPATCH_TIME_NOW, 16 * NSEC_PER_SEC));
        NSLog(@"dispatch_group_wait 超时");
    });
    
}
-(void)semaphore
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    for (int i=0; i<10000; i++) {
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [array addObject:[NSNumber numberWithInt:i]];
            NSLog(@"%@\n",[NSThread currentThread]
                  );
            dispatch_semaphore_signal(sem);
        });
    }
}
-(void)queueApply
{
    dispatch_apply(10,dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"%zd = %@",index,[NSThread currentThread]);
    });
}

@end
