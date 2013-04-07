//
//  Club.m
//  Golf
//
//  Created by Dustin Dettmer on 4/6/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Club.h"
#import "Database.h"

@implementation Club

+ (NSArray *)clubs
{
    static NSArray *clubs = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSMutableString *query = [NSMutableString string];
        
        [query appendString:@"select Abbrev from Clubs"];
        
        clubs = [Database query:query classType:self.class];
    });
    
    return clubs;
}

@end
