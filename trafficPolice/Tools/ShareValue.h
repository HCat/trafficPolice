//
//  ShareValue.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRSingleton.h"

@interface ShareValue : NSObject

LRSingletonH(Default)

@property (nonatomic, copy) NSString *openid;   //微信openid
@property (nonatomic, copy) NSString *unionid;  //微信unionid


@end
