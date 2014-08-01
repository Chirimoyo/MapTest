//
//  VistaMapaViewController.h
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/26/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "MapTestViewController.h"
#import "UnidadGeografica.h"

@interface VistaMapaViewController : UIViewController<MapTestViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) UnidadGeografica *ugeo;
- (IBAction)fnCentrar:(id)sender;
- (IBAction)fnCambiarTitulo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTitulo;

- (IBAction)fnMenu:(id)sender;

@end
