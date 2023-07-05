//
//  AppDelegate.h
//  LCProgessView
//
//  Created by 陆兴凯 on 2023/7/5.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

