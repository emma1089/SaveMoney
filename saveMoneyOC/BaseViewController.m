//
//  BaseViewController.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/8/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "BaseViewController.h"
#import "SettingViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    NSLog(@"%@", [NSLocale preferredLanguages]);
    
    [super viewDidLoad];
    self.naviView = [[NaviView alloc]init];
    self.naviView.delegate = self;
    [self.view addSubview:self.naviView];
    self.keyboard = [[Keyboard alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.32)];
    [self.keyboard.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.32)];
    self.keyboard.delegate = self;
    self.keyboard.memoTextField.delegate = self;
    self.keyboard.memoTextView.delegate = self;
    
    self.optionView = [[OptionScrollView alloc]init];
    self.optionView.delegate = self;
    
    self.placeHolder = self.placeHolder  = [[UILabel alloc]init];
    [self.placeHolder setFont:[UIFont systemFontOfSize:20]];
    [self.placeHolder setTextColor:[UIColor grayColor]];
    
    [self setAllText];
    
}

-(void)didClickDigitButton:(NSString *)digitCost {
    self.amountTextField.text = digitCost;
}
-(void)didClickDeleteButton:(NSString *)digitCost {
    if ([digitCost  isEqual: @""]) {
        self.amountTextField.text = @"0.00";
    } else {
        self.amountTextField.text = digitCost;
    }
}
-(void)didclickPlusButton:(NSString *)tempCalcValue {
    self.amountTextField.text = tempCalcValue;
}
-(void)didClickMinusButton:(NSString *)tempCalcValue {
    self.amountTextField.text = tempCalcValue;
}
-(void)didClickRightButton {
    NSLog(@"开始");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingVC"];
    settingVC.delegate = self;
    [self presentViewController:settingVC animated:YES completion:nil];
    NSLog(@"结束");
}


-(void)didClickAddOptionButton {
    [self performSegueWithIdentifier:@"toAddOptionSegue" sender:nil];
}
-(void)didClickDeleteOptionButton:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Category" message:@"Are you sure you want to delete this category?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirmButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"OptionList.plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        [data removeObjectForKey:button.currentTitle];
        [data writeToFile: path atomically:YES];
        [self.optionView reload];
        
    }];
    [alert addAction:cancelButton];
    [alert addAction:confirmButton];
    [self presentViewController:alert animated:YES completion:nil];
    [self.optionView reload];
}

-(void)pickPhotoFunction {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:GET_TEXT(@"UseCamera") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:true completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:GET_TEXT(@"UsePhotoLibrary") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:true completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:GET_TEXT(@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self viewWillAppear:NO];
    }]];
    if(self.chosenImageView.image != nil) {
        [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            self.chosenPicture = [[UIImage alloc]init];
            self.chosenImageView.image = self.chosenPicture;
        }]];
    }
    [self presentViewController:alert animated:true completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.chosenPicture = chosenImage;
    self.chosenImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)textViewDidChange:(UITextView *)textView {
    if([textView.text  isEqual: @""]) {
        self.placeHolder.textColor = PLACE_HOLDER_COLOR;
    } else {
        self.placeHolder.textColor = [UIColor clearColor];
    }
}
-(void)didChangeLanguage {
    [self setAllText];
}
-(void)setAllText {
    self.keyboard.memoTextField.text = GET_TEXT(@"Memo");
    [self.keyboard.cancelButton setTitle:GET_TEXT(@"Cancel") forState:normal];
    [self.keyboard.okButton setTitle:GET_TEXT(@"OK") forState:normal];
}
@end
