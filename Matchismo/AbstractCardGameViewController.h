//
//  AbstractCardGameViewController.h
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGame.h"
@interface AbstractCardGameViewController : UIViewController
@property (strong, nonatomic) CardGame *game;
- (void) updateUI;
@end
