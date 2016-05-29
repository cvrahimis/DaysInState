//
//  Locations+CoreDataProperties.h
//  DaysInState
//
//  Created by Costas Vrahimis on 5/28/16.
//  Copyright © 2016 Costas Vrahimis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Locations.h"

NS_ASSUME_NONNULL_BEGIN

@interface Locations (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *zip;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSManagedObject *user;

@end

NS_ASSUME_NONNULL_END
