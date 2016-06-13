//
//  ImageCropView.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/10/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "ImageCropView.h"

@interface ImageCropView ()
@property (weak, nonatomic) IBOutlet UIImageView *cropImageView;
@property NaviView *naviView;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (nonatomic) CGFloat lastScale;
@end

@implementation ImageCropView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cropImageView.image = self.cropImage;
    //self.cropImageView.contentMode = UIViewContentModeAspectFill;
    //self.cropImageView.contentMode = UIViewContentModeScaleToFill;
    self.cropImageView.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.cropImageView addGestureRecognizer:pinch];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.cropImageView addGestureRecognizer:pan];
    self.naviView = [[NaviView alloc]init];
    self.naviView.delegate = self;
    [self.naviView setTitleLabelName:GET_TEXT(@"CropImage")];
    [self.naviView.rightButton setBackgroundImage:[UIImage imageNamed:@"crossCancel"] forState:normal];
    [self.naviView.leftButton setBackgroundImage:[UIImage imageNamed:@"checkSave"] forState:normal];
    self.naviView.leftButton.frame = CGRectMake(self.naviView.leftButton.frame.origin.x+5, self.naviView.leftButton.frame.origin.y, 36, 25);
    [self.view addSubview:self.naviView];
    
    
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        self.lastScale = [recognizer scale];
    }
    
    if ([recognizer state] == UIGestureRecognizerStateBegan ||
        [recognizer state] == UIGestureRecognizerStateChanged) {
        
        CGFloat currentScale = [[[recognizer view].layer     valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 2.0;
        const CGFloat kMinScale = 1.0;
        
        CGFloat newScale = 1 -  (self.lastScale - [recognizer scale]); // new scale is in the range (0-1)
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
        [recognizer view].transform = transform;
        
        self.lastScale = [recognizer scale];  // Store the previous scale factor for the next pinch gesture call
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint lastCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                     recognizer.view.center.y + translation.y);
    recognizer.view.center = lastCenter;
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    CGRect lastFrame = recognizer.view.frame;
    CGFloat imageWidth = self.cropImage.size.width;
    CGFloat imageHeight = self.cropImage.size.height;
    CGFloat fillScale = fmaxf(lastFrame.size.width/imageWidth, lastFrame.size.height/imageHeight);
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if(lastCenter.x > imageWidth*fillScale/2 ){
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 recognizer.view.center = CGPointMake(imageWidth*fillScale/2,
                                                                      recognizer.view.center.y);
                                 
                             }
                             completion:nil];
            
        }
        if(lastCenter.y > imageHeight*fillScale/2 ){
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                                                      imageHeight*fillScale/2);
                                 
                             }
                             completion:nil];
        }
        if(self.blackView.frame.size.width - lastCenter.x > imageWidth*fillScale/2){
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 recognizer.view.center = CGPointMake(self.blackView.frame.size.width - imageWidth*fillScale/2,
                                                                      recognizer.view.center.y);
                                 
                             }
                             completion:nil];
        }
        if(self.blackView.frame.size.height - lastCenter.y > imageHeight*fillScale/2){
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                                                      self.blackView.frame.size.height - imageHeight*fillScale/2);
                             }
                             completion:nil];
        }
    }
    
}

-(void)didClickLeftButton {
    if([self.delegate respondsToSelector:@selector(didCropImageSuccess:)]){
        UIImage *cropped;
        if (self.cropImage != nil){
            UIGraphicsEndImageContext();
            CGRect CropRect = self.blackView.frame;
            UIGraphicsBeginImageContextWithOptions(CropRect.size, self.blackView.opaque, 0.0);
            UIGraphicsBeginImageContext(CropRect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.blackView.layer renderInContext:context];
            cropped = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        [self.delegate didCropImageSuccess:cropped];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)didClickRightButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end