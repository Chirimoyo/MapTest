//
//  MapTestViewController.h
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/17/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "UnidadGeografica.h"


@class MapTestViewController;

@protocol MapTestViewControllerDelegate <NSObject>
- (void)addItemViewController:(MapTestViewController *)controller didFinishEnteringItem:(UnidadGeografica *)item;
@end

@interface MapTestViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UIPickerViewDelegate>
{
__weak IBOutlet UITableView *tableView;

}

@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (nonatomic, weak) id <MapTestViewControllerDelegate> delegate;
@property (nonatomic) NSString *nombreCiudad;
@end
