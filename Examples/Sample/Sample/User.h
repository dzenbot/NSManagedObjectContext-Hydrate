//
//  User.h
//  Sample
//
//  Created by Ignacio on 7/13/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSDecimalNumber * height;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDecimalNumber * weight;
@property (nonatomic, retain) NSString * lastName;

@end
