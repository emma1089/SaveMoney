//
//  AddOptionViewController.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 3/12/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "AddOptionViewController.h"

@interface AddOptionViewController()
@property NSString* selectedIconNumber;
@end

@implementation AddOptionViewController

-(void)viewDidLoad {
    NaviView *naviview = [[NaviView alloc]init];
    naviview.delegate = self;
    [naviview setTitleLabelName:GET_TEXT(@"AddNewCategory")];
    [naviview.rightButton setBackgroundImage:[UIImage imageNamed:@"crossCancel"] forState:UIControlStateNormal];
    [naviview.leftButton setBackgroundImage:[UIImage imageNamed:@"checkSave"] forState:UIControlStateNormal];
    naviview.leftButton.frame = CGRectMake(naviview.leftButton.frame.origin.x+5, naviview.leftButton.frame.origin.y, 38, 25);
    [self.view addSubview:naviview];
    
    self.selectedIconNumber = @"1";
    [self loadOptionIconView];
    //[self loadPanel];
    [self.optionNameTextField becomeFirstResponder];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:GET_TEXT(@"InputCategoryNameHere") attributes:@{ NSForegroundColorAttributeName :[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] }];
    self.optionNameTextField.attributedPlaceholder = str;
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.optionNameTextField resignFirstResponder];
}
-(void)loadOptionIconView {
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"OptionIconList" ofType:@"plist"];
    self.OptionIcons = [[NSArray alloc] initWithContentsOfFile:plistPath];
    CGFloat x = 24;
    CGFloat y = 12;
    [self.optionIconView setContentSize:CGSizeMake(SCREEN_WIDTH, 20*(self.OptionIcons.count+3))];
    for (NSString *option in self.OptionIcons) {
        //Add option button
        UIButton *button = [[UIButton alloc]init];
        if(x + 50 > SCREEN_WIDTH) {
            x = 24;
            y = y + 60;
        }
        button.frame = CGRectMake(x, y, 40, 40);
        
        [button setImage: [UIImage imageNamed:option] forState:normal];
        [button addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:option forState:normal];
        [self.optionIconView addSubview:button];
        if(SCREEN_WIDTH >= 375) x = x + (SCREEN_WIDTH - 48 - 40) / 4;
        else x = x + (SCREEN_WIDTH - 48 - 40) / 3;
    }
}

-(void)optionButtonClicked:(UIButton*)sender {
    self.selectedOptionIcon.image = [sender imageForState:normal];
    self.selectedIconNumber = sender.currentTitle;
    [self.optionNameTextField becomeFirstResponder];
}
-(void)cancelAction {
    self.optionNameTextField.text = nil;
    [self.optionNameTextField resignFirstResponder];
    
}
-(void)saveAction {
    if([self.optionNameTextField.text isEqual:@""]) {
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"You must input a category name!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"OptionList.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //here add elements to data file and write data to file
    NSString *key = self.optionNameTextField.text;
    NSString *value = self.selectedIconNumber;
    NSLog(value);
    [data setValue:value forKey:key];
    [data writeToFile: path atomically:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)didClickRightButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)didClickLeftButton {
    [self saveAction];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
