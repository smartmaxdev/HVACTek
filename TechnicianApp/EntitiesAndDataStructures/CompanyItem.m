//
//  CompanyItem.m
//  HvacTek
//
//  Created by Dorin on 1/22/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "CompanyItem.h"

@implementation CompanyItem

+(instancetype) companyItemWithID:(NSString*)itemID
                         address1:(NSString*)address1
                         address2:(NSString*)address2
                         admin_id:(NSString*)admin_id
                       alias_name:(NSString*)alias_name
                    business_name:(NSString *)business_name
                             city:(NSString *)city
                   contact_f_name:(NSString *)contact_f_name
                   contact_l_name:(NSString *)contact_l_name
                    contact_phone:(NSString *)contact_phone
                         csv_name:(NSString *)csv_name
                          deleted:(NSString *)deleted
                    invoice_email:(NSString *)invoice_email
                             logo:(NSString *)logo
                    primary_color:(NSString *)primary_color
                  secondary_color:(NSString *)secondary_color
                            state:(NSString *)state
                         swapi_id:(NSString *)swapi_id
                              zip:(NSString *)zip
                plumbing_category:(NSString *)plumbing_category
                   plumbing_group:(NSString *)plumbing_group
                       isPlumbing:(BOOL)isPlumbing {

    
    CompanyItem *company    = [CompanyItem new];
    company.itemID          = itemID;
    company.address1        = address1;
    company.address2        = address2;
    company.admin_id        = admin_id;
    company.business_name   = business_name;
    company.city            = city;
    company.contact_f_name  = contact_f_name;
    company.contact_l_name  = contact_l_name;
    company.contact_phone   = contact_phone;
    company.deleted         = deleted;
    company.logo            = logo;
    company.primary_color   = primary_color;
    company.secondary_color = secondary_color;
    company.state           = state;
    company.swapi_id        = swapi_id;
    company.zip             = zip;
    company.plumbing_category  = plumbing_category;
    company.plumbing_group  = plumbing_group;
    company.isPlumbing      = isPlumbing;
    company.invoice_email = invoice_email;
    company.alias_name = alias_name;
    company.csv_name = csv_name;
    return company;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.itemID             = [aDecoder decodeObjectForKey:@"itemID"];
        self.address1           = [aDecoder decodeObjectForKey:@"address1"];
        self.address2           = [aDecoder decodeObjectForKey:@"address2"];
        self.admin_id           = [aDecoder decodeObjectForKey:@"admin_id"];
        self.business_name      = [aDecoder decodeObjectForKey:@"business_name"];
        self.city               = [aDecoder decodeObjectForKey:@"city"];
        self.contact_f_name     = [aDecoder decodeObjectForKey:@"contact_f_name"];
        self.contact_l_name     = [aDecoder decodeObjectForKey:@"contact_l_name"];
        self.contact_phone      = [aDecoder decodeObjectForKey:@"contact_phone"];
        self.deleted            = [aDecoder decodeObjectForKey:@"deleted"];
        self.logo               = [aDecoder decodeObjectForKey:@"logo"];
        self.primary_color      = [aDecoder decodeObjectForKey:@"primary_color"];
        self.secondary_color    = [aDecoder decodeObjectForKey:@"secondary_color"];
        self.state              = [aDecoder decodeObjectForKey:@"state"];
        self.swapi_id           = [aDecoder decodeObjectForKey:@"swapi_id"];
        self.zip                = [aDecoder decodeObjectForKey:@"zip"];
        self.plumbing_category  = [aDecoder decodeObjectForKey:@"plumbing_category"];
        self.plumbing_group     = [aDecoder decodeObjectForKey:@"plumbing_group"];
        self.invoice_email     = [aDecoder decodeObjectForKey:@"invoice_email"];
        self.alias_name     = [aDecoder decodeObjectForKey:@"alias_name"];
        self.csv_name     = [aDecoder decodeObjectForKey:@"csv_name"];
        self.isPlumbing         = [[aDecoder decodeObjectForKey:@"isPlumbing"] boolValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // Override in descending classes
    [aCoder encodeObject:self.itemID            forKey:@"itemID"];
    [aCoder encodeObject:self.address1          forKey:@"address1"];
    [aCoder encodeObject:self.address2          forKey:@"address2"];
    [aCoder encodeObject:self.admin_id          forKey:@"admin_id"];
    [aCoder encodeObject:self.business_name     forKey:@"business_name"];
    [aCoder encodeObject:self.city              forKey:@"city"];
    [aCoder encodeObject:self.contact_f_name    forKey:@"contact_f_name"];
    [aCoder encodeObject:self.contact_l_name    forKey:@"contact_l_name"];
    [aCoder encodeObject:self.contact_phone     forKey:@"contact_phone"];
    [aCoder encodeObject:self.deleted           forKey:@"deleted"];
    [aCoder encodeObject:self.logo              forKey:@"logo"];
    [aCoder encodeObject:self.primary_color     forKey:@"primary_color"];
    [aCoder encodeObject:self.secondary_color   forKey:@"secondary_color"];
    [aCoder encodeObject:self.state             forKey:@"state"];
    [aCoder encodeObject:self.swapi_id          forKey:@"swapi_id"];
    [aCoder encodeObject:self.zip               forKey:@"zip"];
    [aCoder encodeObject:self.plumbing_category forKey:@"plumbing_category"];
    [aCoder encodeObject:self.plumbing_group    forKey:@"plumbing_group"];
    [aCoder encodeObject:self.invoice_email    forKey:@"invoice_email"];
    [aCoder encodeObject:self.alias_name    forKey:@"alias_name"];
    [aCoder encodeObject:self.csv_name    forKey:@"csv_name"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isPlumbing] forKey:@"isPlumbing"];
}

@end
