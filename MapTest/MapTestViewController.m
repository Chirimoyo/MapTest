//
//  MapTestViewController.m
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/17/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "MapTestViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *input;
@end


@implementation MapTestViewController {
    GMSMapView *mapView_;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.input.delegate = self; // ADD THIS LINE
    [self.view addSubview:self.input];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.437005
                                                            longitude:-70.650572
                                                                 zoom:10];
    mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.mapView addSubview: mapView_];
    
    
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.437005, -70.650572);
    marker.title = @"Santiago";
    marker.snippet = @"Chile";
    marker.map = mapView_;
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)buscarTexto:(id)sender {

    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=fr&sensor=true&key=AIzaSyA6ORrTeE4pXuzmbP9nm2nFpgoLB_EHhlc", self.input.text];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url
      
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      
      {
          
          NSLog(@"Got response %@ with error %@.\n", response, error);
          
          NSLog(@"DATA:\n%@\nEND DATA\n",
                
                [[NSString alloc] initWithData: data
                 
                                      encoding: NSUTF8StringEncoding]);
          
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          
          if (httpResponse.statusCode == 200)
              
          {
              
              NSError *jsonError;
              
              NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
              
              NSMutableArray *modelData = [NSMutableArray new];
              
              if (!jsonError)
                  
              {
                  
                  
                  
              }
              
          }
          
      }] resume];}

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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=fr&sensor=true&key=AIzaSyA6ORrTeE4pXuzmbP9nm2nFpgoLB_EHhlc", textField.text];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url
      
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      
      {
          
          NSLog(@"Got response %@ with error %@.\n", response, error);
          
          NSLog(@"DATA:\n%@\nEND DATA\n",
                
                [[NSString alloc] initWithData: data
                 
                                      encoding: NSUTF8StringEncoding]);
          
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          
          if (httpResponse.statusCode == 200)
              
          {
              
              NSError *jsonError;
              
              NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
              
              NSMutableArray *modelData = [NSMutableArray new];
              
              if (!jsonError)
                  
              {
                  
                  
                  
              }
              
          }
          
      }] resume];
    return true;
    }
@end
