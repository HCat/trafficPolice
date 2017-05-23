//
//  UserHomeCell.h
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/12.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHomeCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *dic_source;

- (void)setUpCellInsideView:(NSDictionary *)dic_source;

@end
