//
//  AddPatientTableViewController.m
//  OpenMRS-iOS
//
//  Created by Parker Erway on 12/9/14.
//  Copyright (c) 2014 Erway Software. All rights reserved.
//

#import "AddPatientTableViewController.h"
#import "OpenMRSAPIManager.h"
#import "PatientViewController.h"
@interface AddPatientTableViewController ()

@end

@implementation AddPatientTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Patient";
    
    self.selectedGender = @"";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
}
- (void)done
{
    MRSPatient *patient = [[MRSPatient alloc] init];
    patient.name = self.selectedGivenName;
    patient.familyName = self.selectedFamilyName;
    patient.age = @98;
    patient.gender = self.selectedGender;
    
    [OpenMRSAPIManager addPatient:patient completion:^(NSError *error, MRSPatient *createdPatient) {
        if (error != nil)
        {
            
        }
        else
        {
            
        }
    }];
}
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"namecell"];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Given Name";
                break;
            case 1:
                cell.textLabel.text = @"Family Name";
                break;
        }
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(cell.bounds.size.width-150, 0, 130, cell.bounds.size.height)];
        field.backgroundColor = [UIColor clearColor];
        field.textColor = self.view.tintColor;
        field.textAlignment = NSTextAlignmentRight;
        field.returnKeyType = UIReturnKeyDone;
        [field addTarget:self action:@selector(textFieldDidUpdate:) forControlEvents:UIControlEventEditingChanged];
        
        switch (indexPath.row) {
            case 0:
                field.placeholder = @"Given Name";
                field.text = self.selectedGivenName;
                field.tag = 1;
                break;
            case 1:
                field.placeholder = @"Family Name";
                field.text = self.selectedFamilyName;
                field.tag = 2;
                break;
        }
        
        [cell addSubview:field];
        
        return cell;
    }
    if (indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gendercell"];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gendercell"];
        }
        
        cell.textLabel.text = (indexPath.row == 1) ? @"Female" : @"Male";
        
        if (([self.selectedGender isEqualToString:@"M"] && indexPath.row == 0) || ([self.selectedGender isEqualToString:@"F"] && indexPath.row == 1))
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Name";
            break;
        case 1:
            return @"Gender";
            break;
        default:
            return nil;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            self.selectedGender = @"M";
        }
        else
        {
            self.selectedGender = @"F";
        }
        [self.tableView reloadData];
    }
}
- (void)textFieldDidUpdate:(UITextField *)sender
{
    switch (sender.tag) {
        case 1:
            self.selectedGivenName = sender.text;
            break;
        case 2:
            self.selectedFamilyName = sender.text;
            break;
    }
}
@end