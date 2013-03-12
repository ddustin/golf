//
//  Course.m
//  Golf
//
//  Created by Dustin Dettmer on 3/12/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Hole.h"
#import "TouchXML.h"

static CLLocationCoordinate2D location(NSString *str)
{
    CLLocationCoordinate2D ret = { 0 };
    
    NSArray *ary = [str componentsSeparatedByString:@","];
    
    ret.latitude = [[ary objectAtIndex:0] doubleValue];
    ret.longitude = [[ary objectAtIndex:1] doubleValue];
    
    return ret;
}

@implementation Hole

- (id)initWithCourseData:(NSString*)corseData hole:(NSString*)hole
{
    self = [super init];
    
    if(self) {
        
        CXMLDocument *document = [[CXMLDocument alloc] initWithXMLString:corseData options:0 error:nil];
        
        CXMLNode *node = [document nodeForXPath:@"//*[local-name() = 'GetCourseKMLResult']" error:nil];
        
        NSString *xmlString = [node stringValue];
        
        xmlString = [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
        
        document = [[CXMLDocument alloc]
                    initWithXMLString:xmlString
                    options:0
                    error:nil];
        
        BOOL foundIt = NO;
        
        for(CXMLElement *element in [document nodesForXPath:@"//*[local-name() = 'HoleBounds']/*[local-name() = 'Hole']/*" error:nil]) {
            
            if([element.name isEqual:@"no"]) {
                
                if([element.stringValue isEqual:hole])
                    foundIt = YES;
            }
            
            if(!foundIt)
                continue;
            
            if([element.name isEqual:@"no"])
                self.hole = [element stringValue];
            
            if([element.name isEqual:@"zoom"])
                self.zoom = [[element stringValue] floatValue];
            
            if([element.name isEqual:@"center"])
                self.center = location([element stringValue]);
            
            if([element.name isEqual:@"gleft"])
                self.gleft = location([element stringValue]);
            
            if([element.name isEqual:@"gright"])
                self.gright = location([element stringValue]);
            
            if([element.name isEqual:@"tleft"])
                self.tleft = location([element stringValue]);
            
            if([element.name isEqual:@"tright"])
                self.tright = location([element stringValue]);
            
            if([element.name isEqual:@"ang"]) {
                
                self.angle = [[element stringValue] doubleValue];
                
                if(foundIt)
                    break;
            }
        }
    }
    
    return self;
}

- (NSString*)description
{
    NSMutableString *str = [@"" mutableCopy];
    
    [str appendFormat:@"< %@ zoom %f center %f,%f gleft %f,%f gright %f,%f tleft %f,%f tright %f,%f angle %f >",
     self.hole, self.zoom, self.center.latitude, self.center.longitude,
     self.gleft.latitude, self.gleft.longitude,
     self.gright.latitude, self.gright.longitude,
     self.tleft.latitude, self.tleft.longitude,
     self.tright.latitude, self.tright.longitude, self.angle];
    
    return str;
}

@end