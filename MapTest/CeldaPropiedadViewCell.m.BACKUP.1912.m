//
//  CeldaPropiedadViewCell.m
//  MapTest
//
//  Created by Santos Ramon on 7/22/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//
#import "QuartzCore/QuartzCore.h"

#import "CeldaPropiedadViewCell.h"
#import "AlphaGradientView.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"

@interface CeldaPropiedadViewCell(){
    UIActivityIndicatorView *activity;
<<<<<<< HEAD
    UIImageView *first;
=======
    NSDictionary *jsonData;
>>>>>>> v2
}
@end

@implementation CeldaPropiedadViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setData:(PropMeli*)data{
    //remover todo dentro del scrollview
    for(UIView *subview in [_scrollview subviews]) {
        [subview removeFromSuperview];
    }

    _propiedad = data;
<<<<<<< HEAD
    first = [[UIImageView alloc] init];
    first.frame = CGRectMake(0, 0, 320, 200);
    NSURL *urlImg =[NSURL URLWithString:_propiedad.imagen ];
    [first setImage:[UIImage imageNamed:@"imagenNoDisponible.jpg"]];
    [first setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"imagenNoDisponible.jpg"]];
=======
    
    UIImageView *first = [[UIImageView alloc] init];
    first.frame = CGRectMake(0, 0, 320, 200);
    NSURL *urlImg =[NSURL URLWithString:_propiedad.imagen ];
    [first setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"ImagenEspera.png"]];
>>>>>>> v2
    first.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollview addSubview:first];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake(320+160, 100, 10, 10);
    [activity startAnimating];
    [_scrollview addSubview:activity];
    _scrollview.contentSize = CGSizeMake(320*2, 200);
    
    UIButton *btnAgregarFavoritos = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAgregarFavoritos.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btnAgregarFavoritos.frame = CGRectMake(250.0f, 134.0f, 50.0f, 45.0f);
    
    if (_propiedad.esFavorito == YES) {
        [btnAgregarFavoritos setImage:[UIImage imageNamed:@"EsFavorito"] forState:UIControlStateSelected];
        [btnAgregarFavoritos setSelected:YES];
    } else {
        [btnAgregarFavoritos setImage:[UIImage imageNamed:@"NoEsFavorito"] forState:UIControlStateNormal];
        [btnAgregarFavoritos setSelected:NO];
    }
    
    [btnAgregarFavoritos setTintColor: [UIColor whiteColor]];
    [btnAgregarFavoritos addTarget:self action:@selector(toggleUIButtonImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAgregarFavoritos];

    _lblTitulo.text = _propiedad.title;
    _lblPrecio.text = _propiedad.precio;
<<<<<<< HEAD
    
    //recuperando el estado de la celda
    if(!CGPointEqualToPoint(_propiedad.currentOffset, CGPointZero)){
        if (_propiedad.imagenes) {
            [self showSlideShow:_propiedad.imagenes];
        } else {
            [self loadSlideShow];
        }
    } else {
        _propiedad.currentOffset = CGPointZero;
    }
    [_scrollview setContentOffset:_propiedad.currentOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_propiedad.imagenes) {
        [self showSlideShow:_propiedad.imagenes];
=======
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"Punto %f", scrollView.contentOffset.x);
    if (jsonData) {
        NSArray *items = [jsonData objectForKey:@"pictures"];
        [self showSlideShow:items];
>>>>>>> v2
    } else {
        [self loadSlideShow];
    }
}
<<<<<<< HEAD

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _propiedad.currentOffset = scrollView.contentOffset;    
}
=======
>>>>>>> v2

- (void)showSlideShow:(NSArray *)items{
    int i = 0;
    NSLog(@"-------------------------------------");
    for (NSDictionary *obj in items) {
        UIImageView *img = [[UIImageView alloc] init];
        //NSLog(@"img url %@", [obj objectForKey:@"url"]);
        img.frame = CGRectMake(i*320, 0, 320, 200);
        NSURL *urlImg = [NSURL URLWithString:[obj objectForKey:@"url"]];
        NSLog(@"CARGAR %@", [obj objectForKey:@"url"]);
        [img setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"ImagenEspera.png"]];
        img.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollview addSubview:img];
        i++;
    }
    _scrollview.contentSize = CGSizeMake(320*items.count, 200);
    _scrollview.frame = CGRectMake(0, 0, 320, 200);
    [activity stopAnimating];
}

-(void)loadSlideShow{
    NSString *string = [NSString stringWithFormat:@"https://api.mercadolibre.com/items/%@?attributes=pictures",_propiedad.idMeli];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
<<<<<<< HEAD
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        _propiedad.imagenes = [jsonData objectForKey:@"pictures"];
        [self showSlideShow:_propiedad.imagenes];
=======
        jsonData = (NSDictionary *)responseObject;
        NSArray *items = [jsonData objectForKey:@"pictures"];
        [self showSlideShow:items];
>>>>>>> v2
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error cargando JSON"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    [operation start];
<<<<<<< HEAD
=======
    /*
     NSURL *url = [NSURL URLWithString:urlString];
     NSURLSession *session = [NSURLSession sharedSession];
     [[session dataTaskWithURL:url
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
     if (httpResponse.statusCode == 200)
     {
     NSError *jsonError;
     jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
     if (!jsonError)
     {
     NSArray *items = [jsonData objectForKey:@"pictures"];
     [self showSlideShow:items];
     }
     }
     }] resume];
     */
>>>>>>> v2
}

-(IBAction) toggleUIButtonImage:(UIButton*)sender{
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"NoEsFavorito"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        _propiedad.esFavorito = NO;
        
        
    } else {
        [sender setImage:[UIImage imageNamed:@"EsFavorito"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        _propiedad.esFavorito = YES;
    }
}
<<<<<<< HEAD
=======


/*
 if (_propiedad.img != nil) {
 AlphaGradientView* gradient = [[AlphaGradientView alloc] initWithFrame:
 CGRectMake(0, 0, self.frame.size.width,
 self.frame.size.height)];
 
 gradient.color = [UIColor blackColor];
 gradient.direction = GRADIENT_DOWN;
 UIColor *background = [[UIColor alloc] initWithPatternImage:_propiedad.img];
 gradient.backgroundColor = background;
 [self addSubview:gradient];
 self.backgroundView = gradient;
 }
 else
 {
 UIImageView *cbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagenNoDisponible.jpg"]];
 cbg.image = [UIImage imageNamed:@"imagenNoDisponible.jpg"];
 self.backgroundView = cbg;
 [self bajarImagenDesdeUrl:[NSURL URLWithString:_propiedad.imagen] completionBlock:^(BOOL succeeded, UIImage *image) {
 if (succeeded) {
 UIImage *miima = [self imageWithImage:image scaledToSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
 
 _propiedad.img = miima;
 }
 }];
 
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
 } else {
 completionBlock(NO,nil);
 }
 }];
 }
 
 - (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
 // UIGraphicsBeginImageContext(newSize);
 // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
 // Pass 1.0 to force exact pixel size.
 UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
 [image drawInRect:CGRectMake(0, 0, 320, 220)];
 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return newImage;
 }
 */

>>>>>>> v2
@end
