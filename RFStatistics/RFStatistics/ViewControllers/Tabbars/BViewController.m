//
//  BViewController.m
//  RFStatistics
//
//  Created by wiseweb on 16/11/30.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "BViewController.h"
#import <Realm/Realm.h>

// Realm model object
@interface DemoObject : RLMObject
@property NSString *title;
@property NSDate   *date;
@property NSString *sectionTitle;
@end

@implementation DemoObject
// None needed
@end

static NSString * const kCellID    = @"cell";
static NSString * const kTableName = @"table";

@interface BViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *objectsBySection;
@property (nonatomic, strong) RLMNotificationToken *notification;
@property (nonatomic, strong) UITableView *tableView;


@end


@implementation BViewController
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Section Titles
    self.sectionTitles = @[@"A", @"B", @"C"];
    [self setupUI];
    
    // Set realm notification block
    __weak typeof(self) weakSelf = self;
    self.notification = [RLMRealm.defaultRealm addNotificationBlock:^(NSString *note, RLMRealm *realm) {
        [weakSelf.tableView reloadData];
    }];
    self.objectsBySection = [NSMutableArray arrayWithCapacity:3];
    for (NSString *section in self.sectionTitles) {
        RLMResults *unsortedObjects = [DemoObject objectsWhere:@"sectionTitle == %@", section];
        RLMResults *sortedObjects = [unsortedObjects sortedResultsUsingProperty:@"date" ascending:YES];
        [self.objectsBySection addObject:sortedObjects];
    }
    [self.tableView reloadData];
}

#pragma mark - UI

- (void)setupUI
{
    self.title = @"GroupedTableView";
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"BG Add"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backgroundAdd)];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(add)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self objectsInSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kCellID];
    }
    
    DemoObject *object = [self objectsInSection:indexPath.section][indexPath.row];
    cell.textLabel.text = object.title;
    cell.detailTextLabel.text = object.date.description;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RLMRealm *realm = RLMRealm.defaultRealm;
        [realm beginWriteTransaction];
        [realm deleteObject:[self objectsInSection:indexPath.section][indexPath.row]];
        [realm commitWriteTransaction];
    }
}

#pragma mark - Actions

- (void)backgroundAdd
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // Import many items in a background thread
    dispatch_async(queue, ^{
        // Get new realm and table since we are in a new thread
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (NSInteger index = 0; index < 5; index++) {
            // Add row via dictionary. Order is ignored.
            [DemoObject createInRealm:realm withObject:@{@"title": [self randomTitle],
                                                         @"date": [NSDate date],
                                                         @"sectionTitle": [self randomSectionTitle]}];
        }
        [realm commitWriteTransaction];
    });
}

- (void)add
{
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [DemoObject createInDefaultRealmWithObject:@[[self randomTitle], [NSDate date], [self randomSectionTitle]]];
    }];
}

#pragma - Helpers

- (RLMResults *)objectsInSection:(NSUInteger)section
{
    return self.objectsBySection[section];
}

- (NSString *)randomTitle
{
    return [NSString stringWithFormat:@"Title %d", arc4random()];
}

- (NSString *)randomSectionTitle
{
    return self.sectionTitles[arc4random() % self.sectionTitles.count];
}


@end
