//
//  LCProgressView.m
//  LCProgessView
//
//  Created by tigerfly on 2023/7/5.
//

#import "LCProgressView.h"
#import <QuartzCore/CoreAnimation.h>
#import <Foundation/Foundation.h>

@interface UIColor (LCAdds)
+ (UIColor *)colorWithHex:(UInt32)hexValue;
@end

@implementation UIColor (LCAdds)

+ (UIColor *)colorWithHex:(UInt32)hexValue {
    uint8_t R = (0xff0000 & hexValue) >> 16;
    uint8_t G = (0x00ff00 & hexValue) >> 8;
    uint8_t B = 0x0000ff & hexValue;
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}
@end

@interface LCProgressView ()

@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, strong) UIView *progressTrackView;

@property (nonatomic, strong) UILabel *progressLabel;
/// 进度值字体宽高
@property (nonatomic, assign) CGSize progressTextSize;
/// 百分比字符
@property (nonatomic, copy) NSString *percentString;

@end

@implementation LCProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureInnerDefaultValue];
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithStyle:(LCProgressViewStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {
        [self configureInnerDefaultValue];
        self.style = style;
        [self setupSubviews];
    }
    return self;
}

- (void)configureInnerDefaultValue {
    self.disPlayStyle = LCProgressViewsDisplayStyleCenter;
    self.style = LCProgressViewStyleStraight;
    self.showPercent = YES;
    self.disabled = NO;
    self.trackStroke = 4.0;
    self.progressStroke = 4.0;
    self.duration = 300; // 单位为ms
    self.step = 1;
    self.filleted = YES;
    self.mountedTransition = YES;
    self.mountedBezier = @[@0.34, @0.69, @1];
    self.fontSize = 10;
    self.progressColor = UIColor.greenColor;
    self.trackColor = UIColor.redColor;
}

- (void)setupSubviews {
    if (self.style == LCProgressViewStyleCircle) return;
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectZero];
    self.progressView.backgroundColor = self.progressColor;
    [self addSubview:self.progressView];
    
    self.progressTrackView = [[UIView alloc] initWithFrame:CGRectZero];
    self.progressTrackView.backgroundColor = self.trackColor;
    [self addSubview:self.progressTrackView];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.progressLabel.textColor = [UIColor blackColor];
    self.progressLabel.font = [UIFont systemFontOfSize:self.fontSize weight:UIFontWeightLight];
    [self addSubview:self.progressLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.percentage == 0 || CGRectEqualToRect(self.frame, CGRectZero)) return;
    if (self.style == LCProgressViewStyleCircle) return;
    
    CGSize progressValueSize = [self calculateProgressTextSizeByProgressValue];
    CGRect progressViewFrame = CGRectZero;
    CGRect progressTrackViewFrame = CGRectZero;
    CGRect progressLabelFrame = CGRectZero;
    switch (self.disPlayStyle) {
        case LCProgressViewsDisplayStyleLeft: {
            progressViewFrame = CGRectMake(progressValueSize.width,  (CGRectGetHeight(self.frame) - self.progressStroke) / 2.0, CGRectGetWidth(self.frame) - progressValueSize.width, self.progressStroke);
            progressLabelFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - progressValueSize.height) / 2.0, progressValueSize.width, progressValueSize.height);
            progressTrackViewFrame = CGRectMake(progressValueSize.width, (CGRectGetHeight(self.frame) - self.trackStroke) / 2.0, (CGRectGetWidth(self.frame) - progressValueSize.width) * self.percentage, self.trackStroke);
        }
            break;
        case LCProgressViewsDisplayStyleCenter: {
            progressViewFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.progressStroke) / 2.0, CGRectGetWidth(self.frame) - progressValueSize.height, self.progressStroke);
            progressLabelFrame = CGRectMake((CGRectGetWidth(self.frame) - progressValueSize.width) / 2.0, (CGRectGetHeight(self.frame) - progressValueSize.height) / 2.0, progressValueSize.width, progressValueSize.height);
            progressTrackViewFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.trackStroke) / 2.0, CGRectGetWidth(self.frame) * self.percentage, self.trackStroke);
        }
            break;
        case LCProgressViewsDisplayStyleRight: {
            progressViewFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.progressStroke) / 2.0, CGRectGetWidth(self.frame) - progressValueSize.width, self.progressStroke);
            progressLabelFrame = CGRectMake(CGRectGetWidth(self.frame) - progressValueSize.width, (CGRectGetHeight(self.frame) - progressValueSize.height) / 2.0, progressValueSize.width, progressValueSize.height);
            progressTrackViewFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.trackStroke) / 2.0, (CGRectGetWidth(self.frame) - progressValueSize.width) * self.percentage, self.trackStroke);
        }
            break;
        case LCProgressViewsDisplayStyleFollow: {
            progressViewFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.progressStroke) / 2.0, CGRectGetWidth(self.frame), self.progressStroke);
            progressLabelFrame = CGRectMake(CGRectGetWidth(self.frame) * self.percentage - progressValueSize.width, (CGRectGetHeight(self.frame) - progressValueSize.height) / 2.0, progressValueSize.width, progressValueSize.height);
            progressTrackViewFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.trackStroke) / 2.0, CGRectGetWidth(self.frame) * self.percentage, self.trackStroke);
        }
            break;
        case LCProgressViewsDisplayStyleInnerLeft: {
            progressViewFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.progressStroke) / 2.0, CGRectGetWidth(self.frame), self.progressStroke);
            progressLabelFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - progressValueSize.height) / 2.0, progressValueSize.width, progressValueSize.height);
            progressTrackViewFrame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.trackStroke) / 2.0, CGRectGetWidth(self.frame) * self.percentage, self.trackStroke);
        }
            break;
        case LCProgressViewsDisplayStyleCustom: {
        }
            break;
    }
    
    self.progressView.frame = progressViewFrame;
    /// 采用动画过度加载进度
    if (self.mountedTransition == YES) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.beginTime = 0;
        animation.duration = 0.25;
        animation.fromValue = [NSValue valueWithCGRect:CGRectZero];
        animation.toValue = [NSValue valueWithCGRect:progressTrackViewFrame];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.beginTime = 0;
        positionAnimation.duration = 0.25;
        positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(progressTrackViewFrame), CGRectGetMidY(progressTrackViewFrame))];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
        group.animations = @[animation, positionAnimation];
        [self.progressTrackView.layer addAnimation:group forKey:@"frame"];
        
    } else {
        self.progressLabel.frame = progressLabelFrame;
        self.progressTrackView.frame = progressTrackViewFrame;
    }
    
    [self.progressLabel bringSubviewToFront:self.progressTrackView];
    
    if (self.disabled) {
        self.trackColor = [UIColor colorWithHex:0x666666];
        self.progressColor = [UIColor colorWithHex:0x999999];
    }
    if (self.filleted) {
        self.progressView.layer.cornerRadius = self.progressStroke / 2.0;
        self.progressTrackView.layer.cornerRadius = self.trackStroke / 2.0;
    }
    if (self.renderPercent) {
        self.renderPercent(self.percentString);
    }

    //    if (CGRectEqualToRect(self.frame, CGRectZero)) {
    //        NSArray <UILayoutGuide *>*layoutGuides = self.layoutGuides;
    //        for (UILayoutGuide *layoutGuide in layoutGuides) {
    //            NSLayoutYAxisAnchor *topContraint = layoutGuide.topAnchor;
    //        }
    //    }
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (CGRectEqualToRect(rect, CGRectZero)) return;
    if (self.style == LCProgressViewStyleStraight) return;
    
    CGMutablePathRef progressPathRef = CGPathCreateMutable();
    CGPathAddRelativeArc(progressPathRef, NULL, CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect)/2.0, CGRectGetWidth(rect)/2.0, 0, M_PI * 2);
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetWidth(rect));
    progressLayer.path = progressPathRef;
    [progressLayer setStrokeColor:self.progressColor.CGColor];
    [progressLayer setLineWidth:6];
    [progressLayer setFillColor:UIColor.clearColor.CGColor];
    [self.layer addSublayer:progressLayer];
    
    
    CGMutablePathRef trackProgressPathRef = CGPathCreateMutable();
    CGPathAddRelativeArc(trackProgressPathRef, NULL, CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect)/2.0, CGRectGetWidth(rect)/2.0, 0, M_PI * 2);
    CAShapeLayer *trackProgressLayer = [CAShapeLayer layer];
    trackProgressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetWidth(rect));
    trackProgressLayer.path = trackProgressPathRef;
    [trackProgressLayer setStrokeColor:self.trackColor.CGColor];
    [trackProgressLayer setLineWidth:8];
    [trackProgressLayer setStrokeStart:0];
    [trackProgressLayer setStrokeEnd:0.8];
    [trackProgressLayer setLineCap:kCALineCapRound];
    [trackProgressLayer setFillColor:UIColor.clearColor.CGColor];
    [self.layer addSublayer:trackProgressLayer];
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    [keyFrameAnimation setKeyTimes:self.mountedBezier];
    keyFrameAnimation.calculationMode = kCAAnimationCubic;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.duration = 2;
    [trackProgressLayer addAnimation:keyFrameAnimation forKey:@"strokeEnd"];
}

#pragma mark -- setter

- (void)setFilleted:(BOOL)filleted {
    if (!filleted) return;
    _filleted = filleted;
}

- (void)setDisPlayStyle:(LCProgressViewsDisplayStyle)disPlayStyle {
    _disPlayStyle = disPlayStyle;
}

- (void)setStyle:(LCProgressViewStyle)style {
    _style = style;
}

- (void)setShowPercent:(BOOL)showPercent {
    _showPercent = showPercent;
    self.progressLabel.hidden = showPercent == YES ? NO : YES;
}

- (void)setPercentage:(CGFloat)percentage {
    if (percentage == 0) return;
    _percentage = percentage;
    self.progressLabel.text = self.percentString;
}

- (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;
}

- (void)setTrackStroke:(CGFloat)trackStroke {
    if (trackStroke == 0) return;
    _trackStroke = trackStroke;
}

- (void)setProgressStroke:(CGFloat)progressStroke {
    if (progressStroke == 0) return;
    _progressStroke = progressStroke;
}

- (void)setDuration:(NSInteger)duration {
    _duration = duration;
}

- (void)setStep:(NSInteger)step {
    _step = step;
}

- (void)setMountedTransition:(BOOL)mountedTransition {
    _mountedTransition = mountedTransition;
}

- (void)setMountedBezier:(NSArray *)mountedBezier {
    _mountedBezier = mountedBezier;
    if (mountedBezier.count == 0 || mountedBezier == nil) return;
}

- (void)setTrackColor:(UIColor *)trackColor {
    if (trackColor == nil) return;
    _trackColor = trackColor;
    self.progressTrackView.backgroundColor = trackColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    if (progressColor == nil) return;
    _progressColor = progressColor;
    self.progressView.backgroundColor = progressColor;
}

- (void)setFontSize:(NSInteger)fontSize {
    if (fontSize == 0) return;
    _fontSize = fontSize;
}


#pragma mark -- private implements

- (CGSize)calculateProgressTextSizeByProgressValue {
    UIFont *valueFont = [UIFont systemFontOfSize:self.fontSize weight:UIFontWeightLight];
    CGRect valueRect = [self.percentString boundingRectWithSize:CGSizeMake(MAXFLOAT, valueFont.lineHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:valueFont} context:nil];
    return valueRect.size;
}

- (NSString *)percentString {
    return [NSString stringWithFormat:@"%.lf%@",self.percentage * 100, @"%"];
}

//- (nullable __kindof CALayer *)hitTest:(CGPoint)p {
//}


@end



