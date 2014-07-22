//
//  CeldaPropiedadViewCell.m
//  MapTest
//
//  Created by Santos Ramon on 7/22/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "CeldaPropiedadViewCell.h"
#import "AlphaGradientView.h"

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
    _propiedad = data;
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
                
                AlphaGradientView* gradient = [[AlphaGradientView alloc] initWithFrame:
                                               CGRectMake(0, 0, self.frame.size.width,
                                                          self.frame.size.height)];
                
                gradient.color = [UIColor blackColor];
                gradient.direction = GRADIENT_DOWN;
                UIColor *background = [[UIColor alloc] initWithPatternImage:miima];
                gradient.backgroundColor = background;
                [self addSubview:gradient];
                
                self.backgroundView = gradient;
                _propiedad.img = miima;
            }
        }];
        
    }
    
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
    /*
    btnAgregarFavoritos.tag = indexPath.row;
    [btnAgregarFavoritos setTintColor: [UIColor whiteColor]];
    [btnAgregarFavoritos addTarget:self action:@selector(toggleUIButtonImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAgregarFavoritos];
    */
    
    _lblTitulo.text = _propiedad.title;
    _lblPrecio.text = _propiedad.precio;
    [self loadSlideShow];
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

- (void)showSlideShow:(NSArray *)items{
    int i = 0;
    for (NSDictionary *obj in items) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagenNoDisponible.jpg"]];
        img.frame = CGRectMake(i*320, 0, 320, 200);
        [self bajarImagenDesdeUrl:[NSURL URLWithString:[obj objectForKey:@"url"]] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                UIImage *miima = [self imageWithImage:image scaledToSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
                img.image = miima;
                [_scrollview addSubview:img];
            }
        }];
        i++;
    }
    _scrollview.contentSize = CGSizeMake(320*items.count, 200);
    _scrollview.frame = CGRectMake(0, 0, 320, 200);
}

-(void)loadSlideShow{
    NSString *urlString = [NSString stringWithFormat:@"https://api.mercadolibre.com/items/%@?attributes=pictures",_propiedad.idMeli];
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
                  NSArray *items = [jsonData objectForKey:@"pictures"];
                  [self showSlideShow:items];
              }
          }
      }] resume];
}

@end
