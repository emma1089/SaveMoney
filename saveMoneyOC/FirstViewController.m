//
//  FirstViewController.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 2/28/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "FirstViewController.h"
#import "MoneyManager.h"
#import "TimeManager.h"

@interface FirstViewController ()
@property NSMutableDictionary *costByCategory;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property NSDate *currentDateOnPie;
@property UISwipeGestureRecognizer *leftRecognizer;
@property UISwipeGestureRecognizer *rightRecognizer;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *showCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *showRemainLabel;
@property (weak, nonatomic) IBOutlet UILabel *showMaxExpenseLabel;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextfield;
@property NSMutableDictionary *colorDic;
@property NSMutableDictionary *optionDic;
@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UIView *pieContainer;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthBudgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *noExpenseLabel;
@property UIView *grayView;
@property NSString *currency;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    self.pieChart.showLabel = NO;
    self.pieChart.showPercentage = NO;
    [self.pieChart setLabelRadius:85];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    self.leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    self.leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:self.leftRecognizer];
    self.rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    self.rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:self.rightRecognizer];
    [self setColor];
        //initialize keyboard
    [self.budgetTextfield setInputView:self.keyboard];
    self.amountTextField = self.budgetTextfield;
}
-(void)viewWillAppear:(BOOL)animated {
    self.percentageLabel.text = @"";
    self.selectedImage.image = nil;
    self.detailLabel.text = @"";
    self.currentDateOnPie = [NSDate date];
    self.currentMonthBudgetLabel.text = [TimeManager getMonthStringWithYear:[NSDate date]];
    self.currentMonthLabel.text = [TimeManager getMonthStringWithYear:[NSDate date]];
    _costByCategory = [MoneyManager countByCategory:self.currentDateOnPie];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.budgetTextfield.text = [NSString stringWithFormat:@"%@%.2f", self.currency, [defaults doubleForKey:@"Budget"]];

    
}
-(void)viewDidAppear:(BOOL)animated {
    [self setAllText];
    [self loadSecondPanel];
    [self setOptions];
    [self.pieChart reloadData];

}
-(void)loadSecondPanel {
    double monthlyCost = [MoneyManager getMonthlySum:[NSDate date]];
    double budget = [MoneyManager getCurrentBudget];
    double max = [MoneyManager getCurrentMaxCost];
    self.showMaxExpenseLabel.text = [NSString stringWithFormat:@"%@%@%.2f", GET_TEXT(@"TodayMaxExpense"), self.currency, max];
    UIImage* maxTrack = [UIImage imageNamed:@"max"];
    UIImage* minTrack = [UIImage imageNamed:@"min"];
    if(monthlyCost < budget) {
        self.sliderView.value = 1.0 * monthlyCost / budget;
        self.showCostLabel.text = [NSString stringWithFormat:@"%@%@%.2f", GET_TEXT(@"Cost"),self.currency, monthlyCost];
        self.showRemainLabel.text = [NSString stringWithFormat:@"%@%@%.2f", GET_TEXT(@"Remain"),self.currency, budget - monthlyCost];
    } else {
        self.sliderView.value = 1.0 * budget / monthlyCost;
        self.showCostLabel.text = [NSString stringWithFormat:@"%@%@%.2f", GET_TEXT(@"Budget"),self.currency, budget];
        self.showRemainLabel.text = [NSString stringWithFormat:@"%@%@%.2f", GET_TEXT(@"Over"),self.currency, monthlyCost-budget];
        maxTrack = [UIImage imageNamed:@"maxOverSpend"];
    }
    UIImage *flag =  monthlyCost < budget?[UIImage imageNamed:@"todayFlag"]:[UIImage imageNamed:@"budgetFlag"];
    [self.sliderView setThumbImage:flag forState:UIControlStateHighlighted];
    [self.sliderView setThumbImage:flag forState:UIControlStateNormal];
    [self.sliderView setMinimumTrackImage:minTrack forState:UIControlStateNormal];
    [self.sliderView setMaximumTrackImage:maxTrack forState:UIControlStateNormal];
}
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    if(_costByCategory.count == 0) {
        [self.noExpenseLabel setTextColor:PLACE_HOLDER_COLOR];
    } else {
        [self.noExpenseLabel setTextColor:[UIColor clearColor]];
    }
    return [_costByCategory allKeys].count;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    NSArray *keys = [_costByCategory allKeys];
    return [_costByCategory[keys[index]] floatValue];
}


- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    NSArray *keys = [_costByCategory allKeys];
    UIColor *sliceColor = [keys[index] isEqualToString:@"Other"]? [UIColor colorWithRed:0.67 green:0.49 blue:0.80 alpha:1.0]:self.colorDic[self.optionDic[keys[index]]];
    
    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(self.legendView.frame.origin.x + 10, self.legendView.frame.origin.y + index * self.legendView.frame.size.height / 5.5 , 10, 10)];
    [circleView.layer setCornerRadius:circleView.frame.size.width / 2.0];
    UILabel *legendLabel = [[UILabel alloc]initWithFrame:CGRectMake(circleView.frame.origin.x + 20, circleView.frame.origin.y-3, self.legendView.frame.size.width - 20, 15)];
    legendLabel.text = GET_TEXT(keys[index]);
    legendLabel.textAlignment = NSTextAlignmentLeft;
    circleView.tag = index + 50;
    legendLabel.tag = index + 100;
    [legendLabel setFont: [legendLabel.font fontWithSize:14]];
    [circleView setBackgroundColor:sliceColor];
    [self.view addSubview:circleView];
    [self.view addSubview:legendLabel];
    return sliceColor;
}

-(void)viewWillDisappear:(BOOL)animated {
    for (UIView *subView in self.view.subviews) {
        if(subView.tag >= 50 & subView.tag <= 110) {
            [subView removeFromSuperview];
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self.view addSubview:self.grayView];
    [self.keyboard cleanRecords];
}
-(void)keyboardWillDisappear:(NSNotification*)notification {
    [self.grayView removeFromSuperview];
}
-(void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
    NSArray *keys = [_costByCategory allKeys];
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@%@%@", GET_TEXT(keys[index]),@" ",self.currency,[[[self.costByCategory allValues] objectAtIndex:index]stringValue]];
    if([keys[index] isEqualToString:@"Other"]) {
        self.selectedImage.image = [UIImage imageNamed:@"19"];
    } else {
        self.selectedImage.image = [UIImage imageNamed:self.optionDic[keys[index]]];
    }
    double total = [MoneyManager getMonthlySum:self.currentDateOnPie];
    self.percentageLabel.text = [NSString stringWithFormat:@"%.0f%@",[_costByCategory[keys[index]] doubleValue] / total * 100, @"%"];
    

}
-(void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index {
    self.percentageLabel.text = @"";
    self.selectedImage.image = nil;
    self.detailLabel.text = @"";
    
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    for (UIView *subView in self.view.subviews) {
        if(subView.tag >= 50 & subView.tag <= 110) {
            [subView removeFromSuperview];
        }
    }
    self.currentDateOnPie = [TimeManager getLastDateOfNextMonth:self.currentDateOnPie];
    self.costByCategory = [MoneyManager countByCategory:self.currentDateOnPie];
    [self.pieChart reloadData];
    self.percentageLabel.text = @"";
    self.selectedImage.image = nil;
    self.detailLabel.text = @"";
    self.currentMonthLabel.text = [TimeManager getMonthStringWithYear:self.currentDateOnPie];
}
- (IBAction)prevMonthButtonClicked:(id)sender {
    for (UIView *subView in self.view.subviews) {
        if(subView.tag >= 50 & subView.tag <= 110) {
            [subView removeFromSuperview];
        }
    }
    self.currentDateOnPie = [TimeManager getLastDateOfPreviousMonth:self.currentDateOnPie];
    self.costByCategory = [MoneyManager countByCategory:self.currentDateOnPie];
    [self.pieChart reloadData];
    self.percentageLabel.text = @"";
    self.selectedImage.image = nil;
    self.detailLabel.text = @"";
        self.currentMonthLabel.text = [TimeManager getMonthStringWithYear:self.currentDateOnPie];
}
- (IBAction)nextMonthButtonClicked:(id)sender {
    for (UIView *subView in self.view.subviews) {
        if(subView.tag >= 50 & subView.tag <= 110) {
            [subView removeFromSuperview];
        }
    }
    self.currentDateOnPie = [TimeManager getLastDateOfNextMonth:self.currentDateOnPie];
    self.costByCategory = [MoneyManager countByCategory:self.currentDateOnPie];
    [self.pieChart reloadData];
    self.percentageLabel.text = @"";
    self.selectedImage.image = nil;
    self.detailLabel.text = @"";
    self.currentMonthLabel.text = [TimeManager getMonthStringWithYear:self.currentDateOnPie];
}
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    for (UIView *subView in self.view.subviews) {
        if(subView.tag >= 50 & subView.tag <= 110) {
            [subView removeFromSuperview];
        }
    }
    self.currentDateOnPie = [TimeManager getLastDateOfPreviousMonth:self.currentDateOnPie];
    self.costByCategory = [MoneyManager countByCategory:self.currentDateOnPie];
    [self.pieChart reloadData];
    self.currentMonthLabel.text = [TimeManager getMonthStringWithYear:self.currentDateOnPie];
}
-(void)didClickLeftButton {
    for (UIView *subView in self.view.subviews) {
        if(subView.tag >= 50 & subView.tag <= 110) {
            [subView removeFromSuperview];
        }
    }
    self.currentDateOnPie = [NSDate date];
    self.costByCategory = [MoneyManager countByCategory:self.currentDateOnPie];
    [self.pieChart reloadData];
    self.percentageLabel.text = @"";
    self.selectedImage.image = nil;
    self.detailLabel.text = @"";
    self.currentMonthLabel.text = [TimeManager getMonthStringWithYear:self.currentDateOnPie];
}

-(void)didClickCancelButton:(NSString *)digitCost {
    [self.budgetTextfield resignFirstResponder];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.budgetTextfield.text = [NSString stringWithFormat:@"%@%.2f", self.currency, [defaults doubleForKey:@"Budget"]];
}
-(void)didClickSaveButton:(NSString *)digitCost {
    self.budgetTextfield.text = [NSString stringWithFormat:@"%@%.2f", self.currency, [digitCost doubleValue]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:[digitCost doubleValue]  forKey:@"Budget"];

    [self.budgetTextfield resignFirstResponder];
    [self loadSecondPanel];
    
}
-(void)setAllText {
    [super setAllText];
    [self.naviView setTitleLabelName:GET_TEXT(@"OverView")];
    [self.naviView setLeftButtonName:GET_TEXT(@"ThisMonth")];
    self.noExpenseLabel.text = GET_TEXT(@"NoExpense");
    self.currency = [[NSUserDefaults standardUserDefaults] objectForKey:@"currency"];
}
-(void)setColor {
    //set color dictionary
    self.colorDic = [[NSMutableDictionary alloc]init];
    [self.colorDic setObject:[UIColor colorWithRed:255/255.0f green:222/255.0f blue:37/255.0f alpha:1] forKey:@"1"];
    [self.colorDic setObject:[UIColor colorWithRed:171/255.0f green:71/255.0f blue:172/255.0f alpha:1] forKey:@"2"];
    [self.colorDic setObject:[UIColor colorWithRed:150/255.0f green:92/255.0f blue:36/255.0f alpha:1] forKey:@"3"];
    [self.colorDic setObject:[UIColor colorWithRed:154/255.0f green:207/255.0f blue:79/255.0f alpha:1] forKey:@"4"];
    [self.colorDic setObject:[UIColor colorWithRed:117/255.0f green:120/255.0f blue:141/255.0f alpha:1] forKey:@"5"];
    [self.colorDic setObject:[UIColor colorWithRed:246/255.0f green:162/255.0f blue:179/255.0f alpha:1] forKey:@"6"];
    [self.colorDic setObject:[UIColor colorWithRed:255/255.0f green:96/255.0f blue:59/255.0f alpha:1] forKey:@"7"];
    //    [self.colorDic setObject:[UIColor colorWithRed:245/255.0f green:153/255.0f blue:66/255.0f alpha:1] forKey:@"8"];
    [self.colorDic setObject:[UIColor colorWithRed:26/255.0f green:142/255.0f blue:140/255.0f alpha:1] forKey:@"8"];
    [self.colorDic setObject:[UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1] forKey:@"9"];
    [self.colorDic setObject:[UIColor colorWithRed:32/255.0f green:182/255.0f blue:255/255.0f alpha:1] forKey:@"10"];
    [self.colorDic setObject:[UIColor colorWithRed:170/255.0f green:185/255.0f blue:0 alpha:1] forKey:@"11"];
    [self.colorDic setObject:[UIColor colorWithRed:102/255.0f green:191/255.0f blue:151/255.0f alpha:1] forKey:@"12"];
    [self.colorDic setObject:[UIColor colorWithRed:167/255.0f green:222/255.0f blue:231/255.0f alpha:1] forKey:@"13"];
    [self.colorDic setObject:[UIColor colorWithRed:245/255.0f green:177/255.0f blue:153/255.0f alpha:1] forKey:@"14"];
    [self.colorDic setObject:[UIColor colorWithRed:231/255.0f green:36/255.0f blue:32/255.0f alpha:1] forKey:@"15"];
    [self.colorDic setObject:[UIColor colorWithRed:255/255.0f green:238/255.0f blue:95/255.0f alpha:1] forKey:@"16"];
    [self.colorDic setObject:[UIColor colorWithRed:176/255.0f green:167/255.0f blue:209/255.0f alpha:1] forKey:@"17"];
    
    [self.colorDic setObject:[UIColor colorWithRed:246/255.0f green:191/255.0f blue:200/255.0f alpha:1] forKey:@"18"];
    
    [self.colorDic setObject:[UIColor colorWithRed:187/255.0f green:155/255.0f blue:199/255.0f alpha:1] forKey:@"19"];
    //    [self.colorDic setObject:[UIColor colorWithRed:184/255.0f green:122/255.0f blue:108/255.0f alpha:1] forKey:@"20"];
    [self.colorDic setObject:[UIColor colorWithRed:194/255.0f green:221/255.0f blue:244/255.0f alpha:1] forKey:@"20"];
    [self.colorDic setObject:[UIColor colorWithRed:12/255.0f green:105/255.0f blue:86/255.0f alpha:1] forKey:@"21"];
    [self.colorDic setObject:[UIColor colorWithRed:12/255.0f green:105/255.0f blue:86/255.0f alpha:0.6] forKey:@"22"];
    [self.colorDic setObject:[UIColor colorWithRed:231/255.0f green:66/255.0f blue:141/255.0f alpha:1] forKey:@"23"];
}
-(void)setOptions {
    //get optionlist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"OptionList.plist"];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"OptionList" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:path error:nil];
    }
    self.optionDic = [[NSMutableDictionary alloc] initWithContentsOfFile: path];

}
@end
