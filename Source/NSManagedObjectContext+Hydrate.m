//
//  NSManagedObjectContext+Hydrate.m
//
//  Created by Ignacio Romero Zurbuchen on 7/9/13.
//  Copyright (c) 2013 DZN Labs.
//  Licence: MIT-Licence
//

#import "NSManagedObjectContext+Hydrate.h"

@implementation NSManagedObjectContext (Hydrate)

- (void)hydrateStoreWithJSONAtPath:(NSString *)path forEntityName:(NSString *)entityName
{
    // Checks if there isn't already an entity table filled with content
    if ([self isEmptyStoreForEntityName:entityName]) {
        NSError *error = nil;
        
        // Serializes the JSON data structure into arrays and collections
        NSArray *objects = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                                           options:kNilOptions
                                                             error:&error];
        
        // Hydratates the entity table with the serialized objects from the JSON
        if (objects.count > 0) {
            [self populateEntity:entityName withArray:objects];
        }
    }
}

- (void)populateEntity:(NSString *)entityName withArray:(NSArray *)array
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // First we insert a new object to the managed object context
        NSObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        
        // Then we retrieve all the entity's attributes, to specially be aware about its properties name
        NSEntityDescription *attributes = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
        for (NSAttributeDescription *description in attributes.properties) {
            id value = [obj objectForKey:description.name];
            
            // We set the value from the parsed collection, to the entity's attribute name.
            // It is important that the both, the JSON key and the property name match.
            // Use camel case property names for both. An exception will be raised in case that a key doesn't match to its property.
            [newObject setValue:value forKey:description.name];
        }
        
        NSError *error;
        if (![self save:&error]) {
            NSLog(@"%s Houston we got a problem: %@", __FUNCTION__, [error localizedDescription]);
        }
    }];
    
    
    // Test by fetching all the saved entities.
    NSArray *fetchedObjects = [self testByFetchingEntity:entityName];
    
    [fetchedObjects enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"object: %@", obj.description);
    }];

    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores objectAtIndex:0];
    NSLog(@"Successfully preloaded your content into the SQLite store at URL : %@",[store.URL absoluteString]);
}

- (NSArray *)testByFetchingEntity:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%s ERROR : %@",__FUNCTION__, [error localizedDescription]);
    }
    
    return fetchedObjects;
}

- (BOOL)isEmptyStoreForEntityName:(NSString *)entityName
{
    NSArray *fetchedObjects = [self testByFetchingEntity:entityName];
    return (fetchedObjects.count == 0) ? YES : NO;
}

@end
