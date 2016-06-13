//
//  Keyboard.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 2/28/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalMacros.h"
@class Keyboard;
@protocol keyBoardDelegate <NSObject>
-(void)didClickDigitButton:(NSString *)digitCost;
-(void)didClickSaveButton:(NSString *)digitCost;
-(void)didClickCancelButton:(NSString *)digitCost;
-(void)didclickPlusButton:(NSString*)tempCalcValue;
-(void)didClickMinusButton:(NSString*)tempCalcValue;
-(void)didClickDeleteButton:(NSString *)digitCost;
-(void)didClickMemoSaveButton:(NSString *)memoText;
-(void)didClickDateChangeButton:(NSDate *)date;
-(void)didClickCameraButton;
@end
@interface Keyboard : UIView
- (IBAction)digitButtonClicked:(UIButton *)sender;
- (IBAction)saveButtonClicked:(UIButton *)sender;
- (IBAction)cancelButtonClicked:(UIButton *)sender;
- (IBAction)deleteButtonClicked:(UIButton *)sender;
- (IBAction)plusButtonClicked:(id)sender;

- (IBAction)minusButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

-(void)cleanRecords;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;
@property (weak, nonatomic) IBOutlet UIImageView *chosenImageView;


@property (weak, nonatomic) IBOutlet UIView *view;

@property (nonatomic, weak) id<keyBoardDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *keyboardAccessoryView;

@property (strong, nonatomic) IBOutlet UIView *memoView;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@property (weak, nonatomic) IBOutlet UIButton *memoCameraButton;
- (IBAction)memoCameraButtonClicked:(id)sender;

@end
