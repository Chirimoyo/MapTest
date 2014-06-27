//
//  ListadoPropiedadesViewController.m
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/27/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "ListadoPropiedadesViewController.h"
#import "PropMeli.h"
@interface ListadoPropiedadesViewController ()

@end

@implementation ListadoPropiedadesViewController
{
    NSArray *propiedades;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    PropMeli *prop1 =[PropMeli new];
    prop1.idMeli = @"id1";
    prop1.url = @"http://www.meli.cl/id1";
    prop1.latitude = 0;
    prop1.longitud = 0;
    prop1.imagen = @"urlImagen";
    
    PropMeli *prop2 =[PropMeli new];
    prop2.idMeli = @"id1";
    prop2.url = @"http://www.meli.cl/id1";
    prop2.latitude = 0;
    prop2.longitud = 0;
    prop2.imagen = @"urlImagen";
    
    PropMeli *prop3 =[PropMeli new];
    prop3.idMeli = @"id1";
    prop3.url = @"http://www.meli.cl/id1";
    prop3.latitude = 0;
    prop3.longitud = 0;
    prop3.imagen = @"urlImagen";
    
    PropMeli *prop4 =[PropMeli new];
    prop4.idMeli = @"id1";
    prop4.url = @"http://www.meli.cl/id1";
    prop4.latitude = 0;
    prop4.longitud = 0;
    prop4.imagen = @"urlImagen";
    
    PropMeli *prop5 =[PropMeli new];
    prop5.idMeli = @"id1";
    prop5.url = @"http://www.meli.cl/id1";
    prop5.latitude = 0;
    prop5.longitud = 0;
    prop5.imagen = @"urlImagen";
    
    PropMeli *prop6 =[PropMeli new];
    prop6.idMeli = @"id1";
    prop6.url = @"http://www.meli.cl/id1";
    prop6.latitude = 0;
    prop6.longitud = 0;
    prop6.imagen = @"urlImagen";
    
    propiedades = [NSArray arrayWithObjects:prop1, prop2, prop3, prop4, prop5,prop6, nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
