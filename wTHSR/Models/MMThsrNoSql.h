//
//  MMThsrNoSql.h
//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MMThsrSouthbound    @"southbound"
#define MMThsrNorthbound    @"northbound"

@class MMssdb;
@class MMThsr;

@interface MMThsrNoSql : NSObject

@property (nonatomic, strong) MMssdb *db;



+ (id)instance;
+ (void)createDefaultDataIfNeed;
+ (void)updateDataWithDictionary:(NSDictionary *)dict;

- (NSArray *)sounthbound;
- (NSArray *)northbound;
- (NSArray *)stations;


@end
