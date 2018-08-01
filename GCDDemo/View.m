//
//  View.m
//  GCDDemo
//
//  Created by 天空吸引我 on 2018/7/31.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//

#import "View.h"
#import "ViewModel.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;


@interface View()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ViewModel *viewModel;
@property (nonatomic,strong) NSArray *dataArry;
@end

@implementation View
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createTableView];
        [self initIalize];
    }
    return self;
}

-(void)initIalize
{
    WS(weakSelf)
   _viewModel = [[ViewModel alloc] init];
    _viewModel.reloadDataBlock = ^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            weakSelf.dataArry = result;
        }
        [weakSelf.tableView reloadData];
    };
    [_viewModel requestData];
   
}

-(void)createTableView
{
   _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid=@"tableViewCell";
    
    UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil){
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:rid];
        
    }
    NSDictionary *dict = _dataArry[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _dataArry[indexPath.row];
    [_viewModel cellDidSelectRowAtDict:dict];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
