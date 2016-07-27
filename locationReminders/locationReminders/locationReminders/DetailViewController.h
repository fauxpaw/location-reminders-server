//
//  DetailViewController.h
//  locationReminders
//
//  Created by Michael Sweeney on 7/26/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface DetailViewController : UIViewController

@property (strong, nonatomic)NSString *annotationTitle;
@property (nonatomic)CLLocationCoordinate2D coordinate;


@end
