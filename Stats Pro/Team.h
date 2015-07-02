//
//  Team.h
//  Stats Pro
//
//  Created by Daniyar Mukhanov on 7/2/15.
//  Copyright (c) 2015 Daniyar Mukhanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Team : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *scored;
@property (nonatomic, strong) NSMutableArray *conceded;
@property (nonatomic, strong) NSMutableArray *corners;
@property (nonatomic, strong) NSMutableArray *fouls;
@property (nonatomic, strong) NSMutableArray *yellow;
@property (nonatomic, strong) NSMutableArray *winlose;
@property (nonatomic, strong) UIImage *logo;
@property (nonatomic) int rating;

@end
