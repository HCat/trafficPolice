//
//  AccidentAddFootView.h
//  trafficPolice
//
//  Created by hcat on 2017/5/23.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentAPI.h"

@interface AccidentAddFootView : UICollectionReusableView

@property (nonatomic,assign) BOOL isShowMoreAccidentInfo;
@property (nonatomic,assign) BOOL isShowMoreInfo;
@property (nonatomic,strong) AccidentSaveParam *param;

@end
