//
//  FilterViewController.m
//  Yelp
//
//  Created by Satyajit Rai on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"
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
@property (strong, nonatomic) NSArray *featureNames;
@property (strong, nonatomic) NSMutableDictionary* featureStates;
@property (nonatomic) BOOL *isDistanceExpanded;
@property (nonatomic) BOOL *isSortExpanded;
@end

@implementation FilterViewController

static NSString* DefaultCell = @"UITableViewCell";
static NSString* PriceCellName = @"PriceCell";
static NSString* SwitchCellName = @"SwitchCell";

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
        
        self.featureNames = @[@"Take-Out", @"Good for Groups", @"Take Reservations", @"See All"];
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
    
    [self.settingsTable registerClass:[UITableViewCell  class]  forCellReuseIdentifier:DefaultCell];
    [self.settingsTable registerNib:[UINib nibWithNibName:PriceCellName bundle:nil] forCellReuseIdentifier: PriceCellName];
    [self.settingsTable registerNib:[UINib nibWithNibName:SwitchCellName bundle:nil] forCellReuseIdentifier: SwitchCellName];
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
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:SwitchCellName forIndexPath:indexPath];
            ((SwitchCell *)cell).txtLabel.text = self.popularNames[indexPath.row];
            break;
            
        case DistanceSection:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:DefaultCell forIndexPath:indexPath];
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 15];
            if (isCollapsed(DistanceSection)) {
                cell.textLabel.text = self.distanceNames[self.selectedDistanceIndex];
            } else {
                cell.textLabel.text = self.distanceNames[indexPath.row];
                cell.textLabel.textColor = [UIColor blackColor];
                if (self.selectedDistanceIndex == indexPath.row) {
                    NSLog(@"Setting checkmark on row %d", self.selectedDistanceIndex);
                    cell.textLabel.textColor = [UIColor blueColor];
                    cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
            break;
            
        case SortSection:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:DefaultCell forIndexPath:indexPath];
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 15];
            if (isCollapsed(SortSection)) {
                cell.textLabel.text = self.sortNames[self.selectedSortIndex];
            } else {
                cell.textLabel.text = self.sortNames[indexPath.row];
                cell.textLabel.textColor = [UIColor blackColor];
                if (self.selectedSortIndex == indexPath.row) {
                    NSLog(@"Setting checkmark on row %d", self.selectedSortIndex);
                    cell.textLabel.textColor = [UIColor blueColor];
                    cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
            break;
            
        case CategorySection:
            cell = [self.settingsTable dequeueReusableCellWithIdentifier:SwitchCellName forIndexPath:indexPath];
            ((SwitchCell *)cell).txtLabel.text = self.featureNames[indexPath.row];
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
    else if (section == CategorySection && sectionSizes[section] == 4){
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
