//
//  ImageFileInfo.h
//  trafficPolice
//
//  Created by hcat on 2017/5/26.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFileInfo : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSString *mimeType;
@property(nonatomic,assign) long long filesize;
@property(nonatomic,strong) NSData *fileData;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,assign) float width;
@property(nonatomic,assign) float height;

-(id)initWithImage:(UIImage *)image withName:(NSString *)name;

@end
