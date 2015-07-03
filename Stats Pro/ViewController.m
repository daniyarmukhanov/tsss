//
//  ViewController.m
//  Stats Pro
//
//  Created by Daniyar Mukhanov on 7/1/15.
//  Copyright (c) 2015 Daniyar Mukhanov. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "Team.h"
#import "Matches.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *matches;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.matches=[NSMutableArray new];
    self.tableView.dataSource = self;
    [self getListOfMatches];
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.matches count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"forIndexPath:indexPath];
    Matches *match=self.matches[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ - %@", match.home, match.away];
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"MM-dd HH:mm"]; // Date formater
    NSDate *dd=match.date;
    NSString *date = [dateformate stringFromDate:dd];
    cell.detailTextLabel.text=date;
    return cell;
}

-(void) getListOfMatches{
    PFQuery *query = [PFQuery queryWithClassName:@"Matches"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
           // NSLog(@"%@", objects);
            
            for (PFObject *object in objects){
            Matches *match=[Matches new];
                NSString *hometeamId=object[@"home"];
                PFQuery *query = [PFQuery queryWithClassName:@"Teams"];
                [query getObjectInBackgroundWithId:hometeamId block:^(PFObject *team, NSError *error) {
                match.home=team[@"name"];
                
                }];
                
                NSString *awayteamId=object[@"away"];
                PFQuery *query2 = [PFQuery queryWithClassName:@"Teams"];
                [query2 getObjectInBackgroundWithId:awayteamId block:^(PFObject *team, NSError *error) {
                match.away=team[@"name"];
                    match.date=object[@"day"];
                    NSArray *array=object[@"comments"];
                    match.comments=[array mutableCopy];
                    NSLog(@"%@", match.home);
                    [self.matches addObject:match];
                    [self.tableView reloadData];
                }];
                
                
                
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

@end
