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
    //location.delegate = self;
    [locationManager startUpdatingLocation];
    
    
    [super viewDidLoad];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:10];
    
    mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.mapView addSubview: mapView_];
    
    
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    marker.title = @"Santiago";
    marker.snippet = @"Chile";
    marker.map = mapView_;

    // Do any additional setup after loading the view.
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
    
        [self refreshMap:item.latitud longitud:item.longitud];
    });
    //NSLog(@"This was returned from ViewControllerB %@",item.nombre);
}

-(IBAction)listadoPropiedades:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ListadoPropiedadesViewController *second = [storyboard instantiateViewControllerWithIdentifier:@"ListadoPropiedadesViewController"];
  
        [self.navigationController pushViewController:second animated:YES ];


    
}
-(IBAction)invocaListado:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MapTestViewController *second = [storyboard instantiateViewControllerWithIdentifier:@"MapTestViewController"];
    second.nombreCiudad = [self title];
    second.delegate  = self;
    
    second.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [second setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:second animated:YES completion:nil];

}

- (void) refreshMap:(id)lat  longitud:(id)lng{
    [mapView_ animateToLocation:CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue])];
    [self ApiMeli:@"santiago"];
}


-(void) addMarker:(id)lat longitud:(id)lng idMeli:(id)idMeli{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    marker.title = idMeli;
    marker.snippet = idMeli;
    marker.map = mapView_;
}
-(void) ApiMeli:(NSString *) ciudad{
    
    
    NSString *urlString = @"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=50&state=TUxDUE1FVEExM2JlYg&city=TUxDQ1NBTjk4M2M";
    
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
                              
                              
                              
                              /*PropMeli *prop = [[PropMeli alloc] init];
                              [prop setIdMeli:[valor objectForKey:@"id"]];
                              [prop setUrl:[valor objectForKey:@"permalink"]];
                              [prop setUrl:[valor objectForKey:@"latitude"]];
                              [prop setUrl:[valor objectForKey:@"longitude"]];
                              [prop setImagen:[valor objectForKey:@"mosaic_picture"]];
                              
                              [self.listado addObject:prop];*/
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
