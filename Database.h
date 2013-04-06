//
//  Database.h
//  Golf
//
//  Created by Dustin Dettmer on 4/5/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

// Loads a query and allocates classes that match table names in query.
// Automatically any 's' characters on the end of the table name.
+ (NSArray*)query:(NSString*)query classType:(Class)class;

@end
