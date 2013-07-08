//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Xiyuan Liu on 7/7/13.
//  Copyright (c) 2013 Xiyuan Liu. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"
@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) SEL sortSelector;
@end

@implementation GameResultViewController

#pragma mark - UIViewController life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - setter and getter
- (SEL)sortSelector
{
    if (!_sortSelector) _sortSelector = @selector(compareScoreToGameResult:);
    return _sortSelector;
}

#pragma mark - private methods
- (void)updateUI
{
    NSString *displayText = @"";
    
    //Format date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    for (GameResult *result in [[GameResult allGameResults] sortedArrayUsingSelector:self.sortSelector])
    {
        displayText = [displayText stringByAppendingFormat:@"%@ - Score: %d (%@, %0g)\n", result.gameName, result.score, [formatter stringFromDate:result.start], round(result.duration)];
    }
    
    self.display.text = displayText;
}

#pragma mark - action
- (IBAction)sortByScore:(id)sender
{
    self.sortSelector = @selector(compareScoreToGameResult:);
    [self updateUI];
}

- (IBAction)sortByDate:(id)sender
{
    self.sortSelector = @selector(compareEndDateToGameResult:);
    [self updateUI];
}

- (IBAction)sortByDuration:(id)sender
{
    self.sortSelector = @selector(compareDurationToGameResult:);
    [self updateUI];
}


#pragma mark - Before viewDidLoad
- (void) setup
{
    //initialization for those who can't wait until viewDidLoad
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

@end
