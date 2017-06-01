//
//  IllegalParkAddHeadView.h
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalParkAPI.h"

@protocol IllegalParkAddHeadViewDelegate <NSObject>

-(void)recognitionCarNumber:(ImageFileInfo *)imageInfo;

@end


@interface IllegalParkAddHeadView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber; //车牌号
@property (weak, nonatomic) IBOutlet UITextField *tf_roadSection; //选择路段
@property (weak, nonatomic) IBOutlet UITextField *tf_address; //所在位置
@property (weak, nonatomic) IBOutlet UITextField *tf_addressRemarks; //地址备注

@property (nonatomic,strong) IllegalParkSaveParam *param;

@property (nonatomic,assign) BOOL isCanCommit;

@property (nonatomic,weak) id<IllegalParkAddHeadViewDelegate>delegate;

-(BOOL)juegeCanCommit;


@end
