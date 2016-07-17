//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import "THSRSelectViewController.h"
#import "THSRTimetableViewController.h"
#import "MMThsr.h"
#import "MMThsrNoSql.h"
#import "THSRUpdateViewController.h"
#import <objc/message.h>
#import "VTAcknowledgementsViewController.h"
#import "WebViewController.h"


#define ROW_HEIGHT 80

@interface THSRSelectViewController ()
@end

@implementation THSRSelectViewController


#pragma mark UIViewController

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.rowHeight = ROW_HEIGHT;
	self.title = @"台灣高鐵時刻表";
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
//    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight );

}

#pragma mark UITableViewDataSource
#pragma mark UITableViewDataSource
//游標
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 1;
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    
    if (indexPath.row == 4) {
        cell.textLabel.text = NSLocalizedString(@"Open Source",@"");
        cell.textLabel.font = [UIFont systemFontOfSize:29];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        return cell;
    }
    
    
    if (indexPath.row == 3){
        cell.textLabel.text = NSLocalizedString(@"LICENSE",@"");
        cell.textLabel.font = [UIFont systemFontOfSize:29];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        return cell;
    }
    
    NSArray *title = @[NSLocalizedString(@"South", @""), NSLocalizedString(@"North", @""), NSLocalizedString(@"Update", @"")];
    cell.textLabel.text = [title objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:29];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 0;
    }
    
    return ROW_HEIGHT; // this is the generic cell height
}


//選擇的項目
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return;
    }
    
    if (indexPath.row == 4) {
        WebViewController *w = [[WebViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:w animated:YES];
        return;
    }
    
    if (indexPath.row == 3) {
        VTAcknowledgementsViewController *viewController = [VTAcknowledgementsViewController acknowledgementsViewController];
        viewController.headerText = NSLocalizedString(@"We love open source software.", nil); // optional
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    if (indexPath.row == 2){
        THSRUpdateViewController *viewController = [[THSRUpdateViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    THSRTimetableViewController *viewController = [[THSRTimetableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    if (indexPath.row == 0){
        viewController.title = NSLocalizedString(@"Southbound Trains", nil);
        viewController.key = MMThsrSouthbound;
    } else {
        viewController.title = NSLocalizedString(@"Northbound Trains", nil);
        viewController.key = MMThsrNorthbound;
    }
    
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

// ios <= 6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) |
            (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}


// ios > 6
// 是否支持轉屏
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


@end

