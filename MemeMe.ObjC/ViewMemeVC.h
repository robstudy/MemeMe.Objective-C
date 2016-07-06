//
//  ViewMemeVC.h
//  MemeMe.ObjC
//
//  Created by Robert Garza on 7/2/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Meme.h"

@interface ViewMemeVC : UIViewController

@property (weak, nonatomic) Meme *passedMeme;

@end
