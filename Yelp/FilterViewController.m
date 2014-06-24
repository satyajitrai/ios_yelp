//
//  FilterViewController.m
//  Yelp
//
//  Created by Satyajit Rai on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "PriceCell.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingsTable;
@property (strong, nonatomic) NSArray *popularNames;
@property (strong, nonatomic) NSMutableDictionary* popularMap;

@property (nonatomic, assign) int selectedDistanceIndex;
@property (strong, nonatomic) NSArray *distanceNames;

@property (nonatomic, assign) int selectedSortIndex;
@property (strong, nonatomic) NSArray *sortNames;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (strong, nonatomic) NSArray *categoryNames;
@property (strong, nonatomic) NSMutableDictionary* categoryStates;
@property (nonatomic, assign) BOOL categoryCollapsed;
@end

@implementation FilterViewController

static NSString* DefaultCell = @"UITableViewCell";
static NSString* DistanceCell = @"DistanceCell";
static NSString* SortCell = @"SortCell";
static NSString* PriceCellName = @"PriceCell";

static int sectionSizes[] = {1, 4, 1, 1, 4};
const int PriceSection = 0;
const int PopularSection = 1;
const int DistanceSection = 2;
const int SortSection = 3;
const int CategorySection = 4;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sectionTitles = @[@"Price", @"Most Popular", @"Distance", @"Sort By", @"General Features"];

        self.selectedDistanceIndex = 0;
        self.distanceNames = @[@"Auto", @"0.3 miles", @"1 mile", @"5 miles", @"20 miles"];
        
        self.selectedSortIndex = 0;
        self.sortNames = @[@"Best Match", @"Distance", @"Rating", @"Most Reviewed"];
        
        self.popularNames = @[@"Open Now", @"Hot & New", @"Offering a Deal", @"Delivery"];
        self.popularMap = [[NSMutableDictionary alloc] initWithCapacity:self.popularNames.count];
        for (NSString *name in self.popularNames) {
            [self.popularMap setObject:@NO forKey: name];
        }
        
        self.categoryNames = @[@"Take-Out", @"Good for Groups", @"Take Reservations", @"General 1", @"General 2"];
        self.categoryCollapsed = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Filters";
    
    self.settingsTable.delegate = self;
    self.settingsTable.dataSource = self;
    self.view.backgroundColor = self.settingsTable.backgroundColor;
    
    [self.settingsTable registerClass:[UITableViewCell class]  forCellReuseIdentifier:DefaultCell];
    [self.settingsTable registerClass:[UITableViewCell class]  forCellReuseIdentifier:DistanceCell];
    [self.settingsTable registerClass:[UITableViewCell class]  forCellReuseIdentifier:SortCell];
    [self.settingsTable registerNib:[UINib nibWithNibName:PriceCellName bundle:nil] forCellReuseIdentifier: PriceCellName];
    [self.settingsTable setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sectionSizes[section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // NSLog(@"Selected cell at Index Path: %@", indexPath);
    
    switch (indexPath.section) {
        case DistanceSection:
            [self didSelectDistanceForTable:tableView atIndexPath:indexPath];
            break;
            
        case SortSection:
            [self didSelectSortForTable:tableView atIndexPath:indexPath];
            break;
        case CategorySection:
            if (self.categoryCollapsed == YES && indexPath.row == 3) {
                self.categoryCollapsed = false;
                sectionSizes[CategorySection] = self.categoryNames.count;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    switch (indexPath.section) {
        case PriceSection:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:PriceCellName];
            //cell.backgroundColor = [UIColor clearColor];
            break;
            
        case PopularSection:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:DefaultCell forIndexPath:indexPath];
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 15];
            cell.textLabel.text = self.popularNames[indexPath.row];
            cell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
            break;
            
        case DistanceSection:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:DistanceCell forIndexPath:indexPath];
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 15];
            if (isCollapsed(DistanceSection)) {
                cell.textLabel.text = self.distanceNames[self.selectedDistanceIndex];
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                cell.textLabel.text = self.distanceNames[indexPath.row];
                if (self.selectedDistanceIndex == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            break;
            
        case SortSection:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:SortCell forIndexPath:indexPath];
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 15];
            if (isCollapsed(SortSection)) {
                cell.textLabel.text = self.sortNames[self.selectedSortIndex];
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                cell.textLabel.text = self.sortNames[indexPath.row];
                if (self.selectedSortIndex == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            break;
            
        case CategorySection:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:DefaultCell forIndexPath:indexPath];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            if (self.categoryCollapsed && indexPath.row == 3) {
                cell.textLabel.text = @"See All";
            }
            else {
                cell.textLabel.text = self.categoryNames[indexPath.row];
                cell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
            }
            break;
            
        default:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:DefaultCell forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"Section %d - Cell %d", indexPath.section, indexPath.row];
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:15];
    title.text = self.sectionTitles[section];
    return title;
}

#pragma mark - section management
BOOL isCollapsed(int section)
{
    if ((section == DistanceSection || section == SortSection) && (sectionSizes[section] == 1)) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void) didSelectDistanceForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    if (isCollapsed(indexPath.section)) {
        sectionSizes[DistanceSection] = self.distanceNames.count;
    } else {
        sectionSizes[DistanceSection] = 1;
        self.selectedDistanceIndex = indexPath.row;
    }
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
   [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) didSelectSortForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    if (isCollapsed(indexPath.section)) {
        sectionSizes[SortSection] = self.sortNames.count;
    } else {
        sectionSizes[SortSection] = 1;
        self.selectedSortIndex = indexPath.row;
    }
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
    [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
