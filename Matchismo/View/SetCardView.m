//
//  SetCardView.m
//  SuperSetCard
//
//  Created by Xiyuan Liu on 7/21/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#define CORNER_RADIUS_WIDTH_SCALE_FACTOR 0.2
#define PATH_LINE_WIDTH 2.0
#define SYMBOL_HEIGHT_SCALE_FACTOR 0.2
#define SYMBOL_WIDTH_SCALE_FACTOR 0.7
#define SYMBOL_HEIGHT_OFFSET_LARGE 0.25
#define SYMBOL_HEIGHT_OFFSET_SMALL 0.15
#define STRIP_STEP 3

#pragma mark - Setter and getter
- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width * CORNER_RADIUS_WIDTH_SCALE_FACTOR];
    [roundedRect addClip];
    
    if (self.faceUp)
    {
        [[UIColor lightGrayColor] setFill];
    }
    else
    {
        [[UIColor whiteColor] setFill];
    }
    [roundedRect fill];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = PATH_LINE_WIDTH;
    
    [self drawSymbolsWithPath:path];
    
    if (path != nil)
    {
        UIColor *color = [self colorFromID:self.color];
        
        if (self.shading == SHADING_SOLID)
        {
            [color setFill];
            [path fill];
        }
        [color setStroke];
        [path stroke];
    }
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

- (UIColor *)colorFromID:(NSUInteger)colorID
{
    UIColor *color = nil;
    switch (colorID)
    {
        case COLOR_GREEN:
            color = [UIColor greenColor];
            break;
            
        case COLOR_PURPLE:
            color = [UIColor purpleColor];
            break;
            
        case COLOR_RED:
            color = [UIColor redColor];
            break;
            
        default:
            break;
    }
    
    return color;
}

- (void)drawSymbolsWithPath:(UIBezierPath *)path
{
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    
    if (self.number == 1 || self.number == 3)
    {
        [self drawSymbolWithPath:path atPosition:center];
    }
    if (self.number == 2)
    {
        [self drawSymbolWithPath:path atPosition:CGPointMake(center.x, center.y+self.bounds.size.height * SYMBOL_HEIGHT_OFFSET_SMALL)];
        [self drawSymbolWithPath:path atPosition:CGPointMake(center.x, center.y-self.bounds.size.height * SYMBOL_HEIGHT_OFFSET_SMALL)];
    }
    if (self.number == 3)
    {
        [self drawSymbolWithPath:path atPosition:CGPointMake(center.x, center.y+self.bounds.size.height * SYMBOL_HEIGHT_OFFSET_LARGE)];
        [self drawSymbolWithPath:path atPosition:CGPointMake(center.x, center.y-self.bounds.size.height * SYMBOL_HEIGHT_OFFSET_LARGE)];
    }
    
    if (self.shading == SHADING_STRIPED)
    {
        [self drawStripedShadingWithPath:path];
    }
}

- (void)drawSymbolWithPath:(UIBezierPath *)path atPosition:(CGPoint)position
{
    CGSize size = CGSizeMake(self.bounds.size.width*SYMBOL_WIDTH_SCALE_FACTOR, self.bounds.size.height*SYMBOL_HEIGHT_SCALE_FACTOR);
    switch (self.symbol)
    {
        case SYMBOL_DIAMOND:
            [self drawDiamondWithPath:path atPosition:position size:size];
            break;
        case SYMBOL_OVAL:
            [self drawOvalWithPath:path atPosition:position size:size];
            break;
        case SYMBOL_SQUIGGLE:
            [self drawSquiggleWithPath:path atPosition:position size:size];
        default:
            break;
    }
}

- (void)drawStripedShadingWithPath:(UIBezierPath *)path
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [path addClip];
    
    UIBezierPath *stripPath = [[UIBezierPath alloc] init];
    stripPath.lineWidth = PATH_LINE_WIDTH * 0.75;
    for (int i=0; i < self.bounds.size.height; i+=STRIP_STEP)
    {
        [stripPath moveToPoint:CGPointMake(0, i)];
        [stripPath addLineToPoint:CGPointMake(self.bounds.size.width, i)];
        [stripPath closePath];
    }
    
    UIColor *color = [self colorFromID:self.color];
    [color setStroke];
    [stripPath stroke];
    
    CGContextRestoreGState(context);
}

- (void)drawDiamondWithPath:(UIBezierPath *)path atPosition:(CGPoint)position size:(CGSize)size
{
    [path moveToPoint:CGPointMake(position.x, position.y + size.height/2.0)];
    [path addLineToPoint:CGPointMake(position.x + size.width/2.0, position.y)];
    [path addLineToPoint:CGPointMake(position.x, position.y - size.height/2.0)];
    [path addLineToPoint:CGPointMake(position.x - size.width/2.0, position.y)];
    [path closePath];
}

- (void)drawOvalWithPath:(UIBezierPath *)path atPosition:(CGPoint)position size:(CGSize)size
{
    [path moveToPoint:CGPointMake(position.x+size.width*0.5-size.height*0.5, position.y+size.height*0.5)];
    [path addArcWithCenter:CGPointMake(position.x+size.width*0.5-size.height*0.5, position.y) radius:size.height*0.5 startAngle:M_PI*0.5 endAngle:M_PI*1.5 clockwise:NO];
    [path addLineToPoint:CGPointMake(position.x-size.width*0.5+size.height*0.5, position.y-size.height*0.5)];
    [path addArcWithCenter:CGPointMake(position.x-size.width*0.5+size.height*0.5, position.y) radius:size.height*0.5 startAngle:M_PI*1.5 endAngle:M_PI*0.5 clockwise:NO];
    [path closePath];
}

- (void)drawSquiggleWithPath:(UIBezierPath *)path atPosition:(CGPoint)position size:(CGSize)size
{
    [path moveToPoint:CGPointMake(position.x+size.width*0.3, position.y-size.height*0.5)];
    [path addCurveToPoint:CGPointMake(position.x-size.width*0.1, position.y+size.height*0.3) controlPoint1:CGPointMake(position.x+size.width*0.5, position.y-size.height*0.2) controlPoint2:CGPointMake(position.x+size.width*0.3, position.y+size.height*0.5)];
    [path addCurveToPoint:CGPointMake(position.x-size.width*0.3, position.y+size.height*0.5) controlPoint1:CGPointMake(position.x-size.width*0.2, position.y+size.height*0.2) controlPoint2:CGPointMake(position.x-size.width*0.25, position.y+size.height*0.3)];
    [path addCurveToPoint:CGPointMake(position.x+size.width*0.1, position.y-size.height*0.3) controlPoint1:CGPointMake(position.x-size.width*0.5, position.y+size.height*0.2) controlPoint2:CGPointMake(position.x-size.width*0.3, position.y-size.height*0.5)];
    [path addCurveToPoint:CGPointMake(position.x+size.width*0.3, position.y-size.height*0.5) controlPoint1:CGPointMake(position.x+size.width*0.2, position.y-size.height*0.2) controlPoint2:CGPointMake(position.x+size.width*0.25, position.y-size.height*0.3)];
    [path closePath];
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
