//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Xiyuan Liu on 7/9/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView ()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView
@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define CORNER_RADIUS_WIDTH_SCALE_FACTOR 0.2
#define PIP_WIDTH_SCALE_FACTOR 0.20
#define CORNER_OFFSET 2
#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.9

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width * CORNER_RADIUS_WIDTH_SCALE_FACTOR];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    if (self.faceUp)
    {
        UIImage *faceUpImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", [self rankAsString], self.suit]];
        if (faceUpImage)
        {
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0 - self.faceCardScaleFactor), self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceUpImage drawInRect:imageRect];
        }
        else
        {
            [self drawPips];
        }
        [self drawCorner];
    }
    else
    {
        UIImage *backImage = [UIImage imageNamed:@"cardback.png"];
        [backImage drawInRect:self.bounds];
    }
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

#pragma mark - Setters and Getters
- (void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

#pragma mark - Private methods
- (NSString *)rankAsString
{
    return @[@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

#pragma mark - Draw Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    if (self.rank == 1 || self.rank == 3 || self.rank == 5 || self.rank == 9)
    {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:0 mirroredVertically:NO];
    }
    if (self.rank == 6 || self.rank == 7 || self.rank == 8)
    {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:0 mirroredVertically:NO];
    }
    if (self.rank == 4 || self.rank == 5 || self.rank == 6 || self.rank == 7 || self.rank == 8 || self.rank == 9 || self.rank == 10)
    {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET3_PERCENTAGE mirroredVertically:YES];
    }
    if (self.rank == 2 || self.rank == 3)
    {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET3_PERCENTAGE mirroredVertically:YES];
    }
    if (self.rank == 7 || self.rank == 8 || self.rank == 10)
    {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET2_PERCENTAGE mirroredVertically:(self.rank != 7)];
    }
    if (self.rank == 9 || self.rank == 10)
    {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET1_PERCENTAGE mirroredVertically:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    
    //create font
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.width * PIP_WIDTH_SCALE_FACTOR];
    
    //create attributed string
    NSAttributedString *pipText = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName: font}];
    
    //draw
    CGPoint middle = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    CGSize textSize = [pipText size];
    CGPoint origin = CGPointMake(middle.x - textSize.width/2.0 - hoffset*self.bounds.size.width, middle.y - textSize.height/2.0 - voffset*self.bounds.size.height);
    [pipText drawAtPoint:origin];
    
    if (hoffset)
    {
        CGPoint originMirror = CGPointMake(origin.x+2*hoffset*self.bounds.size.width, origin.y);
        [pipText drawAtPoint:originMirror];
    }
    
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
    if (mirroredVertically)
    {
        [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
    }
}


- (void)drawCorner
{
    //create paragraph style
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    //create font
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.width * PIP_WIDTH_SCALE_FACTOR];
    
    //create attributed string
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",[self rankAsString], self.suit] attributes:
    @{
      NSParagraphStyleAttributeName:style,
      NSFontAttributeName:font
                                      }];
    
    //create text bounds
    CGRect textBounds;
    textBounds.origin = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
    textBounds.size = cornerText.size;
    
    //draw in rect
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    
    [cornerText drawInRect:textBounds];
    
    [self popContext];
}

- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Gesture action
- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
}

#pragma mark - Initialization

- (void)setup
{
    // do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}



@end
