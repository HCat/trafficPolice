//
//  LRBaseRequest.h
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "LRBaseResponse.h"
#import "YTKUrlArgumentsFilter.h"


@interface LRBaseRequest : YTKRequest

@property (nonatomic,strong) LRBaseResponse *responseModel;

@property (nonatomic,assign) BOOL isLog; //用来打印具体返回的数据

@property (nonatomic,copy) NSString *successMessage; //成功的提示信息
@property (nonatomic,copy) NSString *failMessage;    //失败的提示信息

//全局为统一的Url添加参数。比如添加token，或者version
+ (void)setupRequestFilters:(NSDictionary *)arguments;
+ (void)clearRequestFilters;

@end
