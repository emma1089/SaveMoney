//
//  TabViewController.m
//  saveMoneyOC
//
//  Created by JingLi on 5/16/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()
@property(nonatomic) UIView *slider;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat screenHeight;
@property(nonatomic) int fromIndex;

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBar];
    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithRed:0.00
                                                                    green:0.62
                                                                     blue:0.93
                                                                    alpha:0.1];

    // Do any additional setup after loading the view.
    UIColor * tabColor = [UIColor colorWithRed:246/255.0
                                         green:246/255.0
                                          blue:246/255.0
                                         alpha:0.5];
    [self.tabBarController.tabBar setTranslucent:YES];
    [self.tabBar setBarTintColor:tabColor];
    self.tabBar.backgroundColor = [UIColor clearColor];

    
    UIImage *newBG = [self imageWithImage:[UIImage imageNamed:@"tabBarBackground"] scaledToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*0.09)];
    
    [[UITabBar appearance] setBackgroundImage:newBG];
    //[self.tabBar setBarTintColor:[UIColor clearColor]];
    [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, -3);
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];
    self.tabBar.tintColor = [UIColor colorWithRed:43/255.0
                                            green:57/255.0
                                             blue:74/255.0
                                            alpha:1.0];
    
    
    self.width = self.tabBar.frame.size.width / [self.tabBar.items count];
    self.height = self.tabBar.frame.size.height / 10.0;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.slider  = [[UIView alloc] initWithFrame:CGRectMake(0, self.screenHeight-self.height, self.width, self.height)];
    self.slider.backgroundColor = MAIN_COLOR;
    [self.view addSubview:self.slider];
    self.fromIndex = 0;
}
-(void)viewWillAppear:(BOOL)animated {
    [self setTabBar];
    [self.selectedViewController viewWillAppear:YES];
}

//-(void)viewWillAppear:(BOOL)animated {
//    [self setTabBar];
//}
//-(void)viewDidAppear:(BOOL)animated {
//    [self setTabBar];
//}
- (void)viewWillLayoutSubviews
{
    [self setTabBar];
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = self.screenHeight*0.09;
    tabFrame.origin.y = self.view.frame.size.height - self.screenHeight*0.09;
    self.tabBar.frame = tabFrame;
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    int toIndex = [[tabBar items] indexOfObject:item];
//    NSLog(@"From tab %d to tab %d", self.fromIndex, toIndex);
    [UIView animateWithDuration:0.7
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.slider.center = CGPointMake(self.slider.center.x+self.width*(toIndex-self.fromIndex),
                                                          self.slider.center.y);
                     }
                     completion:nil];
    self.fromIndex = toIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTabBar {
    NSArray *tabTitle = [NSArray arrayWithObjects:GET_TEXT(@"OverView"), GET_TEXT(@"Expense"), GET_TEXT(@"WishingList"), GET_TEXT(@"budget"), nil];
    for (int i = 0; i < [self.tabBar.items count]; i++){
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        [item initWithTitle:tabTitle[i]
                      image:[UIImage imageNamed:[NSString stringWithFormat:@"tabItem%d", i]]
              selectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabItem%dSelected", i]]];
       // item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
