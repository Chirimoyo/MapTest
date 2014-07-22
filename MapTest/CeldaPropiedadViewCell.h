//
//  CeldaPropiedadViewCell.h
//  MapTest
//
//  Created by Santos Ramon on 7/22/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropMeli.h"
@interface CeldaPropiedadViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;
@property (weak, nonatomic) IBOutlet UILabel *lblDetalle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrecio;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) PropMeli *propiedad;

-(void)setData:(PropMeli*)data;

@end
