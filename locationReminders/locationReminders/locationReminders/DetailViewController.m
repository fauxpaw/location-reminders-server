//
//  DetailViewController.m
//  locationReminders
//
//  Created by Michael Sweeney on 7/26/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminder.h"

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
    
    if (self.completion) {
        self.completion([MKCircle circleWithCenterCoordinate:self.coordinate radius:radius.floatValue]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
