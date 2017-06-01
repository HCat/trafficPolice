//
//  LLPhotoBrowser.h
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLPhotoBrowserDelegate;

typedef void(^photoBrowserDeleteBlock)(NSMutableDictionary * deleteImage);


@interface LLPhotoBrowser : UIViewController

@property (nonatomic, weak) id<LLPhotoBrowserDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * arr_upImages;

@property (nonatomic,copy) photoBrowserDeleteBlock deleteBlock;


- (instancetype)initWithupImages:(NSMutableArray<NSMutableDictionary *> *)arr_upImages currentIndex:(NSInteger)currentIndex;

- (instancetype)initWithImages:(NSMutableArray<UIImage *> *)images currentIndex:(NSInteger)currentIndex;



@end

@protocol LLPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(LLPhotoBrowser *)photoBrowser didSelectImage:(id)image;

@end
