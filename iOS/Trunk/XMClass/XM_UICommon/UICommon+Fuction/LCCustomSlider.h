//
//  LCCustomSlider.h
//  LeCai
//
//  Created by lehecaiminib on 14-8-19.
//
//

#import <UIKit/UIKit.h>
@protocol LCCustomSliderDelegate
- (void)LCCustomSliderValueChange:(int)_value;
@end

@interface LCCustomSlider : UIView {
    NSMutableArray          *mIdentificationArray;
    NSMutableArray          *mMarkImageArray;
    NSMutableArray          *mMarkLableArray;
    int                     mValue;
    UISlider                *mSlider;
    id<LCCustomSliderDelegate>     mDelegate;
    int                     mTotalValue;
}

@property (nonatomic,retain)UISlider     *mSlider;
@property (assign)int                     mValue;

- (id)initWithFrame:(CGRect)_frame sliderFrame:(CGRect)_sliderFrame equallyValue:(int)_equallyValue markImageArray:(NSArray *)_markArray correspondingData:(NSArray *)_correspondingArray delegate:(id)_delegate;

- (void)reSetUI;

- (void)reFreshUI:(NSArray *)_correspondingArray;
@end
