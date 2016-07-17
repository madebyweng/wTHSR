//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import "THSRSelectViewController.h"
#import "THSRTimetableViewController.h"
#import "THSRTableViewCell.h"
#import "UIColor-MoreColors.h"
#import "MMThsr.h"
#import "MMThsrNoSql.h"

#define ROW_HEIGHT 65

@implementation THSRTimetableViewController

#pragma mark UIViewController

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    
    self.tableView.rowHeight = ROW_HEIGHT;
    
    if ([self.key isEqualToString:MMThsrSouthbound]) {
        
        self.trains = [[MMThsrNoSql instance] sounthbound];
        self.stations = [[MMThsrNoSql instance] stations];
    } else {
        self.trains = [[MMThsrNoSql instance] northbound];
        NSArray *ary = [[MMThsrNoSql instance] stations];
        NSMutableArray *t = [NSMutableArray new];
        for (NSUInteger i = ary.count; i>0; i--) {
            [t addObject:ary[i-1]];
        }
        self.stations = t;
    }
}


- (void)viewWillAppear:(BOOL)animated {
}

#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    
    return self.trains.count;
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    
    if (section == 0) {
        return nil;
    }
    
    THSRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header"];
    if (cell == nil) {
        cell = [[THSRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"header"];
        cell.numberOfStations = self.stations.count;
        [cell createSubviews];
    }
    
    cell.backgroundColor = [UIColor deepPeach];
    UILabel *label = nil;
    label = (UILabel*)[cell viewWithTag:91];
    label.text = @"NO";
    
    label = (UILabel*)[cell viewWithTag:92];
    label.text = NSLocalizedString(@"OperateLabel", @"行駛日");
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor redColor];
    
    
    for (NSInteger i = 0; i<self.stations.count; i++) {
        NSDictionary *s = self.stations[i];
        label = (UILabel*)[cell viewWithTag:i+1];
        label.text = NSLocalizedString(s[@"value"], @"station");
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        return 0;
    }
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ad"];
        return c;
    }
    
    static NSString *CellIdentifier = @"TimetableCell";
    THSRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[THSRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.numberOfStations = self.stations.count;
        [cell createSubviews];
    }
    
    
    MMTrain *train = [self.trains objectAtIndex:indexPath.row];
    
    // 車號
    NSString *number = [train trainValueForKey:@"train"];
    UILabel *txtView;
    txtView = (UILabel*)[cell viewWithTag:91];
    txtView.text = [@"" stringByAppendingFormat:@"%d", number.intValue];
    txtView.adjustsFontSizeToFitWidth = YES;
    
    // 營運日期
    NSString *_operate = [train trainValueForKey:@"operate"];
    NSString *operate = @"";
    if (_operate) {
        NSArray *days = [_operate componentsSeparatedByString:@","];
        
        for (NSString *k in days) {
            
            if (operate.length) {
                operate = [operate stringByAppendingString:@", "];
            }
            operate = [operate stringByAppendingString:NSLocalizedString(k, nil)];
            
        }
    }
    txtView = (UILabel*)[cell viewWithTag:92];
    txtView.text = operate;
    txtView.textColor = [UIColor redColor];
    
    
    // 顯示各車站時間
    int i =1;
    for (NSDictionary *s in self.stations) {
        NSString *station = [train trainValueForKey:[s[@"value"] lowercaseString]];
        txtView = (UILabel*)[cell viewWithTag:i];
        txtView.text = station;
        i++;
    }
    
    
    
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor babyBlue];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}




@end

