//
//  NewWishViewController.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/24/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "NewWishViewController.h"
#import "AppDelegate.h"
#import "DailyCost.h"
#import "MoneyManager.h"
@interface NewWishViewController ()
@property NSString *selectedImageNumber;
@property UIImage *picture;
@property NSString *purpose;
@property UITextView *descriptionView;
@property NSString *memo;
@property NSString *cost;
@property BOOL costTextFieldIsFirstResponder;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;
@end

@implementation NewWishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.naviView setLeftButtonName:@""];
    [self.naviView setBackgroundColor:[UIColor clearColor]];
    [self.naviView.leftButton setBackgroundImage:[UIImage imageNamed:@"checkSave"] forState:UIControlStateNormal];
    self.naviView.leftButton.frame = CGRectMake(self.naviView.leftButton.frame.origin.x+5, self.naviView.leftButton.frame.origin.y, 38, 25);
    [self.naviView.rightButton setBackgroundImage:[UIImage imageNamed:@"crossCancel"] forState:UIControlStateNormal];
    //configure option view
    //set option view as accessory view of the keyboard
    [self.optionView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.12)];
    [self.optionView setContentSize:CGSizeMake(1500, SCREEN_HEIGHT*0.11)];
    [self.optionView setBackgroundColor:MAIN_COLOR];
    
    //Set description view as accessory view of costTextField
    self.descriptionView = [[UITextView alloc]init];
    self.descriptionView.delegate = self;
    [self.descriptionView setFont:[UIFont systemFontOfSize:20]];
    switch ((NSInteger)SCREEN_HEIGHT) {
        case 480:
            [self.descriptionView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.56-216)];
            [self.descriptionView setFont:[UIFont systemFontOfSize:16]];
            break;
        case 568:
            [self.descriptionView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.56-216)];
            break;
        case 667:
            [self.descriptionView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.56-216)];
            break;
        case 736:
            [self.descriptionView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.56-226)];
            break;
        default:
            break;
    }

    
    
    self.descriptionView.autocorrectionType = UITextAutocorrectionTypeNo;

    [self.descriptionView setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]];
    [self.descriptionView setTextColor:MAIN_COLOR];
   // [self.descriptionViewContainer addSubview:self.descriptionView];
    self.textField.inputAccessoryView = self.descriptionView;

    [self.placeHolder setFrame:CGRectMake(30, 20, 300, 20)];
    [self.descriptionView addSubview:self.placeHolder];


    self.selectedImageNumber = @"5";
    self.purpose = @"Shopping";
    self.categoryLabel.text = GET_TEXT(self.purpose);
    self.costTextFieldIsFirstResponder = YES;
    [self.costTextField becomeFirstResponder];
    
    [self.costTextField setInputView:self.keyboard];
    self.costTextField.inputAccessoryView = self.optionView;
    
    self.cameraButton.clipsToBounds = YES;
    [self.cameraButton.layer setCornerRadius:SCREEN_WIDTH * 0.3 /2.0];
    
    
    if(self.preWish != nil) {
        [self.naviView setTitleLabelName:@"Edit Wish Item"];
        self.selectedImageNumber = self.preWish.purposeImageNumber;
        self.categoryImage.image = [UIImage imageNamed:self.preWish.purposeImageNumber];
        if(self.preWish.picture != nil) {
            self.picture = [UIImage imageWithData:self.preWish.picture];
            [self setBlurTopImage:self.picture];
            [self.cameraButton setBackgroundImage:self.picture forState:UIControlStateNormal];
        }
        self.purpose = self.preWish.purpose;
        self.categoryLabel.text = GET_TEXT(self.preWish.purpose);
        self.textField.text = self.preWish.memo;
        self.memo = self.preWish.memo;
        self.descriptionView.text = self.textField.text;
        self.costTextField.text = [self.preWish.amount stringValue];
        self.cost = self.costTextField.text;
    }

    self.amountTextField = self.costTextField;

}

- (IBAction)descriptionDidBegin:(id)sender {
    [self.descriptionView becomeFirstResponder];
    //[self.descriptionView setContentOffset: CGPointMake(24,12) animated:NO];
    if(self.memo != nil) self.placeHolder.textColor = [UIColor clearColor];
    self.descriptionView.textContainerInset = UIEdgeInsetsMake(20, 24, 0, 24);
    [self.naviView setTitleLabelName:GET_TEXT(@"EditDescription")];
}


-(void)viewWillAppear:(BOOL)animated {
    [self setAllText];
    if(self.costTextFieldIsFirstResponder) {
        [self.costTextField becomeFirstResponder];
        [self.optionView reload];
    }
    else {
        [self.textField becomeFirstResponder];
        [self.descriptionView becomeFirstResponder];
        [self.naviView setTitleLabelName:GET_TEXT(@"EditDescription")];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.costTextField resignFirstResponder];
}
-(void)didClickOptionImageButton:(NSString *)optionName optionImageNumber:(NSInteger)optionImageNumber {

    self.purpose = optionName;
    self.selectedImageNumber = [NSString stringWithFormat:@"%ld", (long)optionImageNumber];
    
    UIView *imageButton = [self.optionView viewWithTag:optionImageNumber];
    UIImageView *cloneOptionImage = [[UIImageView alloc]initWithFrame:imageButton.frame];
    cloneOptionImage.image = [UIImage imageNamed: self.selectedImageNumber];
    [self.optionView addSubview:cloneOptionImage];
    CGRect frame = [self.optionView convertRect:self.categoryImage.frame fromView:self.categoryImage.superview];
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         cloneOptionImage.frame = frame;
                     }
                     completion:^(BOOL finished){
                        self.categoryLabel.text = GET_TEXT(optionName);
                        self.categoryImage.image = [UIImage imageNamed:self.selectedImageNumber];
                     }];
    
}

- (IBAction)cameraButtonClicked:(id)sender {
    if([self.descriptionView isFirstResponder]) {
        [self.descriptionView resignFirstResponder];
        self.costTextFieldIsFirstResponder = NO;
        
    } else if([self.costTextField isFirstResponder]){
        [self.costTextField resignFirstResponder];
        self.costTextFieldIsFirstResponder = YES;
    }
    self.chosenPicture = self.picture;
    self.chosenImageView = self.cameraButton.imageView;
    [self pickPhotoFunction];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.picture = chosenImage;
    [self.cameraButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    self.cameraButton.clipsToBounds = YES;
    [self.cameraButton.layer setCornerRadius:self.cameraButton.frame.size.width /2.0];
    [self setBlurTopImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)setBlurTopImage:(UIImage*)image {
    [self.topImage setImage:image];
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.33);
    [self.topImage addSubview:effe];
    [self.naviView setBackgroundColor:[UIColor colorWithRed:43/255.0f green:57/255.0f blue:74/255.0f alpha:0.2]];
}
- (IBAction)peekButtonClicked:(id)sender {
    [self sendAlert:[NSString stringWithFormat:@"%@%.1f%@",@"If you buy this item, you could maximumly cost $",[MoneyManager peek:[NSNumber numberWithDouble:[self.costTextField.text doubleValue]]], @" every day after today"]];
}
-(void)sendAlert:(NSString*)message {
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    alert.view.tintColor = MAIN_COLOR;
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)didClickLeftButton {
    if([self.descriptionView isFirstResponder]) {
        self.memo = self.descriptionView.text;
        self.textField.text = self.memo;
        [self.descriptionView resignFirstResponder];
        self.costTextFieldIsFirstResponder = YES;
        [self viewWillAppear:NO];
        return;
    } else
    
    
    if([self.costTextField.text isEqual: @""]) {
        [self sendAlert:@"Cost amount can't be zero."];
        return;
    }
    if([self.textField.text isEqual:@""]) {
        [self sendAlert:@"Please add your description for this item"];
        return;
    }
    if(self.preWish != nil) {
        [DailyCost editCost:self.purpose memo:self.textField.text amount:[NSNumber numberWithDouble:[self.costTextField.text doubleValue]] date:[NSDate date] isCost:[NSNumber numberWithBool:NO] picture:UIImagePNGRepresentation(self.picture) purposeImageNumber:self.selectedImageNumber editedCost:self.preWish];
        
    } else {
        [DailyCost addCostWithPurpose:self.purpose memo:self.textField.text amount:[NSNumber numberWithDouble:[self.costTextField.text doubleValue]] date:[NSDate date] isCost:[NSNumber numberWithBool:NO] picture:UIImagePNGRepresentation(self.picture) purposeImageNumber:self.selectedImageNumber];
        
    }
    [self dismissViewControllerAnimated:true completion:nil];

}
-(void)didClickRightButton {
    if([self.descriptionView isFirstResponder]) {
        [self.descriptionView resignFirstResponder];
        self.costTextFieldIsFirstResponder = YES;
        [self viewWillAppear:NO];
        return;

    } else
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)didClickCancelButton:(NSString *)digitCost {
    if(self.cost == nil) {
        self.costTextField.text = @"";
    } else {
        self.costTextField.text = self.cost;
    }
    
}
-(void)didClickSaveButton:(NSString *)digitCost {
    self.costTextField.text = digitCost;
    self.cost = digitCost;
}
-(void)setAllText {
    [super setAllText];
    [self.naviView setTitleLabelName:GET_TEXT(@"AddNewWishItem")];
    [self.naviView setTitleLabelName:self.preWish == nil? GET_TEXT(@"AddNewWishItem"):GET_TEXT(@"EditWishItem")];
    self.descriptionTextLabel.text = GET_TEXT(@"Description");
    self.textField.placeholder = GET_TEXT(@"AddDescriptionHere");
    self.placeHolder.text = GET_TEXT(@"DescriptionPlaceHolder");
}
@end
