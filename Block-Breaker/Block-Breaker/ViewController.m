//
//  ViewController.m
//  Block-Breaker
//
//  Created by lyh on 15/10/25.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
// 初始位置
@property (nonatomic, assign) CGPoint ballCenter;
//游戏时钟
@property (nonatomic, strong) CADisplayLink *gameTimer;
//速度
@property (nonatomic, assign) CGPoint ballVelocity;

@end

@implementation ViewController

-(void) step{
    NSLog(@"step");
    //更新小球位置
    self.ballImageView.center = CGPointMake(self.ballImageView.centerX + self.ballVelocity.x, self.ballImageView.centerY + self.ballVelocity.y);
}

- (IBAction)tapScreen:(id)sender {
    NSLog(@"error ---%s ---%d", __func__, __LINE__);
    //停止手势, 防止速度累加
    self.tapGesture.enabled = NO;
    /**
     *  设置初始速度
     */
    self.ballVelocity = CGPointMake(0.0, -5.0);
    
    self.gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    [self.gameTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //记录初始位置
    self.ballCenter = self.ballImageView.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
