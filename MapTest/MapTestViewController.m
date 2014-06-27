//
//  MapTestViewController.m
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/17/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "MapTestViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "PropMeli.h"


@interface MapTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (strong, nonatomic) NSMutableArray * listado;


//@property (strong, nonatomic) CLLocationManager *location;
@end

@implementation MapTestViewController {
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    
    
}
@synthesize delegate;

- (NSMutableArray *) listado{
    if(!_listado) _listado = [self crearListado];
    return _listado;
}
-(NSMutableArray *) crearListado{
    return [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    
    locationManager = [[CLLocationManager alloc] init];
    //location.delegate = self;
    self.input.text = self.nombreCiudad;
    [locationManager startUpdatingLocation];
    [super viewDidLoad];
    self.input.delegate = self;
    [self.view addSubview:self.input];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ZoomIn:(id)sender{
    CGFloat currentZoom = mapView_.camera.zoom;
    [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithTarget: mapView_.camera.target zoom:currentZoom + 1]];
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"esta editando????");
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}
*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSString *nombreUgeo = [[textField text]
                            stringByReplacingCharactersInRange:range withString:string];
    
    NSString *urlString = [NSString  stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=cl&sensor=true&key=AIzaSyA6ORrTeE4pXuzmbP9nm2nFpgoLB_EHhlc&componentRestrictions={country:cl}", nombreUgeo];
    
    
    NSString *strUrl=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
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
                  if(!self.mapView.hidden){
                      [self.mapView setHidden: YES];
                      [tableView setHidden: NO];
                  }
                  
                  [self.listado removeAllObjects];
                  
                  for( id key in jsonData){
                      
                      if ( [key isEqualToString:@"predictions"]){
                          NSDictionary *value = [jsonData objectForKey:key];
                          for (id valor in value) {
                              [self.listado addObject:[valor objectForKey:@"description"]];
                              
                              
                          }
                      }
                  }
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self refreshTableView];
                  });
                  
              }
              
          }
          
      }] resume];
    
    return true;
}

- (void) refreshTableView
{
    [tableView reloadData];
}

- (void) refreshTableContenido
{
    /* if ([self isMainThread]) {
     [tablecontent reloadData];
     }*/
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [self.listado count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we coigure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    cell.textLabel.text = [self.listado objectAtIndex:indexPath.row];
    return cell;
    [self.listado removeAllObjects];
    
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.input setText: cell.textLabel.text];
    [self.view endEditing:YES];
    [self.mapView setHidden: NO];
    [tableView setHidden: YES];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&types=geocode&language=fr&sensor=true&key=AIzaSyA6ORrTeE4pXuzmbP9nm2nFpgoLB_EHhlc", cell.textLabel.text ];
    
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
                  [self.listado removeAllObjects];
                  for( id key in jsonData){
                      
                      if ( [key isEqualToString:@"results"]){
                          NSDictionary *value = [jsonData objectForKey:key];
                          for (id valor in value) {
                              id lat= [[[valor objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
                              id lng= [[[valor objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
                              
                              UnidadGeografica *ugeo = [UnidadGeografica new];
                              [ugeo setLatitud:lat];
                              [ugeo setLongitud:lng];
                              [ugeo setNombre:cell.textLabel.text];
                              //NSString *itemToPassBack = @"Pass this value back to ViewControllerA";
                              [self.delegate addItemViewController:self didFinishEnteringItem:ugeo];
                              dispatch_async(dispatch_get_main_queue(), ^{
                              [self dismissViewControllerAnimated:YES completion:nil];
                              });
                                             
                              
                          }
                      }
                  }
                  [tableView reloadData];
              }
              
          }
          
      }] resume];
}



@end
