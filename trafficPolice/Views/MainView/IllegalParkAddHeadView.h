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
@property (nonatomic,strong) IllegalParkSaveParam *param;
@property (nonatomic,assign) BOOL isCanCommit;

@property (nonatomic,weak) id<IllegalParkAddHeadViewDelegate>delegate;

@end
