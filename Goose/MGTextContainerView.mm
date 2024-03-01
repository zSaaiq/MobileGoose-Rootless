#import "MGTextContainerView.h"

@implementation MGTextContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        if (!_textLabel) return nil;

        _textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _textLabel.numberOfLines = 0;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.minimumScaleFactor = 0.1;

        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _textLabel.frame = CGRectMake(
        3.0,
        3.0,
        self.contentView.frame.size.width - 6.0,
        self.contentView.frame.size.height - 6.0
    );
}

@end
