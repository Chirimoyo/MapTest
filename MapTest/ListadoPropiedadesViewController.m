//
//  ListadoPropiedadesViewController.m
//  MapTest
//
//  Created by Alvaro Zenteno Almarza on 6/27/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "ListadoPropiedadesViewController.h"
#import "PropMeli.h"
#import "AlphaGradientView.h"

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
    [NSURLConnection  sendAsynchronousRequest:request
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


- (UIImage *) imagenFondoNegro:(UIImage *) image{

    CGFloat scale = image.scale;
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGRect rect = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
    CGContextDrawImage(context, rect, image.CGImage);
    
    UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *colorTwo = [UIColor colorWithRed:0 green:0 blue:0 alpha:50];
    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, NULL);
    
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,image.size.height),CGPointMake(0,50), 10);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return gradientImage;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PropMeli *propiedad = ((PropMeli * )propiedades[indexPath.row]);
    
  
    
    UISwipeGestureRecognizer *gestureR = [[UISwipeGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleSwipeFrom:)];
    [gestureR setDirection:UISwipeGestureRecognizerDirectionRight];//|UISwipeGestureRecognizerDirectionRight)];
    [cell addGestureRecognizer:gestureR];
    
    
   
    
    if (propiedad.img != nil) {
        
        AlphaGradientView* gradient = [[AlphaGradientView alloc] initWithFrame:
                                       CGRectMake(0, 0, cell.frame.size.width,
                                                  cell.frame.size.height)];
        
        gradient.color = [UIColor blackColor];
        gradient.direction = GRADIENT_DOWN;
        UIColor *background = [[UIColor alloc] initWithPatternImage:propiedad.img];
        gradient.backgroundColor = background;
        [cell addSubview:gradient];
        cell.backgroundView = gradient;

    
    }
    else
    {
        UIImageView *cbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagenNoDisponible.jpg"]];
        cbg.image = [UIImage imageNamed:@"imagenNoDisponible.jpg"];
        cell.backgroundView = cbg;
        [self bajarImagenDesdeUrl:[NSURL URLWithString:propiedad.imagen] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                
                 UIImage *miima = [self imageWithImage:image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height)];
                
                AlphaGradientView* gradient = [[AlphaGradientView alloc] initWithFrame:
                                               CGRectMake(0, 0, cell.frame.size.width,
                                                          cell.frame.size.height)];
                
                gradient.color = [UIColor blackColor];
                gradient.direction = GRADIENT_DOWN;
                UIColor *background = [[UIColor alloc] initWithPatternImage:miima];
                gradient.backgroundColor = background;
                [cell addSubview:gradient];

                cell.backgroundView = gradient;

                // pal cache..
                propiedad.img = miima;
            }
        }];

    }
    
    UIButton *btnAgregarFavoritos = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAgregarFavoritos.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btnAgregarFavoritos.frame = CGRectMake(250.0f, 134.0f, 50.0f, 45.0f);
    
    if (propiedad.esFavorito == YES) {
        [btnAgregarFavoritos setImage:[UIImage imageNamed:@"EsFavorito"] forState:UIControlStateSelected];
        [btnAgregarFavoritos setSelected:YES];
        
    } else {
        [btnAgregarFavoritos setImage:[UIImage imageNamed:@"NoEsFavorito"] forState:UIControlStateNormal];
        [btnAgregarFavoritos setSelected:NO];
    }
    
    btnAgregarFavoritos.tag = indexPath.row;
    [btnAgregarFavoritos setTintColor: [UIColor whiteColor]];
    [btnAgregarFavoritos addTarget:self action:@selector(toggleUIButtonImage:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnAgregarFavoritos];

    
    UILabel *recipeNameLabel = (UILabel *)[cell viewWithTag:102];
    recipeNameLabel.text = propiedad.title;
    
    UILabel *recipeDetailLabel = (UILabel *)[cell viewWithTag:103];
    recipeDetailLabel.text = propiedad.precio;
    
    
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


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    NSLog(@"%d = %d",recognizer.direction,recognizer.state);
}

@end
