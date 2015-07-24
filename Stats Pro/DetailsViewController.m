//
//  DetailsViewController.m
//  Stats Pro
//
//  Created by Daniyar Mukhanov on 7/6/15.
//  Copyright (c) 2015 Daniyar Mukhanov. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *redDot;
@property (weak, nonatomic) IBOutlet UIImageView *orangeDot;
@property (nonatomic)  NSMutableArray *home;
@property (nonatomic) NSMutableArray *away;
@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@property (weak, nonatomic) IBOutlet UIImageView *awayImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScored;
@property (weak, nonatomic) IBOutlet UILabel *awayScored;
@property (weak, nonatomic) IBOutlet UIView *awayScoredBar;
@property (weak, nonatomic) IBOutlet UILabel *homeConceded;
@property (weak, nonatomic) IBOutlet UILabel *awayConceded;
@property (weak, nonatomic) IBOutlet UIView *awayConcededBar;
@property (weak, nonatomic) IBOutlet UILabel *homeCorner;
@property (weak, nonatomic) IBOutlet UILabel *awayCorner;
@property (weak, nonatomic) IBOutlet UIView *cornerBar;
@property (weak, nonatomic) IBOutlet UILabel *homeFoul;
@property (weak, nonatomic) IBOutlet UILabel *awayFoul;
@property (weak, nonatomic) IBOutlet UIView *foulsBar;
@property (weak, nonatomic) IBOutlet UILabel *homeYellow;
@property (weak, nonatomic) IBOutlet UILabel *awayYellow;
@property (weak, nonatomic) IBOutlet UIView *yellowBar;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UILabel *dateText;





@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=[NSString stringWithFormat:@"%@ - %@", self.homeTeam[@"name"], self.awayTeam[@"name"] ];
    self.home=[NSMutableArray new];
    self.away=[NSMutableArray new];
    self.orangeDot.backgroundColor=[self colorWithHexString:@"f5a623"];
    self.redDot.backgroundColor = [self colorWithHexString:@"d0021b"];
    [self.away addObject:self.orangeDot];
    [self.home addObject:self.redDot];
   for (int i=0; i<4; i++) {
    UIImageView *dot = [UIImageView new];
    dot.image = [UIImage imageNamed:@"circle.png"];
    dot.backgroundColor = [self colorWithHexString:@"b8e986"];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
       
    [self.view addSubview:dot];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeRight multiplier:1 constant:(5*(i+1))+(17*i)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
       [self.home addObject:dot];
    }
    for (int i=0; i<4; i++) {
    UIImageView *dot = [UIImageView new];
    dot.image = [UIImage imageNamed:@"circle.png"];
    dot.backgroundColor = [self colorWithHexString:@"b8e986"];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:dot];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orangeDot attribute:NSLayoutAttributeRight multiplier:1 constant:-39-(i*22)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self.away addObject:dot];
    }
    self.away =[[[self.away reverseObjectEnumerator]allObjects] mutableCopy];
//   NSLog(@"%@",self.awayTeam);
   
    PFFile *file=self.homeTeam[@"logo"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.homeImage.image=image;
            // image can now be set on a UIImageView
        }
    }];
    file=self.awayTeam[@"logo"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.awayImage.image=image;
            // image can now be set on a UIImageView
        }
    }];
    
    self.homeImage.contentMode = UIViewContentModeCenter;
    self.homeImage.contentMode = UIViewContentModeScaleAspectFit;
    self.awayImage.contentMode = UIViewContentModeCenter;
    self.awayImage.contentMode = UIViewContentModeScaleAspectFit;
    
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"HH:mm"]; // Date formater
    NSDate *dd=self.match.date;
    NSString *date = [dateformate stringFromDate:dd];
    self.dateText.text=date;
    
    [self showText];
    [self colorResults];
    [self showComments];
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showText{
    NSArray *homescored=self.homeTeam[@"scored"];
    double avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumFractionDigits = 1;
    formatter.maximumFractionDigits = 2;
    formatter.minimumSignificantDigits=1;
    NSString *myString = [formatter stringFromNumber:@(avg)];
    self.homeScored.text=myString;
    
    homescored=self.awayTeam[@"scored"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.awayScored.text=myString;
    
    homescored=self.homeTeam[@"conceded"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.homeConceded.text=myString;
    
    homescored=self.awayTeam[@"conceded"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.awayConceded.text=myString;
    
    homescored=self.homeTeam[@"corners"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.homeCorner.text=myString;
    
    homescored=self.awayTeam[@"corners"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.awayCorner.text=myString;
    
    homescored=self.homeTeam[@"fouls"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.homeFoul.text=myString;
    
    homescored=self.awayTeam[@"fouls"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.awayFoul.text=myString;
    
    homescored=self.homeTeam[@"yellow"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.homeYellow.text=myString;
    
    homescored=self.awayTeam[@"yellow"];
    avg=0;
    for (int i=0; i<5; i++) {
        NSNumber *tmp=homescored[i];
        avg+=[tmp intValue];
    }
    avg=avg/5;
    myString = [formatter stringFromNumber:@(avg)];
    self.awayYellow.text=myString;
    
    
    
    [self adjustBars];
}

-(void) adjustBars{
    double width = self.awayScoredBar.bounds.size.width;
    double sum=[self.homeScored.text doubleValue]+[self.awayScored.text doubleValue];
    UIView *homeScoredBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*[self.homeScored.text doubleValue]/sum, 18)];
    [homeScoredBar setBackgroundColor:[self colorWithHexString:@"b8e986"]];
    self.awayScoredBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    [self.awayScoredBar addSubview:homeScoredBar];
    if([self.homeScored.text doubleValue]<[self.awayScored.text doubleValue]){
        self.awayScoredBar.backgroundColor=[self colorWithHexString:@"b8e986"];
        homeScoredBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    }
    
    sum=[self.homeConceded.text doubleValue]+[self.awayConceded.text doubleValue];
    homeScoredBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*[self.homeConceded.text doubleValue]/sum, 18)];
    [homeScoredBar setBackgroundColor:[self colorWithHexString:@"b8e986"]];
    self.awayConcededBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    [self.awayConcededBar addSubview:homeScoredBar];
    if([self.homeConceded.text doubleValue]<[self.awayConceded.text doubleValue]){
        self.awayConcededBar.backgroundColor=[self colorWithHexString:@"b8e986"];
        homeScoredBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    }
    
    sum=[self.homeCorner.text doubleValue]+[self.awayCorner.text doubleValue];
    homeScoredBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*[self.homeCorner.text doubleValue]/sum, 18)];
    [homeScoredBar setBackgroundColor:[self colorWithHexString:@"b8e986"]];
    self.cornerBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    [self.cornerBar addSubview:homeScoredBar];
    if([self.homeCorner.text doubleValue]<[self.awayCorner.text doubleValue]){
        self.cornerBar.backgroundColor=[self colorWithHexString:@"b8e986"];
        homeScoredBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    }
    
    sum=[self.homeFoul.text doubleValue]+[self.awayFoul.text doubleValue];
    homeScoredBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*[self.homeFoul.text doubleValue]/sum, 18)];
    [homeScoredBar setBackgroundColor:[self colorWithHexString:@"b8e986"]];
    self.foulsBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    [self.foulsBar addSubview:homeScoredBar];
    if([self.homeFoul.text doubleValue]<[self.awayFoul.text doubleValue]){
        self.foulsBar.backgroundColor=[self colorWithHexString:@"b8e986"];
        homeScoredBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    }
    
    sum=[self.homeYellow.text doubleValue]+[self.awayYellow.text doubleValue];
    homeScoredBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width*[self.homeYellow.text doubleValue]/sum, 18)];
    [homeScoredBar setBackgroundColor:[self colorWithHexString:@"b8e986"]];
    self.yellowBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    [self.yellowBar addSubview:homeScoredBar];
    if([self.homeYellow.text doubleValue]<[self.awayYellow.text doubleValue]){
        self.yellowBar.backgroundColor=[self colorWithHexString:@"b8e986"];
        homeScoredBar.backgroundColor=[self colorWithHexString:@"d0021b"];
    }

}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void) colorResults{
    UIImageView *dot=[UIImageView new];
    int score=2;
    NSNumber *number=[NSNumber new];
    NSArray *array=[NSArray new];
    for (int i=0; i<5; i++) {
        dot=self.home[i];
        array=self.homeTeam[@"winlose"];
        number=array[i];
        score=[number intValue];
        if(score==0){
            dot.backgroundColor=[self colorWithHexString:@"d0021b"];
        }else if(score==1){
            dot.backgroundColor=[self colorWithHexString:@"f5a623"];
        }else if(score==3){
            dot.backgroundColor=[self colorWithHexString:@"b8e986"];
        }
    }
    for (int i=0; i<5; i++) {
        dot=self.away[i];
        array=self.awayTeam[@"winlose"];
        number=array[i];
        score=[number intValue];
        if(score==0){
            dot.backgroundColor=[self colorWithHexString:@"d0021b"];
        }else if(score==1){
            dot.backgroundColor=[self colorWithHexString:@"f5a623"];
        }else if(score==3){
            dot.backgroundColor=[self colorWithHexString:@"b8e986"];
        }
    }
}

-(void)showComments{
    NSString *str=@"";
    self.comments.numberOfLines=self.match.comments.count+1;
    for (int i=0; i<self.match.comments.count; i++) {
        if(i==0){
            str=self.match.comments[i];
        }else{
        str=[NSString stringWithFormat:@"%@ \n%@", str, self.match.comments[i]];
        }
    }
    self.comments.text=str;
    
    NSLog(@"%@", str);
    
}


@end
