//
//  CoreDataController.h
//  MemeMe.ObjC
//
//  Created by Robert Garza on 6/20/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coredata/CoreData.h"

@interface CoreDataController : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;

-(void)initializeCoreData;

@end
