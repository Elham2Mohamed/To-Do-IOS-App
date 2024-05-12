//
//  DetailsViewController.h
//  ToDoList
//
//  Created by JETSMobileLabMini10 on 17/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property Task *task;
@property int type;
@property int index;

@end

NS_ASSUME_NONNULL_END
