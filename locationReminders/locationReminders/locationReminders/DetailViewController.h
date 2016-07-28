//
//  DetailViewController.h
//  locationReminders
//
//  Created by Michael Sweeney on 7/26/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

typedef void(^DetailViewControllerCompletion)(MKCircle *circle);

@interface DetailViewController : UIViewController

@property (strong, nonatomic)NSString *annotationTitle;
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (copy, nonatomic)DetailViewControllerCompletion completion;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *radiusField;


@end
