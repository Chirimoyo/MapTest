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
#import "Busqueda.h"
#import "AFHTTPRequestOperationManager.h"

@interface VistaMapaViewController ()

@end

@implementation VistaMapaViewController
{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    GMSMarker *currentPositionMarker;
    NSUserDefaults *userDefaults;
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

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:10];

    userDefaults = [NSUserDefaults standardUserDefaults];
    [self initMap];
    [self initMarker];
}

-(void) initMap{
    float init_latitude = -33.438941;
    float init_longitude = -70.644632;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: init_latitude
                                                            longitude: init_longitude
                                                                 zoom:10];
    mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
    mapView_.myLocationEnabled = NO;
    [self.mapView addSubview: mapView_];

    NSString *ultimaBusqueda = [userDefaults objectForKey:@"ultimaBusqueda"];
    NSNumber *lat = [userDefaults objectForKey:@"latitud"];
    NSNumber *lon = [userDefaults objectForKey:@"longitud"];
    if (ultimaBusqueda != nil) {
        NSLog(@"ultimaBusqueda %@", ultimaBusqueda);
        //cargar la ultima busqueda realizada
        [self actualizarMapaDesdeBusqueda:ultimaBusqueda latitud:lat longitud:lon];
    } else {
        //ubicar al usuario en su posición actual
        [self centrarMapaPosicionUsuario];
    }
}
-(void *)setDireccionFromLocationFromLatitude:(double) lat Longitud:(double) lon
{
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(lat, lon) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        for(GMSAddress* addressObj in [response results])
        {
            self.title = addressObj.lines[1];
        }
    }];
    return @"";
}

-(void) initMarker{
    // Creates a marker in the center of the map.
    currentPositionMarker = [[GMSMarker alloc] init];
    UIImage *imagen = [UIImage imageNamed:@"pinUsuario" ];
    [currentPositionMarker setIcon:imagen];
    currentPositionMarker.zIndex = 99;
    currentPositionMarker.title = @"Santiago";
    currentPositionMarker.snippet = @"Chile";
    currentPositionMarker.map = mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//puede ser actualizado externamente
- (void)actualizarMapaDesdeBusqueda:(NSString *)titulo latitud:(NSNumber *)lat longitud:(NSNumber *)lon
{
    NSLog(@"actualizar mapa: %@", titulo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = titulo;
        [self refreshMap:lat longitud:lon nombreCiudad: titulo];
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
     
    //[self performSegueWithIdentifier:@"goListado" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goListado"]) {
        ListadoPropiedadesViewController *vistaListado = (ListadoPropiedadesViewController *) segue.destinationViewController;
        UnidadGeografica *unidadgeo = [UnidadGeografica new];
        unidadgeo.nombre = [self title];
        vistaListado.unidadGeografica = unidadgeo;
    }
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

- (void) refreshMapDouble:(double)lat longitud:(double)lng nombreCiudad:(NSString *)nombreCiudad{
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
    marker.zIndex = 80;
    UIImage *imagen = [UIImage imageNamed:@"PinPropiedad" ];
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
            
            //urlString =@"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=50&state=TUxDUERFTE9lODZj&city=TUxDQ0NPTjYwZTdk";
            urlString = @"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=50&state=TUxDUE1FVEExM2JlYg&city=TUxDQ1NBTjk4M2M";

        }
    }
    /*

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *jsonData = (NSDictionary *)responseObject;
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

     */

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


- (IBAction)fnCentrar:(id)sender {
    NSLog(@"Centrar button pressed");
    [self centrarMapaPosicionUsuario];
}

-(void) centrarMapaPosicionUsuario {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [self ApiMeli:@"Santiago"];

    [self setDireccionFromLocationFromLatitude:(double)locationManager.location.coordinate.latitude Longitud:((double)locationManager.location.coordinate.longitude)];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"%@", locations);

    currentPositionMarker.position = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    mapView_.camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                  longitude: locationManager.location.coordinate.longitude
                                                       zoom:10];
    [locationManager stopUpdatingLocation];
    //TODO: actualizar la data con el valor real
    [self ApiMeli:@"Santiago"];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Error obtener localizacion" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



@end
