//
//  ViewController.m
//  启动动画demo
//
//  Created by M on 2017/7/5.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *home_demo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    [self.view addSubview:home_demo];
    home_demo.frame = CGRectMake(0, 0, 375, 667);
    
    
    CALayer *maskLayer = [CALayer layer];// 创建遮罩
    maskLayer.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
    maskLayer.frame = CGRectMake(375 * .5 - 30, 667 * .5 - 30, 60, 60);
    self.navigationController.view.layer.mask = maskLayer;
    
    // 创建白色背景
    UIView *maskBackgroundView = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    maskBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:maskBackgroundView];
    [self.navigationController.view bringSubviewToFront:maskBackgroundView];
    
    
    // 关键帧动画
    /* 
     ——values 关键帧数组
     上述的NSArray对象。里面的元素称为“关键帧”(keyframe)。
     动画对象会在指定的时间（duration）内，依次显示values数组中的每一个关键帧
     ——path 路径轨迹
     path：可以设置一个CGPathRef、CGMutablePathRef，让图层按照路径轨迹移动。
     path只对CALayer的anchorPoint和position起作用。
     ****注意：如果设置了path，那么values关键帧将被忽略
     ——keyTimes：关键帧所对应的时间点
     keyTimes：可以为对应的关键帧指定对应的时间点，其取值范围为0到1.0
     keyTimes中的每一个时间值都对应values中的每一帧。如果没有设置keyTimes，各个关键帧的时间是平分的
     */
    CAKeyframeAnimation *logoMaskAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    logoMaskAnimation.duration = 1.0f;
    logoMaskAnimation.beginTime = CACurrentMediaTime() + 1.0f;
    
    CGRect initalBounds = maskLayer.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 50, 50);
    CGRect finalBounds = CGRectMake(0, 0, 2000, 2000);
    logoMaskAnimation.values = @[[NSValue valueWithCGRect:initalBounds], [NSValue valueWithCGRect:secondBounds], [NSValue valueWithCGRect:finalBounds]];
    logoMaskAnimation.keyTimes = @[@0, @.5, @1];
    logoMaskAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];// 设置动画的速度变化
    logoMaskAnimation.removedOnCompletion = NO;// “需要将其 removedOnCompletion 设置为 false 才行,不然 fillMode 将不起作用。
    /*
     kCAFillModeRemoved 这个是默认值，也就是说当动画开始前和动画结束后，动画对layer都没有影响，动画结束后，layer会恢复到之前的状态。
     kCAFillModeForwards 当动画结束后，layer会一直保持着动画最后的状态。
     kCAFillModeBackwards 这个和 kCAFillModeForwards 是相对的，就是在动画开始前，你只要将动画加入了一个layer，layer便立即进入动画的初始状态并等待动画开始。你可以这样设定测试代码，将一个动画加入一个layer的时候延迟5秒执行。然后就会发现在动画没有开始的时候，只要动画被加入了 layer , layer 便处于动画初始状态， 动画结束后，layer 也会恢复到之前的状态。
     kCAFillModeBoth 理解了上面两个，这个就很好理解了，这个其实就是上面两个的合成。动画加入后立即开始，layer便处于动画初始状态，动画结束后layer保持动画最后的状态”
     摘录来自: 杨骑滔（KittenYang）. “A GUIDE TO IOS ANIMATION”。 iBooks.
     */
    logoMaskAnimation.fillMode = kCAFillModeForwards;// kCAFillModeForwards动画开始之后layer的状态将保持在动画的最后一帧，而removedOnCompletion的默认属性值是 YES，所以为了使动画结束之后layer保持结束状态，应将removedOnCompletion设置为NO
    [self.navigationController.view.layer.mask addAnimation:logoMaskAnimation forKey:@"logoMaskAnimation"];
    
    
    [UIView animateWithDuration:0.1 delay:1.35 options:UIViewAnimationOptionTransitionNone animations:^{
        maskBackgroundView.alpha = 0.0;// 白色背景视图渐变透明
    } completion:^(BOOL finished) {
        [maskBackgroundView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:.25 delay:1.3 options:UIViewAnimationOptionTransitionNone animations:^{
        self.navigationController.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.navigationController.view.transform = CGAffineTransformIdentity;// CGAffineTransformIdentity是系统提供的一个常量，/* The identity transform: [ 1 0 0 1 0 0 ]. */（和原图一样的transform）
        } completion:^(BOOL finished) {
            self.navigationController.view.layer.mask = nil;
        }];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
