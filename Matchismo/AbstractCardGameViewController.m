//
//  AbstractCardGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "AbstractCardGameViewController.h"
#import "CardGame.h"
#import "GameResult.h"

@interface AbstractCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) GameResult *gameResult;

@property (nonatomic) NSUInteger flipCount;
@end

@implementation AbstractCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - setter and getter
- (void) setFlipCount:(NSUInteger)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

#pragma mark - event handler
- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateStatus];
    self.flipCount ++;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

- (IBAction)deal:(UIButton *)sender
{
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
    self.statusLabel.text = @"";
    self.gameResult = nil;
}

#pragma mark - to be overridden methods
- (void) updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void) updateStatus
{
    NSString *title = @"";
    //No match happened
    if ([self.game.cardsFlipped count])
    {
        if ([self.game.cardsFlipped count] < self.game.cardsToMatch)
        {
            title = [NSString stringWithFormat:@"Flipped %@", [[self.game.cardsFlipped lastObject] description]];
        }
        else
        {
            if (self.game.scoreChanged > 0)
            {
                title = [NSString stringWithFormat:@"Matched %@ for %d points", [self.game.cardsFlipped componentsJoinedByString:@" & "], self.game.scoreChanged];
            }
            else
            {
                title = [NSString stringWithFormat:@"%@ don't match! %d points penalty", [self.game.cardsFlipped componentsJoinedByString:@" & "], self.game.scoreChanged];
            }
        }
    }
    self.statusLabel.text = title;
}

#pragma mark - special initializer
- (void)setup
{
    // Initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

@end
