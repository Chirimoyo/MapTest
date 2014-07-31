//
//  Busqueda.h
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 7/14/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnidadGeografica.h"
#import "Enums.h"
@interface Busqueda : NSObject

@property (nonatomic, strong) UnidadGeografica *unidadGeografica;
@property NSString *tipoOperacion;
@property NSString *tipoPropiedad;
@property NSInteger rangoPrecioDesde;
@property NSInteger rangoPrecioHasta;
@property NSString *rangoSuperficie;
@property NSInteger cantidadDormitorios;
@property NSInteger cantidadBaños;
@property NSInteger tipoMoneda;
@property BOOL Amoblado;

@end
