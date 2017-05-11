//
//  ListBaseVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/11.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ListBaseVC.h"
#import "ListTableCell.h"


@interface ListBaseVC ()

@end

@implementation ListBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableCellID"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ListTableCell" bundle:nil] forCellReuseIdentifier:@"ListTableCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
