//
//  CountAccidentHelper.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/28.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "CountAccidentHelper.h"
#import "ShareFun.h"
#import "AccidentAPI.h"
#import "AlertView.h"

@interface CountAccidentHelper()




@end


@implementation CountAccidentHelper
LRSingletonM(Default)




- (void)setCarNo:(NSString *)carNo{

    _carNo = carNo;
    
    if (_carNo) {
        
        if ([ShareFun validateCarNumber:_carNo]) {
            
            AccidentCountByCarNoManger *manger = [AccidentCountByCarNoManger new];
            
            manger.carNo = _carNo;
            manger.state = _state;
            manger.isNeedShowHud = NO;
            
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                if (manger.responseModel.code == CODE_SUCCESS) {
                    
                    AccidentCountModel *accidentCountModel = manger.accidentCountModel;
                    
                    if (accidentCountModel) {
                        
                        if (accidentCountModel.accidentWeek > 2 || accidentCountModel.accidentYear > 3) {
                            
                            NSString *t_string = [NSString stringWithFormat:@"该车辆近一个月内发生过%d起交通事故,近一年内发生过%d起交通事故",accidentCountModel.accidentWeek,accidentCountModel.accidentYear];
                            
                            [AlertView showWindowWithTitle:@"提示" contents:t_string];
                            
                        }
                        
                    }
                    
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
            
        }
        
    }

}

- (void)setIdNo:(NSString *)idNo{
    
    _idNo = idNo;
    
    if (_idNo) {
        
        if ([ShareFun validateIDCardNumber:_idNo]) {
            
            AccidentCountByidNoManger *manger = [AccidentCountByidNoManger new];
            
            manger.idNo = _idNo;
            manger.state = _state;
            manger.isNeedShowHud = NO;
            
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                if (manger.responseModel.code == CODE_SUCCESS) {
                    
                    AccidentCountModel *accidentCountModel = manger.accidentCountModel;
                    
                    if (accidentCountModel) {
                        
                        if (accidentCountModel.accidentWeek > 2 || accidentCountModel.accidentYear > 3) {
                            
                            NSString *t_string = [NSString stringWithFormat:@"该车辆近一个月内发生过%d起交通事故,近一年内发生过%d起交通事故",accidentCountModel.accidentWeek,accidentCountModel.accidentYear];
                        
                            [AlertView showWindowWithTitle:@"提示" contents:t_string];
                            
                        }
                        
                    }
                    
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
        }
    }

}

- (void)setTelNum:(NSString *)telNum{
    
    _telNum = telNum;
    
    if (_telNum) {
        
        if ([ShareFun validatePhoneNumber:_telNum]) {
            
            AccidentCountByTelNumManger *manger = [AccidentCountByTelNumManger new];
            
            manger.telNum = _telNum;
            manger.state = _state;
            manger.isNeedShowHud = NO;
            
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                if (manger.responseModel.code == CODE_SUCCESS) {
                    
                    AccidentCountModel *accidentCountModel = manger.accidentCountModel;
                    
                    if (accidentCountModel) {
                        
                        if (accidentCountModel.accidentWeek > 2 || accidentCountModel.accidentYear > 3) {
                            NSString *t_string = [NSString stringWithFormat:@"该车辆近一个月内发生过%d起交通事故,近一年内发生过%d起交通事故",accidentCountModel.accidentWeek,accidentCountModel.accidentYear];
                            
                            [AlertView showWindowWithTitle:@"提示" contents:t_string];
                            
                        }
                       
                    }
                    
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                
            }];
        }
    }
    
}

@end
