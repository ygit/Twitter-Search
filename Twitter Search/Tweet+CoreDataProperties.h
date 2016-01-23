//
//  Tweet+CoreDataProperties.h
//  Twitter Search
//
//  Created by yogesh singh on 23/01/16.
//  Copyright © 2016 yogesh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *date;

@end

NS_ASSUME_NONNULL_END
