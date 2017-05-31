//
//  IllegalParkVC.h
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface IllegalParkVC : HideTabSuperVC

@property (nonatomic, strong) UIImage *img_carNumber; //车牌近照
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
