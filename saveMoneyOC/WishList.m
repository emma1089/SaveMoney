//
//  WishList.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/19/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "WishList.h"
#import "AppDelegate.h"
#import "wishcell.h"
#import "DailyCost.h"
#import "MoneyManager.h"
#import "NewWishViewController.h"
#import "SettingViewController.h"
@interface WishList ()
@property(nonatomic) NSMutableArray *listItems;
@property (strong, nonatomic) NSMutableArray *expandedCells;
@property NaviView *naviview;
@property NSString *currency;
@end

@implementation WishList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.expandedCells = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _naviview = [[NaviView alloc]init];
    _naviview.delegate = self;
    [_naviview.leftButton setBackgroundImage:[UIImage imageNamed:@"addWishList"] forState:UIControlStateNormal];
    [_naviview.leftButton setFrame:CGRectMake(20, _naviview.titleLabel.frame.origin.y, 25, 25)];
    [self.view addSubview:_naviview];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self setAllText];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyCost" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSMutableArray *temp = [[context executeFetchRequest:request error:nil] mutableCopy];
    NSMutableArray *newItems = [[NSMutableArray alloc]init];
    [self.listItems removeAllObjects];
    for(DailyCost *cost in temp) {
        if(cost.isCost.boolValue == NO) {
            [newItems insertObject:cost atIndex:0];
        }
    }
    _listItems = newItems;
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listItems.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    wishcell *cell = [tableView dequeueReusableCellWithIdentifier:@"wishcell" forIndexPath:indexPath];
    DailyCost *wishItem = [self.listItems objectAtIndex:indexPath.section];
    cell.buyLabel.text= GET_TEXT(@"Buy");
    cell.peekLabel.text = GET_TEXT(@"Peek");
    cell.editLabel.text =GET_TEXT(@"Edit");
    cell.deleteLabel.text = GET_TEXT(@"Delete");
    cell.memoLabel.text = wishItem.memo;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",self.currency,[wishItem.amount doubleValue]];
    cell.purposeLabel.text = GET_TEXT(wishItem.purpose);
    
    if(wishItem.picture != nil) {
        cell.purposeImageLabel.clipsToBounds = YES;
        [cell.purposeImageLabel.layer setCornerRadius:cell.purposeImageLabel.bounds.size.width/2.0f];
        cell.purposeImageLabel.image = [UIImage imageWithData:wishItem.picture];
    } else {
        cell.purposeImageLabel.image = [UIImage imageNamed:wishItem.purposeImageNumber];
    }

    cell.addButton.tag = indexPath.section;
    [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.peekButton.tag = indexPath.section;
    [cell.peekButton addTarget:self action:@selector(peekButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = indexPath.section;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.editButton.tag = indexPath.section;
    [cell.editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *cellBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBackgound"]];
    cell.backgroundView = cellBGView;
    UIImageView *cellExpandBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellExpandBackground"]];
    cell.backgroundView = cellExpandBGView;
    return  cell;
}

-(void)addButtonClicked:(UIButton*)sender {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    DailyCost *selectedItem = self.listItems[sender.tag];
    selectedItem.isCost = [NSNumber numberWithBool:YES];
    selectedItem.date = [NSDate date];
    [context save:nil];
    [self.listItems removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
    [self.expandedCells removeAllObjects];
    [self sendAlert:@"Already moved to account book."];
}
-(void)peekButtonClicked:(UIButton*)sender {
    DailyCost *temp = self.listItems[sender.tag];
    double newCost = [MoneyManager peek:temp.amount];
    [self sendAlert:[NSString stringWithFormat:@"New daily maximum cost: $%f", newCost]];
}
-(void)deleteButtonClicked:(UIButton*)sender {
    [DailyCost deleteCostWithIdentification:self.listItems[sender.tag]];
    [self.listItems removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
    [self.expandedCells removeAllObjects];
}


-(void)sendAlert:(NSString*)message {
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Notification"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Expandable tableView cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.expandedCells containsObject:indexPath])
    {
        [self.expandedCells removeObject:indexPath];
    }
    else
    {
        [self.expandedCells removeAllObjects];
        [self.expandedCells addObject:indexPath];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kExpandedCellHeight = 130;
    CGFloat kNormalCellHeigh = 70;
    
    if ([self.expandedCells containsObject:indexPath]) {
        return kExpandedCellHeight; //It's not necessary a constant, though
    }
    else {
        return kNormalCellHeigh; //Again not necessary a constant
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.expandedCells removeAllObjects];
}
-(void)editButtonClicked:(UIButton*)sender{
    DailyCost *cost = self.listItems[sender.tag];
    [self performSegueWithIdentifier:@"editWishSegue" sender:cost];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"editWishSegue"]) {
        NewWishViewController *vc = (NewWishViewController*)segue.destinationViewController;
        vc.preWish = (DailyCost*)sender;
    }
}
-(void)didClickLeftButton {
    [self performSegueWithIdentifier:@"addWishSegue" sender:nil];
}
-(void)didClickRightButton {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingVC"];
    [self presentViewController:settingVC animated:YES completion:nil];
}
-(void)setAllText {
    [_naviview setTitleLabelName:GET_TEXT(@"WishingList")];
    self.currency = [[NSUserDefaults standardUserDefaults] objectForKey:@"currency"];
}
@end
