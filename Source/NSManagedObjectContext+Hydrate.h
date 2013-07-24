//
//  NSManagedObjectContext+Hydrate.m
//
//  Created by Ignacio Romero Zurbuchen on 7/9/13.
//  Copyright (c) 2013 DZN Labs.
//  Licence: MIT-Licence
//

#import <CoreData/CoreData.h>

/* A NSManagedObjectContext category class for preload a CoreData persistent store with JSON data.
 * Parsing is done automagically.
 * @warning The JSON key-values must fit the object's property names, so the serialization is made automatically.
 */
@interface NSManagedObjectContext (Hydrate)

/*
 */
+ (NSManagedObjectContext *)sharedContext;

/* 
 */
+ (void)setSharedContext:(NSManagedObjectContext *)context;

/* Preloads an entity table into the persistent store.
 * @param path The JSON file's path.
 * @param entityName The entity name to preload and parse.
 */
- (void)hydrateStoreWithJSONAtPath:(NSString *)path forEntityName:(NSString *)entityName;

/* Preloads an entity table into the persistent store.
 * @param data The JSON parsed objects.
 * @param entityName The entity name to preload and parse.
 */
- (void)hydrateStoreWithJSONObjects:(NSArray *)objects forEntityName:(NSString *)entityName;

/* Checks if there isn't already an entity table preloaded with content.
 *
 * @param entityName The entity name to check.
 * @returns YES if the store's table is empty. NO if the store is already preloaded with content.
 */
- (BOOL)isEmptyStoreForEntityName:(NSString *)entityName;


@end
