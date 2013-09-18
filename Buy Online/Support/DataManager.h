// DataManager.h
#define DOCUMENT_DIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define UNIQUE_STRING (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault))

#define IS_IPHONE ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
#define IS_IPHONE_RETINA ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] scale] == 2.00 )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPAD ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
#define IS_IPAD_RETINA ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && [[UIScreen mainScreen] scale] == 2.00 )

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const DataManagerDidSaveNotification;
extern NSString * const DataManagerDidSaveFailedNotification;

@interface DataManager : NSObject {
}

@property (nonatomic, readonly, strong) NSManagedObjectModel *objectModel;
@property (nonatomic, readonly, strong) NSManagedObjectContext *mainObjectContext;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DataManager*)sharedInstance;
- (BOOL)save;
//- (NSManagedObjectContext*)managedObjectContext;
- (void)saveContext;
- (NSArray *) fetRecordsOfEntity : (NSString *)entityName withSortDescriptors: (NSArray *) sortDescriptors;
- (NSArray *)saveImageToDocument:(NSArray *)imageArray;
@end
