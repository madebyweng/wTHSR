//
//  MySSDB.h
//  ssdb-ios
//
//  Created by ideawu on 8/7/15.
//  Copyright (c) 2015 ideawu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySSDB : NSObject

+ (MySSDB *)open:(NSString *)path;

- (void)close;

- (BOOL)set:(NSString *)key string:(NSString *)string;
- (BOOL)set:(NSString *)key data:(NSData *)data;
/**
 * found:     ret=YES & string != nil
 * not_found: ret=YES & string == nil
 * error:     ret=NO
 */
- (BOOL)get:(NSString *)key string:(NSString **)string;
- (BOOL)get:(NSString *)key data:(NSData **)data;
- (BOOL)del:(NSString *)key;
@end



/*
 MySSDB *db = [MySSDB open:@"ssdb"];
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
*/