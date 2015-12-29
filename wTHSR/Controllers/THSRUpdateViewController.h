//
//  THSRUpdateViewController.h
//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface THSRUpdateViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
	UITableView *myTableView;
	UIActivityIndicatorView *activityIndicator;
	UIAlertView *alert;
}

@property (nonatomic, copy)   NSArray *items;
@property (nonatomic, strong) NSDictionary *currentItem;


- (void)updateDB;

@end
