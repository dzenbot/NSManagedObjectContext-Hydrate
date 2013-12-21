//
//  Person.h
//  Sample
//
//  Created by Ignacio on 12/21/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSDecimalNumber * height;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDecimalNumber * weight;
@property (nonatomic, retain) NSDate * birthDate;

@end
