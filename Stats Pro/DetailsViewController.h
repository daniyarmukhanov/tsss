//
//  DetailsViewController.h
//  Stats Pro
//
//  Created by Daniyar Mukhanov on 7/6/15.
//  Copyright (c) 2015 Daniyar Mukhanov. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface DetailsViewController : ViewController

@property (nonatomic) PFObject *homeTeam;
@property (nonatomic) PFObject *awayTeam;


@end
