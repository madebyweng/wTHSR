//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THSRTimetableViewController : UITableViewController

@property (nonatomic, strong) NSArray *trains;
@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) NSString *key;

@end