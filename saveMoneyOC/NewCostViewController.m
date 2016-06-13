//
//  NewCostViewController.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 2/28/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "NewCostViewController.h"
#import "AppDelegate.h"
#import "DailyCost.h"
#import "TimeManager.h"

@interface NewCostViewController ()
@property NSString *memo;
@property NSString *selectedImageNumber;
@property UIImage *picture;
@property NSString *purpose;
@property BOOL keyboardIsUp;

@end

@implementation NewCostViewController
@synthesize managedObjectContext;
@synthesize preCost;

- (void)viewDidLoad {
    self.keyboardIsUp = NO;
    [super viewDidLoad];
    self.selectedImageNumber = @"1";
    self.purpose = @"Dining";
    self.selectedOptionNameLabel.text = GET_TEXT(self.purpose);
    //set up core data context
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.picture = [[UIImage alloc]init];
    self.keyboard.dateTextField.text = [TimeManager getDateString:self.predate];
    //self.keyBoard.frame = CGRectMake(0, SCREEN_HEIGHT*0.68, SCREEN_WIDTH, SCREEN_HEIGHT * 0.32);
    self.keyboard.view.frame = CGRectMake(0, SCREEN_HEIGHT*0.68, SCREEN_WIDTH, SCREEN_HEIGHT * 0.32);

    self.keyboard.memoCameraButton.imageView.layer.masksToBounds = YES;
    self.keyboard.memoCameraButton.imageView.layer.cornerRadius = 10;
    [self.keyboard.keyboardAccessoryView setFrame:CGRectMake(0, SCREEN_HEIGHT*0.6, SCREEN_WIDTH, SCREEN_HEIGHT*0.08)];
    if(SCREEN_HEIGHT == 736) {
        [self.keyboard.memoView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.88 - 226)];
    } else {
        [self.keyboard.memoView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.88 - 216)];
    }
    //load option view
    self.optionView.frame = CGRectMake(0, SCREEN_HEIGHT*0.21, SCREEN_WIDTH, SCREEN_HEIGHT*0.39);
    self.optionView.showsVerticalScrollIndicator = YES;

    [self.view addSubview:self.optionView];
    self.optionView.layer.zPosition = MAXFLOAT;
    [self.view addSubview:self.keyboard.keyboardAccessoryView];
    [self.view addSubview:self.keyboard.view];
    self.keyboard.memoTextField.inputAccessoryView = self.keyboard.memoView;
    self.amountTextField = self.label;
        // if shown by detail segue, show the detail
    if (self.preCost != nil) {
        self.selectedImageNumber = self.preCost.purposeImageNumber;
        self.selectedOptionImageView.image = [UIImage imageNamed:self.preCost.purposeImageNumber];
        self.picture = [UIImage imageWithData:self.preCost.picture];
        if(self.picture == nil) {
            [self.keyboard.memoCameraButton setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        } else {
            self.keyboard.chosenImageView.image = self.picture;
//            [self.keyBoard.memoCameraButton setBackgroundImage:self.picture forState:UIControlStateNormal];
            
        }
        self.predate = self.preCost.date;
        self.purpose = self.preCost.purpose;
        self.selectedOptionNameLabel.text = GET_TEXT(self.preCost.purpose);
        self.label.text = self.preCost.amount.stringValue;
        self.keyboard.memoTextView.text = self.preCost.memo;
        self.keyboard.dateTextField.text = [TimeManager getDateString:self.preCost.date];
    }

    [self.naviView.rightButton setBackgroundImage:[UIImage imageNamed:@"checkSave"] forState:UIControlStateNormal];
    [self.naviView.leftButton setBackgroundImage:[UIImage imageNamed:@"crossCancel"] forState:UIControlStateNormal];
    self.naviView.leftButton.frame = CGRectMake(self.naviView.leftButton.frame.origin.x, self.naviView.leftButton.frame.origin.y, 25, 25);
    self.naviView.rightButton.frame = CGRectMake(self.naviView.rightButton.frame.origin.x-10, self.naviView.rightButton.frame.origin.y, 38, 25);

    [self.placeHolder setFrame:CGRectMake(0, 0, 300, 20)];
    
    [self.keyboard.memoTextView addSubview:self.placeHolder];
    [self.keyboard.memoTextView setContentOffset:CGPointMake(0, 0)];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
}
-(void)viewWillAppear:(BOOL)animated {
    [self setAllText];
    [self.optionView reload];
    
}
- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardIsUp = YES;
    self.naviView.titleLabel.text = GET_TEXT(@"AddMemo");
    if([self.keyboard.memoTextView.text  isEqual: @""]) {
        self.placeHolder.textColor = PLACE_HOLDER_COLOR;
    } else {
        self.placeHolder.textColor = [UIColor clearColor];
    }

    
}
- (void)keyboardWillDisappear:(NSNotification *)notification {
    self.keyboardIsUp = NO;
    self.naviView.titleLabel.text = GET_TEXT(@"AddNewExpense");
}

-(void)didClickCancelButton:(NSString *)digitCost {
    self.label.text = @"0.00";
}


-(void)didClickSaveButton:(NSString *)digitCost {
    self.label.text = digitCost;
}

-(void)saveDataAndExit {
    if([self.label.text doubleValue] == 0){
        [self sendAlert:@"Your cost should not be zero."];
        return;
    }
    if(self.preCost != nil) {
        [DailyCost editCost:self.purpose memo:self.memo amount:[NSNumber numberWithDouble:[self.label.text doubleValue]] date:self.predate isCost:[NSNumber numberWithBool:YES] picture:UIImagePNGRepresentation(self.picture) purposeImageNumber:self.selectedImageNumber editedCost:preCost];
        
    } else {
        double cost = [self.label.text doubleValue];
        [DailyCost addCostWithPurpose:self.purpose memo:self.memo amount:[NSNumber numberWithDouble:cost] date:self.predate isCost:[NSNumber numberWithBool:YES] picture:UIImagePNGRepresentation(self.picture)  purposeImageNumber:self.selectedImageNumber];
    }
    [self dismissViewControllerAnimated:true completion:nil];

}
-(void)didClickOptionImageButton:(NSString *)optionName optionImageNumber:(NSInteger)optionImageNumber {
    self.purpose = optionName;
    self.selectedImageNumber = [NSString stringWithFormat:@"%ld", (long)optionImageNumber];
    CGRect originalFrame;
    for(UIView *v in self.optionView.subviews) {
        if([v isKindOfClass:[UIButton class]]) {
            UIButton *temp = (UIButton*)v;
            if([temp.currentTitle isEqual:optionName]) {
                originalFrame = temp.frame;
                break;}
        }

    }

    UIImageView *cloneOptionImage = [[UIImageView alloc]initWithFrame:originalFrame];
    cloneOptionImage.image = [UIImage imageNamed: self.selectedImageNumber];
    [self.optionView addSubview:cloneOptionImage];
    CGRect frame = [self.optionView convertRect:self.selectedOptionImageView.frame fromView:self.selectedOptionImageView.superview];
    [UIView animateWithDuration:0.3
                          delay:0.05
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         cloneOptionImage.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.selectedOptionNameLabel.text = GET_TEXT(optionName);
                         self.selectedOptionImageView.image = [UIImage imageNamed: self.selectedImageNumber];
                     }];
}

-(void)didClickMemoSaveButton:(NSString *)memoText {
    self.memo = memoText;
    self.keyboard.memoTextView.text = self.memo;
    [self.keyboard.memoTextField resignFirstResponder];
}
-(void)didClickDateChangeButton:(NSDate *)date {
    self.predate = date;
    self.keyboard.dateTextField.text = [TimeManager getDateString:date];
}

-(void)didClickCameraButton {
    [self.keyboard.memoTextView resignFirstResponder];
//    self.picture = self.chosenPicture;
//    self.keyboard.chosenImageView = self.chosenImageView;
    self.chosenPicture = self.picture;
    self.chosenImageView = self.keyboard.chosenImageView;
    [self pickPhotoFunction];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.picture = chosenImage;
    self.keyboard.chosenImageView.image = self.picture;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.keyboard.memoTextField becomeFirstResponder];
}
-(void)sendAlert:(NSString*)message {
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    alert.view.tintColor = MAIN_COLOR;
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)didClickRightButton {
    if(self.keyboardIsUp == YES) {
        self.memo = self.keyboard.memoTextView.text;
        [self.keyboard.memoTextView resignFirstResponder];
        [self.keyboard.memoTextField resignFirstResponder];
    } else {
        [self saveDataAndExit];
    }
}
-(void)didClickLeftButton {
    if(self.keyboardIsUp == YES) {
        [self.keyboard.memoTextView resignFirstResponder];
        [self.keyboard.memoTextField resignFirstResponder];
    }
    else [self dismissViewControllerAnimated:true completion:nil];
}
-(void)setAllText {
    [super setAllText];
    [self.naviView setTitleLabelName:GET_TEXT(@"AddNewExpense")];
    [self.naviView setTitleLabelName:self.preCost == nil? GET_TEXT(@"AddNewExpense"):GET_TEXT(@"EditExpense")];
    self.placeHolder.text = GET_TEXT(@"MemoPlaceHolder");
}
@end
