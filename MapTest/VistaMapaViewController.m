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
@property (strong, nonatomic) Busqueda *busqueda;
@end

@implementation VistaMapaViewController
{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    GMSMarker *currentPositionMarker;
    NSUserDefaults *userDefaults;
}
@synthesize busqueda;
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

   

    userDefaults = [NSUserDefaults standardUserDefaults];
    [self initMap];
    [self initMarker];
    [self initSearchableBar];
}

-(void) initMap{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:11];
    mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
    mapView_.myLocationEnabled = NO;
    mapView_.delegate = self;
    [self.mapView addSubview: mapView_];

    NSString *ultimaBusqueda = [userDefaults objectForKey:@"ultimaBusqueda"];

    if (ultimaBusqueda != nil) {
        NSLog(@"ultimaBusqueda %@", ultimaBusqueda);
        //cargar la ultima busqueda realizada
        [self actualizarMapaDesdeBusqueda:nil];
    } else {
        //ubicar al usuario en su posición actual
        [self centrarMapaPosicionUsuario];
    }
}

-(void *)setDireccionFromLocationFromLatitude:(double) lat Longitud:(double) lon
{
    [[GMSGeocoder geocoder]  reverseGeocodeCoordinate:CLLocationCoordinate2DMake(lat, lon) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        if ([[response results] count] > 0){
            GMSAddress* addressObj = [[response results] firstObject];
            self.title = addressObj.locality;
        }
        else {
            // Add logic
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

-(void) initSearchableBar{
    _btnTitulo.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//puede ser actualizado externamente
- (void)actualizarMapaDesdeBusqueda:(Busqueda *)bus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        /*[_btnTitulo setTitle:titulo forState:UIControlStateNormal];
        [self refreshMap:lat longitud:lon nombreCiudad: titulo];*/
        self.busqueda = bus;
        self.title = self.busqueda.unidadGeografica.nombre;
        [self refreshMap];
    });
    //NSLog(@"This was returned from ViewControllerB %@",item.nombre);
}

-(IBAction)listadoPropiedades:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ListadoPropiedadesViewController *vistaListado = [storyboard instantiateViewControllerWithIdentifier:@"ListadoPropiedadesViewController"];
    UnidadGeografica *unidadgeo = [UnidadGeografica new];
    unidadgeo.nombre = [self title];
    vistaListado.busqueda = self.busqueda;
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
       
        vistaListado.busqueda = self.busqueda;
    }
}

-(IBAction)viewFiltrosBusqueda:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MapTestViewController *second = [storyboard instantiateViewControllerWithIdentifier:@"MapTestViewController"];
    second.nombreCiudad = [self title];
    second.busqueda = self.busqueda;
    second.delegate  = self;
    
    second.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [second setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:second animated:YES completion:nil];
}

- (void) refreshMap{
    [mapView_ clear];
    [mapView_ animateToLocation:CLLocationCoordinate2DMake(self.busqueda.unidadGeografica.latitud, busqueda.unidadGeografica.longitud)];
    [self ApiMeli];
}




-(void) addMarker:(id)lat longitud:(id)lng idMeli:(id)idMeli idTipoPropiedad:(NSString *) idTipoPropiedad{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    marker.title = idMeli;
    marker.snippet = idMeli;
    marker.zIndex = 80;
    UIImage *imagen;
    if([idTipoPropiedad isEqualToString:@"MLC1466"]){
        imagen = [UIImage imageNamed:@"pinCasa" ];}
    else{
        imagen = [UIImage imageNamed:@"PinPropiedad" ];
    }
    
    [marker setIcon:imagen];
    marker.map = mapView_;
}

-(void) ApiMeli{
    NSString *urlString;
    
    urlString = [NSString stringWithFormat: @"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=%@&limit=100&state=%@&price=*-%d&%d-", self.busqueda.tipoOperacion , self.busqueda.unidadGeografica.idMeli, self.busqueda.rangoPrecioDesde, self.busqueda.rangoPrecioHasta ];

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
                                  [self addMarker:lat longitud:lng idMeli:[valor objectForKey:@"permalink"] idTipoPropiedad: busqueda.tipoPropiedad ];
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

- (IBAction)fnCambiarTitulo:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MapTestViewController *second = [storyboard instantiateViewControllerWithIdentifier:@"MapTestViewController"];
    second.nombreCiudad = _btnTitulo.titleLabel.text;
    second.showTextDialog = YES;
    second.delegate  = self;
    
    second.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [second setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:second animated:YES completion:nil];
}

-(void) centrarMapaPosicionUsuario {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    self.busqueda = [Busqueda new];
    UnidadGeografica *ugeo = [UnidadGeografica new];
    [ugeo setLatitud:locationManager.location.coordinate.latitude];
    [ugeo setLongitud: locationManager.location.coordinate.longitude];
    [ugeo setIdMeli: @"TUxDUE1FVEExM2JlYg"]; //esta en duro pq se q parte en stgo!!
    [ugeo setNombre: @"Posición actual"];
    [self.busqueda setTipoOperacion:@"MLC1480"];
    [self.busqueda setTipoPropiedad:@"MLC1472"];
    [self.busqueda setTipoMoneda:0];
    [self.busqueda setRangoPrecioDesde:0];
    [self.busqueda setRangoPrecioHasta:0];
    
    [busqueda setUnidadGeografica:ugeo];
    busqueda.tipoOperacion = @"MLC1480";
    
    [self ApiMeli];
    self.title = @"Posición actual";

    //[self setDireccionFromLocationFromLatitude:(double)locationManager.location.coordinate.latitude Longitud:((double)locationManager.location.coordinate.longitude)];
    
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    NSLog(@"%f,%f",mapView.projection.visibleRegion.farLeft.latitude,mapView.projection.visibleRegion.farLeft.longitude);
    NSLog(@"%f,%f",mapView.projection.visibleRegion.farRight.latitude,mapView.projection.visibleRegion.farRight.longitude);
    NSLog(@"%f,%f",mapView.projection.visibleRegion.nearLeft.latitude,mapView.projection.visibleRegion.nearLeft.longitude);
    NSLog(@"%f,%f",mapView.projection.visibleRegion.nearRight.latitude,mapView.projection.visibleRegion.nearRight.longitude);
    
    
    CGPoint point = mapView.center;
    CLLocationCoordinate2D coordenada = [mapView.projection coordinateForPoint:point];
    [self setDireccionFromLocationFromLatitude:coordenada.latitude Longitud:coordenada.longitude];
    
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
