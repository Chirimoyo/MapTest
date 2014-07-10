//
//  PropMeli.h
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/23/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropMeli : NSObject
@property (strong, nonatomic) NSString *idMeli;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) id latitude;
@property (strong, nonatomic) id longitud;
@property (strong, nonatomic) NSString *imagen;
@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) NSString *precio;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *imagenes;
@property (nonatomic) BOOL esFavorito;



@end
