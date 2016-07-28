//
//  Reminder.m
//  locationReminders
//
//  Created by Michael Sweeney on 7/27/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@dynamic name;
@dynamic location;
@dynamic radius;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Reminder";
}



@end
