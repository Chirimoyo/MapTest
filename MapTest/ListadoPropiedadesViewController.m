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
    NSMutableArray *propiedades;
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
    
    NSString *urlString;

    
    if ([self.unidadGeografica.nombre rangeOfString:@"Santiago"].location != NSNotFound) {
        urlString = @"https://mobile.mercadolibre.com.ar/sites/MLC/search?category=MLC1480&limit=50&state=TUxDUE1FVEExM2JlYg&city=TUxDQ1NBTjk4M2M";
    } else {
        
        if ([self.unidadGeografica.nombre rangeOfString:@"del Mar"].location != NSNotFound) {
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
                             NSMutableArray *array = [NSMutableArray new];
                          for (id valor in value) {
                 
                              PropMeli *prop = [[PropMeli alloc] init];
                               [prop setIdMeli:[valor objectForKey:@"id"]];
                               [prop setUrl:[valor objectForKey:@"permalink"]];
                               [prop setUrl:[valor objectForKey:@"latitude"]];
                               [prop setUrl:[valor objectForKey:@"longitude"]];
                               [prop setImagen:[valor objectForKey:@"gallery_picture"]];
                               [prop setTitle:[valor objectForKey:@"title"]];
                              id precio = [valor objectForKey:@"price"];
                              NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                              [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
                              [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
                              NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:[precio doubleValue]]];
                               
                              
                               [prop setPrecio:[NSString stringWithFormat:@"%@ %@", @"$", numberString]];
                               [array addObject:prop];
                          }
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self refreshTableView: array];
                          });

                      }
                  }
                  
              }
              
          }
          
      }] resume];
    
    
    // Do any additional setup after loading the view.
}
- (void) refreshTableView:(NSMutableArray *)listado
{
    propiedades = listado;
    [tableview reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return propiedades.count;
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, 320, 220)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(IBAction)volverMapa:(id)sender
{


    //second.delegate  = self;

    
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

- (void)bajarImagenDesdeUrl:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PropMeli *propiedad = ((PropMeli * )propiedades[indexPath.row]);
    if (propiedad.img != nil) {
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:propiedad.img];
        cellBackgroundView.image = propiedad.img;
        cell.backgroundView = cellBackgroundView;

    }
    else
    {
        UIImageView *cbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"esperando1.png"]];
        cbg.image = [UIImage imageNamed:@"esperando1.png"];
        cell.backgroundView = cbg;
        
        //cell.imageView.image = ;
        [self bajarImagenDesdeUrl:[NSURL URLWithString:propiedad.imagen] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
               
                //cell.imageView.image = image;
                UIImage *miima = [self imageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height)];
                UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:miima];
                cellBackgroundView.image = miima;
                
                cell.backgroundView = cellBackgroundView;
                
                // pal cache..
                propiedad.img = miima;
            }
        }];

    }

    UILabel *recipeNameLabel = (UILabel *)[cell viewWithTag:102];
    recipeNameLabel.text = propiedad.title;
    
    UILabel *recipeDetailLabel = (UILabel *)[cell viewWithTag:103];
    recipeDetailLabel.text = propiedad.precio;
    
    return cell;
}


@end
