//
//  THSRTableViewself.m
//  wTHSR
//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import "THSRTableViewCell.h"

#define COLUMN_OFFSET 10.0
#define COLUMN_WIDTH  50.0

//#define COLUMN_TIME 30.0


#define MAIN_FONT_SIZE 18.0
#define LABEL_HEIGHT 26.0

#define IMAGE_SIDE 30.0

@implementation THSRTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubviews];
    }
    return self;
}


- (void)createSubviews
{
//    CGSize cellSize = self.contentView.frame.size;
//    CGFloat py = (cellSize.height - LABEL_HEIGHT) / 2.0 - 8;
//    CGRect contentRect;
    
//    contentRect = CGRectMake(5, py, 30, LABEL_HEIGHT);
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectZero];
    labelView.tag = 91;
    [self.contentView addSubview:labelView];
    
//    contentRect = CGRectMake(cellSize.width - 80, 44-18, 80, 16);
    labelView = [[UILabel alloc] initWithFrame:CGRectZero];
    labelView.font = [UIFont systemFontOfSize:11];
    labelView.textColor = [UIColor darkGrayColor];
    labelView.tag = 92;
    [labelView setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:labelView];

    for (NSInteger i=0 ; i< self.numberOfStations; i++) {
        labelView = [self createLabel];
        labelView.tag = i+1;
        [self.contentView addSubview:labelView];
    }
    
    UIView *v = [self createView];
    v.tag = 999;
    [self.contentView addSubview:v];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat numberOfLine = 8;
    CGFloat trainNoSize = 40;
    CGFloat space = 10;
    CGSize cellSize = self.contentView.frame.size;
    CGFloat labelHeight = cellSize.height/2;
    CGFloat columnWidth = 0;
    CGRect contentRect;
    UILabel *labelView = nil;
    
    // line1: train no
    contentRect = CGRectMake(10, 0, trainNoSize-10, self.frame.size.height);
    UILabel *v = (UILabel*)[self viewWithTag:91];
    labelView.textAlignment = NSTextAlignmentCenter;
    v.frame = contentRect;
    

    // line1: station or time
    columnWidth = (cellSize.width - trainNoSize - space*2 - COLUMN_OFFSET*numberOfLine+1) / numberOfLine;
    NSInteger point = numberOfLine-(self.numberOfStations-5);
    CGRect secondContentRect = CGRectMake(CGRectGetMaxX(contentRect)+(columnWidth*point+COLUMN_OFFSET*point), 0, 0, 0);
    for (NSInteger i=0 ; i< 5; i++) {
        contentRect = CGRectMake(CGRectGetMaxX(contentRect)+COLUMN_OFFSET  , 0  , columnWidth, labelHeight);
        labelView = (UILabel *)[self viewWithTag:i+1];
        labelView.frame = contentRect;
    }
    
    // line1: operate
    CGFloat w = self.frame.size.width - CGRectGetMaxX(contentRect)-COLUMN_OFFSET*2;
    contentRect = CGRectMake(CGRectGetMaxX(contentRect)+COLUMN_OFFSET, 0, w, labelHeight);
    labelView = (UILabel *)[self viewWithTag:92];
    labelView.textAlignment = NSTextAlignmentLeft;
    labelView.minimumScaleFactor = 0.4;
    labelView.minimumFontSize = 6;
    labelView.frame = contentRect;
    
    
    // line2
    contentRect = secondContentRect;
    for (NSInteger i=0 ; i< self.numberOfStations-5; i++) {
        contentRect = CGRectMake(CGRectGetMaxX(contentRect)+COLUMN_OFFSET  , labelHeight  , columnWidth, labelHeight);
        labelView = (UILabel *)[self viewWithTag:i+1+5];
        labelView.frame = contentRect;
    }
    
    
    //
    UIView *t = (UIView *)[self viewWithTag:999];
    t.frame = CGRectMake(trainNoSize+5, 0, 1, self.contentView.frame.size.height);

}

- (UILabel *)createLabel
{
    UILabel *v = [[UILabel alloc] initWithFrame:CGRectZero];
    v.textAlignment = NSTextAlignmentLeft;
    v.adjustsFontSizeToFitWidth = YES;
    v.minimumScaleFactor = 0.5;
    v.minimumFontSize = 9;
    
    return v;
}


- (UIView *)createView
{
    UIView *v = nil;
    v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor darkTextColor];
    v.alpha = 0.2;
    return v;
}


@end
