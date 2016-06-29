//
//  Meme.m
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/20/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import "Meme.h"

@implementation Meme

// Insert code here to add functionality to your managed object subclass
-(id)initWithContext:(NSManagedObjectContext *)context memeTopText:(NSString *)tText memeBottomText:(NSString *)bText memeImage:(NSData *)image memeImageWithText:(NSData *)imageWithText{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meme" inManagedObjectContext:context];
    
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    self.topText = tText;
    self.bottomText = bText;
    self.image = image;
    self.imageWithText = imageWithText;
    
    return self;
}

@end
