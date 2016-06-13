//
//  BaseViewController.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/8/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviView.h"
#import "Keyboard.h"
#import "OptionScrollView.h"
#import "SettingViewController.h"
@interface BaseViewController : UIViewController<NaviviewDelegate, keyBoardDelegate, UITextFieldDelegate, UITextViewDelegate, optionScrollViewDelegate, UIImagePickerControllerDelegate, SettingVCDelegate>
@property NaviView *naviView;
@property Keyboard *keyboard;
@property UIImage *chosenPicture;
@property UIImageView *chosenImageView;
@property UITextField *amountTextField;
@property OptionScrollView *optionView;
@property UILabel *placeHolder;
-(void)pickPhotoFunction;
-(void)setAllText;
@end
