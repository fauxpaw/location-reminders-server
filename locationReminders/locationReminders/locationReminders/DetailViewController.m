//
//  DetailViewController.m
//  locationReminders
//
//  Created by Michael Sweeney on 7/26/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminder.h"
#import "LocationController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *coordLabel;
- (IBAction)createReminderButtonSelected:(UIButton *)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Title: %@", self.annotationTitle);
    NSLog(@"Coordinate: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
    
    _coordLabel.text = [NSString stringWithFormat:@"Coords are: %f, %f", self.coordinate.latitude, self.coordinate.longitude];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TestNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)createReminderButtonSelected:(UIButton *)sender {
    
    NSString *reminderName = _nameField.text;
    NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *radius = [f numberFromString:_radiusField.text];
    
    Reminder *reminder = [Reminder object];
    reminder.name = reminderName;
    reminder.radius = radius;
    
    reminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    __weak typeof (self) weakSelf = self;
    
    [reminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        __strong typeof (weakSelf) strongSelf = self;
        NSLog(@"Reminder saved to parse server");
        
        if (strongSelf.completion) {
            
            if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:strongSelf.coordinate radius:radius.floatValue identifier:reminderName];
                [[[LocationController sharedController]locationManager]startMonitoringForRegion:region];
                strongSelf.completion([MKCircle circleWithCenterCoordinate:strongSelf.coordinate radius:radius.floatValue]);
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
            
            self.completion([MKCircle circleWithCenterCoordinate:self.coordinate radius:radius.floatValue]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}
@end
