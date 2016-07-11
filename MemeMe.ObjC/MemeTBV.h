//
//  MemeTBV.h
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/19/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Meme.h"

@interface MemeTBV : UITableViewController<NSFetchedResultsControllerDelegate, UINavigationControllerDelegate>

{
    Meme *memeToPass;
}

@end
