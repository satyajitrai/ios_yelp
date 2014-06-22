//
//  YelpViewController.m
//  Yelp
//
//  Created by Satyajit Rai on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpViewController.h"
#import "YelpTableViewCell.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface YelpViewController ()

@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) YelpClient *client;
@property (strong, nonatomic) NSArray *results;

@end

@implementation YelpViewController

static NSString *const YelpTableCellClassName = @"YelpTableViewCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.tblView.rowHeight = 120;
    
    [self getYelpResults:@""];
    
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    [self.tblView registerNib:[UINib nibWithNibName:YelpTableCellClassName bundle:nil] forCellReuseIdentifier:YelpTableCellClassName];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
    [self.tblView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getYelpResults:(NSString*)term {
    [self.client searchWithTerm:term success:^(AFHTTPRequestOperation *operation, id response) {
        self.results = response[@"businesses"];
        //NSLog(@"result %@", response);
        NSLog(@"Got %d business listings", self.results.count);
        [self.tblView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        self.results = [[NSArray alloc]init];
    }];
}

#pragma mark - Filter View invocation
- (void)onFilterButton {
    NSLog(@"TODO: Implement Filter view");
}

#pragma mark - search bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self getYelpResults: searchText];
    [self.tblView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


#pragma mark - Table refresh
- (void)refreshTable:(UIRefreshControl*) refresh {
    [refresh endRefreshing];
    [self.view endEditing:YES];
}

#pragma mark - Table View methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Row count %d", self.results.count);
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YelpTableCellClassName forIndexPath:indexPath];
    [cell setBusiness:self.results[indexPath.row] withRank:indexPath.row];
    return cell;
}

@end
