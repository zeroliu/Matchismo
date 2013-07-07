//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "CardGame.h"
#import "SetCard.h"

@interface AbstractCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) NSUInteger flipCount;
@end

@implementation SetGameViewController
@synthesize game = _game;

#pragma mark - setter and getter
- (CardGame *) game
{
    if (!_game) _game = [[CardGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[SetCardDeck alloc] init]
                                                cardsToMatch:3];
    return _game;
}

#pragma mark - private methods
- (NSAttributedString *) getAttributedStringFromCard:(SetCard *)card
{
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:card.contents];
    
    //Set center
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init]; 
//    [style setAlignment:NSTextAlignmentCenter];
    
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
    [attributedTitle setAttributes:
     @{
//     NSParagraphStyleAttributeName:style,
    NSForegroundColorAttributeName:fillingColor,
        NSStrokeColorAttributeName:strokeColor,
        NSStrokeWidthAttributeName:@-5
     }
                             range:NSMakeRange(0, [[attributedTitle string] length])];
    
    return attributedTitle;
}

- (NSAttributedString *)getAttributedStringFromCards:(NSArray *)cards
{
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < cards.count; i++) {
        [attributedTitle appendAttributedString:[self getAttributedStringFromCard: cards[i]]];
        if (i < cards.count-1) [attributedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" & "]];
    }
    return attributedTitle;
}

#pragma mark - override methods
- (void) updateUI
{
    [super updateUI];
    
    for (UIButton *cardButton in self.cardButtons)
    {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        
        [cardButton setAttributedTitle:[self getAttributedStringFromCard:card] forState:UIControlStateNormal];
        
        cardButton.backgroundColor = card.isFaceUp ? [UIColor lightGrayColor] : [UIColor whiteColor];
        cardButton.hidden = card.isUnplayable;
    }
}

- (void) updateStatus
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if ([self.game.cardsFlipped count])
    {
        //No match happened
        if ([self.game.cardsFlipped count] < self.game.cardsToMatch)
        {
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Selected "]];
            [attributedString appendAttributedString:[self getAttributedStringFromCard:[self.game.cardsFlipped lastObject]]];
    //        self.statusLabel.attributedText
    //        [[NSAttributedString alloc ]:@"Selected %@", [self getAttributedStringFromCard:[self.game.cardsFlipped lastObject]]];
        }
        else
        {
            if (self.game.scoreChanged > 0)
            {
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
                [attributedString appendAttributedString:[self getAttributedStringFromCards:self.game.cardsFlipped]];
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", self.game.scoreChanged]]];
            }
            else
            {
                [attributedString appendAttributedString:[self getAttributedStringFromCards:self.game.cardsFlipped]];
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d points penalty", self.game.scoreChanged]]];
            }
        }
    }
    self.statusLabel.attributedText = attributedString;
}
@end
