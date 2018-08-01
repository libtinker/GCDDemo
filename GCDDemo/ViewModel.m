//
//  ViewModel.m
//  GCDDemo
//
//  Created by 天空吸引我 on 2018/7/31.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//

#import "ViewModel.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@implementation ViewModel

-(id)init
{
    if (self = [super init]) {
        [self initIalize];
    }
    return self;
}
-(void)initIalize
{
    self.model = [Model new];
}
-(void)requestData
{
    WS(weakSelf)
    [self.model getDataSuccess:^(id result) {
        if (weakSelf.reloadDataBlock) {
            weakSelf.reloadDataBlock(result);
        }
    } failure:^(id result) {
        if (weakSelf.reloadDataBlock) {
            weakSelf.reloadDataBlock(result);
        }
    }];
}

-(void)cellDidSelectRowAtDict:(NSDictionary *)dict
{
    NSString *method = dict[@"method"];    
    [self.model queueImplementWithMethod:method];

}


@end
