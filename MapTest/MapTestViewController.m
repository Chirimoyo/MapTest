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
#import "Busqueda.h"
#import <QuartzCore/QuartzCore.h>


@interface MapTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tipoPropiedad;
@property (weak, nonatomic) IBOutlet UIButton *btnRangoPrecio;
@property (weak, nonatomic) IBOutlet UIButton *btnSuperficie;
@property (weak, nonatomic) IBOutlet UIButton *btnLimpiar;

@property (weak, nonatomic) IBOutlet UIView *viewTipoPropiedad;

@property (weak, nonatomic) IBOutlet UIView *vistaRangoPrecios;
@property (weak, nonatomic) IBOutlet UIView *vistaSuperficie;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UILabel *lblPrecio;
@property (weak, nonatomic) IBOutlet UILabel *lblDormitorios;
@property (weak, nonatomic) IBOutlet UILabel *lblBanos;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerTipoPropiedad;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerRangoDesde;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerRangoHasta;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerSuperficie;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedDormitorios;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedBanos;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedTipoOperacion;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedTipoMoneda;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray * listado;
@property (strong, nonatomic) NSArray *arrayTipoPropiedad;
@property (strong, nonatomic) NSArray *arrayTipoMoneda;

@property (strong, nonatomic) NSMutableArray *arrayPrecioArriendoPesosDesde;
@property (strong, nonatomic) NSMutableArray *arrayPrecioArriendoPesosHasta;
@property (strong, nonatomic) NSMutableArray *arrayPrecioCompraPesosDesde;
@property (strong, nonatomic) NSMutableArray *arrayPrecioCompraPesosHasta;
@property (strong, nonatomic) NSMutableArray *arrayPrecioArriendoUFDesde;
@property (strong, nonatomic) NSMutableArray *arrayPrecioArriendoUFHasta;
@property (strong, nonatomic) NSMutableArray *arrayPrecioCompraUFDesde;
@property (strong, nonatomic) NSMutableArray *arrayPrecioCompraUFHasta;

@property (strong, nonatomic) NSArray *arraySuperficie;
@property (weak, nonatomic) IBOutlet UIView *vistaResultadoGoogle;
@property (weak, nonatomic) IBOutlet UIView *vistafiltros;
@property (strong, nonatomic) Busqueda *busqueda;

@property (strong, nonatomic) NSNumber *filaDesdeCompra;;
@property (strong, nonatomic) NSNumber *filaDesdeArriendo;
@property (strong, nonatomic) NSNumber *filaHastaCompra;
@property (strong, nonatomic) NSNumber *filaHastaArriendo;

@end

@implementation MapTestViewController {
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
}

@synthesize delegate;
@synthesize arrayTipoPropiedad;
@synthesize arrayTipoMoneda;
@synthesize arrayPrecioArriendoPesosDesde;
@synthesize arrayPrecioArriendoPesosHasta;
@synthesize arrayPrecioCompraPesosDesde;
@synthesize arrayPrecioCompraPesosHasta;
@synthesize arrayPrecioArriendoUFDesde;
@synthesize arrayPrecioArriendoUFHasta;
@synthesize arrayPrecioCompraUFDesde;
@synthesize arrayPrecioCompraUFHasta;
@synthesize arraySuperficie;
@synthesize busqueda;
@synthesize filaDesdeCompra;
@synthesize filaDesdeArriendo;
@synthesize filaHastaCompra;
@synthesize filaHastaArriendo;

bool isShown = false;

- (NSMutableArray *) listado{
    if(!_listado) _listado = [self crearListado];
    return _listado;
}
-(NSMutableArray *) crearListado{
    return [[NSMutableArray alloc] init];
}

-(BOOL) cerrarPickers{
    BOOL cerro;
    cerro = NO;
    CGRect frame ;
    UIPickerView *picker;
    for (id view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            UIView *vista = (UIView *) view;
             frame = vista.frame;
            if (frame.size.height >= 162 ){
                frame.size.height = 0;
                for (id elemento in vista.subviews) {
                    if ([elemento isKindOfClass:[UIPickerView class]]) {
                         picker = (UIPickerView *) elemento;
                        picker.hidden = YES;
                        cerro = YES;
                    }
                }
                [UIView animateWithDuration:0.5 animations:^{
                    vista.frame = frame;
                } completion:^(BOOL finished) {
                }];
            }
        }
    }
    return cerro;
}

-(IBAction) superficieClick:(id)sender{
    CGRect frameSuperficie = self.vistaSuperficie.frame;
    CGRect framebtnSuperficie = self.btnSuperficie.frame;
    CGRect frameLblDormitorio = self.lblDormitorios.frame;
    CGRect frameSegmentedDormitorio = self.segmentedDormitorios.frame;
    CGRect frameLblBanos = self.lblBanos.frame;
    CGRect frameSegmentedBanos = self.segmentedBanos.frame;
    CGRect frameBtnLimpiar = self.btnLimpiar.frame;
    CGRect framelblPrecio = self.lblPrecio.frame;
    CGRect framebtnRangoPrecio = self.btnRangoPrecio.frame;

    if (frameSuperficie.size.height == 172){
        frameSuperficie.size.height = 0;
        frameLblDormitorio.origin.y = 225;
        frameSegmentedDormitorio.origin.y = 247;
        frameLblBanos.origin.y = 285;
        frameSegmentedBanos.origin.y = 308;
        frameBtnLimpiar.origin.y = 388;
        self.pickerSuperficie.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.lblDormitorios.frame = frameLblDormitorio;
            self.segmentedDormitorios.frame = frameSegmentedDormitorio;
            self.lblBanos.frame = frameLblBanos;
            self.segmentedBanos.frame = frameSegmentedBanos;
            self.btnLimpiar.frame = frameBtnLimpiar;
            self.vistaSuperficie.frame = frameSuperficie;
         }];
        
    }
    else{
        if(self.btnSuperficie.frame.origin.y > 178)
        {
            framebtnRangoPrecio.origin.y = 127;
            framelblPrecio.origin.y = 105;
            framebtnSuperficie.origin.y = 178;
            frameLblDormitorio.origin.y = 225 + 172;
            frameSegmentedDormitorio.origin.y = 247 + 172;
            frameLblBanos.origin.y = 285 + 172;
            frameSegmentedBanos.origin.y = 308 + 172;
            frameBtnLimpiar.origin.y = 388 + 172;
            if(frameSuperficie.size.height == 172)
                frameSuperficie.size.height = 0;
            else
                frameSuperficie.size.height = 172;
            
            [UIView animateWithDuration:0.5 animations:^{
                [self cerrarPickers];
                self.btnSuperficie.frame = framebtnSuperficie;
                self.lblDormitorios.frame = frameLblDormitorio;
                self.segmentedDormitorios.frame = frameSegmentedDormitorio;
                self.lblBanos.frame = frameLblBanos;
                self.segmentedBanos.frame = frameSegmentedBanos;
                self.btnLimpiar.frame = frameBtnLimpiar;
                self.lblPrecio.frame = framelblPrecio;
                self.btnRangoPrecio.frame = framebtnRangoPrecio;
            } completion:^(BOOL finished)
             {
                 [UIView animateWithDuration:0.5 animations:^{
                     self.vistaSuperficie.frame = frameSuperficie;
                 } completion:^(BOOL finished) {
                     if(frameSuperficie.size.height == 172){
                         self.pickerSuperficie.hidden=NO;
                     }
                     else
                         self.pickerSuperficie.hidden=YES;
                 }];
             }];
        }
        else{
            if(self.btnSuperficie.frame.origin.y == 178 && frameSuperficie.size.height == 0){
            frameLblDormitorio.origin.y = 225 + 172;
            frameSegmentedDormitorio.origin.y = 247 + 172;
            frameLblBanos.origin.y = 285 + 172;
            frameSegmentedBanos.origin.y = 308 + 172;
            frameBtnLimpiar.origin.y = 388 + 172;
            if(frameSuperficie.size.height == 172)
                frameSuperficie.size.height = 0;
            else
                frameSuperficie.size.height = 172;
            [UIView animateWithDuration:0.5 animations:^{
                self.lblDormitorios.frame = frameLblDormitorio;
                self.segmentedDormitorios.frame = frameSegmentedDormitorio;
                self.lblBanos.frame = frameLblBanos;
                self.segmentedBanos.frame = frameSegmentedBanos;
                self.btnLimpiar.frame = frameBtnLimpiar;
                self.vistaSuperficie.frame = frameSuperficie;
            } completion:^(BOOL finished)
             {
                if(frameSuperficie.size.height == 172)
                    self.pickerSuperficie.hidden=NO;
                else
                    self.pickerSuperficie.hidden=YES;
             }];
         }
        }
        
    }
}

-(IBAction) rangoPrecioClick:(id)sender{
    
    CGRect frameRangoPrecios = self.vistaRangoPrecios.frame;
    CGRect framebtnRangoPrecio = self.btnRangoPrecio.frame;
    CGRect framelblPrecio = self.lblPrecio.frame;
    CGRect framebtnSuperficie = self.btnSuperficie.frame;
    CGRect frameLblDormitorio = self.lblDormitorios.frame;
    CGRect frameSegmentedDormitorio = self.segmentedDormitorios.frame;
    CGRect frameLblBanos = self.lblBanos.frame;
    CGRect frameSegmentedBanos = self.segmentedBanos.frame;
    CGRect frameBtnLimpiar = self.btnLimpiar.frame;

    if (frameRangoPrecios.size.height == 162){
        frameRangoPrecios.size.height = 0;
        self.pickerRangoDesde.hidden = YES;
        self.pickerRangoHasta.hidden = YES;
        framebtnSuperficie.origin.y = 178;
        frameLblDormitorio.origin.y = 225;
        frameSegmentedDormitorio.origin.y = 247;
        frameLblBanos.origin.y = 285;
        frameSegmentedBanos.origin.y = 308;
        frameBtnLimpiar.origin.y = 388;
        [UIView animateWithDuration:0.5 animations:^{
            self.lblDormitorios.frame = frameLblDormitorio;
            self.segmentedDormitorios.frame = frameSegmentedDormitorio;
            self.lblBanos.frame = frameLblBanos;
            self.segmentedBanos.frame = frameSegmentedBanos;
            self.btnLimpiar.frame = frameBtnLimpiar;
            self.btnSuperficie.frame = framebtnSuperficie;
            self.vistaRangoPrecios.frame = frameRangoPrecios;
        }];
        
        
    }else{
        if(self.btnRangoPrecio.frame.origin.y > 127)
        {
            framebtnRangoPrecio.origin.y = 127;
            framelblPrecio.origin.y = 105;
            framebtnSuperficie.origin.y = 178 + 162;
            frameLblDormitorio.origin.y = 225 + 162;
            frameSegmentedDormitorio.origin.y = 247 + 162;
            frameLblBanos.origin.y = 285 + 162;
            frameSegmentedBanos.origin.y = 308 + 162;
            frameBtnLimpiar.origin.y = 388 + 162;
            if(frameRangoPrecios.size.height == 162)
                frameRangoPrecios.size.height = 0;
            else
                frameRangoPrecios.size.height = 162;
            [UIView animateWithDuration:0.5  animations:^{
                [self cerrarPickers];
                self.btnRangoPrecio.frame = framebtnRangoPrecio;
                self.lblPrecio.frame = framelblPrecio;
                self.lblDormitorios.frame = frameLblDormitorio;
                self.segmentedDormitorios.frame = frameSegmentedDormitorio;
                self.lblBanos.frame = frameLblBanos;
                self.segmentedBanos.frame = frameSegmentedBanos;
                self.btnLimpiar.frame = frameBtnLimpiar;
                self.btnSuperficie.frame = framebtnSuperficie;
            } completion:^(BOOL finished)
             {
                 [UIView animateWithDuration:0.5   animations:^{
                     self.vistaRangoPrecios.frame = frameRangoPrecios;
                 } completion:^(BOOL finished) {
                     if(frameRangoPrecios.size.height == 162){
                         self.pickerRangoDesde.hidden=NO;
                         self.pickerRangoHasta.hidden=NO;
                     }
                     else{
                         self.pickerRangoDesde.hidden=YES;
                         self.pickerRangoHasta.hidden=YES;
                     }
                     
                 }];
             }];
            
        }
        else{
                double delay = ([self cerrarPickers] == YES? 0.5 : 0 );
                framebtnSuperficie.origin.y = 178 + 162;
                frameLblDormitorio.origin.y = 225 + 162;
                frameSegmentedDormitorio.origin.y = 247 + 162;
                frameLblBanos.origin.y = 285 + 162;
                frameSegmentedBanos.origin.y = 308 + 162;
                frameBtnLimpiar.origin.y = 388 + 162;
                frameRangoPrecios.size.height = 162;
                [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.vistaRangoPrecios.frame = frameRangoPrecios;
                    self.lblDormitorios.frame = frameLblDormitorio;
                    self.segmentedDormitorios.frame = frameSegmentedDormitorio;
                    self.lblBanos.frame = frameLblBanos;
                    self.segmentedBanos.frame = frameSegmentedBanos;
                    self.btnLimpiar.frame = frameBtnLimpiar;
                    self.btnSuperficie.frame = framebtnSuperficie;
                    [self.vistafiltros setUserInteractionEnabled:NO];
                    
                } completion:^(BOOL finished)
                 {
                     self.pickerRangoDesde.hidden=NO;
                     self.pickerRangoHasta.hidden=NO;
                     [self.vistafiltros setUserInteractionEnabled:YES];
                 }];
            }
    }
}

- (IBAction)tipoPropiedadClick:(id)sender {
    CGRect frameTipoPropiedad = self.viewTipoPropiedad.frame;
    CGRect framebtnRangoPrecio = self.btnRangoPrecio.frame;
    CGRect framelblPrecio = self.lblPrecio.frame;
    CGRect framebtnSuperficie = self.btnSuperficie.frame;
    CGRect frameLblDormitorio = self.lblDormitorios.frame;
    CGRect frameSegmentedDormitorio = self.segmentedDormitorios.frame;
    CGRect frameLblBanos = self.lblBanos.frame;
    CGRect frameSegmentedBanos = self.segmentedBanos.frame;
    CGRect frameBtnLimpiar = self.btnLimpiar.frame;
    CGRect framesegmentedTipoMonedas = self.segmentedTipoMoneda.frame;
    BOOL cerroPickers = NO;
    if (frameTipoPropiedad.size.height == 162){
        frameTipoPropiedad.size.height = 0;
        self.pickerTipoPropiedad.hidden = YES;
        framebtnRangoPrecio.origin.y = 127;
        framesegmentedTipoMonedas.origin.y = 127;
        framelblPrecio.origin.y = 95;
        framebtnSuperficie.origin.y = 178;
        frameLblDormitorio.origin.y = 225;
        frameSegmentedDormitorio.origin.y = 247;
        frameLblBanos.origin.y = 285;
        frameSegmentedBanos.origin.y = 308;
        frameBtnLimpiar.origin.y = 388;
    }
    else{
        cerroPickers = [self cerrarPickers];
        frameTipoPropiedad.size.height = 162;
        framebtnRangoPrecio.origin.y = 127 + 162;
        framesegmentedTipoMonedas.origin.y = 127 + 162;
        framelblPrecio.origin.y = 95  + 162;
        framebtnSuperficie.origin.y = 178 + 162;
        frameLblDormitorio.origin.y = 225 + 162;
        frameSegmentedDormitorio.origin.y = 247 + 162;
        frameLblBanos.origin.y = 285 + 162;
        frameSegmentedBanos.origin.y = 308 + 162;
        frameBtnLimpiar.origin.y = 388 + 162;

    }
    if(cerroPickers){
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.btnRangoPrecio.frame = framebtnRangoPrecio;
            self.lblPrecio.frame = framelblPrecio;
            self.btnSuperficie.frame = framebtnSuperficie;
            self.lblDormitorios.frame = frameLblDormitorio;
            self.segmentedDormitorios.frame = frameSegmentedDormitorio;
            self.lblBanos.frame = frameLblBanos;
            self.segmentedBanos.frame = frameSegmentedBanos;
            self.btnLimpiar.frame = frameBtnLimpiar;
            self.viewTipoPropiedad.frame = frameTipoPropiedad;
            self.segmentedTipoMoneda.frame = framesegmentedTipoMonedas;
        } completion:^(BOOL finished) {
                self.pickerTipoPropiedad.hidden=NO;
        }];

    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.viewTipoPropiedad.frame = frameTipoPropiedad;
            self.btnRangoPrecio.frame = framebtnRangoPrecio;
            self.lblPrecio.frame = framelblPrecio;
            self.btnSuperficie.frame = framebtnSuperficie;
            self.lblDormitorios.frame = frameLblDormitorio;
            self.segmentedDormitorios.frame = frameSegmentedDormitorio;
            self.lblBanos.frame = frameLblBanos;
            self.segmentedBanos.frame = frameSegmentedBanos;
            self.btnLimpiar.frame = frameBtnLimpiar;
            self.segmentedTipoMoneda.frame = framesegmentedTipoMonedas;
            
        } completion:^(BOOL finished) {
            if(frameTipoPropiedad.size.height == 162)
                self.pickerTipoPropiedad.hidden=NO;
            self.viewTipoPropiedad.frame = frameTipoPropiedad;
        }];

    }
    
}

- (void) agregarLabelBoton: (UIButton *) button texto:(NSString *)texto {
    double buttonheight = button.frame.size.height;
    UILabel *buttonLabel ;
    for (UIView *subView in button.subviews)
    {
        if (subView.tag == 100){
            [subView removeFromSuperview];
        }
    }
    buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 100,buttonheight )];
    buttonLabel.textColor = button.titleLabel.tintColor;
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.text = texto;
    buttonLabel.tag = 100;
    buttonLabel.font = [UIFont systemFontOfSize:14];
    buttonLabel.textAlignment = UITextAlignmentCenter;
    [button addSubview:buttonLabel];
}

- (void)viewDidLoad
{
    self.pickerTipoPropiedad.showsSelectionIndicator = YES;
    [tableView setHidden: YES];
    
    locationManager = [[CLLocationManager alloc] init];
    //location.delegate = self;
    [self llamadoAutoComplete: self.nombreCiudad];
    if ([self.nombreCiudad rangeOfString:@"Posición actual"].location == NSNotFound) {
        self.input.text = self.nombreCiudad;
    } else {
        self.input.text = @"";
    }

    //self.input.text = self.nombreCiudad;
    [locationManager startUpdatingLocation];
    [super viewDidLoad];

    self.input.delegate = self;
    self.input.clearButtonMode = UITextFieldViewModeWhileEditing;
   
    [self cargarData];
    //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self redondearbotones:self.tipoPropiedad];
    [self redondearbotones:self.btnRangoPrecio];
    [self redondearbotones:self.btnSuperficie];

    CGAffineTransform t0 = CGAffineTransformMakeTranslation (0, self.pickerTipoPropiedad.bounds.size.height/2);
    CGAffineTransform s0 = CGAffineTransformMakeScale       (1.0, 0.8);
    CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -self.pickerTipoPropiedad.bounds.size.height/2);
    self.pickerTipoPropiedad.transform = CGAffineTransformConcat          (t0, CGAffineTransformConcat(s0, t1));
    
    
    t0 = CGAffineTransformMakeTranslation (0, self.pickerRangoDesde.bounds.size.height/2);
    s0 = CGAffineTransformMakeScale       (1.0, 0.8);
    t1 = CGAffineTransformMakeTranslation (0, -self.pickerRangoDesde.bounds.size.height/2);
    self.pickerRangoDesde.transform = CGAffineTransformConcat          (t0, CGAffineTransformConcat(s0, t1));
    
    t0 = CGAffineTransformMakeTranslation (0, self.pickerRangoHasta.bounds.size.height/2);
    s0 = CGAffineTransformMakeScale       (1.0, 0.8);
    t1 = CGAffineTransformMakeTranslation (0, -self.pickerRangoHasta.bounds.size.height/2);
    self.pickerRangoHasta.transform = CGAffineTransformConcat          (t0, CGAffineTransformConcat(s0, t1));
    
    t0 = CGAffineTransformMakeTranslation (0, self.pickerSuperficie.bounds.size.height/2);
    s0 = CGAffineTransformMakeScale       (1.0, 0.8);
    t1 = CGAffineTransformMakeTranslation (0, -self.pickerSuperficie.bounds.size.height/2);
    self.pickerSuperficie.transform = CGAffineTransformConcat          (t0, CGAffineTransformConcat(s0, t1));
    [self.view addSubview:self.input];
}

-(void) cargarData{
    arrayTipoPropiedad = [[NSArray alloc] initWithObjects:@"Todos",@"Casa", @"Departamento", nil];
    arrayTipoMoneda = [[NSArray alloc] initWithObjects:@"UF", @"Pesos", nil];
    
    arrayPrecioArriendoPesosDesde = [[NSMutableArray alloc] initWithObjects:@"No min",@"50.000",@"100.000", @"150.000",
                                     @"200.000",@"300.000", @"400.000",
                                     @"500.000",@"1.000.000", @"1.500.000",nil];
    arrayPrecioArriendoPesosHasta = [[NSMutableArray alloc] initWithObjects:@"No max",@"50.000",@"100.000", @"150.000",
                                     @"200.000",@"300.000", @"400.000",
                                     @"500.000",@"1.000.000", @"1.500.000",nil];
    
    arrayPrecioArriendoUFDesde = [[NSMutableArray alloc] initWithObjects: @"No min",@"2",@"4", @"6",@"10",@"14", @"18",
                                  @"22",@"26", @"30", nil];
    arrayPrecioArriendoUFHasta = [[NSMutableArray alloc] initWithObjects: @"No max",@"2",@"4", @"6",@"10",@"14", @"18",
                                  @"22",@"26", @"30", nil];
    
    arrayPrecioCompraPesosDesde = [[NSMutableArray alloc] initWithObjects:@"No min",@"10.000.000",@"20.000.000", @"30.000.000",
                                     @"50.000.000",@"70.000.000", @"100.000.000",
                                     @"150.000.000",@"200.000.000",nil];
    arrayPrecioCompraPesosHasta = [[NSMutableArray alloc] initWithObjects:@"No max",@"10.000.000",@"20.000.000", @"30.000.000",
                                    @"50.000.000",@"70.000.000", @"100.000.000",
                                    @"150.000.000",@"200.000.000",nil];
    
    arrayPrecioCompraUFDesde = [[NSMutableArray alloc] initWithObjects: @"No min",@"450",@"1000", @"1500",@"2500",@"3000", @"4000",
                                    @"6000",@"9000", nil];
    arrayPrecioCompraUFHasta = [[NSMutableArray alloc] initWithObjects: @"No max",@"450",@"1000", @"1500",@"2500",@"3000", @"4000",
                                    @"6000",@"9000", nil];
    
    
     arraySuperficie =[[NSArray alloc] initWithObjects:@"50 mts",@"100 mts", @"200 mts", nil];
    
    [self agregarLabelBoton:self.tipoPropiedad texto:@"Todos"];

}
- (void)redondearbotones:(UIButton *) boton{
    boton.layer.cornerRadius = 6;
    boton.clipsToBounds = YES;
    [[boton layer] setBorderWidth:1.0f];
    [[boton layer] setBorderColor:boton.tintColor.CGColor];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.vistaResultadoGoogle.hidden = NO;
    self.vistafiltros.hidden = YES;
    
    return YES;
}

-(IBAction)tipoOperacionClick:(id)sender
{
    NSString *valorHasta;
    NSString *valorDesde;
    if(self.segmentedTipoOperacion.selectedSegmentIndex == 0)
    {
        valorHasta = arrayPrecioArriendoPesosHasta[[self.pickerRangoHasta selectedRowInComponent:0]];
        valorDesde = arrayPrecioArriendoPesosDesde[[self.pickerRangoDesde selectedRowInComponent:0]];
        self.filaDesdeArriendo = [NSNumber numberWithInteger: [arrayPrecioArriendoPesosDesde indexOfObject:valorDesde]];
        self.filaHastaArriendo = [NSNumber numberWithInteger: [arrayPrecioArriendoPesosHasta indexOfObject:valorHasta]];
        
        [self.pickerRangoDesde reloadComponent:0];
        [self cargarValoresPrecioHasta];
        [self.pickerRangoHasta reloadComponent:0];
        [self.pickerRangoDesde selectRow:[self.filaDesdeCompra integerValue] inComponent:0 animated:NO];
        [self.pickerRangoHasta selectRow:[self.filaHastaCompra integerValue] inComponent:0 animated:NO];
    }
    else{
        
        valorHasta = arrayPrecioCompraPesosHasta[[self.pickerRangoHasta selectedRowInComponent:0]];
        valorDesde = arrayPrecioCompraPesosDesde[[self.pickerRangoDesde selectedRowInComponent:0]];
        self.filaDesdeCompra = [NSNumber numberWithInteger: [arrayPrecioCompraPesosDesde indexOfObject:valorDesde]];
        self.filaHastaCompra = [NSNumber numberWithInteger: [arrayPrecioCompraPesosHasta indexOfObject:valorHasta]];
        [self.pickerRangoDesde reloadComponent:0];
        [self cargarValoresPrecioHasta];
        
        [self.pickerRangoHasta reloadComponent:0];
        
        [self.pickerRangoDesde selectRow:[self.filaDesdeArriendo intValue] inComponent:0 animated:NO];
        
        [self.pickerRangoHasta selectRow:[self.filaHastaArriendo intValue] inComponent:0 animated:NO];
    }
    
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tipoMonedaClick:(id)sender{
    [self.pickerRangoDesde reloadComponent:0];
    [self.pickerRangoHasta reloadComponent:0];
}


-(void)llamadoAutoComplete:(NSString *)nombreUgeo{

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
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        [self llamadoAutoComplete:[[textField text]
                stringByReplacingCharactersInRange:range withString:string]];
    
    return true;
}

- (void) refreshTableView
{
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [self.listado count];
}

- (IBAction)btnAceptar:(id)sender{

    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&types=geocode&language=fr&sensor=true&key=AIzaSyA6ORrTeE4pXuzmbP9nm2nFpgoLB_EHhlc", self.input.text ];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:self.input.text forKey:@"ultimaBusqueda"];

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
                              [ugeo setNombre:self.input.text];
                              [busqueda setUnidadGeografica: ugeo];
                              
                              //NSString *itemToPassBack = @"Pass this value back to ViewControllerA";
                              [self.delegate addItemViewController:self didFinishEnteringItem:busqueda];
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

- (IBAction)CerrarModal:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) cargarValoresPrecioHasta{
    //TODO: refactorizar
    if(self.segmentedTipoOperacion.selectedSegmentIndex == 0)
    {
        
        NSString *valorHasta = arrayPrecioArriendoPesosHasta[[self.pickerRangoHasta selectedRowInComponent:0]];
        NSString *valorDesde = arrayPrecioArriendoPesosDesde[[self.pickerRangoDesde selectedRowInComponent:0]];
        NSInteger filaDesde = [arrayPrecioArriendoPesosDesde indexOfObject:valorDesde];
        
        NSInteger totalElementosPicker = [arrayPrecioCompraPesosDesde count];

        [arrayPrecioCompraPesosHasta removeAllObjects];
        [arrayPrecioCompraUFHasta removeAllObjects];
        
        [arrayPrecioCompraPesosHasta addObject:@"No max"];
        [arrayPrecioCompraUFHasta addObject:@"No max"];
        
        for(NSInteger i = filaDesde; i < totalElementosPicker; i++)
        {
            if(i != 0){
                [arrayPrecioCompraPesosHasta addObject:arrayPrecioCompraPesosDesde[i]];
                [arrayPrecioCompraUFHasta addObject:arrayPrecioCompraUFDesde[i]];
            }
        }
    }
    else{
        NSString *valorHasta = arrayPrecioCompraPesosHasta[[self.pickerRangoHasta selectedRowInComponent:0]];
        NSString *valorDesde = arrayPrecioCompraPesosDesde[[self.pickerRangoDesde selectedRowInComponent:0]];
        NSInteger filaDesde = [arrayPrecioCompraPesosDesde indexOfObject:valorDesde];
       
        NSInteger totalElementosPicker = [arrayPrecioArriendoPesosDesde count];
        
        [arrayPrecioArriendoPesosHasta removeAllObjects];
        [arrayPrecioArriendoUFHasta removeAllObjects];
        
        [arrayPrecioArriendoPesosHasta addObject:@"No max"];
        [arrayPrecioArriendoUFHasta addObject:@"No max"];
        
        for(NSInteger i = filaDesde; i < totalElementosPicker; i++)
        {
            if(i != 0){
                [arrayPrecioArriendoPesosHasta addObject:arrayPrecioArriendoPesosDesde[i]];
                [arrayPrecioArriendoUFHasta addObject:arrayPrecioArriendoUFDesde[i]];
            }
        }

    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == self.pickerTipoPropiedad)
        [self agregarLabelBoton: self.tipoPropiedad texto:[arrayTipoPropiedad objectAtIndex:row]];
    else
            if(pickerView == self.pickerRangoHasta)
            {
              
                [self cargarValoresPrecioHasta];
                [self.pickerRangoHasta reloadComponent:0];
            }
            else{
                if(pickerView == self.pickerRangoDesde){
                    NSString *valorHasta;
                    NSString *valorDesde;
                    //TODO: Refactorizar
                    if(self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                    {
                        if(self.segmentedTipoMoneda.selectedSegmentIndex == 0){
                            valorHasta = arrayPrecioCompraUFHasta[[self.pickerRangoHasta selectedRowInComponent:0]];
                            valorDesde = arrayPrecioCompraUFDesde[[self.pickerRangoDesde selectedRowInComponent:0]];
                        }
                        else{
                            valorHasta = arrayPrecioCompraPesosHasta[[self.pickerRangoHasta selectedRowInComponent:0]];
                            valorDesde = arrayPrecioCompraPesosDesde[[self.pickerRangoDesde selectedRowInComponent:0]];
                        }
                    }
                    else{
                        if(self.segmentedTipoMoneda.selectedSegmentIndex == 0){
                            valorHasta = arrayPrecioArriendoUFHasta[[self.pickerRangoHasta selectedRowInComponent:0]];
                            valorDesde = arrayPrecioArriendoUFDesde[[self.pickerRangoDesde selectedRowInComponent:0]];
                        }
                        else{
                            valorHasta = arrayPrecioArriendoPesosHasta[[self.pickerRangoHasta selectedRowInComponent:0]];
                            valorDesde = arrayPrecioArriendoPesosDesde[[self.pickerRangoDesde selectedRowInComponent:0]];
                        }
                    }
                    [self cargarValoresPrecioHasta];
                    [self.pickerRangoHasta reloadComponent:0];
                    NSInteger index;
                    if([valorHasta intValue] >= [valorDesde intValue]){
                        if(self.segmentedTipoMoneda.selectedSegmentIndex == 0){
                             if(self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                                index= [arrayPrecioCompraUFHasta indexOfObject:valorHasta];
                            else
                                index= [arrayPrecioArriendoUFHasta indexOfObject:valorHasta];
                        }
                        else{
                             if(self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                                index= [arrayPrecioCompraPesosHasta indexOfObject:valorHasta];
                            else
                                index= [arrayPrecioArriendoPesosHasta indexOfObject:valorHasta];
                        }
                    }
                    else
                        index = 0;
                    
                    [self.pickerRangoHasta selectRow:index inComponent:0 animated:NO];
                }
            }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   if(pickerView == self.pickerTipoPropiedad)
        return [arrayTipoPropiedad count];
    else{
            if(pickerView == self.pickerRangoDesde)
            {
                switch (self.segmentedTipoOperacion.selectedSegmentIndex) {
                    case 0:
                        
                        if( self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                             return [arrayPrecioCompraUFDesde count];
                        else
                             return [arrayPrecioCompraPesosDesde count];
                        break;
                    default: //para arriendo y arriendo de temporada
                        if( self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                            return [arrayPrecioArriendoUFDesde count];
                        else
                            return [arrayPrecioArriendoPesosDesde count];
                        break;
                }
            }
            else{
                if(pickerView == self.pickerRangoHasta){
                    switch (self.segmentedTipoOperacion.selected) {
                        case 0:
                            if( self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                                return [arrayPrecioCompraUFHasta count];
                            else
                                return [arrayPrecioCompraPesosHasta count];
                            break;
                        default: //para arriendo y arriendo de temporada
                            if( self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                                return [arrayPrecioArriendoUFHasta count];
                            else
                                return [arrayPrecioArriendoPesosHasta count];
                            break;
                    }
                }
                else{
                    if(pickerView == self.pickerSuperficie)
                        return [arraySuperficie count];
                    else
                        return 0;
                }
            }
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   if(pickerView == self.pickerTipoPropiedad)
        return [arrayTipoPropiedad objectAtIndex:row];
    else{
            if(pickerView == self.pickerRangoDesde)
                switch (self.segmentedTipoOperacion.selectedSegmentIndex) {
                    case 0:
                        if( self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                            return [arrayPrecioCompraUFDesde objectAtIndex:row];
                        else
                            return [arrayPrecioCompraPesosDesde objectAtIndex:row];
                        break;
                    default: //para arriendo y arriendo de temporada
                        if( self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                            return [arrayPrecioArriendoUFDesde objectAtIndex:row];
                        else
                            return [arrayPrecioArriendoPesosDesde objectAtIndex:row];
                        break;
                }
            else{
                if(pickerView == self.pickerRangoHasta)
                    switch (self.segmentedTipoOperacion.selectedSegmentIndex) {
                        case 0:
                            if( self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                                return [arrayPrecioCompraUFHasta objectAtIndex:row];
                            else
                                return [arrayPrecioCompraPesosHasta objectAtIndex:row];
                            break;
                        default: //para arriendo y arriendo de temporada
                            if( self.segmentedTipoMoneda.selectedSegmentIndex == 0)
                                return [arrayPrecioArriendoUFHasta objectAtIndex:row];
                            else
                                return [arrayPrecioArriendoPesosHasta objectAtIndex:row];
                            break;
                    }
                else{
                    return [arraySuperficie objectAtIndex:row];
                }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.input) {
        [textField resignFirstResponder];
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell *cell;
        static NSString *CellIdentifier = @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [self.listado objectAtIndex:indexPath.row];
    
        //[self.listado removeAllObjects];
    return cell;

}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.input setText: cell.textLabel.text];
    [self.view endEditing:YES];
    [self.mapView setHidden: NO];
    self.vistaResultadoGoogle.hidden = YES;
    tableView.hidden = YES;
    self.vistafiltros.hidden = NO;
}



@end
