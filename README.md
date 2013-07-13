NSManagedObjectContext-Hydrate
==============================

Have you ever wanted to preload an application's CoreData store?
If you did, you must know then that it's a real pain and undocumented process. You probably tried different technics like writing a python or bash script, but it should be easier than that!
This category class intends to preload and parse automagically an object and save it into a persistent store with no effort.

### Step 1
```
Import "NSManagedObjectContext+Hydrate.h" to your Application Delegate class.
```

### Step 2
```
Import Apple's CoreData framework.
```

### Step 3
After initialising your Managed Object Context, you are ready to preload your JSON content into the store.
Call the following method:
```
NSString *path = [[NSBundle mainBundle] pathForResource:@"Persons" ofType:@"json"];
[_managedObjectContext hydrateStoreWithJSONAtPath:path forEntityName:@"Person"];
```

### Sample project
Take a look into the sample project. Everything is there.
Enjoy and collaborate if you feel this library could be even better. (Check the to-do list)

## To-Do's
- Multiple-hydrations at a time (Gran Central Dispatch or NSOperationQueue)
- Key-value mapping � la RESTKit (by assigning a collection of object keys matching the JSON keys)
- CSV importing


## License
(The MIT License)

Copyright (c) 2012 Ignacio Romero Zurbuchen <iromero@dzen.cl>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
