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
@property UnidadGeografica *unidadGeografica;
@property TipoOperacion tipoOperacion;
@property TipoPropiedad tipoPropiedad;
@property NSInteger rangoPrecioDesde;
@property NSInteger rangoPrecioHasta;
@property NSString *rangoSuperficie;
@property NSInteger cantidadDormitorios;
@property NSInteger cantidadBaños;
@property BOOL Amoblado;

@end
