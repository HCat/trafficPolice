//
//  AccidentPicListModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccidentPicListModel : NSObject

@property (nonatomic,copy) NSString *picId;     //图片ID
@property (nonatomic,copy) NSString *picName;   //图片名称
@property (nonatomic,copy) NSString *imgUrl;    //图片地址

@end