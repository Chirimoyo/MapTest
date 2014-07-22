//
//  ListadoPropiedadesViewController.m
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/27/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "ListadoPropiedadesViewController.h"
#import "PropMeli.h"
#import "CeldaPropiedadViewCell.h";

@interface ListadoPropiedadesViewController ()
@property NSMutableArray *propiedades;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation ListadoPropiedadesViewController
- (UIActivityIndicatorView *) activityIndicator{
    if(!_activityIndicator) _activityIndicator = [self createactivityIndicator];
    return _activityIndicator;
}

- (UIActivityIndicatorView * ) createactivityIndicator {
    return [UIActivityIndicatorView new];
}



@synthesize propiedades;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) cargarTabla: (NSInteger) offset{
    
    NSString *urlString;
    
    
    if ([self.unidadGeografica.nombre rangeOfString:@"Santiago"].location != NSNotFound) {
        urlString = [NSString stringWithFormat:@"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=3&state=TUxDUE1FVEExM2JlYg&city=TUxDQ1NBTjk4M2M&offset=%d" , offset];
    } else {
        
        if ([self.unidadGeografica.nombre rangeOfString:@"del Mar"].location != NSNotFound) {
            urlString = [ NSString stringWithFormat:@"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=3&state=TUxDUFZBTE84MDVj&city=TUxDQ1ZJ0WQ3ZGU4&offset=%d", offset];
        } else {
            
            urlString =[ NSString stringWithFormat: @"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=3&state=TUxDUERFTE9lODZj&city=TUxDQ0NPTjYwZTdk&offset=%d", offset];
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
                  int i = 1;
                  for( id key in jsonData){
                      
                      if ( [key isEqualToString:@"results"]){
                          NSDictionary *value = [jsonData objectForKey:key];
                          NSMutableArray *array = [NSMutableArray new];
                          for (id valor in value) {
                              
                              PropMeli *prop = [[PropMeli alloc] init];
                              [prop setIdMeli:[valor objectForKey:@"id"]];
                              [prop setUrl:[valor objectForKey:@"permalink"]];
                              [prop setUrl:[valor objectForKey:@"latitude"]];
                              [prop setUrl:[valor objectForKey:@"longitude"]];
                              [prop setImagen:[valor objectForKey:@"gallery_picture"]];
                              [prop setTitle:[valor objectForKey:@"title"]];
                              
                              prop.esFavorito = NO ;
                              id precio = [valor objectForKey:@"price"];
                              NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                              [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
                              [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
                              NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:[precio doubleValue]]];
                              
                              
                              [prop setPrecio:[NSString stringWithFormat:@"%@ %@", @"$", numberString]];
                              [array addObject:prop];
                              i++;
                          }
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self refreshTableView: array];
                              [self.activityIndicator stopAnimating];
                              self.navigationItem.titleView = nil;
                              
                          });
                          
                      }
                  }
                  
              }
              
          }
          
      }] resume];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    self.title = self.unidadGeografica.nombre ;
    propiedades =  [NSMutableArray new];
    [self cargarTabla:0];
}
- (void) refreshTableView:(NSMutableArray *)listado
{
    for (PropMeli *prop in listado) {
        [propiedades addObject:prop];
    }
    
    [tableview reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return propiedades.count;
}

-(IBAction) toggleUIButtonImage:(UIButton*)sender{
    PropMeli *propiedad = ((PropMeli * )propiedades[sender.tag]);
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"NoEsFavorito"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        propiedad.esFavorito = NO;

        
    } else {
        [sender setImage:[UIImage imageNamed:@"EsFavorito"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        propiedad.esFavorito = YES;

    }
}

-(IBAction)volverMapa:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    VistaMapaViewController *second = [storyboard instantiateViewControllerWithIdentifier:@"VistaMapaViewController"];
    UnidadGeografica *ugeo = [UnidadGeografica new];
    ugeo.nombre = [self title];
    second.ugeo = ugeo;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:second animated:YES ];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CeldaPropiedadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CeldaPropiedadViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setData:propiedades[indexPath.row]];
    return cell;
}

- (void)scrollViewDidEndDecelerating: (UIScrollView*)scroll {
    
    CGFloat currentOffset = scroll.contentOffset.y;
    CGFloat maximumOffset = scroll.contentSize.height - scroll.frame.size.height;

    if (maximumOffset - currentOffset <= 10.0) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [self.activityIndicator startAnimating];
        
        self.navigationItem.titleView = self.activityIndicator;
        
       [self cargarTabla: [propiedades count]  +1 ];
    }
}

@end
