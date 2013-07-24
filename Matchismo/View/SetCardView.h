//
//  SetCardView.h
//  SuperSetCard
//
//  Created by Xiyuan Liu on 7/21/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYMBOL_DIAMOND 1
#define SYMBOL_SQUIGGLE 2
#define SYMBOL_OVAL 3

#define SHADING_SOLID 1
#define SHADING_STRIPED 2
#define SHADING_OPEN 3

#define COLOR_RED 1
#define COLOR_GREEN 2
#define COLOR_PURPLE 3

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;
@property (nonatomic) BOOL faceUp;

@end
