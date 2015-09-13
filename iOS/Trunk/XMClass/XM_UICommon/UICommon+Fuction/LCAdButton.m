//
//  LCAdButton.m
//  LeCai
//
//  Created by HXG on 12/27/14.
//
//

#import "LCAdButton.h"
#import "UIImageView+WebCache.h"

@interface LCAdButton ()

@property (strong, nonatomic) UIImageView *adImageView;
@property (assign, nonatomic) BOOL makeImageSizeFixed;

@end

@implementation LCAdButton

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
    return [self initWithFrame:frame delegate:nil];
}

#pragma mark - private
- (void)initUI
{
    self.makeImageSizeFixed = YES;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.adImageView = imageView;
    [self addSubview:imageView];
    [imageView release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    if (self.makeImageSizeFixed) {
        self.adImageView.frame = CGRectMake(0, 0, 22, 22);
        self.adImageView.center = CGPointMake(self.width/2.f, self.height/2.f);
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    [self.delegate buttonClickedInAdButton:self];
}

- (void)dealloc
{
    self.adImageView = nil;
    [super dealloc];
}

#pragma mark - public
- (id)initWithFrame:(CGRect)frame delegate:(id<LCAdButtonDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self initUI];
    }
    return self;
}

+ (id)buttonWithFrame:(CGRect)frame delegate:(id<LCAdButtonDelegate>)delegate
{
    LCAdButton *adButton = [[LCAdButton alloc] initWithFrame:frame delegate:delegate];
    return [adButton autorelease];
}

- (void)setImage:(UIImage *)aImage
{
    [self setPlaceHolderImage:aImage remoteURL:nil];
}

- (void)setPlaceHolderImage:(UIImage *)phImage remoteURL:(NSString *)imageURL
{
    self.adImageView.image = phImage;
    [self caculateImageLayout];
    if (imageURL.length > 0) {
        __block LCAdButton *weakSelf = self;
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                            placeholderImage:phImage
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       if (image) {
                                           [weakSelf caculateImageLayout];
                                       }
                                   }];
    }
}

- (void)caculateImageLayout
{
    if (self.makeImageSizeFixed) {
    } else {
        UIImage *aImage = self.adImageView.image;
        CGSize imageSize = aImage.size;
        if (imageSize.height <= 0 || imageSize.width <= 0) {
            return;
        }
        
        CGFloat screenScale = [UIScreen mainScreen].scale;
        
        if (screenScale != aImage.scale && screenScale > 1) {
            imageSize.height = imageSize.height / screenScale;
            imageSize.width = imageSize.width / screenScale;
        }
        
        CGSize viewSize = self.bounds.size;
        CGSize resultImageSize = imageSize;
        BOOL accordingToWidth = NO;
        BOOL shouldChange = YES;
        if (imageSize.height > viewSize.height && imageSize.width > viewSize.width) {
            if (viewSize.height > viewSize.width) {
                accordingToWidth = YES;
            }
        } else if (imageSize.height > viewSize.height) {
            accordingToWidth = NO;
        } else if (imageSize.width > viewSize.width) {
            accordingToWidth = YES;
        } else {
            shouldChange = NO;
        }
        
        if (shouldChange) {
            if (accordingToWidth) {
                resultImageSize.width = viewSize.width;
                resultImageSize.height = viewSize.width * imageSize.height / imageSize.width;
            } else {
                resultImageSize.height = viewSize.height;
                resultImageSize.width = viewSize.height * imageSize.width / imageSize.height;
            }
        }
        
        self.adImageView.frame = CGRectMake(0, 0, resultImageSize.width, resultImageSize.height);
        self.adImageView.center = CGPointMake(viewSize.width/2.f, viewSize.height/2.f);
    }
}

@end
