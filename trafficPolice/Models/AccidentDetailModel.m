//
//  AccidentDetailModel.m
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentDetailModel.h"

@implementation AccidentPicListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"picId" : @"id",
             };
}

@end

@implementation AccidentVoModel

@end

@implementation AccidentDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picList" : [AccidentPicListModel class]
             };
}

@end
