//
//  XMAttributedLabel.m
//  XiaoMai
//
//  Created by Jeanne on 15/5/6.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "XMAttributedLabel.h"

@interface XMAttributedLabel ()
@property (nonatomic, strong)NSMutableAttributedString *mContentString;
@end

@implementation XMAttributedLabel

- (void)setXMAttributedString:(NSString *)string_ {
    if (!self.mContentString) {
        self.mContentString = [[[NSMutableAttributedString alloc] init] autorelease];
    }
    [self setText:string_];
    [self.mContentString initWithString:string_];
}

- (void)addAttributeType:(XMAttributedType)xmAttributedType_ value:(id)value_ range:(NSRange)range_ {
    NSAssert((xmAttributedType_ == XMAttributedTypeColor || xmAttributedType_ == XMAttributedTypeFont || xmAttributedType_ == XMAttributedTypeParagraph), @"type is wrong");
    NSAssert(range_.length + range_.location <= self.mContentString.length, @"the range index is out of length ");
    [self.mContentString addAttribute:(xmAttributedType_ == XMAttributedTypeColor ? NSForegroundColorAttributeName :(xmAttributedType_ == XMAttributedTypeFont ? NSFontAttributeName :NSParagraphStyleAttributeName))value:value_ range:range_];
}

- (void)addAttributeDictionary:(NSDictionary *)value_ range:(NSRange)range_  {
    NSAssert(range_.length + range_.location <= self.mContentString.length, @"the range index is out of length ");
    [self.mContentString addAttributes:value_ range:range_];
}

- (void)renderAttribute {
    self.attributedText = self.mContentString;
}

- (void)dealloc {
    [super dealloc];
}
@end
