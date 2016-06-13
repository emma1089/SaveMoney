//
//  WishList.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/19/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviView.h"
#import "GlobalMacros.h"
@interface WishList : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, NaviviewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
