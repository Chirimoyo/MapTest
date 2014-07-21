//
//  Enums.h
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 7/14/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enums : NSObject
typedef enum
{
    Venta = 1,
    Arriendo,
    ArriendoDeTemporada
}TipoOperacion;

typedef enum
{
    Casa = 1,
    Departamento
}TipoPropiedad;

typedef enum{
    Peso = 1,
    UF
}TipoMoneda;


@end
