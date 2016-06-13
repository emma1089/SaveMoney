//
//  BudgetViewController.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/31/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "BudgetViewController.h"
@interface BudgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;
@property UIView *grayView;
@property NSString *currency;
@end

@implementation BudgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.naviView.leftButton removeFromSuperview];

    self.grayView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.22, SCREEN_WIDTH, SCREEN_HEIGHT * 0.78)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.grayView setBackgroundColor:SHADOW_COLOR];
    [self.budgetTextField setInputView:self.keyboard];
    self.amountTextField = self.budgetTextField;
}
-(void)viewWillAppear:(BOOL)animated {
    [self.budgetTextField becomeFirstResponder];
    [super setAllText];
    self.currency = [[NSUserDefaults standardUserDefaults] objectForKey:@"currency"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.budgetTextField.text =  [NSString stringWithFormat:@"%@%.2f", self.currency, [defaults doubleForKey:@"Budget"]];
    [self.naviView setTitleLabelName:GET_TEXT(@"budget")];
    
}
- (void)keyboardWillShow:(NSNotification *)notification {
    [self.view addSubview:self.grayView];
    [self.keyboard cleanRecords];
}
-(void)keyboardWillDisappear:(NSNotification*)notification {
    [self.grayView removeFromSuperview];
}


-(void)didClickCancelButton:(NSString *)digitCost {
    [self.budgetTextField resignFirstResponder];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.budgetTextField.text = [NSString stringWithFormat:@"%@%.2f", self.currency, [defaults doubleForKey:@"Budget"]];

}
-(void)didClickSaveButton:(NSString *)digitCost {
    self.budgetTextField.text = [NSString stringWithFormat:@"%@%@", self.currency, digitCost];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:[digitCost doubleValue]  forKey:@"Budget"];
    [self.budgetTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
