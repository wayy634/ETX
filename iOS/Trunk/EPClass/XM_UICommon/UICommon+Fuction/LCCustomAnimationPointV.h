//
//  LCCustomAnimationPointV.h
//  LeCai
//
//  Created by lehecaiminib on 14-12-23.
//
//

#import <UIKit/UIKit.h>

typedef void(^AnimationSuccess)();
@interface LCCustomAnimationPointV : UIView {
    UIImageView     *mAnimationImageV;
}
@property(nonatomic,strong) AnimationSuccess animationBlock;
//init
- (id)initCustomKeyAnimation:(UIImage *)_image;

//for point
- (void)startPointAniamtionPointFrame:(NSArray *)_pointArray durationTime:(float)_durationTime success:(AnimationSuccess)_completion;

//for path
- (void)startPathAnimationPathFrame:(CGMutablePathRef)_PathRef durationTime:(float)_durationTime success:(AnimationSuccess)_completion;

//for object
+ (void)startAnimation:(UIView *)_view animationGroupArray:(NSArray *)_array durationTime:(float)_durationTime;

//稍后做成传参方法。。。目前没时间
- (void)startBaiduChooseBallPathAnimationpathFrame:(CGMutablePathRef)_PathRef success:(AnimationSuccess)_completion;
@end
