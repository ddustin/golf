//
//  PlayViewController.m
//  Golf
//
//  Created by Dustin Dettmer on 3/5/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "PlayViewController.h"
#import "TouchXML.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidAppear:(BOOL)animated
{
    NSURL *course = [[NSBundle mainBundle] URLForResource:@"course_list" withExtension:@"xml"];
    
    NSString *fmt = [NSString stringWithContentsOfURL:course encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *url = [NSURL URLWithString:@"https://golflogix.com/golflogixservice.asmx"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *str = [NSString stringWithFormat:fmt, @(37.788766), @(-122.401110)];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"https://www.golflogix.com/GetCourseListByLocation" forHTTPHeaderField:@"SOAPAction"];
    [request setValue:@"GolfLogix/3.0 CFNetwork/609.1.4 Darwin/13.0.0" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"URL: %@", request.URL);
    NSLog(@"Headers: %@", request.allHTTPHeaderFields);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding options:0 error:nil];
        
        CXMLNode *node = [document nodeForXPath:@"//*[local-name() = 'GetCourseListByLocationResult']" error:nil];
        
        NSString *xmlString = [node stringValue];
        
        xmlString = [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
        
        document = [[CXMLDocument alloc]
                    initWithXMLString:xmlString
                    options:0
                    error:&error];
        
        NSLog(@"document: %@", document);
    }];
}

@end
