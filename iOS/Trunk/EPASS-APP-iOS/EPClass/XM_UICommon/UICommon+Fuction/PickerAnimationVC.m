    //
//  PickerAnimationVC.m
//  LeHeCai
//
//  Created by HXG on 11-10-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerAnimationVC.h"

#define BarHeight  ([[[UIDevice currentDevice] systemVersion] intValue] < 7 ? 20.0 : 0.0)

@implementation PickerAnimationVC
@synthesize pickerAnimationDelegate;
@synthesize isSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

#pragma mark -
#pragma mark - View lifecycle
- (id)initPickerAnimationData:(NSMutableArray *)array 
              titleTextString:(NSString *)text 
                   controller:(id)controller{
    if ((self = [super init])) {
        mDataArray = [[NSMutableArray alloc] init];
        [mDataArray addObjectsFromArray:array];
        [self setPickerAnimationDelegate:controller];
        [APP_DELEGATE.mWindow addSubview:self.view];
    }
    [mMessageLabel setText:text];
    mPickerString = (NSString *)[mDataArray objectAtIndex:0];
    return self;
}

- (void)setPickerAnimationFrame:(CGRect)_frame {
    [self.view setFrame:_frame];
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - mPickerView.frame.size.height, mPickerView.frame.size.width, mPickerView.frame.size.height)];
    [temp setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:temp atIndex:0];
    [temp release];
    [mPickerView setFrame:CGRectMake(0, self.view.height - mPickerView.height, mPickerView.width, mPickerView.height)];
    [mBottomView setFrame:CGRectMake(0, mPickerView.top - mBottomView.height, mBottomView.width, mBottomView.height)];
}

- (void)updataDataArray:(NSMutableArray *)array {
    [mDataArray removeAllObjects];
    [mDataArray addObjectsFromArray:array];
    mPickerString = (NSString *)[mDataArray objectAtIndex:0];
    [mPickerView reloadAllComponents];
    [mPickerView selectedRowInComponent:0];
}

- (void)updataPickerToIndex:(NSInteger)_index {
    [mPickerView selectRow:_index inComponent:0 animated:NO];
}
- (void)removeAll {
    isSelected = NO;
    [self animationDisappear];
    [self.view removeFromSuperview];
    [self release] , self = nil;
}

- (void)animationShow {
    if (isSelected) {
        return;
    }
    isSelected = YES;
    [LTools animationView:self.view 
                    fromX:0 
                    fromY:K_SCREEN_HEIGHT
                      toX:0 
                      toY:BarHeight
                    delay:0.0 
                 duration:PICKERVIEW_ANIMATION_DURATION];
    
    mPickerString = (NSString *)[mDataArray objectAtIndex:[mPickerView selectedRowInComponent:0]];
}

- (void)animationDisappear {
    isSelected = NO;
    if (self.view.frame.origin.y != K_SCREEN_HEIGHT) {
        [LTools animationView:self.view 
                        fromX:0 
                        fromY:BarHeight
                          toX:0 
                          toY:BarHeight+K_SCREEN_HEIGHT
                        delay:0.0 
                     duration:PICKERVIEW_ANIMATION_DURATION];
    }
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [self animationDisappear];
    if (sender == mDecideButton) {
        [self.pickerAnimationDelegate pickerAnimationOkButtonPressed:mPickerString];
    }else if (sender == mCancelButton){
        if ([self.pickerAnimationDelegate respondsToSelector:@selector(pickerAnimationClose)]) {
            [self.pickerAnimationDelegate pickerAnimationClose];
        }
    }
}

#pragma mark -
#pragma mark - Picker Data Source & Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [mDataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [mDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    mPickerString = [[NSString alloc] initWithString:[mDataArray objectAtIndex:row]];
}

- (void)dealloc {
    [mPickerView release] ,   mPickerView = nil;
    [mCancelButton release] , mCancelButton = nil;
    [mDecideButton release] , mDecideButton = nil;
    [mMessageLabel release] , mMessageLabel = nil;
    [mDataArray release] ,    mDataArray = nil;
    [mPickerString release] , mPickerString = nil;
    [super dealloc];
}


@end
