//
//  OptionScrollView.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 3/10/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "OptionScrollView.h"

@interface OptionScrollView()
@property UIButton *shakingButton;
@end

@implementation OptionScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT*0.21, SCREEN_WIDTH, SCREEN_HEIGHT*0.39);
        [self setContentSize:CGSizeMake(SCREEN_WIDTH, 1000)];
        [self reload];
        
    }
    return self;
}

-(void)optionButtonClicked:(UIButton *)sender {
    [self.delegate didClickOptionImageButton:sender.currentTitle optionImageNumber: sender.tag];
}
-(void)addButtonClicked {
    [self.delegate didClickAddOptionButton];
}

-(void)reload {
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"OptionList.plist"];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"OptionList" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:path error:nil];
    }
    self.Options = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    

    CGFloat width = self.frame.size.width;
    CGFloat contentWidth =self.contentSize.width;
    CGFloat x = 24;
    CGFloat y = width == contentWidth? 12:12;
    width == contentWidth? [self setContentSize:CGSizeMake(SCREEN_WIDTH, 20*(self.Options.count+5))]:    [self setContentSize:CGSizeMake(80*(self.Options.count + 3), SCREEN_HEIGHT*0.11)];
    for (NSString *option in self.Options) {
        //Add option button
        UIButton *button = [[UIButton alloc]init];
        //添加长按手势
        UILongPressGestureRecognizer *recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        //长按响应时间
        recognize.minimumPressDuration = 1;
        [button addGestureRecognizer:recognize];
        
        if(x + 50 > contentWidth) {
            x = 24;
            y = y + 80;
        }
        if(contentWidth != width & SCREEN_WIDTH == 320) button.frame = CGRectMake(x, y, 30, 30);
        else button.frame = CGRectMake(x, y, 40, 40);
        [button setBackgroundImage:[UIImage imageNamed:self.Options[option]] forState:UIControlStateNormal];
        [button setTitle:option forState:normal];
        //button.titleLabel.text = option;
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setTag:[self.Options[option] intValue]];
        [button addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        //Add option label
        UILabel *label = [[UILabel alloc]init];
        label.text = GET_TEXT(option);

        label.tag = button.tag + 200;
        label.frame = CGRectMake(x - 15, y + 45, 80, 30);
        if(self.contentSize.width == width) {
            //in add new cost view
           [label setTextColor:MAIN_COLOR];
            [label setFont: [label.font fontWithSize:13]];
            label.center = CGPointMake(button.center.x, button.center.y + 35);
            
        } else {
            //in add new wish item view
            [label setTextColor:[UIColor whiteColor]];
            //[label setFont: [label.font fontWithSize:14]];
            SCREEN_HEIGHT == 480? [label setFont: [label.font fontWithSize:12]]: [label setFont: [label.font fontWithSize:14]];
            //label.center = CGPointMake(button.center.x, button.center.y + 22);
            SCREEN_HEIGHT == 480? [label setCenter:CGPointMake(button.center.x, button.center.y + 22)]:[label setCenter:CGPointMake(button.center.x, button.center.y + 30)];
            
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        //x = x + 75;
        if(width >= 375) x = x + (width - 48 - 40) / 4;
        else x = x + (width - 48 - 40) / 3;
    }
    if(x + 40 > contentWidth) {
        x = 24;
        y = y + 80;
    }
    UIButton *addButton = [[UIButton alloc]init];
    [addButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y + 50, 60, 30)];
    if(self.contentSize.width == width) {
        [addButton setFrame:CGRectMake(x, y, 40, 40)];
        [addLabel setCenter:CGPointMake(addButton.center.x, addButton.center.y+35)];
        [addLabel setFont: [addLabel.font fontWithSize:14]];
        [addLabel setTextColor:MAIN_COLOR];
        [addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        
    } else {
        SCREEN_WIDTH == 320? [addButton setFrame:CGRectMake(x, y, 30, 30)]:[addButton setFrame:CGRectMake(x, y, 40, 40)];
        [addLabel setCenter:CGPointMake(addButton.center.x, addButton.center.y+30)];
        [addLabel setFont: [addLabel.font fontWithSize:14]];
        [addLabel setTextColor:[UIColor whiteColor]];
        //[addButton setImage:[UIImage imageNamed:@"addWhite"] forState:normal];
        [addButton setBackgroundImage:[UIImage imageNamed:@"addWhite"] forState:UIControlStateNormal];
    }
    
    [self addSubview:addButton];
    
    addLabel.text = GET_TEXT(@"Add");
    addLabel.textAlignment = NSTextAlignmentCenter;
    [addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addLabel];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
//    if (recognizer.state == UIGestureRecognizerStateBegan ) {
//        UIButton *shakeButton = (UIButton*)recognizer.view;
//        UIButton *deleteOptionButton = [[UIButton alloc]initWithFrame:CGRectMake(-5, -5, 20, 20)];
//        deleteOptionButton.tag = 100;
//        [deleteOptionButton addTarget:self action:@selector(deleteOptionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [deleteOptionButton setBackgroundImage:[UIImage imageNamed:@"cross-circle"] forState:normal];
//        [shakeButton addSubview:deleteOptionButton];
//        CABasicAnimation *animation = (CABasicAnimation *)[shakeButton.layer animationForKey:@"rotation"];
//        if (animation == nil) {
//            if (self.shakingButton == nil) {
//                self.shakingButton = shakeButton;
//            } else {
//                [self pause:self.shakingButton];
//                self.shakingButton = shakeButton;
//            }
//            
//            [self shakeButton:shakeButton];
//        }else {
//            [self resume:shakeButton];
//        }
//    }
//    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        [self shakeAllButtons];
    }
    
}
-(void)shakeAllButtons {
    NSArray *viewsToShake = [self subviews];
    for (UIView *v in viewsToShake) {
        
        if(v.tag <= 100 & v.tag >= 1) {
            UIButton *deleteOptionButton = [[UIButton alloc]initWithFrame:CGRectMake(-5, -5, 20, 20)];
            deleteOptionButton.tag = 300 + v.tag;
            [deleteOptionButton setBackgroundImage:[UIImage imageNamed:@"cross-circle"] forState:normal];
            [deleteOptionButton setTitle:((UIButton*)v).currentTitle forState:normal];
            [deleteOptionButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [deleteOptionButton addTarget:self action:@selector(deleteOptionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [v addSubview:deleteOptionButton];
            CABasicAnimation *animation = (CABasicAnimation *)[v.layer animationForKey:@"rotation"];
            if(animation == nil) {
                [self shakeButton:(UIButton*)v];
            } else {
                [self resume:(UIButton*)v];
            }
        }
    }

}
-(void)deleteOptionButtonClicked:(UIButton*)sender {
    for(UIView *v in [self subviews]) {
        if([v isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)v;
            if(button.tag <= 100 & button.tag >= 1 & button.currentTitle == sender.currentTitle) {
                [self.delegate didClickDeleteOptionButton:button];
                [self shakeAllButtons];
            }
        }
    }
}

-(void)resume:(UIButton*)button{
    button.layer.speed = 1.0;
    [self pause:self.shakingButton];
    self.shakingButton = button;
}

-(void)pause:(UIButton*)button {
    button.layer.speed = 0.0;
    self.shakingButton = nil;
    [[button viewWithTag:100] removeFromSuperview];
    
}
-(void)shakeButton:(UIButton*)button {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:0.08];
    animation.fromValue = @(-M_1_PI/3);
    animation.toValue = @(M_1_PI/3);
    animation.speed = 0.8;
    animation.repeatCount = HUGE_VAL;
    //animation.repeatCount = 10;
    animation.autoreverses = YES;
    button.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [button.layer addAnimation:animation forKey:@"rotation"];
    [[self viewWithTag:button.tag+200].layer addAnimation:animation forKey:@"rotation"];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self reload];
}

@end
