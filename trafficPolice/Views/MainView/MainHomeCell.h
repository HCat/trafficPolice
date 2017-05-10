//
//  MainHomeCell.h
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainHomeVCDelegate;

@interface MainHomeCell : UITableViewCell
@property (nonatomic,weak) id<MainHomeVCDelegate> delegate;


- (void)createCell:(NSString *)title withItems:(NSArray *)arr_item;

@end

@protocol MainHomeVCDelegate <NSObject>

- (void)itemClickInCell:(MainHomeCell *)cell withIndex:(NSInteger)index;


@end
