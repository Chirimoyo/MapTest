//
//  MenuItem.m
//  MapTest
//
//  Created by Santos Ramon on 8/1/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

-(id)initWithTitulo:(NSString *)tit icono:(NSString *)icon id:(NSString *)iden{
    self = [super init];
    if(self)
    {
        self.titulo = tit;
        self.icono = icon;
        self.identificador = iden;
    }
    return self;
}

@end