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

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

// 小球初始位置
@property (nonatomic, assign) CGPoint ballCenter;
//挡板初始位置
@property (nonatomic, assign) CGPoint paddleCenter;
//游戏时钟
@property (nonatomic, strong) CADisplayLink *gameTimer;
//小球速度
@property (nonatomic, assign) CGPoint ballVelocity;
//挡板的水平速度
@property (nonatomic, assign) CGFloat paddleVeloCityX;

@end

@implementation ViewController

#pragma mark - 开始游戏
- (IBAction)tapScreen:(id)sender {
    NSLog(@"error ---%s ---%d", __func__, __LINE__);
    //停止手势, 防止速度累加
    self.tapGesture.enabled = NO;
    //隐藏提示
    self.messageLabel.hidden = YES;
    //小球
    self.ballImageView.center = self.ballCenter;
    //挡板
    self.paddleImageView.center = self.paddleCenter;
    //砖块  ---所有砖块取消隐藏
    for (UIImageView *block in self.blockImageViews) {
        block.hidden = NO;
    }
    /**
     *  设置初始速度
     */
    self.ballVelocity = CGPointMake(0.0, -8.0);
    
    self.gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    [self.gameTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
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
    //屏幕左侧
    if (CGRectGetMinX(self.ballImageView.frame) <= 0) {
        _ballVelocity.x = ABS(_ballVelocity.x);
    }
    //屏幕右侧
    if (CGRectGetMaxX(self.ballImageView.frame) >= self.view.width) {
        _ballVelocity.x = -ABS(_ballVelocity.x);
    }
    //屏幕底部
    if (CGRectGetMinY(self.ballImageView.frame) >= self.view.height) {
        NSLog(@">>>游戏结束");
        //关闭时钟
        [self.gameTimer invalidate];
        //提示
        self.messageLabel.hidden = NO;
        self.messageLabel.text = @"你是SB";
        //启用点击手势
        self.tapGesture.enabled = YES;
        /**
         *  @return 初始化游戏 [小球位置][挡板位置][砖块]
         */
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
    //遍历所有砖块是否都隐藏
    BOOL win = YES;
    for (UIImageView *block in self.blockImageViews) {
        if (![block isHidden]) {
            win = NO;
            break;
        }
    }
    //游戏胜利
    if (win) {
        //关闭时钟
        [self.gameTimer invalidate];
        //提示
        self.messageLabel.hidden = NO;
        self.messageLabel.text = @"你不是SB";
        //启用点击手势
        self.tapGesture.enabled = YES;
    }
    
}
/**
 *  挡板检测
 */
-(void) intersectWithPaddle{
    if (CGRectIntersectsRect(self.paddleImageView.frame, self.ballImageView.frame)) {
        //速度方向为负
        _ballVelocity.y = -ABS(_ballVelocity.y);
        //挡板赋予的速度[修正, 没有监测时间]
        _ballVelocity.x += _paddleVeloCityX / 120.0;
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - 拖动挡板
- (IBAction)dragPaddle:(UIPanGestureRecognizer *) sender {
/**
 1>挡板移动
 2>记录水平移动速度  ---与小球交互时才改变小球的速度
 */
    //判断手指是否在移动
    if (UIGestureRecognizerStateChanged == sender.state) {
        //获取手指移动到的位置
        CGPoint location = [sender locationInView:self.view];
        //只改变水平位置, y 不变
        self.paddleImageView.center = CGPointMake(location.x, self.paddleImageView.centerY);
        //记录  ---添加到小球
        self.paddleVeloCityX = [sender velocityInView:self.view].x;
    } else if(UIGestureRecognizerStateEnded == sender.state) {
        //停止拖动时, 挡板水平速度清0, 否则最后一次速度会记录下来并添加到小球
        self.paddleVeloCityX = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //记录小球初始位置
    self.ballCenter = self.ballImageView.center;
    //记录挡板初始位置
    self.paddleCenter = self.paddleImageView.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
