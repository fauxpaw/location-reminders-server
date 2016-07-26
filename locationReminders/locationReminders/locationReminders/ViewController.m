//
//  ViewController.m
//  locationReminders
//
//  Created by Michael Sweeney on 7/25/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
@import MapKit;

@interface ViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        NSLog(@"Succeeded: %i, Error: %@ ", succeeded, error);
//    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       
        if (!error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Objects: %@", objects);
            }];
        }
        
    }];
    
    [self requestPermissions];
    [self.mapView.layer setCornerRadius:20.0];
    
}

-(void)requestPermissions{
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [self.locationManager requestAlwaysAuthorization];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)firstLocationButtonPressed:(UIButton *)sender {
    //Vatican
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(41.9023600, 12.4533200);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
    
}
- (IBAction)secondLocationButtonPressed:(UIButton *)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(29.9753 , 31.1376);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
    
}
- (IBAction)thirdLocationButtonPressed:(UIButton *)sender {
    //Himeji Castle
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(34.8394, 134.6939);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
    
}

@end
