//
//  UserHomeCell.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/12.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "UserHomeCell.h"


@interface UserHomeCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgV_content;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;


@end

@implementation UserHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUpCellInsideView:(NSDictionary *)dic_source{

    if (dic_source) {
        self.dic_source = dic_source;
        self.imgV_content.image = [UIImage imageNamed:[dic_source objectForKey:@"image"]];
        self.lb_content.text  = [dic_source objectForKey:@"title"];
    }
    


}


@end
