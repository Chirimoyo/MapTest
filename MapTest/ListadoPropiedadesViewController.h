//
//  ListadoPropiedadesViewController.h
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/27/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnidadGeografica.h"
#import "VistaMapaViewController.h"

@interface ListadoPropiedadesViewController : UIViewController

{
    __weak IBOutlet UITableView *tableview;
}
@property UnidadGeografica * unidadGeografica;
@end
