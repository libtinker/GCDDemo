//
//  Model.h
//  GCDDemo
//
//  Created by 天空吸引我 on 2018/7/31.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 这个相当于Model，我们可以在Model里边完成数据的请求，然后在ViewModel中调用
 */

typedef void(^Success)(id result);
typedef void(^Failure)(id result);
@interface Model : NSObject

-(void)getDataSuccess:(Success)success failure:(Failure)failure;

-(void)queueImplementWithMethod:(NSString *)method;
@end
