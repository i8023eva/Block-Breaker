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
//砖块图像数组
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *blockImageViews;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (weak, nonatomic) IBOutlet UIImageView *paddleImageView;

@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
// 初始位置
@property (nonatomic, assign) CGPoint ballCenter;
//游戏时钟
@property (nonatomic, strong) CADisplayLink *gameTimer;
//速度
@property (nonatomic, assign) CGPoint ballVelocity;

@end

@implementation ViewController

-(CADisplayLink *)gameTimer {
    if (_gameTimer == nil) {
        
        _gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
        [_gameTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _gameTimer;
}
#pragma mark - 开始移动
- (IBAction)tapScreen:(id)sender {
    NSLog(@"error ---%s ---%d", __func__, __LINE__);
    //停止手势, 防止速度累加
    self.tapGesture.enabled = NO;
    /**
     *  设置初始速度
     */
    self.ballVelocity = CGPointMake(0.0, -8.0);
    
    [self gameTimer];
    
}
#pragma mark - 游戏刷新
-(void) step{
    NSLog(@"step");
    [self intersectWithScreen];
    [self intersectWithBlocks];
    [self intersectWithPaddle];
    //更新小球位置
    self.ballImageView.center = CGPointMake(self.ballImageView.centerX + self.ballVelocity.x, self.ballImageView.centerY + self.ballVelocity.y);
}

#pragma mark - 碰撞检测
/**
 *  屏幕检测
 */
-(void) intersectWithScreen{
    //屏幕顶部
    if (CGRectGetMinY(self.ballImageView.frame) <= 0) {
        CGPoint tmpVelocity = self.ballVelocity;
        tmpVelocity.y = ABS(self.ballVelocity.y);
        self.ballVelocity = tmpVelocity;
    }
}
/**
 *  砖块检测
 */
-(void) intersectWithBlocks{
    for (UIImageView *block in self.blockImageViews) {
        //两个矩形是否相交    隐藏的砖块不去遍历
        if (CGRectIntersectsRect(block.frame, self.ballImageView.frame) && !block.hidden) {
            //隐藏砖块
            block.hidden = YES;
            //反转小球 Y 方向的速度
            _ballVelocity.y *= -1;
        }
    }
}
/**
 *  挡板检测
 */
-(void) intersectWithPaddle{
    if (CGRectIntersectsRect(self.paddleImageView.frame, self.ballImageView.frame)) {
        //速度方向为负
        _ballVelocity.y = -ABS(_ballVelocity.y);
    }
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
