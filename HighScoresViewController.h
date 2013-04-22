//
//  HighScoresViewController.h
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/19/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tvHighScores;
@property (weak, nonatomic) IBOutlet UIButton *lblBackButton;

- (IBAction)btnBack:(UIButton *)sender;

@end