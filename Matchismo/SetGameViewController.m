//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "CardSetGame.h"
#import "SetCard.h"

@interface AbstractCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@end

@implementation SetGameViewController
@synthesize game = _game;

#pragma mark - setter and getter
- (CardGame *) game
{
    if (!_game) _game = [[CardSetGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[SetCardDeck alloc] init]];
    return _game;
}

#pragma mark - event handler

#pragma mark - override method
- (void) updateUI
{
    [super updateUI];
    
    for (UIButton *cardButton in self.cardButtons)
    {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:card.contents];
        
        //Set center
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setAlignment:NSTextAlignmentCenter];
        
        //Set color
        UIColor *strokeColor = [UIColor blackColor]; //black color by default
        if ([card.color isEqualToString:@"Red"])
        {
            strokeColor = [UIColor redColor];
        }
        else if ([card.color isEqualToString:@"Green"])
        {
            strokeColor = [UIColor greenColor];
        }
        else if ([card.color isEqualToString:@"Blue"])
        {
            strokeColor = [UIColor blueColor];
        }
        
        UIColor *fillingColor = [strokeColor colorWithAlphaComponent:1];
        //Set shading
        //Must be set after color
        if ([card.shading isEqualToString:@"FULL"])
        {
            fillingColor = [strokeColor colorWithAlphaComponent:1];
        }
        else if ([card.shading isEqualToString:@"HALF"])
        {
            fillingColor = [strokeColor colorWithAlphaComponent:0.1];
        }
        else if ([card.shading isEqualToString:@"EMPTY"])
        {
            fillingColor = [strokeColor colorWithAlphaComponent:0];
        }
        
        //Add attributes
        [attributedTitle addAttributes:
         @{
         NSParagraphStyleAttributeName:style,
        NSForegroundColorAttributeName:fillingColor,
            NSStrokeColorAttributeName:strokeColor,
            NSStrokeWidthAttributeName:@-5
         }
                                 range:NSMakeRange(0, [[attributedTitle string] length])];
        [cardButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        
        cardButton.backgroundColor = card.isFaceUp ? [UIColor lightGrayColor] : [UIColor whiteColor];
        cardButton.hidden = card.isUnplayable;
    }
    
    
}
@end
