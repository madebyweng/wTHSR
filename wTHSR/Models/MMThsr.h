//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MMProperty.h"

@interface MMTrain : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (NSString *)trainValueForKey:(NSString *)key;

@end



@interface MMThsr : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *trains;


@end
