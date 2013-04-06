//
//  Database.m
//  Golf
//
//  Created by Dustin Dettmer on 4/5/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Database.h"
#import <sqlite3.h>

@implementation Database

+ (NSArray *)query:(NSString *)query classType:(__unsafe_unretained Class)class
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"db" withExtension:@"sqlite"];
    
    sqlite3 *db = NULL;
    
    int res = sqlite3_open(url.path.UTF8String, &db);
    
    NSAssert(res == SQLITE_OK, @"%s", sqlite3_errmsg(db));
    
    NSMutableArray *result = [@[] mutableCopy];
    
    sqlite3_stmt *stmt = NULL;
    
    res = sqlite3_prepare_v2(db, query.UTF8String, query.length, &stmt, NULL);
    
    NSAssert(res == SQLITE_OK, @"%s", sqlite3_errmsg(db));
    
    while((res = sqlite3_step(stmt)) == SQLITE_ROW) {
        
        id<NSObject> instance = [class new];
        
        for(int i = 0; i < sqlite3_column_count(stmt); i++) {
            
            id value = nil;
            
            int type = sqlite3_column_type(stmt, i);
            
            if(type == SQLITE_INTEGER)
                value = [NSNumber numberWithLongLong:sqlite3_column_int64(stmt, i)];
            
            if(type == SQLITE_FLOAT)
                value = [NSNumber numberWithDouble:sqlite3_column_double(stmt, i)];
            
            if(type == SQLITE_TEXT) {
                
                // Converts utf16 to utf8, do this just to be safe against the deadly utf16
                sqlite3_column_bytes(stmt, i);
                
                const char *str = (const char*)sqlite3_column_text(stmt, i);
                
                if(str)
                    value = [NSString stringWithUTF8String:str];
                else
                    value = [NSNull null];
            }
            
            if(type == SQLITE_BLOB) {
                
                int len = sqlite3_column_bytes(stmt, i);
                
                const char *bytes = (const char*)sqlite3_column_blob(stmt, i);
                
                if(bytes)
                    value = [NSData dataWithBytes:bytes length:len];
                else
                    value = [NSNull null];
            }
            
            if(type == SQLITE_NULL)
                value = [NSNull null];
            
            if(value) {
                
                NSString *name = [NSString stringWithUTF8String:sqlite3_column_name(stmt, i)];
                
                // Capitalize first character
                name = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] capitalizedString]];
                
                NSString *selectorStr = [NSString stringWithFormat:@"set%@:", name];
                
                SEL selector = NSSelectorFromString(selectorStr);
                
                if([instance respondsToSelector:selector]) {
                    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [instance performSelector:selector withObject:value];
#pragma clang diagnostic pop
                }
                else {
                    
                    NSLog(@"Query error: %@ does not respond to %@", class, selectorStr);
                }
            }
        }
        
        [result addObject:instance];
    }
    
    NSAssert(res == SQLITE_DONE, @"%s", sqlite3_errmsg(db));
    
    res = sqlite3_finalize(stmt);
    
    NSAssert(res == SQLITE_OK, @"%s", sqlite3_errmsg(db));
    
    res = sqlite3_close(db);
    
    NSAssert(res == SQLITE_OK, @"%s", sqlite3_errmsg(db));
    
    return result;
}

@end
