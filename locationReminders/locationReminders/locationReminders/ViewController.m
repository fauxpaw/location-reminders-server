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
#import "DetailViewController.h"
#import "LocationController.h"

@interface ViewController () <MKMapViewDelegate, LocationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *startingCoords;

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //    testObject[@"foo"] = @"bar";
    //    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    //        NSLog(@"Succeeded: %i, Error: %@ ", succeeded, error);
    //    }];
    //
    //    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    //    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    //
    //        if (!error) {
    //            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //                NSLog(@"Objects: %@", objects);
    //            }];
    //        }
    //
    //    }];
    
    [self.mapView.layer setCornerRadius:20.0];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    
    [self createStartingLocales];
    [self.mapView addAnnotations:_startingCoords];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[LocationController sharedController]setDelegate:self];
    [[[LocationController sharedController]locationManager]startUpdatingLocation];
    
    
    
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

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchpoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchpoint toCoordinateFromView:self.mapView];
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = touchMapCoordinate;
        newPoint.title = @"New Location";
        
        [self.mapView addAnnotation:newPoint];
        
    }
    
}

-(void)locationControllerDidUpdateLocation:(CLLocation *)location{
    
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500) animated:YES];
    
}

-(MKPinAnnotationView *)randomizePinColor:(MKPinAnnotationView *)inputAnnoView {
    
    int r = arc4random_uniform(5);
    
    switch (r) {
        case 0:
            inputAnnoView.pinTintColor = [UIColor blueColor];
            break;
        case 1:
            inputAnnoView.pinTintColor = [UIColor greenColor];
            break;
        case 2:
            inputAnnoView.pinTintColor = [UIColor redColor];
            break;
        case 3:
            inputAnnoView.pinTintColor = [UIColor orangeColor];
            break;
        case 4:
            inputAnnoView.pinTintColor = [UIColor yellowColor];
            break;
        case 5:
            inputAnnoView.pinTintColor = [UIColor purpleColor];
            break;
        default:
            break;
    }

    return inputAnnoView;
}

#pragma mark - MapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) { return nil; }
    
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    //    [self randomizePinColor:annotationView];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    

    [self randomizePinColor:annotationView];
    
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    return annotationView;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            
            DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
            
            detailViewController.annotationTitle = annotationView.annotation.title;
            detailViewController.coordinate = annotationView.annotation.coordinate;
        }
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
    
}

-(void)createStartingLocales{
    
    _startingCoords = [[NSMutableArray alloc]init];
    
    CLLocationCoordinate2D cfMapCoord = CLLocationCoordinate2DMake(47.618165, -122.351850);
    
    MKPointAnnotation *cfPin = [[MKPointAnnotation alloc]init];
    cfPin.coordinate = cfMapCoord;
    cfPin.title = @"Codefellows";
    
    CLLocationCoordinate2D seelCoord = CLLocationCoordinate2DMake(47.617670, -122.350162);
    MKPointAnnotation *seelPin = [[MKPointAnnotation alloc]init];
    seelPin.coordinate = seelCoord;
    seelPin.title = @"Seel";
    
    CLLocationCoordinate2D zubatCoord = CLLocationCoordinate2DMake(47.619812, -122.352626);
    MKPointAnnotation *zubatPin = [[MKPointAnnotation alloc]init];
    zubatPin.coordinate = zubatCoord;
    zubatPin.title = @"Zubat";
    
    CLLocationCoordinate2D growlitheCoord = CLLocationCoordinate2DMake(47.617709, -122.352472);
    MKPointAnnotation *growlithePin = [[MKPointAnnotation alloc]init];
    growlithePin.coordinate = growlitheCoord;
    growlithePin.title = @"Growlithe";
    
    
    CLLocationCoordinate2D pidgeyCoord = CLLocationCoordinate2DMake(47.617905, -122.351689);
    MKPointAnnotation *pidgeyPin = [[MKPointAnnotation alloc]init];
    pidgeyPin.coordinate = pidgeyCoord;
    pidgeyPin.title = @"Pidgeys for days";
    
    [_startingCoords addObject:cfPin];
    [_startingCoords addObject:seelPin];
    [_startingCoords addObject:zubatPin];
    [_startingCoords addObject:growlithePin];
    [_startingCoords addObject:pidgeyPin];

    
    //    [self.mapView addAnnotation:cfPoint];
    //    [self.mapView addAnnotation:seelPoint];
    //    [self.mapView addAnnotation:zubatPoint];
    
}


@end
