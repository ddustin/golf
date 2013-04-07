//
//  RecordSwingViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 4/6/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "RecordSwingViewController.h"
#import "Club.h"

@interface RecordSwingViewController ()

@property NSArray *clubs;
@property NSArray *fairways;
@property NSArray *sands;
@property NSArray *penalties;

@end

@implementation RecordSwingViewController

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return (self.clubs = [Club clubs]).count;
    
    return 5;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
        return [[self.clubs objectAtIndex:row] Abbrev];
    
    return @"title";
}

@end
