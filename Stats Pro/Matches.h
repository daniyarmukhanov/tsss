//
//  Matches.h
//  Stats Pro
//
//  Created by Daniyar Mukhanov on 7/2/15.
//  Copyright (c) 2015 Daniyar Mukhanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matches : NSObject

@property (nonatomic, strong) NSString *home;
@property (nonatomic, strong) NSString *away;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSDate *date;

@end
