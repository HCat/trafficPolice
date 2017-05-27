//
//  SearchLocationVC.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/27.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "BaseViewController.h"
#import "HideTabSuperVC.h"
#import "AccidentAPI.h"

typedef void(^SearchLocationBlock)(AccidentGetCodesModel *model);

@interface SearchLocationVC : HideTabSuperVC

@property (nonatomic,copy) SearchLocationBlock searchLocationBlock;

@end
