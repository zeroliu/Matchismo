//
//  AbstractCardGameViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/6/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "AbstractCardGameViewController.h"
#import "CardGame.h"
@interface AbstractCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (nonatomic) int flipCount;
@end

@implementation AbstractCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - setter and getter
- (void) setFlipCount:(int)flipCount
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
    self.flipCount ++;
    [self updateUI];
}

- (IBAction)deal:(UIButton *)sender
{
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}

#pragma mark - to be overridden methods
- (void) updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.statusLabel.text = self.game.status;
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
