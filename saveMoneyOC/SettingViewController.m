//
//  SettingViewController.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/4/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//
#define DEFAULT_MODEL 0
#define LANGUAGE_MODEL 1
#define WALLPAPER_MODEL 2
#define CURRENCY_MODEL 3
#define  ENGLISH 0
#define  CHINESE 1

#import "SettingViewController.h"
#import "GlobalMacros.h"
#import "AccountBook.h"
@interface SettingViewController ()
@property NSInteger model;
@property NSInteger chosenLanguage;
@property NSInteger chosenCurrency;
@property NaviView *naviView;
@property UIImagePickerController *picker;
@property UIImage *pickedImage;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIImageView *hehe;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView = [[NaviView alloc]init];
    self.naviView.delegate = self;
    [self.naviView.rightButton setBackgroundImage:[UIImage imageNamed:@"crossCancel"] forState:normal];
    self.naviView.leftButton.frame = CGRectMake(self.naviView.leftButton.frame.origin.x+5, self.naviView.leftButton.frame.origin.y, 25, 25);
    [self.view addSubview:self.naviView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.model = DEFAULT_MODEL;
    self.chosenLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]  isEqual: @"en"]? ENGLISH:CHINESE;
    self.chosenCurrency = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]  isEqual: @"$"]? 0:1;
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    
    [self.applyButton setBackgroundColor:[UIColor clearColor]];
    [self.applyButton setTitleColor:[UIColor clearColor] forState:normal];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    [self setAllText];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    switch (self.model) {
        case DEFAULT_MODEL:
            return 2;
            break;
        case WALLPAPER_MODEL:
            return 2;
            break;
        case LANGUAGE_MODEL:
            return 1;
            break;
        case  CURRENCY_MODEL:
            return 1;
        default:
            return 2;
            break;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.model) {
        case DEFAULT_MODEL:
            if(section == 0) return 3;
            else return 1;
            break;
        case WALLPAPER_MODEL:
            if(section == 0) return 1;
            else return 2;
            break;
        case LANGUAGE_MODEL:
            return 2;
            break;
        case CURRENCY_MODEL:
            return 2;
        default:
            return 2;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lol"];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickBlack"]];
    [image setFrame:CGRectMake(100, 100, 25, 25)];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *name;
    switch (self.model) {
        case DEFAULT_MODEL:
            if(indexPath.section == 0 & indexPath.row == 0) name = GET_TEXT(@"Background") ;
            else if(indexPath.section == 0 & indexPath.row == 1) name = GET_TEXT(@"Language") ;
            else if (indexPath.section == 0 & indexPath.row == 2) name = GET_TEXT(@"Currency");
            else name = GET_TEXT(@"Feedback");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case WALLPAPER_MODEL:
            if(indexPath.section == 0) name = GET_TEXT(@"ChooseAWallpaper");
            else if(indexPath.row == 0) name = GET_TEXT(@"ChooseFromPhoto");
            else name = GET_TEXT(@"TakePhoto");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case LANGUAGE_MODEL:
            if(indexPath.row == 0) name = @"English";
            else name = @"简体中文";
            cell.accessoryView = indexPath.row == self.chosenLanguage? image:nil;
            break;
        case CURRENCY_MODEL:
            if(indexPath.row == 0) name = GET_TEXT(@"Dollar");
            else name = GET_TEXT(@"RMB");
            cell.accessoryView = indexPath.row == self.chosenCurrency?image:nil;
            
            break;
        default:
            break;
    }
    cell.textLabel.text = name;
    return cell;
 }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.model) {
        case DEFAULT_MODEL:
            if(indexPath.section == 0 & indexPath.row == 0) {
                self.model = WALLPAPER_MODEL;
                [self.naviView.leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
                [self.tableView reloadData];
                [self.applyButton setBackgroundColor:MAIN_COLOR];
                [self.applyButton setTitleColor:[UIColor whiteColor] forState:normal];
            } else if(indexPath.section == 0 & indexPath.row == 1) {
                self.model = LANGUAGE_MODEL;
                [self.naviView.leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
                [self.tableView reloadData];
                [self.applyButton setBackgroundColor:[UIColor clearColor]];
                [self.applyButton setTitleColor:[UIColor clearColor] forState:normal];
            } else if (indexPath.section == 0 & indexPath.row  == 2) {
                self.model = CURRENCY_MODEL;
                [self.naviView.leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
                [self.tableView reloadData];
                [self.tableView reloadData];
                [self.applyButton setBackgroundColor:[UIColor clearColor]];
                [self.applyButton setTitleColor:[UIColor clearColor] forState:normal];
            } else {
                NSMutableString *mailUrl = [[NSMutableString alloc] init];
                NSArray *toRecipients = @[@"emmapu1089@gmail.com"];
                // 注意：如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为@","
                [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
                NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
            }
            break;
        case WALLPAPER_MODEL:
            if(indexPath.section == 0) {
                [self performSegueWithIdentifier:@"toWallPaperSegue" sender:self.pickedImage];
            } else if(indexPath.row == 0) {
                [self pickPhotoFromLibrary];
            } else {
                [self pickPhotoFromCamera];
            }
            break;
        case LANGUAGE_MODEL:
            if(indexPath.row == 0) {
                self.chosenLanguage = ENGLISH;
                [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
                [self setAllText];
                [self.delegate didChangeLanguage];

            } else {
                self.chosenLanguage = CHINESE;
                [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
                [self setAllText];
                [self.delegate didChangeLanguage];
            }
            [self.tableView reloadData];
            break;
        case CURRENCY_MODEL:
            if(indexPath.row == 0) {
                [[NSUserDefaults standardUserDefaults] setObject:@"$" forKey:@"currency"];
                self.chosenCurrency = 0;
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:@"¥" forKey:@"currency"];
                self.chosenCurrency = 1;
            }
            [self.tableView reloadData];
        default:
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
-(void)didClickLeftButton {
    if(self.model != DEFAULT_MODEL) {
        self.model = DEFAULT_MODEL;
        [self.naviView.leftButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.tableView reloadData];
        [self.applyButton setBackgroundColor:[UIColor clearColor]];
        [self.applyButton setTitleColor:[UIColor clearColor] forState:normal];
    }
}
-(void)didClickRightButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)pickPhotoFromCamera {
    self.picker.allowsEditing = NO;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:true completion:nil];
}
-(void)pickPhotoFromLibrary {
    self.picker.allowsEditing = NO;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:true completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    //[self performSegueWithIdentifier:@"toCrop" sender:[info valueForKey:UIImagePickerControllerOriginalImage]];
    [self performSegueWithIdentifier:@"toCrop" sender:chosenImage];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"toCrop"]) {
        ImageCropView *icv = (ImageCropView *)segue.destinationViewController;
        icv.delegate = self;
        [icv setCropImage:(UIImage*)sender];
    } else if([segue.identifier isEqual:@"toWallPaperSegue"]) {
        WallpaperVC *wpv = (WallpaperVC*)segue.destinationViewController;
        wpv.delegate = self;
        wpv.selectedPic = (UIImage *)sender;
    }
}
- (void)didCropImageSuccess:(UIImage *)croppedImage {
    if(croppedImage != nil) self.pickedImage = croppedImage;
    self.hehe.image = self.pickedImage;
}
-(void)didSelectWallPaperSuccess:(UIImage *)selectedWallPaperImage {
    if(selectedWallPaperImage != nil) self.pickedImage = selectedWallPaperImage;
    self.hehe.image = self.pickedImage;
}
- (IBAction)didClickApplyButton:(id)sender {
    switch (self.model) {
        case WALLPAPER_MODEL:
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.pickedImage) forKey:@"backgroundImage"];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}

-(void)setAllText {
    [self.naviView setTitleLabelName:GET_TEXT(@"About")];
    [self.applyButton setTitle:GET_TEXT(@"Apply") forState:normal];
}

@end
