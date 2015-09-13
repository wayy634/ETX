//
//  LCNumKeyboard.m
//  LeCai
//
//  Created by wanghui on 10/13/14.
//
//

#import "LCNumKeyboard.h"

@implementation LCTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

@end

@interface LCNumKeyboard ()

@property (nonatomic, assign) LCTextField *textField;
@property (nonatomic, assign) long long maxValue;
@property (nonatomic, retain) NSString *finishedText;
@property (nonatomic, retain) UIButton *doneButton;

@end

@implementation LCNumKeyboard

- (id)initWithFrame:(CGRect)frame finishedText:(NSString *)finishedText
{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishedText = finishedText;
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    [NSException raise:@"LCNumKeyboardInitException" format:@"不能使用initWithFrame:进行初始化，请使用类方法"];
    return nil;
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.finishedText = nil;
    self.doneButton = nil;
    self.mDelegate = nil;
    [super dealloc];
}

#pragma mark - private
- (void)initUI
{
    _maxValue = NSIntegerMax;
    self.backgroundColor = [UIColor colorWithRed:181.f/255.f green:185.f/255.f blue:189.f/255.f alpha:1.f];
    
    NSArray *buttonTitles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", self.finishedText, @"0"];
    
    int index = 0;
    CGRect buttonFrame = CGRectMake(0, 0, ceil(K_SCREEN_WIDTH/3), 53);
    int row = 0;
    int col = 0;
    CGFloat space = 1.0f;
    
    for (NSString *buttonTitle in buttonTitles) {
        
        row = index / 3;
        col = index % 3;
        buttonFrame.origin.x = col * (buttonFrame.size.width + space);
        buttonFrame.origin.y = row * (buttonFrame.size.height + space) + 1;
        [self addNumericKeyWithTitle:buttonTitle frame:buttonFrame isDone:(index == 9)];
        index++;
    }
    
    buttonFrame.origin.x = 2 * (buttonFrame.size.width + space);
    buttonFrame.origin.y = 3 * (buttonFrame.size.height + space) + 1;
    [self addBackspaceKeyWithFrame:buttonFrame];
}

- (UIButton *)addNumericKeyWithTitle:(NSString *)title frame:(CGRect)frame isDone:(BOOL)isDone
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:K_BOLD_FONT_SIZE(25)];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    UIImage *whiteImage = [UIImage imageNamed:@"LCNumKeyboard_White"];
    UIImage *grayImage = [UIImage imageNamed:@"LCNumKeyboard_Gray"];
    
    if (isDone) {
        [button setBackgroundImage:grayImage forState:UIControlStateNormal];
        [button setBackgroundImage:whiteImage forState:UIControlStateHighlighted];
        self.doneButton = button;
    } else {
        [button setBackgroundImage:whiteImage forState:UIControlStateNormal];
        [button setBackgroundImage:grayImage forState:UIControlStateHighlighted];
    }
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    return button;
}

- (UIButton *)addBackspaceKeyWithFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    UIImage *image = [UIImage imageNamed:@"LCNumKeyboard_Del"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - image.size.width) / 2, (frame.size.height - image.size.height) / 2, image.size.width, image.size.height)];
    imgView.image = image;
    [button addSubview:imgView];
    [imgView release];
    
    [button setBackgroundImage:[UIImage imageNamed:@"LCNumKeyboard_Gray"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"LCNumKeyboard_White"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(delButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    return button;
}

- (void)setTextField:(LCTextField *)textField
{
    _textField = textField;
    _textField.inputView = self;
}

- (void)buttonPressed:(UIButton *)aButton
{
    NSString *buttonTitle = [aButton titleForState:UIControlStateNormal];
    
    long long textValue = [self textFieldValue];
    
    if ([buttonTitle isEqualToString:self.finishedText]) {
        if ([self shouldChangeToMaxValue:textValue]) {
            self.textField.text = [NSString stringWithFormat:@"%lld", _maxValue];
        }
        [self.textField resignFirstResponder];
        
        if (self.mDelegate) {
            [self.mDelegate numKeyBoardDonePressed];
        }
    } else {
        NSString *changedText = nil;
        NSString *oldText = self.textField.text;
        
        [self.textField replaceRange:self.textField.selectedTextRange withText:[NSString stringWithFormat:@"%d", [buttonTitle intValue]]];
        
        if ([self shouldChangeToMaxValue:[self textFieldValue]]) {
            changedText = [NSString stringWithFormat:@"%lld", _maxValue];
        } else {
            changedText = self.textField.text;
        }
        
        if ([self shouldChangeText:changedText inRange:NSMakeRange(0, self.textField.text.length)]) {
            self.textField.text = changedText;
        } else {
            self.textField.text = oldText;
        }
    }
}

- (void)delButtonPressed:(UIButton *)aButton
{
    NSString *text = self.textField.text;
    
    if (text.length > 0) {
        NSString *changedText = [text substringWithRange:NSMakeRange(0, text.length - 1)];
        if ([self shouldChangeText:changedText inRange:NSMakeRange(0, self.textField.text.length)]) {
            [self.textField deleteBackward];
            self.textField.text = changedText;
        }
    }
}

- (BOOL)shouldChangeText:(NSString *)text inRange:(NSRange)range
{
    BOOL shouldChange = YES;
    if (self.textField.delegate && [self.textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        shouldChange = [self.textField.delegate textField:self.textField shouldChangeCharactersInRange:range replacementString:text];
    }
    return shouldChange;
}

- (BOOL)shouldChangeToMaxValue:(long long)maxValue
{
    if (_maxValue == NSIntegerMax || maxValue <= _maxValue) {
        return NO;
    }
    return YES;
}

- (long long)textFieldValue
{
    return [self.textField.text longLongValue];
}

- (void)setMaxValue:(long long)maxValue
{
    if (_maxValue != maxValue && maxValue > 0) {
        _maxValue = maxValue;
    }
}

#pragma mark - public
+ (LCNumKeyboard *)numKeyboardWithTextField:(LCTextField *)aTextField maxValue:(long long)maxValue deleagte:(id)delegate_
{
    return [self numKeyboardWithTextField:aTextField maxValue:maxValue finishedText:nil delegate:delegate_];
}

+ (LCNumKeyboard *)numKeyboardWithTextField:(LCTextField *)aTextField maxValue:(long long)maxValue finishedText:(NSString *)finishedText delegate:(id)deleagte_
{
    NSString *tmpFinishedText = nil;
    if (finishedText) {
        tmpFinishedText = finishedText;
    } else {
        tmpFinishedText = @"完成";
    }
    
    LCNumKeyboard *numKeyboard = [[LCNumKeyboard alloc] initWithFrame:CGRectMake(0, 0, 320.f, 215.f) finishedText:tmpFinishedText];
    numKeyboard.textField = aTextField;
    numKeyboard.maxValue = maxValue;
    if (deleagte_ != nil) {
        numKeyboard.mDelegate = deleagte_;
    }

    return [numKeyboard autorelease];
}

- (void)changeMaxValue:(long long)maxValue
{
    if (maxValue > 0 && maxValue != _maxValue) {
        long long textFiledValue = [self textFieldValue];
        if (textFiledValue > maxValue) {
            self.textField.text = [NSString stringWithFormat:@"%lld", maxValue];
        }
        self.maxValue = maxValue;
    }
}

- (void)doneButtonClicked
{
    [self buttonPressed:_doneButton];
}

@end
