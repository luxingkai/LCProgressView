//
//  ViewController.m
//  LCProgessView
//
//  Created by tigerfly on 2023/7/5.
//

#import "ViewController.h"
#import "LCProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(80, 100, 100, 6)];
//    progressView.trackTintColor = UIColor.redColor;
//    progressView.progressTintColor = UIColor.greenColor;
//    progressView.progress = 0.4;
//    [self.view addSubview:progressView];
    
    LCProgressView *progressView = [[LCProgressView alloc] initWithStyle:LCProgressViewStyleStraight];
    progressView.frame = CGRectMake(80, 200, 200, 100);
    progressView.progressColor = UIColor.yellowColor;
    progressView.trackColor = UIColor.greenColor;
    progressView.percentage = 0.4;
    progressView.filleted = YES;
    progressView.mountedTransition = NO;
    progressView.disPlayStyle = LCProgressViewsDisplayStyleCenter;
    progressView.disabled = NO;
    progressView.progressStroke = 12;
    progressView.trackStroke = 8;
    [progressView setRenderPercent:^(NSString * _Nonnull progress) {
        NSLog(@"%@",progress);
    }];
    [self.view addSubview:progressView];
    
}


@end
