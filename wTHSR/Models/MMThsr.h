//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MMProperty.h"

@interface MMTrain : MMModel


@property (nonatomic, strong) NSString *operate;

@property (nonatomic, strong) NSString *train;
@property (nonatomic, strong) NSString *taipei;
@property (nonatomic, strong) NSString *banqiao;
@property (nonatomic, strong) NSString *taoyuan;
@property (nonatomic, strong) NSString *hsinchu;
@property (nonatomic, strong) NSString *miaoli;
@property (nonatomic, strong) NSString *taichung;
@property (nonatomic, strong) NSString *changhua;
@property (nonatomic, strong) NSString *chiayi;
@property (nonatomic, strong) NSString *yunlin;
@property (nonatomic, strong) NSString *tainan;
@property (nonatomic, strong) NSString *zuoying;

@property (nonatomic, strong) NSString *monday;
@property (nonatomic, strong) NSString *tuesday;
@property (nonatomic, strong) NSString *wednesday;
@property (nonatomic, strong) NSString *thursday;
@property (nonatomic, strong) NSString *friday;
@property (nonatomic, strong) NSString *saturday;
@property (nonatomic, strong) NSString *sunday;

@end



@interface MMThsr : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *trains;


@end
