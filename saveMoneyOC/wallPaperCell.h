//
//  wallPaperCell.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/11/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wallPaperCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *wallImage;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property BOOL isSelected;
@end
