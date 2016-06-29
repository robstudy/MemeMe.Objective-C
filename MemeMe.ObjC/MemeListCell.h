//
//  MemeListCell.h
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/29/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *memeImage;
@property (weak, nonatomic) IBOutlet UITextView *topText;
@property (weak, nonatomic) IBOutlet UITextView *bottomText;

@end
