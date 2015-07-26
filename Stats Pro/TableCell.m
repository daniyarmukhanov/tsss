//
//  TableCell.m
//  Stats Pro
//
//  Created by Daniyar Mukhanov on 7/25/15.
//  Copyright (c) 2015 Daniyar Mukhanov. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell
@synthesize homeTeam=_homeTeam;
@synthesize awayTeam=_awayTeam;
@synthesize timeDay=_timeDay;
@synthesize timeHour=_timeHour;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
