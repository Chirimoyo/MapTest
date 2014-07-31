//
//  UnidadGeografica.h
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/26/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UnidadGeografica : NSObject
@property (strong, nonatomic) NSString *nombre;
@property (nonatomic) double latitud;
@property (nonatomic) double longitud;
@property (strong, nonatomic) NSString *idMeli;
@end
