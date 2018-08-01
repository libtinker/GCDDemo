//
//  ViewModel.h
//  GCDDemo
//
//  Created by 天空吸引我 on 2018/7/31.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface ViewModel : NSObject

@property (nonatomic,strong) Model *model;
@property (nonatomic,copy) void (^reloadDataBlock)(id result);

//刷新数据
-(void)requestData;

//cell点击事件
-(void)cellDidSelectRowAtDict:(NSDictionary *)dict;
@end
