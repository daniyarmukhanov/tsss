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
#import "DetailsViewController.h"
#import "TableCell.h"
@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *matches;
@property (nonatomic) int currentMatch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.attributedTitle= [[NSMutableAttributedString alloc] initWithString:@"Загрузка..."];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(getListOfMatches)
                  forControlEvents:UIControlEventValueChanged];
    
    self.matches=[NSMutableArray new];
    self.tableView.dataSource = self;
    self.tableView.delegate=self;
    [self getListOfMatches];
    [self.tableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.refreshControl];
    
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
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell" forIndexPath:indexPath];
    if (cell == nil)
    {
       // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        [tableView registerNib:[UINib nibWithNibName:@"CellDesign" bundle:nil ]forCellReuseIdentifier:@"SimpleTablecell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell"];
        //cell = [nib objectAtIndex:0];
        NSLog(@"LOL");
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Matches *match=self.matches[indexPath.row];
    cell.homeTeam.text=match.home;
    cell.awayTeam.text=match.away;
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd MMMM"]; // Date formater
    NSLocale *RU=[[NSLocale alloc]initWithLocaleIdentifier:@"ru_RU"];
    
    dateformate.locale=RU;
        NSDate *dd=match.date;
        NSString *date = [dateformate stringFromDate:dd];
        cell.timeDay.text=date;
        [dateformate setDateFormat:@"HH:mm"]; // Date formater
        dd=match.date;
        date = [dateformate stringFromDate:dd];
        cell.timeHour.text=date;
    return cell;
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(TableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    Matches *match=self.matches[indexPath.row];
//    cell.homeTeam.text=match.home;
//    cell.awayTeam.text=match.away;
//    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
//    [dateformate setDateFormat:@"MM-dd"]; // Date formater
//    NSDate *dd=match.date;
//    NSString *date = [dateformate stringFromDate:dd];
//    cell.timeDay.text=date;
//    [dateformate setDateFormat:@"HH-mm"]; // Date formater
//    dd=match.date;
//    date = [dateformate stringFromDate:dd];
//    cell.timeHour.text=date;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentMatch=(int)indexPath.row;
    //NSLog(@"CURRENT %d", self.currentMatch);
    
    [self performSegueWithIdentifier:@"Details" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"Details"])
    {
        DetailsViewController *vc = segue.destinationViewController;
        Matches *match=[Matches new];
        match=self.matches[self.currentMatch];
      //  NSLog(@"CURRENT %d", self.currentMatch);
        vc.homeTeam=match.homeTeam;
        vc.awayTeam=match.awayTeam;
        vc.match=match;
    }
}

-(void) getListOfMatches{
    PFQuery *query = [PFQuery queryWithClassName:@"Matches"];
    //[query fromLocalDatastore];
    [query addAscendingOrder:@"day"];
    [self.matches removeAllObjects];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
        // The find succeeded. The first 100 objects are available in objects
        // NSLog(@"%@", objects);
            [PFObject pinAllInBackground:objects];
            
            for (PFObject *object in objects){
            Matches *match=[Matches new];
                NSString *hometeamId=object[@"home"];
                PFQuery *query = [PFQuery queryWithClassName:@"Teams"];
                [query getObjectInBackgroundWithId:hometeamId block:^(PFObject *team, NSError *error) {
                match.home=team[@"name"];
                    match.homeTeam=team;
                    [team pinInBackground];
                
                }];
                
                NSString *awayteamId=object[@"away"];
                PFQuery *query2 = [PFQuery queryWithClassName:@"Teams"];
                [query2 getObjectInBackgroundWithId:awayteamId block:^(PFObject *team, NSError *error) {
                match.away=team[@"name"];
                    [team pinInBackground];
                    match.awayTeam=team;
                    match.date=object[@"day"];
                    int timestamp=[match.date timeIntervalSince1970];
                    timestamp-=21600;
                    match.date=[NSDate dateWithTimeIntervalSince1970:timestamp];
                    NSArray *array=object[@"comments"];
                    match.comments=[array mutableCopy];
                    //NSLog(@"%@", match.home);
                    [self.matches addObject:match];
                    [self.tableView reloadData];
                }];
                
                
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
    
    [self.refreshControl endRefreshing];
}


-(void) getListOfMatchesOffline{
    PFQuery *query = [PFQuery queryWithClassName:@"Matches"];
    [query fromLocalDatastore];
    [query addAscendingOrder:@"day"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            // NSLog(@"%@", objects);
            [PFObject pinAllInBackground:objects];
            
            for (PFObject *object in objects){
                Matches *match=[Matches new];
                NSString *hometeamId=object[@"home"];
                PFQuery *query = [PFQuery queryWithClassName:@"Teams"];
                [query getObjectInBackgroundWithId:hometeamId block:^(PFObject *team, NSError *error) {
                    match.home=team[@"name"];
                    match.homeTeam=team;
                    [team pinInBackground];
                    
                }];
                
                NSString *awayteamId=object[@"away"];
                PFQuery *query2 = [PFQuery queryWithClassName:@"Teams"];
                [query2 getObjectInBackgroundWithId:awayteamId block:^(PFObject *team, NSError *error) {
                    match.away=team[@"name"];
                    [team pinInBackground];
                    match.awayTeam=team;
                    match.date=object[@"day"];
                    NSArray *array=object[@"comments"];
                    match.comments=[array mutableCopy];
                    //NSLog(@"%@", match.home);
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

//- (void) fetchDataFromLocalstore: (BOOL) fromLocalStore loader:(BOOL)loader{
//    PFQuery *query = [PFQuery queryWithClassName:@"Tamada"];
//    if(fromLocalStore){
//        [query fromLocalDatastore];
//    }
//    if (loader) {
//        [KVNProgress show];
//    }
//    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
//        [KVNProgress dismiss];
//        if(!error){
//            if([objects count] == 0){
//                if(fromLocalStore){
//                    [self fetchDataFromLocalstore:NO loader:YES];
//                }
//            }
//            else{
//                self.regularTamadas = [NSMutableArray new];
//                self.proTamadas = [NSMutableArray new];
//                for (Tamada *tamada in objects) {
//                    if ([tamada.isPro boolValue]) {
//                        [self.proTamadas addObject:tamada];
//                    }
//                    else {
//                        [self.regularTamadas addObject:tamada];
//                    }
//                    [self.tableView reloadData];
//                }
//                [PFObject pinAllInBackground:objects];
//            }
//        }
//        else{
//            NSString *errorString = [error userInfo][@"error"];
//            [UIAlertView alertView:errorString];
//        }
//    }];
//}

@end
