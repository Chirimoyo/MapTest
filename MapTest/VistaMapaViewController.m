//
//  VistaMapaViewController.m
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/26/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "VistaMapaViewController.h"
#import "MapTestViewController.h"
#import "ListadoPropiedadesViewController.h"


@interface VistaMapaViewController ()

@end

@implementation VistaMapaViewController
{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
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
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    self.title  = @"Posición actual";
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:10];
    
    mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
    mapView_.myLocationEnabled = NO;
    [self.mapView addSubview: mapView_];
    
    
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    UIImage *imagen = [UIImage imageNamed:@"pinUsuario" ];
    [marker setIcon:imagen];
    marker.zIndex = 99;
    marker.title = @"Santiago";
    marker.snippet = @"Chile";
    marker.map = mapView_;
    
    if(self.ugeo == nil){
        [self ApiMeli:@"Santiago"];
    }
    else
    {
        [self ApiMeli: self.ugeo.nombre];
    }
    //UIImage *imagen = [UIImage imageNamed:@"pin.png"];
    

    // Do any additional setup after loading the view.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Error obtener localizacion" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
       

        [self refreshMapDouble:currentLocation.coordinate.latitude  longitud:currentLocation.coordinate.longitude nombreCiudad: @"Posición actual"];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)addItemViewController:(MapTestViewController *)controller didFinishEnteringItem:(UnidadGeografica *)item
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = item.nombre;
        
        [self refreshMap:item.latitud longitud:item.longitud nombreCiudad: item.nombre];
    });
    //NSLog(@"This was returned from ViewControllerB %@",item.nombre);
}


-(IBAction)listadoPropiedades:(id)sender
{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ListadoPropiedadesViewController *vistaListado = [storyboard instantiateViewControllerWithIdentifier:@"ListadoPropiedadesViewController"];
    UnidadGeografica *unidadgeo = [UnidadGeografica new];
    unidadgeo.nombre = [self title];
    vistaListado.unidadGeografica = unidadgeo;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:vistaListado animated:YES ];

    
}
-(IBAction)viewFiltrosBusqueda:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MapTestViewController *second = [storyboard instantiateViewControllerWithIdentifier:@"MapTestViewController"];
    second.nombreCiudad = [self title];
    second.delegate  = self;
    
    second.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [second setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:second animated:YES completion:nil];
    
    

}

- (void) refreshMap:(id)lat  longitud:(id)lng nombreCiudad:(NSString *)nombreCiudad{
    [mapView_ clear];
    [mapView_ animateToLocation:CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue])];
    [self ApiMeli:nombreCiudad];
}

- (void) refreshMapDouble:(double)lat  longitud:(double)lng nombreCiudad:(NSString *)nombreCiudad{
   [mapView_ clear];
   [mapView_ animateToLocation:CLLocationCoordinate2DMake(lat, lng)];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    UIImage *imagen = [UIImage imageNamed:@"pinUsuario" ];
    [marker setIcon:imagen];
    marker.title = @"Santiago";
    marker.snippet = @"Chile";
    marker.map = mapView_;
   [self ApiMeli:nombreCiudad];
}


-(void) addMarker:(id)lat longitud:(id)lng idMeli:(id)idMeli{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    marker.title = idMeli;
    marker.snippet = idMeli;
    UIImage *imagen = [UIImage imageNamed:@"pin.png" ];
    [marker setIcon:imagen];
    marker.map = mapView_;
}
-(void) ApiMeli:(NSString *) ciudad{
    
    
    NSString *urlString;
   
    
    if ([ciudad rangeOfString:@"Santiago"].location != NSNotFound) {
        urlString = @"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=50&state=TUxDUE1FVEExM2JlYg&city=TUxDQ1NBTjk4M2M";
    } else {
        
        if ([ciudad rangeOfString:@"del Mar"].location != NSNotFound) {
            urlString = @"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=50&state=TUxDUFZBTE84MDVj&city=TUxDQ1ZJ0WQ3ZGU4";
        } else {
            
            urlString =@"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=50&state=TUxDUERFTE9lODZj&city=TUxDQ0NPTjYwZTdk";
        }
    }



    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url
      
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      
      {
          
          
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          
          if (httpResponse.statusCode == 200)
              
          {
              
              NSError *jsonError;
              NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
              
              if (!jsonError)
                  
              {
                  
                  for( id key in jsonData){
                    
                      if ( [key isEqualToString:@"results"]){
                          NSDictionary *value = [jsonData objectForKey:key];
                          for (id valor in value) {
                              id lat= [[valor objectForKey:@"location"] objectForKey:@"latitude"];
                              id lng= [[valor objectForKey:@"location"] objectForKey:@"longitude"];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self addMarker:lat longitud:lng idMeli:[valor objectForKey:@"permalink"] ];
                              });
                              
                              
                          }
                      }
                  }
                  
              }
              
          }
          
      }] resume];
}


@end
