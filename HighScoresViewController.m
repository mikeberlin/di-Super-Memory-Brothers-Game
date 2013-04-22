//
//  HighScoresViewController.m
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/19/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HighScoresViewController.h"
#import "HomeViewController.h"
#import "CardGame.h"

@interface HighScoresViewController ()
{
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic) NSArray *highScores;

@end

@implementation HighScoresViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.lblTitle.font = [UIFont fontWithName:@"Super Plumber Brothers" size:32];
    self.lblBackButton.titleLabel.font = [UIFont fontWithName:@"Emulogic" size:12];

    self.highScores = [CardGame LoadHighScores];
    [self.tvHighScores reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self playTitleMusic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(UIButton *)sender
{
    [self stopTitleMusic];

    HomeViewController *vcHome = [[HomeViewController alloc] init];
    [self presentViewController:vcHome animated:YES completion:Nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.highScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell = @"HighScoreCell";
    UITableViewCell *tvCell = [tableView dequeueReusableCellWithIdentifier:cell];

    if (tvCell == nil)
    {
        tvCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
    }

    NSDictionary *highScore = [self.highScores objectAtIndex:indexPath.row];
    tvCell.textLabel.text = [highScore objectForKey:@"Name"];
    tvCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f seconds", [[highScore objectForKey:@"Time"] doubleValue]];

    return tvCell;
}

#pragma mark - Private Methods

- (void)stopTitleMusic
{
    [audioPlayer stop];
}

- (void)playTitleMusic
{
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource:@"MusicBox"
                                    ofType:@"mp3"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                         error:nil];
    
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
}

@end