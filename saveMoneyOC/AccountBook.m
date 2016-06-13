//
//  ViewController.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 1/8/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "AccountBook.h"
#import "DailyCostCell.h"
#import "AppDelegate.h"
#import "DailyCost.h"
#import "TimeManager.h"
#import "NewCostViewController.h"
#import "MoneyManager.h"
//#import "TabViewController.h"
@interface AccountBook ()
@property(nonatomic) NSMutableArray *dailyCosts;
@property(nonatomic) NSMutableArray *currentDailyCosts;
@property(nonatomic) NSDate *currentDate;
@property(nonatomic) NSDate *today;
//@property(nonatomic) UIButton *AddButton;
@property(nonatomic) UISwipeGestureRecognizer *rightRecognizer;
@property(nonatomic) UISwipeGestureRecognizer *leftRecognizer;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *dragBar;
@property(nonatomic) double maxcost;
@property NaviView *naviview;
@property (weak, nonatomic) IBOutlet UILabel *budgetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseTextLabel;
@property NSString *currency;
@end

@implementation AccountBook

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviview = [[NaviView alloc]init];
    self.naviview.delegate = self;


    [self.view addSubview:self.naviview];
    self.accountTableView.tableHeaderView = nil;
    self.today = [[NSDate alloc]init];
    self.currentDailyCosts = [[NSMutableArray alloc]init];
    self.currentDate = self.today;
    self.accountTableView.separatorStyle = UITableViewCellSelectionStyleNone;
}
-(void)viewWillAppear:(BOOL)animated {
    [self handleNaviButton];
}
-(void)viewDidAppear:(BOOL)animated {
    [self setAllText];
    //Fetch all data
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyCost" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    self.dailyCosts = [[context executeFetchRequest:request error:nil] mutableCopy];
    [self updateDataWhenDateChange];
    self.maxCostLabel.text = [NSString stringWithFormat:@"%@%.2f", self.currency,self.maxcost];
    self.alreadyCostLabel.text = [NSString stringWithFormat:@"%@%.2f",self.currency, [MoneyManager getDailySum:self.currentDate]];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    if(image != nil) {
        [self.backgroundImageView setImage:image];
        [self.backgroundImageView setAlpha:0.8];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentDailyCosts.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyCostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyCostCell" forIndexPath:indexPath];
    //DailyCost *cost = [self.dailyCosts objectAtIndex:indexPath.row];
    DailyCost *cost = [self.currentDailyCosts objectAtIndex:indexPath.row];
    //cell.amountLabel.text = cost.amount.stringValue;
    //cell.purposeLabel.text = cost.purpose;
    cell.purposeLabel.text = [NSString stringWithFormat:@"%@%@%@%.2f", GET_TEXT(cost.purpose),@" ",self.currency,[cost.amount doubleValue]];
    cell.purposeImageView.image = [UIImage imageNamed:cost.purposeImageNumber];
    cell.pictureImageView.image = [UIImage imageWithData:cost.picture];
    cell.memoLabel.text = cost.memo;
    [cell.bar1 setBackgroundColor:MAIN_COLOR];
    [cell.bar2 setBackgroundColor:MAIN_COLOR];
    if(indexPath.row == self.currentDailyCosts.count - 1) {
        [cell.bar2 setBackgroundColor:[UIColor clearColor]];
    }
    if(![[TimeManager getDateString:cost.date] isEqualToString:[TimeManager getDateString:[NSDate date]]]) {
        cell.overspendLabel.text = @"";
        return cell;
    }
    double sum = 0;
    for(int i = 0; i <= indexPath.row; i++) {
        DailyCost *temp = self.currentDailyCosts[i];
        sum += [temp.amount doubleValue];
    }

    if(sum > self.maxcost) {
        cell.overspendLabel.text = [NSString stringWithFormat:@"%@%@%.2f", GET_TEXT(@"Overspend"), self.currency,sum - self.maxcost];
    } else {
        cell.overspendLabel.text = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    NSLog(@"么么么么么哒");
    [self showActionSheet:indexPath.row];

}

-(void)showActionSheet:(NSInteger)row {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = MAIN_COLOR;
    
    [UIActionSheet setAnimationDelay:0];
    [UIActionSheet setAnimationDuration:0.1];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:GET_TEXT(@"Edit") style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //code to run once button is pressed
                                                        [self performSegueWithIdentifier:@"showDetailSegue" sender:self.currentDailyCosts[row]];
                                                    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:GET_TEXT(@"Delete") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [DailyCost deleteCostWithIdentification:self.currentDailyCosts[row]];
        [self.currentDailyCosts removeObjectAtIndex:row];
        [self updateDataWhenDateChange];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:GET_TEXT(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){}];

    
    [alert addAction:editAction];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [UIActionSheet setAnimationDelay:0];
    [UIActionSheet setAnimationDuration:0.1];
    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL)isToday {
    if([[TimeManager getDateString:self.currentDate] isEqualToString:[TimeManager getDateString:self.today]]) {
        return true;
    } else {
        return false;
    }
}
-(void)handleNaviButton {
    if ([self isToday]) {
        self.showNextButton.enabled = false;
    } else {
        self.showNextButton.enabled = true;
    }
}

-(void)updateDataWhenDateChange {
    [self.currentDailyCosts removeAllObjects];
    self.maxcost = [MoneyManager getCurrentMaxCost];
    for(DailyCost *cost in self.dailyCosts) {
        if(cost.isCost.boolValue == NO) continue;
        if([[TimeManager getDateString:cost.date] isEqualToString:[TimeManager getDateString:self.currentDate]]) {
            [self.currentDailyCosts addObject:cost];
            //[self.currentDailyCosts insertObject:cost atIndex:0];
        }
    }
    if(self.currentDailyCosts.count == 0) {
        [self.dragBar setBackgroundColor:[UIColor clearColor]];
    } else {
        [self.dragBar setBackgroundColor:MAIN_COLOR];
    }
    //[self.accountTableView reloadData];
    [self.accountTableView beginUpdates];
    [self.accountTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.accountTableView endUpdates];
    
    if([self.accountTableView numberOfRowsInSection:0] == 0) return;
    long lastRowNumber = [self.accountTableView numberOfRowsInSection:0] - 1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [self.accountTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - previous & next day & back Today

- (IBAction)showPreviousButtonClicked:(UIButton *)sender {
    self.currentDate = [TimeManager getPreviousDate:self.currentDate];
    [self.currentDateButton setTitle:[TimeManager getDateString:self.currentDate] forState:UIControlStateNormal];
    [self updateDataWhenDateChange];
    [self handleNaviButton];
    
    
}

- (IBAction)showNextButtonClicked:(UIButton *)sender {
    self.currentDate = [TimeManager getNextDate:self.currentDate];
    [self.currentDateButton setTitle:[TimeManager getDateString:self.currentDate] forState:UIControlStateNormal];
    [self updateDataWhenDateChange];
    [self handleNaviButton];
}

-(void)backToToday {
    self.currentDate = self.today;
    [self.currentDateButton setTitle:[TimeManager getDateString:self.currentDate] forState:UIControlStateNormal];
    [self updateDataWhenDateChange];
    [self handleNaviButton];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"addNewCostSegue"]) {
        NewCostViewController *nc = (NewCostViewController*)segue.destinationViewController;
        nc.predate = (NSDate*)sender;
    }
    if ([segue.identifier isEqual:@"showDetailSegue"]) {
        NewCostViewController *nc = (NewCostViewController*)segue.destinationViewController;
        nc.preCost = (DailyCost*)sender;
    }
}
- (IBAction)addNewCostButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"addNewCostSegue" sender:self.currentDate];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void) addNewCost:(id)sender{
    [self performSegueWithIdentifier:@"addNewCostSegue" sender:self.currentDate];
}

-(void)didClickLeftButton {
    self.currentDate = self.today;
    [self.currentDateButton setTitle:[TimeManager getDateString:self.currentDate] forState:UIControlStateNormal];
    [self updateDataWhenDateChange];
    [self handleNaviButton];
}
-(void)didClickRightButton {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingVC"];
    settingVC.delegate = self;
    [self presentViewController:settingVC animated:YES completion:nil];
}
-(void)didChangeLanguage {
    [self setAllText];
}
-(void)setAllText {
    [self.naviview setTitleLabelName:GET_TEXT(@"Expense")];
    [self.naviview setLeftButtonName:GET_TEXT(@"Today")];
    self.budgetTextLabel.text = GET_TEXT(@"budget");
    self.expenseTextLabel.text = GET_TEXT(@"Expense");
    [self.currentDateButton setTitle:[TimeManager getDateString:self.currentDate] forState:UIControlStateNormal];
    self.currency = [[NSUserDefaults standardUserDefaults] objectForKey:@"currency"];
}
-(void)startAnimation {
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.dragBar.frame = CGRectMake(SCREEN_WIDTH / 2-0.5, self.dragBar.frame.origin.y, 1, -self.accountTableView.contentOffset.y + 2);
                     }
                     completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < 0) {
        [self startAnimation];
    }
}
@end
