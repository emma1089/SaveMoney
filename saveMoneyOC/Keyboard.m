//
//  Keyboard.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 2/28/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "Keyboard.h"
#import "TimeManager.h"
@interface Keyboard()
@property(nonatomic) NSString* digitCost;
@property(nonatomic) float tempCalcValue;
@property NSDate* date;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property BOOL isPlusOperation;
@end

@implementation Keyboard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [[NSBundle mainBundle]loadNibNamed:@"Keyboard" owner:self options:nil];
        self.digitCost = @"";
        self.tempCalcValue = 0;
        self.isPlusOperation = YES;
        [self handleDatePicker];
        [self loadDatePanel];
        self.chosenImageView.clipsToBounds = YES;
        [self.chosenImageView.layer setCornerRadius:10];
        [self addSubview:self.view];
        
    }
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"Keyboard" owner:self options:nil];
        [self addSubview:self.view];
        [self.memoView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.digitCost = @"";
        self.memoTextField.inputAccessoryView = self.memoView;
        [self loadDatePanel];
        [self handleDatePicker];

    }
    return self;
}


- (IBAction)digitButtonClicked:(UIButton *)sender {
    if (sender.tag != 10) {
        
        self.digitCost = [NSString stringWithFormat:@"%@%li", self.digitCost, (long)sender.tag];
    } else {
        self.digitCost = [self.digitCost stringByAppendingString:@"."];
    }
    [self.delegate didClickDigitButton:self.digitCost];
}


- (IBAction)saveButtonClicked:(UIButton *)sender {
    [self calc];
    [self.delegate didClickSaveButton:[NSString stringWithFormat:@"%.2f", self.tempCalcValue]];
    self.tempCalcValue = 0;
    self.digitCost = @"";
    self.isPlusOperation = YES;
}

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    self.digitCost = @"";
    self.tempCalcValue = 0;
    self.isPlusOperation = YES;
    [self.delegate didClickCancelButton:self.digitCost];
}

- (IBAction)deleteButtonClicked:(UIButton *)sender {
    if(![self.digitCost  isEqual: @""]) {
        self.digitCost = [self.digitCost substringToIndex:self.digitCost.length-(self.digitCost.length > 0)];
        [self.delegate didClickDeleteButton:self.digitCost];
    } else {
        [self.delegate didClickDeleteButton:self.digitCost];
        self.tempCalcValue = 0;
    }
}
-(void)calc {
    if(self.isPlusOperation) self.tempCalcValue += [self.digitCost doubleValue];
    else self.tempCalcValue -= [self.digitCost doubleValue];
}
- (IBAction)plusButtonClicked:(id)sender {
    [self.plusButton setBackgroundColor:MAIN_COLOR];
    [self.plusButton setTitleColor:[UIColor whiteColor] forState:normal];
    [self calc];
    self.isPlusOperation = YES;
    self.digitCost = @"";
    [self.delegate didclickPlusButton:[NSString stringWithFormat:@"%.2f", self.tempCalcValue]];
}

- (IBAction)minusButtonClicked:(id)sender {
    [self calc];
    self.isPlusOperation = NO;
    self.digitCost = @"";
    [self.delegate didClickMinusButton:[NSString stringWithFormat:@"%.2f", self.tempCalcValue]];
    
}
-(void)dismissMemo {
    [self.memoTextField resignFirstResponder];
    [self.view endEditing:YES];
}
-(void)handleDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 180)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    NSDate *today = [[NSDate alloc]init];
    [datePicker setMaximumDate:today];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
}
-(void)dateChanged:(UIDatePicker*)datePicker {
    self.date = datePicker.date;
}
-(void)loadDatePanel {
    UIView *panel = [[UIView alloc]init];
    [panel setFrame:CGRectMake(0, 0, 375, 50)];
    [panel setBackgroundColor:[UIColor grayColor]];
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 50, 50)];
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(220, 0, 50, 50)];
    [cancelButton addTarget:self action:@selector(cancelChangeDate) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:normal];
    [saveButton addTarget:self action:@selector(saveChangeDate) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"save"] forState:normal];
    [panel addSubview:cancelButton];
    [panel addSubview:saveButton];
    self.dateTextField.inputAccessoryView = panel;
}
-(void)cancelChangeDate {
    [self.dateTextField resignFirstResponder];
}
-(void)saveChangeDate {
    [self.delegate didClickDateChangeButton:self.date];
    [self.dateTextField resignFirstResponder];
}

- (IBAction)memoCameraButtonClicked:(id)sender {
    [self.delegate didClickCameraButton];
}

-(void)cleanRecords {
    self.digitCost = @"";
}
- (IBAction)hehe:(id)sender {
    self.memoTextField.text = GET_TEXT(@"Memo");
}


@end
