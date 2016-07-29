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
@import ParseUI;
#import "DetailViewController.h"
#import "LocationController.h"
#import "Reminder.h"

@interface ViewController () <MKMapViewDelegate, LocationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *startingCoords;
@property DetailViewControllerCompletion completion;

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
    [self setupStartingReminders];

    [self.mapView addAnnotations:_startingCoords];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testObserverFired) name:@"TestNotification" object:nil];
    [self login];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[LocationController sharedController]setDelegate:self];
    [[[LocationController sharedController]locationManager]startUpdatingLocation];

}

-(void) setupStartingReminders {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error && objects.count > 0) {
            
            for (PFObject *item in objects) {
                Reminder *reminder = [[Reminder alloc]init];
                reminder.location = [item objectForKey:@"location"];
                NSLog(@"location is: %@", reminder.location);
                
                
                reminder.name = [item objectForKey:@"name"];
                reminder.radius = [item objectForKey:@"radius"];
                
                CLLocation *loc = [[CLLocation alloc]initWithLatitude:reminder.location.latitude longitude:reminder.location.longitude];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude);
                
                if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                    CLCircularRegion *eventRegion = [[CLCircularRegion alloc]initWithCenter: coord radius:reminder.radius.floatValue identifier:reminder.name];
                    [[[LocationController sharedController]locationManager]startMonitoringForRegion:eventRegion];
                    
                    self.completion([MKCircle circleWithCenterCoordinate:coord radius:reminder.radius.floatValue]);
                }
            }
            
        } else {
            NSLog(@"ERROR: %@", error.localizedDescription);
        }
        
        
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TestNotification" object:nil];
}

-(void)testObserverFired{
    NSLog(@"Notification fired!");
    [self.view setBackgroundColor:[UIColor blueColor]];
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
            __weak typeof (self) weakSelf = self;
            detailViewController.completion = ^(MKCircle *cirle){
                __strong typeof (weakSelf) strongSelf = weakSelf;

                [strongSelf.mapView removeAnnotation:annotationView.annotation];
                [strongSelf.mapView addOverlay:cirle];
                
            };
            
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

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKCircleRenderer *circleRender = [[MKCircleRenderer alloc]initWithOverlay:overlay];
    circleRender.strokeColor = [UIColor blueColor];
    circleRender.lineWidth = 1;
    
    circleRender.fillColor = [UIColor redColor];
    circleRender.alpha = 0.25;
    
    return circleRender;
}

#pragma mark - Parse Login/Signup

-(void)login {
    
    if (![PFUser currentUser]) {
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
        
        loginViewController.delegate = self;
        loginViewController.signUpController.delegate = self;
        UILabel *logoLabel = [[UILabel alloc]init];
        logoLabel.text = @"Location Reminders";
        loginViewController.logInView.logo = logoLabel;
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else {
        [self setupAdditionalUI];
    }
}

-(void)setupAdditionalUI{
    
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)];
    
    self.navigationItem.leftBarButtonItem = signOutButton;
}

-(void)signOut{
    [PFUser logOut];
    [self login];
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];
}

@end
