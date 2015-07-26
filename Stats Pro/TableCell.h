//
//  TableCell.h
//  Stats Pro
//
//  Created by Daniyar Mukhanov on 7/25/15.
//  Copyright (c) 2015 Daniyar Mukhanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *homeTeam;
@property (weak, nonatomic) IBOutlet UILabel *awayTeam;
@property (weak, nonatomic) IBOutlet UILabel *timeDay;
@property (weak, nonatomic) IBOutlet UILabel *timeHour;

@end
