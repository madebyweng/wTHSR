//
//  MMThsrNoSql.m
//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import "MMThsrNoSql.h"
#import "MMThsr.h"
#import <SBJson/JSON.h>
#import "MMssdb.h"

@interface MMThsrNoSql ()
@property (nonatomic, strong) NSDictionary *station;
@end


@implementation MMThsrNoSql

+ (id)instance {
    static MMThsrNoSql *_sharedNoSQL = nil;
    if(!_sharedNoSQL) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedNoSQL = [[self alloc] init];
            _sharedNoSQL.db = (id)[MMssdb open:@"db"];
        });
    }
    
    return _sharedNoSQL;
}


+ (NSString *)docsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (void)createDefaultDataIfNeed
{
    //    NSString *dir = [[MMThsrNoSql docsPath] stringByAppendingPathComponent:@"db"];
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:dir] ) {
    //        return;
    //    }
    
    MMssdb *db = [[MMThsrNoSql instance] db];
    NSString *p = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString *string = [NSString stringWithContentsOfFile:p encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *json = string.JSONValue;
    
    // version
    NSNumber *v = json[@"version"];
    NSString *version = [[MMThsrNoSql instance] dbVersion];
    if (version && version.intValue < v.intValue) {
        return;
    }
    
    if (!v && [version isEqual:@""]) {
        return;
    }
    if (v) {
        [db set:@"version" string:v.stringValue];
    }
    
    
    // station
    NSDictionary *station = json[@"station"];
    if (station) {
        [db set:@"station" string:station.JSONFragment];
    }
    
    
    // timetable
    NSDictionary *s = json[MMThsrSouthbound];
    NSDictionary *n = json[MMThsrNorthbound];
    if (s) {
        [db set:MMThsrSouthbound string:s.JSONFragment];
    }
    if (n) {
        [db set:MMThsrNorthbound string:n.JSONFragment];
    }
    
}


+ (void)test
{
    BOOL ret;
    MMssdb *db = (id)[MMssdb open:@"ssdb"];
    NSString *key = @"key";
    NSString *content = @"www";
    NSString *val = nil;
    
    [db set:key string:content];
    [db get:key string:&val];
    NSLog(@"val=%@", val);
    
    [db del:key];
    
    val = nil;
    ret = [db get:key string:&val];
    if(!ret){
        NSLog(@"db error");
    }else if(val == nil){
        NSLog(@"not found");
    }else{
        NSLog(@"val=%@", val);
    }
    
    [db close]; // close db
}

+ (void)updateDataWithDictionary:(NSDictionary *)dict
{
    MMssdb *db = [[MMThsrNoSql instance] db];
    NSDictionary *s = dict[MMThsrSouthbound];
    NSDictionary *n = dict[MMThsrNorthbound];
    NSDictionary *station = dict[@"station"];
    if (s) {
        [db set:MMThsrSouthbound string:s.JSONFragment];
    }
    if (n) {
        [db set:MMThsrNorthbound string:n.JSONFragment];
    }
    if (station) {
        [db set:@"station" string:station.JSONFragment];
    }
}

- (NSString *)dbVersion
{
    NSString *val = nil;
    [self.db get:@"version" string:&val];
    return val;
}


- (NSArray *)sounthbound
{
    NSString *val = nil;
    [self.db get:MMThsrSouthbound string:&val];
    
    NSArray *trains = val.JSONValue;
    NSMutableArray *items = [NSMutableArray new];
    for (NSDictionary *item in trains) {
        MMTrain *t = [MMTrain new];
        t.data = item;
        [items addObject:t];
    }
    
    
    return [NSArray arrayWithArray:items];
    
}
- (NSArray *)northbound
{
    NSString *val = nil;
    [self.db get:MMThsrNorthbound string:&val];
    NSArray *trains = val.JSONValue;
    
    NSMutableArray *items = [NSMutableArray new];
    for (NSDictionary *item in trains) {
        MMTrain *t = [MMTrain new];
        t.data = item;
        [items addObject:t];
    }
    
    return [NSArray arrayWithArray:items];
}

- (NSArray *)stations
{
    
    if (!self.station) {
        NSString *val = nil;
        [self.db get:@"station" string:&val];
        NSDictionary *dict = val.JSONValue;
        self.station = dict;
    }
    
    return self.station[@"hits"];
}

@end
