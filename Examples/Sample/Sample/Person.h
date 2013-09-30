//
//  Person.h
//  Sample
//
//  Created by Ignacio Romero Zurbuchen on 9/29/13.
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

@end
