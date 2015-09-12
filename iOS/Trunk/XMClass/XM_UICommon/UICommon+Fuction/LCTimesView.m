//
//  LCTimesView.m
//  LeCai
//
//  Created by WangHui on 12/1/14.
//
//

#import "LCTimesView.h"
#import "LTools.h"

@interface LCTimesView () <UITextFieldDelegate,LCNumKeyboardDelegate>

@property (retain, nonatomic) UIButton *minusButton;
@property (retain, nonatomic) UIButton *plusButton;
@property (retain, nonatomic) LCNumKeyboard *numKeyboard;

@property (assign, nonatomic) NSInteger times;
@property (retain, nonatomic) NSTimer *amountTimer;
@property (assign, nonatomic) BOOL plusPressed;
@property (assign, nonatomic) int step;

@property (retain, nonatomic) NSString *enabledMinusImage;
@property (retain, nonatomic) NSString *disabledMinusImage;

@property (retain, nonatomic) NSString *enabledPlusImage;
@property (retain, nonatomic) NSString *disabledPlusImage;

@property (retain, nonatomic) UIColor *editColor;
@property (retain, nonatomic) UIColor *normalColor;

@end

@implementation LCTimesView
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)dealloc
{
    if ([self.amountTimer isValid]) {
        [self.amountTimer invalidate];
    }
    self.minusButton = nil;
    self.plusButton = nil;
    self.timesField = nil;
    self.amountTimer = nil;
    self.numKeyboard = nil;
    self.enabledMinusImage = nil;
    self.disabledMinusImage = nil;
    self.enabledPlusImage = nil;
    self.disabledPlusImage = nil;
    self.editColor = nil;
    self.normalColor = nil;
    [super dealloc];
}

#pragma mark - actions
- (void)minusClicked:(id)sender
{
    [self changeTimes:1 isPlus:NO];
}

- (void)plusClicked:(id)sender
{
    [self changeTimes:1 isPlus:YES];
}

- (void)plusLongPressed:(UILongPressGestureRecognizer *)longGesture
{
    [self processLongPress:longGesture isPlus:YES];
}

- (void)minusLongPressed:(UILongPressGestureRecognizer *)longGesture
{
    [self processLongPress:longGesture isPlus:NO];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    if (self.timesFiledCanEdit) {
        [self.timesField becomeFirstResponder];
    }
}

#pragma mark - private
- (void)initUI
{
    _maxTimes = 999;
    _minTimes = 1;
    _inEditing = NO;
    _shouldAddTimesSuffix = NO;
    
    self.normalColor = [LTools colorWithHexString:@"9296a3"];
    self.editColor = [LTools colorWithHexString:@"333333"];
    self.times = 1;
    self.shouldAddTimesSuffix = NO;
    self.timesFiledCanEdit = YES;
    
    self.layer.cornerRadius = 4.f;
    self.layer.borderWidth = 1;
    self.layer.borderColor = K_COLOR_MAIN_ORANGER.CGColor;
    self.clipsToBounds = YES;
    
    self.timesField = [[[LCTextField alloc] initWithFrame:CGRectZero] autorelease];
    self.timesField.hidden = NO;
    self.timesField.delegate = self;
    [self addSubview:self.timesField];
    
    self.numKeyboard = [LCNumKeyboard numKeyboardWithTextField:self.timesField maxValue:self.maxTimes deleagte:nil];
    self.numKeyboard.mDelegate = self;
    
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.plusButton setImage:[UIImage imageNamed:@"btn_shoppingCart_plus.png"] forState:UIControlStateNormal];
    [self.plusButton setAdjustsImageWhenHighlighted:NO];
    [self.plusButton setTitleColor:[[XMThemeManager sharedThemeManager] getAppThemeColor] forState:UIControlStateNormal];
    [self.plusButton addTarget:self action:@selector(plusClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.plusButton];
    
    UILongPressGestureRecognizer *plusLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(plusLongPressed:)];
    [self.plusButton addGestureRecognizer:plusLongPress];
    [plusLongPress release];
    
    self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.minusButton setImage:[UIImage imageNamed:@"btn_shoppingCart_minus.png"] forState:UIControlStateNormal];
    [self.minusButton setAdjustsImageWhenHighlighted:NO];
    [self.minusButton setTitleColor:[[XMThemeManager sharedThemeManager] getAppThemeColor] forState:UIControlStateNormal];
    [self.minusButton addTarget:self action:@selector(minusClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.minusButton];
    UILongPressGestureRecognizer *minusLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(minusLongPressed:)];
    [self.minusButton addGestureRecognizer:minusLongPress];
    [minusLongPress release];
    
    _timesField.borderStyle = UITextBorderStyleNone;
    _timesField.layer.borderWidth = 0.5f;
    _timesField.clipsToBounds = YES;
    _timesField.textAlignment = NSTextAlignmentCenter;
    _timesField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _timesField.backgroundColor = [UIColor clearColor];
    _timesField.font = K_FONT_SIZE(15);
    
    self.enabledPlusImage = @"main_plus";
    self.disabledPlusImage = @"main_plus_disabled";
    self.enabledMinusImage = @"main_minus";
    self.disabledMinusImage = @"main_minus_disabled";
    [self configureTimesUI];
    [self setBorderColor:[LTools colorWithHexString:@"dbdbdb"]];
    [self configureLabelStatus];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize viewSize = self.bounds.size;
    self.minusButton.frame = CGRectMake(0, 0, viewSize.height, viewSize.height);
    self.plusButton.frame = CGRectMake(viewSize.width - viewSize.height, -1, viewSize.height, viewSize.height);
    self.timesField.frame = CGRectMake(viewSize.height, -1, viewSize.width - 2 * viewSize.height, viewSize.height);
}

- (void)changeTimes:(int)changeAmount isPlus:(BOOL)isPlus
{
    NSInteger theTimes = 0;
    if (isPlus) {
        theTimes = self.times + changeAmount;
    } else {
        theTimes = self.times - changeAmount;
    }
    if (theTimes > self.maxTimes || theTimes < self.minTimes) {
        return;
    }
    [self changeTimesWithActionSend:(int)theTimes];
}

- (void)changeTimesWithActionSend:(int)theTimes
{
    NSInteger oldTimes = self.times;
    self.times = theTimes;
    [self checkTimesValues];
    [self configureTimesUI];
    if ([self.delegate respondsToSelector:@selector(timesChangedWhenMaxTimeCallBack:)]) {
        [self.delegate timesChangedWhenMaxTimeCallBack:self];
    } else {
        if (oldTimes != _times && [self.delegate respondsToSelector:@selector(timesChanged:)]) {
            [self.delegate timesChanged:self];
        }
    }
}

- (void)processLongPress:(UILongPressGestureRecognizer *)longGesture isPlus:(BOOL)isPlus
{
    self.plusPressed = isPlus;
    
    UIGestureRecognizerState state = longGesture.state;
    if (state == UIGestureRecognizerStateBegan) {
        [self setupTimer];
    } else if (state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateEnded) {
        [self.amountTimer invalidate];
        self.amountTimer = nil;
    }
}

- (void)checkTimesValues
{
    if (self.times > _maxTimes) {
        self.times = _maxTimes;
    } else if (self.times < _minTimes) {
        self.times = _minTimes;
    }
}

- (void)setupTimer
{
    self.step = 0;
    self.amountTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(processTimer:) userInfo:nil repeats:YES];
}

- (void)processTimer:(NSTimer *)aTimer
{
    int amount = 1;
    
    if (self.step > 20) {
        amount = 50;
    } else if (self.step > 10) {
        amount = 10;
    } else if (self.step > 5) {
        amount = 5;
    }
    
    self.step = self.step + 1;
    
    [self changeTimes:amount isPlus:self.plusPressed];
}

- (void)configureTimesUI
{
    if (self.shouldAddTimesSuffix) {
        self.timesField.text = [NSString stringWithFormat:@"%ld倍", (long)self.times];
    } else {
        self.timesField.text = [NSString stringWithFormat:@"%ld", (long)self.times];
    }
    
    [self configureButtonImages];
}

- (void)setInEditing:(BOOL)inEditing
{
    if (_inEditing != inEditing) {
        _inEditing = inEditing;
        [self configureLabelStatus];
    }
}

- (void)configureLabelStatus
{
    if (_inEditing) {
        self.timesField.textColor = self.editColor;
    } else {
        self.timesField.textColor = self.normalColor;
    }
}

#pragma mark - public
- (void)setEnabledMinusImage:(NSString *)enabledMinusImageName
          disabledMinusImage:(NSString *)disabledMinusImageName
            enabeldPlusImage:(NSString *)enabledPlusImageName
           disabledPlusImage:(NSString *)disabledPlusImageName
{
    self.enabledMinusImage = enabledMinusImageName;
    self.disabledMinusImage = disabledMinusImageName;
    self.enabledPlusImage = enabledPlusImageName;
    self.disabledPlusImage = disabledPlusImageName;
    [self configureButtonImages];
}

- (void)setEditColor:(UIColor *)editColor normalColor:(UIColor *)nomralColor
{
    self.editColor = editColor;
    self.normalColor = normal;
    [self configureLabelStatus];
}

- (void)configureButtonImages
{
    if (self.times > self.minTimes) {
        UIImage *minusEnabelImage = [UIImage imageNamed:self.enabledMinusImage];
        [self.minusButton setBackgroundImage:minusEnabelImage forState:UIControlStateNormal];
        [self.minusButton setBackgroundImage:minusEnabelImage forState:UIControlStateHighlighted];
    } else {
        UIImage *minusDisabledImage = [UIImage imageNamed:self.disabledMinusImage];
        [self.minusButton setBackgroundImage:minusDisabledImage forState:UIControlStateNormal];
        [self.minusButton setBackgroundImage:minusDisabledImage forState:UIControlStateHighlighted];
    }
    
    if (self.times < self.maxTimes) {
        UIImage *plusEnabledImage = [UIImage imageNamed:self.enabledPlusImage];
        [self.plusButton setBackgroundImage:plusEnabledImage forState:UIControlStateHighlighted];
        [self.plusButton setBackgroundImage:plusEnabledImage forState:UIControlStateNormal];
    } else {
        UIImage *plusDisabledImage = [UIImage imageNamed:self.disabledPlusImage];
        [self.plusButton setBackgroundImage:plusDisabledImage forState:UIControlStateHighlighted];
        [self.plusButton setBackgroundImage:plusDisabledImage forState:UIControlStateNormal];
    }
}

- (void)setMaxTimes:(NSInteger)maxTimes
{
    if (_maxTimes != maxTimes) {
        _maxTimes = maxTimes;
        [self.numKeyboard changeMaxValue:_maxTimes];
        [self checkTimesValues];
        [self configureTimesUI];
    }
}

- (void)setMinTimes:(NSInteger)minTimes
{
    if (_minTimes != minTimes) {
        _minTimes = minTimes;
        [self checkTimesValues];
        [self configureTimesUI];
    }
}

- (void)setShouldAddTimesSuffix:(BOOL)shouldAddTimesSuffix
{
    if (_shouldAddTimesSuffix != shouldAddTimesSuffix) {
        _shouldAddTimesSuffix = shouldAddTimesSuffix;
        if (_shouldAddTimesSuffix) {
            self.timesFiledCanEdit = NO;
        }
        [self configureTimesUI];
    }
}

- (void)setTimesFiledCanEdit:(BOOL)timesFiledCanEdit
{
    if (_timesFiledCanEdit != timesFiledCanEdit) {
        _timesFiledCanEdit = timesFiledCanEdit;
        self.timesField.userInteractionEnabled = timesFiledCanEdit;
    }
}

- (void)setDisplayTimes:(NSInteger)times
{
    self.times = times;
    [self checkTimesValues];
    self.timesField.text = [NSString stringWithFormat:@"%ld", (long)_times];
    [self configureTimesUI];
    if ([self.delegate respondsToSelector:@selector(timesChangedWhenMaxTimeCallBack:)]) {
        [self.delegate timesChangedWhenMaxTimeCallBack:self];
    } else if ([self.delegate respondsToSelector:@selector(timesChanged:)]){
        [self.delegate timesChanged:self];
    }
}

- (void)setDisplayTimesNoNeedCallBack:(NSInteger)times {
    self.times = times;
    [self checkTimesValues];
    self.timesField.text = [NSString stringWithFormat:@"%ld", times];
    [self configureTimesUI];
}

- (void)setBorderColor:(UIColor *)borderColor
{
//    self.layer.borderColor = borderColor.CGColor;
    self.timesField.layer.borderColor = borderColor.CGColor;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self changeTimesWithActionSend:[string intValue]];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.inEditing = YES;
    if ([self.delegate respondsToSelector:@selector(textLCTimesViewTextFieldDidBeginEditing:)]) {
        [self.delegate performSelector:@selector(textLCTimesViewTextFieldDidBeginEditing:) withObject:_timesField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.inEditing = NO;
    if ([textField.text intValue] < _minTimes) {
        if ([self.delegate respondsToSelector:@selector(timesLessThanMinWhenKeyboardHide:)]) {
            [self.delegate timesLessThanMinWhenKeyboardHide:self];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(textLCTimesViewTextFieldDidEndEditing:)]) {
        [self.delegate performSelector:@selector(textLCTimesViewTextFieldDidEndEditing:) withObject:_timesField];
    } else {
        [self changeTimesWithActionSend:[textField.text intValue]];
    }
    
    if ([self.delegate respondsToSelector:@selector(textFieldEditFinish:)]) {
        [self.delegate textFieldEditFinish:self];
    }
}

- (void)hideKeyboard {
    [self.numKeyboard doneButtonClicked];
}

#pragma mark--
#pragma mark LCNumKeyboard Delegate
- (void)numKeyBoardDonePressed {
    if ([self.delegate respondsToSelector:@selector(textFieldDonePressed:)]) {
        [self.delegate textFieldDonePressed:self];
    }
}

@end
