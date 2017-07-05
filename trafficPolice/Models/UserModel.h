//
//  UserModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

#define kPersonInfoPath [KDocumentPath stringByAppendingPathComponent:@"userModel.archiver"]


@interface UserModel : BaseModel

@property (nonatomic,copy) NSString *token;         //token
@property (nonatomic,copy) NSString * userId;       //用户Id
@property (nonatomic,copy) NSString * phone;        //用户手机
@property (nonatomic,copy) NSString * name;         //用户名
@property (nonatomic,copy) NSString * nickName;     //昵称
@property (nonatomic,copy) NSString * realName;     //真实姓名
@property (nonatomic,assign) BOOL isInsurance;      //是否保险人员 0否 1是
@property (nonatomic,copy) NSArray *menus;          //可操作的菜单列表

/******** menus ********
 有权限的菜单编码值，参考下面的编码值，数组类型
 菜单编码：
 
 "ACCIDENT_LIST",
 "FASTACC_LIST",
 "FAST_ACCIDENT_ADD",
 "ILLEGAL_LIST",
 "ILLEGAL_PARKING",
 "ILLEGAL_THROUGH",
 "NORMAL_ACCIDENT_ADD",
 "THROUGH_LIST",
 "VIDEO_COLLECT",
 "VIDEO_COLLECT_LIST"
 
 ACCIDENT_ADD 事故添加
 FAST_ACCIDENT_ADD 快处事故添加
 ACCIDENT_LIST 事故列表
 ILLEGAL_PARKING 违停采集,
 ILLEGAL_THROUGH 闯禁令采集
 ILLEGAL_LIST 违法行为采集列表
*/


//归档
+ (void)setUserModel:(UserModel *)model;


//解档
+ (UserModel *)getUserModel;
 
@end
