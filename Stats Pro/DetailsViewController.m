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


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orangeDot.backgroundColor=[UIColor orangeColor];
    self.redDot.backgroundColor = [UIColor redColor];
   for (int i=0; i<4; i++) {
    UIImageView *dot = [UIImageView new];
    dot.image = [UIImage imageNamed:@"circle.png"];
    dot.backgroundColor = [UIColor greenColor];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
       
    [self.view addSubview:dot];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeRight multiplier:1 constant:(5*(i+1))+(17*i)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
    for (int i=0; i<4; i++) {
    UIImageView *dot = [UIImageView new];
    dot.image = [UIImage imageNamed:@"circle.png"];
    dot.backgroundColor = [UIColor greenColor];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:dot];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orangeDot attribute:NSLayoutAttributeRight multiplier:1 constant:-39-(i*22)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.redDot attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
