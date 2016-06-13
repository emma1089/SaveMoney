//
//  GlobalMacros.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/9/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#ifndef GlobalMacros_h

#define GlobalMacros_h
#define MAIN_COLOR [UIColor colorWithRed:43/255.0 green:57/255.0 blue:74/255.0 alpha:1]
#define SHADOW_COLOR [UIColor colorWithRed:43/255.0 green:57/255.0 blue:74/255.0 alpha:0.4]
#define PLACE_HOLDER_COLOR [UIColor colorWithRed:43/255.0 green:57/255.0 blue:74/255.0 alpha:0.5]
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define LANGUAGE_PATH [[NSBundle mainBundle] pathForResource:[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"] ofType:@"lproj"]
#define GET_TEXT(text) \
[[NSBundle bundleWithPath:LANGUAGE_PATH]  localizedStringForKey:text value:nil table:@"ALLocalization"]

#define CONTEXT [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
#endif /* GlobalMacros_h */
