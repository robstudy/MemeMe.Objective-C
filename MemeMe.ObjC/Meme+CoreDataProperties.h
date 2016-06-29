//
//  Meme+CoreDataProperties.h
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/28/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Meme.h"

NS_ASSUME_NONNULL_BEGIN

@interface Meme (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bottomText;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSData *imageWithText;
@property (nullable, nonatomic, retain) NSString *topText;

@end

NS_ASSUME_NONNULL_END
