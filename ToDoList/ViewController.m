//
//  ViewController.m
//  ToDoList
//
//  Created by JETSMobileLabMini10 on 17/04/2024.
//

#import "ViewController.h"
#import "Task.h"
#import "DetailsViewController.h"
@interface ViewController ()
@property NSUserDefaults *userDefault;
@property NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImg;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property Task* task;
@property (weak, nonatomic) IBOutlet UITableView *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchBar];
    
    _filteredArray=[NSMutableArray new];
    _userDefault = [NSUserDefaults standardUserDefaults];
    _task = [Task new];
    printf("%lu" , _dataArray.count);
    //_todoArr=[NSMutableArray new];
    _data.delegate = self;
    _data.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
//    NSDictionary *attributes = @{
//        NSForegroundColorAttributeName: [UIColor redColor], // Change color here
//        NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:20.0] // Change font and size here
//    };
//    self.tabBarController.navigationItem.title = @"TODO";
//    self.tabBarController.navigationItem.title = attributes;

    self.tabBarController.navigationItem.rightBarButtonItem.hidden=NO;
    self.tabBarController.navigationItem.title=@"TODO";
    //self.tabBarController.navigationItem.titleView.tintColor
    NSData *decoded = [_userDefault objectForKey:@"custom"];
    _dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:decoded];
    if(_dataArray.count!=0)
    {
        _emptyImg.hidden=YES;
    }
    else{
        _emptyImg.hidden=NO;
    }
    for(int i=0;i<_dataArray.count;i++){
        if([[_dataArray objectAtIndex:i] state]!=0)
            [_dataArray removeObject:[_dataArray objectAtIndex:i]];
        
    }
    [self filterContentForSearchText:self.searchBar.text];
    
    [_data reloadData];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    if (self.searchBar.text.length > 0) {
        _task = [_filteredArray objectAtIndex:indexPath.row];
    } else {
        _task = [_dataArray objectAtIndex:indexPath.row];
    }
    
    
    if(_task.state==0){
        
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
    DetailsViewController *ditails=[self.storyboard instantiateViewControllerWithIdentifier:@"ditails_Screen" ];
    
    ditails.task=[_dataArray objectAtIndex:indexPath.row];
    ditails.type=1;
    ditails.index=(int)indexPath.row;
    NSLog(@"%d index",ditails.index);
    [self.navigationController pushViewController:ditails  animated:YES];
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self->_dataArray removeObject:[self->_dataArray objectAtIndex:indexPath.row]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->_dataArray];
            [self->_userDefault setObject:data forKey:@"custom"];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
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
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchBar.text.length > 0) {
        return self.filteredArray.count;
    } else {
        if(_dataArray.count<1)
        {
            _emptyImg.hidden=NO;
        }
        return self.dataArray.count;
    }
}

- (void)filterContentForSearchText:(NSString *)searchText {
    [self.filteredArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    self.filteredArray = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicate]];
    [self.data reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText];
}


@end
