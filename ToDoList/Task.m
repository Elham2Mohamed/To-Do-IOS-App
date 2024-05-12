//
//  Task.m
//  ToDoList
//
//  Created by JETSMobileLabMini10 on 17/04/2024.
//

#import "Task.h"

@implementation Task

- (void)encodeWithCoder:(NSCoder *)coder
{
   
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_desc forKey:@"desc"];
    [coder encodeInteger:_priority forKey:@"priority"];
    [coder encodeInteger:_state forKey:@"state"];
    [coder encodeObject:_date forKey:@"date"];
    [coder encodeObject:_strImg forKey:@"img"];
    
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _name=[coder decodeObjectForKey:@"name"];
        _desc=[coder decodeObjectForKey:@"desc"];
        _priority=[coder decodeIntegerForKey:@"priority"];
        _state=[coder decodeIntegerForKey:@"state"];
        _date=[coder decodeObjectForKey:@"date"];
        _strImg=[coder decodeObjectForKey:@"img"];
    }
    return self;
}



@end
