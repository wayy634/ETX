//
//  LCCustomSlider.m
//  LeCai
//
//  Created by lehecaiminib on 14-8-19.
//
//

#import "LCCustomSlider.h"


@implementation LCCustomSlider
@synthesize mSlider,mValue;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)_frame sliderFrame:(CGRect)_sliderFrame equallyValue:(int)_equallyValue markImageArray:(NSArray *)_markArray correspondingData:(NSArray *)_correspondingArray delegate:(id)_delegate {
    self = [super initWithFrame:_frame];
    if (self) {
        [self setBackgroundColor:[LTools colorWithHexString:@"f2f2f2"]];
        mDelegate = _delegate;
        mIdentificationArray = [[NSMutableArray alloc] init];
        mMarkLableArray = [[NSMutableArray alloc] init];
        mMarkImageArray = [[NSMutableArray alloc] initWithArray:_markArray];
        mValue = 0;
        mTotalValue = _equallyValue;
        // Initialization code
        mSlider = [[UISlider alloc] initWithFrame:_sliderFrame];
        
        [mSlider setMinimumValue:0];
        [mSlider setMaximumValue:_equallyValue];
        
        if (_markArray != nil && _correspondingArray != nil) {
            for (int i = 0; i < _equallyValue; i++) {
                UIImage *image;
                if (i == 0) {
                    image = [UIImage imageNamed:@"recommend_slider_finish_selected.png"];
                } else if (i == _equallyValue - 1) {
                    image = [UIImage imageNamed:[mMarkImageArray objectAtIndex:2]];
                } else {
                    image = [UIImage imageNamed:[mMarkImageArray objectAtIndex:0]];
                }
                UIImageView *temp = [[UIImageView alloc] initWithImage:image];
                [temp setFrame:CGRectMake(/*(i*(mSlider.width/(_equallyValue - 1))) - image.size.width/2*/mSlider.left +  10 + i*51, ((mSlider.height - image.size.height)/2) + 0.5 - 3, image.size.width, image.size.height)];
                [self addSubview:temp];
                [mIdentificationArray addObject:temp];
                
                UILabel *mark = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
                [mark setText:[_correspondingArray objectAtIndex:i]];
                [mark setFrame:[mark textRectForBounds:mark.frame limitedToNumberOfLines:0]];
                if (i==0) {
                    mark.width += 5;
                }
                [mark setTextColor:[UIColor grayColor]];
                [mark setBackgroundColor:[UIColor clearColor]];
                [mark setFont:K_FONT_SIZE(11)];
                [mark setFrame:CGRectMake(temp.frame.origin.x + ((temp.width - mark.width)/2) + i*1.5, mSlider.bottom-8, mark.width, mark.height)];
                [mMarkLableArray addObject:mark];
                [self addSubview:mark];
                [mark release] , mark = nil;
                [temp release], temp = nil;
            }
        }
        [self addSubview:mSlider];
        [mSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [mSlider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)reSetUI {
    for (int i = 0;i < [mIdentificationArray count] ; i++) {
        if (i <= mValue) {
            if (i != 0 && i != mTotalValue - 1) {
                [(UIImageView *)[mIdentificationArray objectAtIndex:i] setImage:[UIImage imageNamed:[mMarkImageArray objectAtIndex:1]]];
            } else {
                [(UIImageView *)[mIdentificationArray objectAtIndex:i] setImage:[UIImage imageNamed:[mMarkImageArray objectAtIndex:3]]];
            }
        } else {
            if (i != 0 && i != mTotalValue - 1) {
                [(UIImageView *)[mIdentificationArray objectAtIndex:i] setImage:[UIImage imageNamed:[mMarkImageArray objectAtIndex:0]]];
            } else {
                [(UIImageView *)[mIdentificationArray objectAtIndex:i] setImage:[UIImage imageNamed:[mMarkImageArray objectAtIndex:2]]];
            }
        }
    }
}

- (void)reFreshUI:(NSArray *)_correspondingArray {
    for (int i = 0; i < [mMarkLableArray count]; i++) {
        UILabel *temp = [mMarkLableArray objectAtIndex:i];
        [temp setText:[_correspondingArray objectAtIndex:i]];
    }
}

- (void)sliderValueChanged:(UISlider *)_slider {
    if ((int)mSlider.value != mValue) {
        if ((int)mSlider.value >= mValue) {
            if (mTotalValue - mSlider.value != 1) {
                [(UIImageView *)[mIdentificationArray objectAtIndex:mValue+1] setImage:[UIImage imageNamed:[mMarkImageArray objectAtIndex:1]]];
            } else {
                [(UIImageView *)[mIdentificationArray objectAtIndex:mValue+1] setImage:[UIImage imageNamed:[mMarkImageArray objectAtIndex:3]]];
            }
        } else {
            if (mSlider.value > mTotalValue - 2) {
                [(UIImageView *)[mIdentificationArray objectAtIndex:mValue] setImage:[UIImage imageNamed:[mMarkImageArray objectAtIndex:2]]];
            } else {
                [(UIImageView *)[mIdentificationArray objectAtIndex:mValue] setImage:[UIImage imageNamed:[mMarkImageArray objectAtIndex:0]]];
            }
        }
        mValue = (int)mSlider.value;
    }
}

- (void)sliderTouchUpInSide:(UISlider *)_slider {
    [_slider setValue:(int)(_slider.value + 0.5) animated:YES];
    [self sliderValueChanged:_slider];
    [mDelegate LCCustomSliderValueChange:(int)_slider.value];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
