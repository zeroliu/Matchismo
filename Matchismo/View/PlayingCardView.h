//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Xiyuan Liu on 7/9/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;

@end

