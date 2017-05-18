//
//  LRBaseRequest.h
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "LRBaseResponse.h"

@interface LRBaseRequest : YTKRequest

@property (nonatomic,strong) LRBaseResponse *responseModel;

@property (nonatomic,assign) BOOL isLog; //用来打印具体返回的数据

@end
