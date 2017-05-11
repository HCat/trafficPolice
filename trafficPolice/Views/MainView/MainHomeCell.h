//
//  MainHomeCell.h
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainHomeCellDelegate;

@interface MainHomeCell : UITableViewCell
@property (nonatomic,weak) id<MainHomeCellDelegate> delegate;


- (void)createCell:(NSString *)title withItems:(NSArray *)arr_item;

@end

@protocol MainHomeCellDelegate <NSObject>

- (void)itemClickInCell:(MainHomeCell *)cell withIndex:(NSInteger)index;


@end
