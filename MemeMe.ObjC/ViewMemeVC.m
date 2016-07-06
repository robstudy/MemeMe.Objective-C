//
//  ViewMemeVC.m
//  MemeMe.ObjC
//
//  Created by Robert Garza on 7/2/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import "ViewMemeVC.h"
#import "MemeEditorVC.h"
#import "CoreDataController.h"

@interface ViewMemeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *memeImage;

@end

@implementation ViewMemeVC

//@synthesize passedMeme;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    _memeImage.image = [UIImage imageWithData:_passedMeme.imageWithText];
}

- (IBAction)editMeme:(id)sender {
    [self performSegueWithIdentifier:@"callMemeEditor" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]  isEqual: @"callMemeEditor"]) {
        MemeEditorVC *memeEditorVC = (MemeEditorVC *)[segue destinationViewController];
        memeEditorVC.passedMeme = self.passedMeme;
        memeEditorVC.calledFromViewMemeVC = YES;
    }
}

@end
