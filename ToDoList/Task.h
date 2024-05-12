//
//  Task.h
//  ToDoList
//
//  Created by JETSMobileLabMini10 on 17/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject<NSCopying>
@property NSString * name;
@property NSString *desc;
@property NSInteger priority;
@property NSInteger state;
@property NSDate *date;
@property NSString *strImg;
@end

NS_ASSUME_NONNULL_END
