//
//  AccidentDetailModel.h
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentModel.h"
#import "AccidentPicListModel.h"

@interface AccidentVoModel : NSObject

@property (nonatomic,copy) NSString * ptaIsZkCl;        //甲方是否暂扣车辆 0否1是
@property (nonatomic,copy) NSString * ptaIsZkXsz;       //甲方是否暂扣行驶证 0否1是
@property (nonatomic,copy) NSString * ptaIsZkJsz;       //甲方是否暂扣驾驶证 0否1是
@property (nonatomic,copy) NSString * ptaIsZkSfz;       //甲方是否暂扣身份证 0否1是
@property (nonatomic,copy) NSString * ptbIsZkCl;        //乙方是否暂扣车辆 0否1是
@property (nonatomic,copy) NSString * ptbIsZkXsz;       //乙方是否暂扣行驶证 0否1是
@property (nonatomic,copy) NSString * ptbIsZkJsz;       //乙方是否暂扣驾驶证 0否1是
@property (nonatomic,copy) NSString * ptbIsZkSfz;       //乙方是否暂扣身份证 0否1是
@property (nonatomic,copy) NSString * ptcIsZkCl;        //丙方是否暂扣车辆 0否1是
@property (nonatomic,copy) NSString * ptcIsZkXsz;       //丙方是否暂扣行驶证 0否1是
@property (nonatomic,copy) NSString * ptcIsZkJsz;       //丙方是否暂扣驾驶证 0否1是
@property (nonatomic,copy) NSString * ptcIsZkSfz;       //丙方是否暂扣身份证 0否1是

@end


@interface AccidentDetailModel : NSObject

@property (nonatomic,strong) AccidentModel *accident; //事故对象
@property (nonatomic,copy) NSArray<AccidentPicListModel *> *picList; //图片列表
@property (nonatomic,strong) AccidentVoModel *accidentVo;  //是否扣留对象 是否扣留车辆、驾驶证、行驶证、身份证放此对象中


@end
