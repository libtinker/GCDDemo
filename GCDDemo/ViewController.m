//
//  ViewController.m
//  GCDDemo
//
//  Created by 天空吸引我 on 2018/7/28.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//
#define WeakSelf(type) __weak typeof(type) weak##type = type

#import "ViewController.h"
#import "View.h"
@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createQueue];
//    [self getSystemQueue];
//    [self setCustomerQueuePriority];
//    [self setQueueAfter];
//    [self queueGroup];
//    [self barrierAsync];
//    [self queueSuspendAndresume];
//   [self queueGroupEnterAndLeave];
//   [self semaphore];
//    [self dispatchAfter];
    
    [self createContentView];
    
}
-(void)createContentView
{
    View *view = [[View alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:view];
}



//创建队列
-(void)createQueue
{
    dispatch_queue_t concurrentQueueT = dispatch_queue_create("com.tiankong.GCDDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueueT, ^{
        NSLog(@"创建并行的异步队列");
    });
    
    dispatch_queue_t serialQueueT = dispatch_queue_create("com.tiankong.GCDDemo", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueueT, ^{
        NSLog(@"创建串行的异步队列");
    });
    

}
-(void)getSystemQueue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"主线程执行任务");
    });
    
    /* NSLog(@"执行系统提供的并行队列，这个队列有优先级，可以手动设置");
     #define DISPATCH_QUEUE_PRIORITY_HIGH 2
     #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
     #define DISPATCH_QUEUE_PRIORITY_LOW (-2)
     #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
     */
    
    dispatch_queue_t global_queue_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(global_queue_background, ^{
        NSLog(@"我是第四：DISPATCH_QUEUE_PRIORITY_BACKGROUND");
    });
    
    dispatch_queue_t global_queue_low = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_async(global_queue_low, ^{
        NSLog(@"我是第三：DISPATCH_QUEUE_PRIORITY_LOW");
    });
    
    dispatch_queue_t global_queue_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(global_queue_default, ^{
        NSLog(@"我是第二：DISPATCH_QUEUE_PRIORITY_DEFAULT");
    });
    
    dispatch_queue_t global_queue_High = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(global_queue_High, ^{
        NSLog(@"我是第一：DISPATCH_QUEUE_PRIORITY_HIGH");
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
-(void)setQueueAfter
{
    dispatch_time_t  time = dispatch_time(DISPATCH_TIME_NOW, 10ull * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
         NSLog(@"time时间后执行的代码");
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
    
    /*
    //dispatch_group_wait(group_t, DISPATCH_TIME_FOREVER);//意味着永久等待
    dispatch_time_t  time = dispatch_time(DISPATCH_TIME_NOW, 21ull * NSEC_PER_SEC);
    long result = dispatch_group_wait(group_t, time);
    if (result == 0) {
        NSLog(@"线程组全部执行完毕");
    }else{
        NSLog(@"还有任务正在进行");
    }
     */
    
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
        NSLog(@"dispatch_group_wait 结束");

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
-(void)dispatchAfter
{
    NSLog(@"xian");
    //延迟2秒执行
    NSTimeInterval  duration = 5.0;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration)/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //执行2秒后的操作
        NSLog(@"5miaoshou");
    });

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
