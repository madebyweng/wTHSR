    //
//  FTHSRSelectViewController.m
//  wTHSR_03r
//
//  Created by madebyweng on 2011/4/1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTHSRSelectViewController.h"
#import "HWAds.h"
#import "HWHomeAd.h"

@implementation FTHSRSelectViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect frame = CGRectMake(0, 0, 320, 50);
	homeAd = [[HWHomeAd alloc] initWithFrame:frame];
	[homeAd loadRequestWithString:@"http://madebyweng.appspot.com/apps/thsr/"];
	homeAd.rootViewController = self;
	//[self.view addSubview:homeAd];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[homeAd requestFreshAd];
}



- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSLog(@"viewDidAppear");
	self.tableView.tableFooterView = nil;
	self.tableView.tableFooterView = [homeAd view];
	[self.tableView reloadData];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];	
	[self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section { 
	
	if (section == 0 ) {
		return homeAd;
	}
	return tableView.tableFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { 
	if(section == 0) { 		
		return homeAd.frame.size.height;
	} 
	
	return 0;
}
*/
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[[HWAds sharedAdsWithDelegate:self] newAd];
	
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	HWLog(@"");
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section { 
	
	if (section == 0 ) {
		return [[HWAds sharedAdsWithDelegate:self] view];
	}
	return tableView.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { 
	if(section == 0) { 		
		return [[HWAds sharedAdsWithDelegate:self] view].frame.size.height;
	} 
	
	return 0;
}
*/
@end
