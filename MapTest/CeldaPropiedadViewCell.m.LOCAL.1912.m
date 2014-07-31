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
    UIImageView *first;
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
    first = [[UIImageView alloc] init];
    first.frame = CGRectMake(0, 0, 320, 200);
    NSURL *urlImg =[NSURL URLWithString:_propiedad.imagen ];
    [first setImage:[UIImage imageNamed:@"imagenNoDisponible.jpg"]];
    [first setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"imagenNoDisponible.jpg"]];
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
    } else {
        [self loadSlideShow];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _propiedad.currentOffset = scrollView.contentOffset;    
}

- (void)showSlideShow:(NSArray *)items{
    int i = 0;
    for (NSDictionary *obj in items) {
        UIImageView *img = [[UIImageView alloc] init];
        //NSLog(@"img url %@", [obj objectForKey:@"url"]);
        img.frame = CGRectMake(i*320, 0, 320, 200);
        NSURL *urlImg = [NSURL URLWithString:[obj objectForKey:@"url"]];
        [img setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"imagenNoDisponible.jpg"]];
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
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        _propiedad.imagenes = [jsonData objectForKey:@"pictures"];
        [self showSlideShow:_propiedad.imagenes];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error cargando JSON"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    [operation start];
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
@end
