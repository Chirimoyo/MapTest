//
//  MenuViewController.m
//  MapTest
//
//  Created by Santos Ramon on 7/31/14.
//  Copyright (c) 2014 Chirimoyos. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "MenuItem.h"
#import "UIViewController+ECSlidingViewController.h"

@interface MenuViewController (){
    NSArray *menuItems;
}
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@end

@implementation MenuViewController

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
    // Do any additional setup after loading the view.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    [self loadItems];
    [_tableview setBackgroundColor:[UIColor blackColor]];
    [self initSelected];
}

- (void)initSelected {
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:1];
    [_tableview selectRowAtIndexPath:myIP animated:YES  scrollPosition:UITableViewScrollPositionBottom];

}

- (void)loadItems{
    NSArray *seccion1 = @[
                          [[MenuItem alloc] initWithTitulo:@"Logo" icono:nil id:@"logo"],
                          [[MenuItem alloc] initWithTitulo:@"Login" icono:nil id:@"login"]
                        ];
    NSArray *seccion2 = @[
                          [[MenuItem alloc] initWithTitulo:@"Buscar" icono:@"buscar.png" id:@"buscar"]
                          ];
    NSArray *seccion3 = @[
                          [[MenuItem alloc] initWithTitulo:@"Mis favoritos" icono:@"favoritos.png" id:@"favoritos"],
                          [[MenuItem alloc] initWithTitulo:@"Mis búsquedas" icono:@"busquedas.png" id:@"busquedas"],
                          [[MenuItem alloc] initWithTitulo:@"Mis áreas de interés" icono:@"areas_interes.png" id:@"areas"],
                          [[MenuItem alloc] initWithTitulo:@"Mis cotizaciones" icono:@"cotizaciones.png" id:@"cotizaciones"]
                          ];
    NSArray *seccion4 = @[
                          [[MenuItem alloc] initWithTitulo:@"Encontrar corredor" icono:@"corredor.png" id:@"corredor"],
                          [[MenuItem alloc] initWithTitulo:@"Calificar aplicación" icono:@"calificar.png" id:@"calificar"],
                          [[MenuItem alloc] initWithTitulo:@"Compartir aplicación" icono:@"compartir.png" id:@"compartir"],
                          [[MenuItem alloc] initWithTitulo:@"Configuración" icono:@"config.png" id:@"configuracion"]
                          ];
    menuItems = @[seccion1, seccion2, seccion3, seccion4];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 29.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return menuItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *seccion = menuItems[section];
    return seccion.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    if (indexPath.section == 0 && indexPath.row == 0) {
    //pintamos la celda del logo
        CellIdentifier = @"celda_logo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
    //pintamos la celda de menu item
        CellIdentifier = @"celda_boton";
        MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        MenuItem *item = menuItems[indexPath.section][indexPath.row];
        cell.labelTitulo.text = item.titulo;
        cell.imgLogo.image = [UIImage imageNamed:item.icono];
        //seteamos el fondo de la celda
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:157.0/255.0 blue:218.0/255.0 alpha:1];
        [cell setSelectedBackgroundView:bgColorView];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"goHome" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 1.0f;
    return 0.0f;
}

- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

@end
