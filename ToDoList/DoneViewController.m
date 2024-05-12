//
//  DoneViewController.m
//  ToDoList
//
//  Created by JETSMobileLabMini10 on 17/04/2024.
//

#import "DoneViewController.h"
#import "Task.h"
#import "DetailsViewController.h"
@interface DoneViewController ()
@property NSUserDefaults *userDefault;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImg;
@property NSMutableArray *arr;
@property NSMutableArray *lowPriorityTasks;
@property NSMutableArray *mediumPriorityTasks;
@property NSMutableArray *highPriorityTasks;
//@property NSMutableArray *todoArr;
@property Task* task;
@property (weak, nonatomic) IBOutlet UITableView *data;
@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefault = [NSUserDefaults standardUserDefaults];
    _task = [Task new];
    printf("%lu" , _arr.count);
    _lowPriorityTasks=[NSMutableArray new];
    _mediumPriorityTasks=[NSMutableArray new];
    _highPriorityTasks=[NSMutableArray new];
    _data.delegate = self;
    _data.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.title=@"DONE";
    self.tabBarController.navigationItem.rightBarButtonItem.hidden=YES;
    NSData *decoded = [_userDefault objectForKey:@"done"];
    
    if(decoded != nil){
        _arr = [NSKeyedUnarchiver unarchiveObjectWithData:decoded];
    }
    else{
        printf("nil");
        _arr=[NSMutableArray new];
    }
   
    if(_isFiltered){
        [_lowPriorityTasks removeAllObjects];
        [_mediumPriorityTasks removeAllObjects];
        [_highPriorityTasks removeAllObjects];
       
           for (Task *task in _arr) {
               if (task.priority == 0) {
                   [_lowPriorityTasks addObject:task];
               } else if (task.priority == 1) {
                   [_mediumPriorityTasks addObject:task];
               } else if (task.priority == 2) {
                   [_highPriorityTasks addObject:task];
               }
           }
        
        [_data reloadData];
        
    }
    if(_arr.count!=0)
    {
        _emptyImg.hidden=YES;
    }
    else{
        _emptyImg.hidden=NO;
    }
    
    for(int i=0;i<_arr.count;i++){
        if([[_arr objectAtIndex:i] state]!=2)
            [_arr removeObject:[_arr objectAtIndex:i]];
        
    }
    
    [_data reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if(_isFiltered){
        if (indexPath.section == 0) {
            _task = [_lowPriorityTasks objectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 1) {
            _task = [_mediumPriorityTasks objectAtIndex:indexPath.row];
        }
        else {
            _task =  [_highPriorityTasks objectAtIndex:indexPath.row];
        }
    }
    else{
        _task = [_arr objectAtIndex:indexPath.row];
    }
   
    if(_task.state==2){
        
        UILabel *name = (UILabel*) [cell viewWithTag:2];
        name.text = _task.name;
        NSLog(@"%@",_task.name);
        
        UIImageView*img=(UIImageView*)[cell viewWithTag:1];
        NSLog(@"%@ imageview", _task.strImg);
        
        if([_task.strImg isEqual:@"0"] )
        {
            img.image=[UIImage imageNamed: @"low"];
        }
        else if ([_task.strImg isEqual:@"1"]){
            img.image=[UIImage imageNamed: @"medium"];
        }
        else if ([_task.strImg isEqual:@"2"]){
            img.image=[UIImage imageNamed: @"high"];
        }
        
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"ditails_Screen" ];
    
   
    if(_isFiltered){
        if (indexPath.section == 0) {
            details.task = _lowPriorityTasks[indexPath.row];
        }
        else if (indexPath.section == 1) {
            details.task = _mediumPriorityTasks[indexPath.row];
        }
        else {
            details.task = _highPriorityTasks[indexPath.row];
        }
    }
    else{
        details.task=[_arr objectAtIndex:indexPath.row];
     }
      
    details.type=3;
    details.index=(int)indexPath.row;
    NSLog(@"%d index",details.index);
    [self.navigationController pushViewController:details  animated:YES];
    
    
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if(self->_isFiltered){
                if (indexPath.section == 0)
                {
                    [self->_arr removeObject:[self->_lowPriorityTasks objectAtIndex:indexPath.row]];
                    [self->_lowPriorityTasks removeObject:[self->_lowPriorityTasks objectAtIndex:indexPath.row]];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->_arr];
                    [self->_userDefault setObject:data forKey:@"done"];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                else if (indexPath.section == 1)
                {
                    [self->_arr removeObject:[self->_mediumPriorityTasks objectAtIndex:indexPath.row]];
                    [self->_mediumPriorityTasks removeObject:[self->_mediumPriorityTasks objectAtIndex:indexPath.row]];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->_arr];
                    [self->_userDefault setObject:data forKey:@"done"];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                else {
                    [self->_arr removeObject:[self->_highPriorityTasks objectAtIndex:indexPath.row]];
                    [self->_highPriorityTasks removeObject:[self->_highPriorityTasks objectAtIndex:indexPath.row]];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->_arr];
                    [self->_userDefault setObject:data forKey:@"done"];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
            }
            else
            {
                [self->_arr removeObject:[self->_arr objectAtIndex:indexPath.row]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->_arr];
                [self->_userDefault setObject:data forKey:@"done"];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        // Delete the row from the data source
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    if(_arr.count==0)
    {
        _emptyImg.hidden=NO;
    }
}


//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isFiltered==YES)
        return 3;
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_arr.count<1)
    {
        _emptyImg.hidden=NO;
    }
    if(_isFiltered==YES){
        if (section == 0) {
                return _lowPriorityTasks.count;
            }
        else if (section == 1) {
                return _mediumPriorityTasks.count;
            }
        else {
                return _highPriorityTasks.count;
            }
    }
    return  _arr.count;
}
- (IBAction)filter:(id)sender {
    _isFiltered=!_isFiltered;
   
    
    [_lowPriorityTasks removeAllObjects];
    [_mediumPriorityTasks removeAllObjects];
    [_highPriorityTasks removeAllObjects];
   
       for (Task *task in _arr) {
           if (task.priority == 0) {
               [_lowPriorityTasks addObject:task];
           } else if (task.priority == 1) {
               [_mediumPriorityTasks addObject:task];
           } else if (task.priority == 2) {
               [_highPriorityTasks addObject:task];
           }
       }
    
    [_data reloadData];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_isFiltered){
        if(section==0)
        {
            return @"Low Tasks";
        }
        else if (section==1)
        {
            return @"Medium Tasks";
        }
        else
            return @"High Tasks";
        
    }
    else
        return @"All Tasks";
}
@end



























































































