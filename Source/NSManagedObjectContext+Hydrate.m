//
//  NSManagedObjectContext+Hydrate.m
//
//  Created by Ignacio Romero Zurbuchen on 7/9/13.
//  Copyright (c) 2013 DZN Labs.
//  Licence: MIT-Licence
//

#import "NSManagedObjectContext+Hydrate.h"

static NSManagedObjectContext *_sharedContext = nil;


@implementation NSManagedObjectContext (Hydrate)

#pragma mark - Shared NSManagedObjectContext

+ (NSManagedObjectContext *)sharedContext
{
    return _sharedContext;
}

+ (void)setSharedContext:(NSManagedObjectContext *)context
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContext = context;
    });
}


#pragma mark - Hydrate from JSON data

- (void)hydrateStoreWithJSONAtPath:(NSString *)path forEntityName:(NSString *)entityName
{
    [self hydrateStoreWithJSONAtPath:path attributeMappings:nil forEntityName:entityName];
}

- (void)hydrateStoreWithJSONAtPath:(NSString *)path attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName
{
    // Checks if there isn't already an entity table filled with content
    if (!path || ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"Sorry, the file at path %@ doesn't seem the exist.",path);
        return;
    }
    
    NSError *error = nil;
    
    // Serializes the JSON data structure into arrays and collections
    NSArray *objects = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                                       options:kNilOptions
                                                         error:&error];
    
    if (!error) {
        [self hydrateStoreWithObjects:objects attributeMappings:attributes forEntityName:entityName];
    }
    else {
        NSLog(@"%s error : %@",__FUNCTION__, error.localizedDescription);
    }
}


#pragma mark - Hydrate from native objects

- (void)hydrateStoreWithObjects:(NSArray *)objects forEntityName:(NSString *)entityName
{
    [self hydrateStoreWithObjects:objects attributeMappings:nil forEntityName:entityName];
}

- (void)hydrateStoreWithObjects:(NSArray *)objects attributeMappings:(NSDictionary *)attributes forEntityName:(NSString *)entityName
{
    // Checks if there isn't already an entity table filled with content
    if (![self isEmptyStoreForEntityName:entityName] || objects.count == 0) {
        return;
    }
    
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // First we insert a new object to the managed object context
        NSObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        
        // Then we retrieve all the entity's attributes, to specially be aware about its properties name
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
        
        for (NSAttributeDescription *attributeDescription in entityDescription.properties) {
            
            NSString *sourceKey = attributes ? [attributes objectForKey:attributeDescription.name] : attributeDescription.name;
            id value = [obj objectForKey:sourceKey];
            
            NSLog(@"source key : %@     matching    attribute name : %@",sourceKey, attributeDescription.name);
            
            // We set the value from the parsed collection, to the entity's attribute name.
            // It is important that the both, the JSON key and the property name match.
            // An exception will be raised in case that a key doesn't match to its property.
            [newObject setValue:value forKey:attributeDescription.name];
        }
        
        NSError *error = nil;
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
    NSLog(@"Successfully preloaded content into the SQLite's %@ table at URL : %@",entityName,[store.URL absoluteString]);
}


#pragma mark - Testing and validation methods

- (NSArray *)testByFetchingEntity:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        return fetchedObjects;
    }
    else {
        NSLog(@"%s ERROR : %@",__FUNCTION__, [error localizedDescription]);
        return nil;
    }
}

- (BOOL)isEmptyStoreForEntityName:(NSString *)entityName
{
    NSArray *fetchedObjects = [self testByFetchingEntity:entityName];
    return (fetchedObjects.count == 0) ? YES : NO;
}

@end
