//
//  LCProgressView.h
//  LCProgessView
//
//  Created by tigerfly on 2023/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LCProgressViewsDisplayStyle) {
    LCProgressViewsDisplayStyleLeft = 0,
    LCProgressViewsDisplayStyleRight = 1,
    LCProgressViewsDisplayStyleCenter = 2,
    LCProgressViewsDisplayStyleInnerLeft,
    LCProgressViewsDisplayStyleFollow = 5,
    LCProgressViewsDisplayStyleCustom = 7
};

typedef NS_ENUM(NSInteger, LCProgressViewStyle) {
    LCProgressViewStyleStraight = 1,
    LCProgressViewStyleCircle = 2
};

typedef void(^renderPercent)(NSString *progress);


@interface LCProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithStyle:(LCProgressViewStyle)style;

/*
 进度文字显示位置
 默认值为 LCProgressViewsDisplayStyleCenter
 */
@property (nonatomic) LCProgressViewsDisplayStyle disPlayStyle;

/// 展示样式
@property (nonatomic, readwrite) LCProgressViewStyle style;

/**
 是否显示进度条内部文字
 默认值为 YES
 */
@property (nonatomic) BOOL showPercent;

/**
 进度条百分比
 此属性为必填项
 */
@property (nonatomic, assign) CGFloat percentage;

/// 进度条内部文字显示
@property (nonatomic, copy) renderPercent renderPercent;

/// 轨道颜色
@property (nonatomic, strong) UIColor *trackColor;

/// 进度条颜色
@property (nonatomic, strong) UIColor *progressColor;

/**
 是否置灰
 默认值为 NO
 */
@property (nonatomic, assign) BOOL disabled;

/**
 进度条背景高度
 默认值为 4
 */
@property (nonatomic, assign) CGFloat trackStroke;

/**
 进度条高度
 默认值为 4
 */
@property (nonatomic, assign) CGFloat progressStroke;

/**
 每增加step步长所需的毫秒数
 默认值为 300 ms
 */
@property (nonatomic, assign) NSInteger duration;

/**
 步长（增加步长，以step增长)
 默认值为 1
 */
@property (nonatomic, assign) NSInteger step;

/**
 进度条是否两端圆角
 默认值为 YES
 */
@property (nonatomic, assign) BOOL filleted;

/**
 初始化percentage时是否以动画形式过渡到目的值
 默认值为 YES
 */
@property (nonatomic, assign) BOOL mountedTransition;

/**
 初始化时动画的贝塞尔曲线
 默认值为 [0.34, 0.69, 1]
 */
@property (nonatomic, copy) NSArray *mountedBezier;

/**
 当前进度字体大小
 默认大小为10
 */
@property (nonatomic, assign) NSInteger fontSize;



@end

NS_ASSUME_NONNULL_END
