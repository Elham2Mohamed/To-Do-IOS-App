//
//  DetailsViewController.m
//  ToDoList
//
//  Created by JETSMobileLabMini10 on 17/04/2024.
//

#import "DetailsViewController.h"
#import "Task.h"
#import "ViewController.h"
#import "UserNotifications/UserNotifications.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityItem;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateItem;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imagView;

@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property NSUserDefaults *userDefault;
@property NSMutableArray *arr;
@property  NSMutableArray *ss;
@end

@implementation DetailsViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.datePicker setMinimumDate:[NSDate date]];
    _nameTextField.text=_task.name;
    _descTextView.text=_task.desc;
    _priorityItem.selectedSegmentIndex=_task.priority;
    _stateItem.selectedSegmentIndex=_task.state;
    _datePicker.date=_task.date;
    _arr=[NSMutableArray new];
    if(_type==1){}
    
    else if(_type==2){
        [_stateItem setEnabled:NO forSegmentAtIndex:0];
    }
    else if(_type==3){
        [_nameTextField setSelectable:NO];
        [_descTextView setSelectable:NO];
        [_priorityItem setEnabled:NO];
        [_datePicker setEnabled:NO];
        [_btnDone setHidden:YES];
        [_stateItem setEnabled:NO forSegmentAtIndex:0];
        [_stateItem setEnabled:NO forSegmentAtIndex:1];
        
    }
    else{
        [_stateItem setEnabled:NO forSegmentAtIndex:1];
        [_stateItem setEnabled:NO forSegmentAtIndex:2];
    }
    if([_task.strImg isEqual:@"0"] )
        _imagView.image=[UIImage imageNamed: @"low"];
    else if ([_task.strImg isEqual:@"1"])
        _imagView.image=[UIImage imageNamed: @"medium"];
    else if ([_task.strImg isEqual:@"2"])
        _imagView.image=[UIImage imageNamed: @"high"];
    
    
    _userDefault = [NSUserDefaults standardUserDefaults];
    //_newArr   = [NSMutableArray new];
}


- (void)viewWillAppear:(BOOL)animated{
    if(_type==1){
        
        NSData *decoded = [_userDefault objectForKey:@"custom"];
        if(decoded != nil){
            _arr = [NSKeyedUnarchiver unarchiveObjectWithData:decoded];
        }
        else{
            printf("nil");
            _arr=[NSMutableArray new];
        }
        
        NSData *decoded1 = [_userDefault objectForKey:@"prog"];
        if(decoded1!= nil){
            _ss = [NSKeyedUnarchiver unarchiveObjectWithData:decoded1];
        }
        else{
            printf("nil");
            _ss=[NSMutableArray new];
        }
        
    }
    else if (_type==2){
        NSData *decoded = [_userDefault objectForKey:@"prog"];
        if(decoded != nil){
            _arr = [NSKeyedUnarchiver unarchiveObjectWithData:decoded];
        }
        else{
            printf("nil");
            _arr=[NSMutableArray new];
        }
        
        NSData *decoded1 = [_userDefault objectForKey:@"done"];
        if(decoded1!= nil){
            _ss = [NSKeyedUnarchiver unarchiveObjectWithData:decoded1];
        }
        else{
            printf("nil");
            _ss=[NSMutableArray new];
        }
        
    }
    else{
        
        NSData *decoded = [_userDefault objectForKey:@"custom"];
        if(decoded != nil){
            _arr = [NSKeyedUnarchiver unarchiveObjectWithData:decoded];
        }
        else{
            printf("nil");
            _arr=[NSMutableArray new];
        }
        
        
    }
}


- (IBAction)done:(id)sender {
    Task *t = [Task new];
    t.name = _nameTextField.text;
    t.desc=_descTextView.text;
    t.priority=_priorityItem.selectedSegmentIndex;
    t.state=_stateItem.selectedSegmentIndex;
    t.date=[_datePicker date];
    
    t.strImg=[NSString stringWithFormat:@"%ld", (long)_priorityItem.selectedSegmentIndex] ;
    
    NSLog(@"%@ image", t.strImg);
    if([t.name isEqual:@""]||[t.desc isEqual:@""])
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"You must enter a task title and description." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        printf("%lu count\n",_arr.count );
        if(_type==2){
            if(t.state==2){
                [_arr removeObject:[_arr objectAtIndex:_index]];
                [_ss addObject:t ];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_arr];
                [_userDefault setObject:data forKey:@"prog"];
                
                NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:_ss];
                [_userDefault setObject:data1 forKey:@"done"];
            }
            else{
                [_arr removeObject:[_arr objectAtIndex:_index]];
                [_arr insertObject:t atIndex:_index];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_arr];
                [_userDefault setObject:data forKey:@"prog"];
            }
        }
        else if(_type==1){
            if(t.state==1){
                [_arr removeObject:[_arr objectAtIndex:_index]];
                [_ss addObject:t ];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_arr];
                [_userDefault setObject:data forKey:@"custom"];
                
                NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:_ss];
                [_userDefault setObject:data1 forKey:@"prog"];
            }
            else if(t.state==2){
                NSData *decoded1 = [_userDefault objectForKey:@"done"];
                if(decoded1!= nil){
                    _ss = [NSKeyedUnarchiver unarchiveObjectWithData:decoded1];
                }
                else{
                    printf("nil");
                    _ss=[NSMutableArray new];
                }
                [_arr removeObject:[_arr objectAtIndex:_index]];
                [_ss addObject:t ];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_arr];
                [_userDefault setObject:data forKey:@"custom"];
                
                NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:_ss];
                [_userDefault setObject:data1 forKey:@"done"];
            }
            else{
                [_arr removeObject:[_arr objectAtIndex:_index]];
                [_arr insertObject:t atIndex:_index];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_arr];
                [_userDefault setObject:data forKey:@"custom"];
            }
        }
        
        else{
            
            [_arr addObject:t];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_arr];
            [_userDefault setObject:data forKey:@"custom"];
        }
    }
    printf("%lu count after\n",_arr.count );
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


@end
