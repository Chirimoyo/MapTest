//
//  MenuItem.h
//  MapTest
//
//  Created by Santos Ramon on 8/1/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
@property NSString *titulo;
@property NSString *icono;
@property NSString *identificador;

-(id)initWithTitulo:(NSString *)tit icono:(NSString *)icon id:(NSString *)iden;

@end