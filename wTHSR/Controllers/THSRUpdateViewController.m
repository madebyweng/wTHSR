//
//  THSRUpdateViewController.m
//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import "THSRUpdateViewController.h"
#import <SBJson/JSON.h>
#import "MMThsrNoSql.h"

@interface THSRUpdateViewController (Private)
- (void)checkForUpdatesOfButton;
- (BOOL)checkForUpdates;

@end

@implementation THSRUpdateViewController

#pragma mark - UIView

- (void)viewWillAppear:(BOOL)animated
{	
	NSIndexPath *tableSelection = [myTableView indexPathForSelectedRow];
	[myTableView deselectRowAtIndexPath:tableSelection animated:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Update", @"");
		
	myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	myTableView.scrollEnabled = YES;
	[self.view addSubview: myTableView];
		
	//在載入時顯示圖形
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	activityIndicator.tag = 988;
	[self.view addSubview:activityIndicator];

    [self checkUpdateIfNeed];
    [myTableView reloadData];
}

- (void)viewDidLayoutSubviews {
    myTableView.frame = self.view.bounds;
    activityIndicator.center = self.view.center;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if( buttonIndex == 0 ) //NO
	{
		self.title = nil;
	}
	else
	{
		[self performSelectorOnMainThread:@selector(updateNow) withObject:nil waitUntilDone:YES];
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateEnd) userInfo:nil repeats:NO];
	}
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.items count]+1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.items.count) {
        return 0;
    }
	return  1 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

    if (self.items.count > indexPath.section) {
    
        NSDictionary *data = [self.items objectAtIndex:indexPath.section];
        cell.textLabel.text = data[@"title"];
    } else {
        cell.textLabel.text = nil;
    }
	return cell;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	
	if ([self.items count] > section){
		NSDictionary *data = [self.items objectAtIndex:section];
		return data[@"description"];
	}
	return nil;
}


- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
	
	if ( [self.items count] == section){
		NSString *tempHeader = [[NSString alloc] init];
		tempHeader = @"\n\n更新高鐵時刻表　　　　　　\n\n請選擇您所需要的時刻表資料\n點選後立即更新時刻表\n";
		return tempHeader;
	}

	return nil;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSDictionary *data = [self.items objectAtIndex:indexPath.section];
	self.currentItem = data;
		
	UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" 
													 message:NSLocalizedString(@"是否確定要更新資料", nil) 
													delegate:self 
										   cancelButtonTitle:nil 
										   otherButtonTitles:NSLocalizedString(@"Cancel", nil) ,NSLocalizedString(@"OK", nil), nil];
	[alert1 show];
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - Check Update

- (void)checkUpdateIfNeed
{
    [activityIndicator startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkUpdateIfNeedInBackground) userInfo:nil repeats:NO];
    
}
- (BOOL)checkUpdateIfNeedInBackground
{
    NSString	*URLString	= [NSString stringWithFormat:@"https://s3.amazonaws.com/w-e-n-g/thsr_update.json"];
    NSURL       *addressURL = [NSURL URLWithString: URLString];
    NSString    *jsonString = [[NSString alloc] initWithContentsOfURL:addressURL encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *json = [jsonString JSONValue];
    self.items = json[@"hits"];
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [activityIndicator stopAnimating];
    [myTableView reloadData];
    return YES;
}


- (void)updateDB
{
    NSString *URLString = self.currentItem[@"url"];
    NSURL    *addressURL = [NSURL URLWithString: URLString];
    NSString *string = [[NSString alloc] initWithContentsOfURL:addressURL encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *json = [string JSONValue];
    
    [MMThsrNoSql updateDataWithDictionary:json];
}

- (void)updateNow
{
    alert = [[UIAlertView alloc] initWithTitle:@"下傳中...."
                                       message:@" "
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    
    UIActivityIndicatorView *updateActivityIndicator= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    updateActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [alert addSubview:updateActivityIndicator];
    [alert show];
    [updateActivityIndicator startAnimating];
}

- (void)updateEnd
{
    [self performSelectorOnMainThread:@selector(updateDB) withObject:nil waitUntilDone:YES];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    NSIndexPath *tableSelection = [myTableView indexPathForSelectedRow];
    [myTableView deselectRowAtIndexPath:tableSelection animated:NO];
    self.title = @"時刻表已經更新完成";	
    
}

@end
