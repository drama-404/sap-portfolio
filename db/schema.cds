namespace cv.portfolio;

using { cuid, managed } from '@sap/cds/common';

/**
 * Profile Entity (Singleton)
 * Contains personal information and bio
 */
entity Profile : cuid, managed {
  firstName         : String(50) not null;
  lastName          : String(50) not null;
  email             : String(100) not null;
  phone             : String(20);
  location          : String(100);
  linkedInUrl       : String(200);
  bio               : LargeString;
  photoUrl          : String(500);
  yearsOfExperience : Integer default 0;
}

/**
 * Projects Entity
 * Represents portfolio projects with detailed metadata
 */
entity Projects : cuid, managed {
  title           : String(200) not null;
  company         : String(200) not null;
  industry        : Association to Industries;
  projectType     : Association to ProjectTypes not null;
  startDate       : Date not null;
  endDate         : Date;
  description     : LargeString;
  goal            : LargeString;
  role            : String(200);
  outcomes        : LargeString;

  // Associations
  tasks           : Composition of many Tasks on tasks.project = $self;
  technologies    : Association to many ProjectTechnologies on technologies.project = $self;
}

/**
 * Tasks Entity
 * Specific tasks and contributions within a project
 */
entity Tasks : cuid, managed {
  project         : Association to Projects not null;
  taskNumber      : Integer not null;
  title           : String(200) not null;
  description     : LargeString not null;
  technologiesUsed: String(500); // Comma-separated list for quick reference
}

/**
 * Skills Entity
 * Technical competencies with proficiency levels
 */
entity Skills : cuid, managed {
  skillName       : String(100) not null;
  category        : String(50) not null; // Backend, Frontend, Integration, Database, etc.
  proficiencyLevel: Integer not null; // 1-100 percentage
  yearsExperience : Decimal(3,1); // e.g., 2.5 years
  description     : LargeString;
}

/**
 * Certifications Entity
 * Professional certifications and academic achievements
 */
entity Certifications : cuid, managed {
  name            : String(200) not null;
  issuingOrg      : String(200) not null;
  certificationType: String(50) not null; // SAP, Academic, Professional
  issueDate       : Date not null;
  expiryDate      : Date;
  credentialUrl   : String(500);
  credentialId    : String(200);
  badgeImageUrl   : String(500);
  description     : LargeString;
}

/**
 * Technologies Entity
 * Technology stack items
 */
entity Technologies : cuid, managed {
  name            : String(100) not null;
  category        : String(50) not null; // Backend, Frontend, Integration, Database, Cloud, Tools
  description     : LargeString;
  officialUrl     : String(500);
}

/**
 * ProjectTechnologies Association Entity
 * Many-to-many relationship between Projects and Technologies
 */
entity ProjectTechnologies : cuid {
  project         : Association to Projects not null;
  technology      : Association to Technologies not null;
  usageLevel      : String(20); // Primary, Secondary, Auxiliary
}

/**
 * Industries Code List
 * Standardized industry sectors
 * @cds.odata.valuelist enables automatic value help in Fiori
 */
@cds.odata.valuelist
entity Industries : cuid {
  code            : String(20) not null;
  name            : String(100) not null;
  description     : String(500);
}

/**
 * ProjectTypes Code List
 * Standardized project type classifications
 * @cds.odata.valuelist enables automatic value help in Fiori
 */
@cds.odata.valuelist
entity ProjectTypes : cuid {
  code            : String(50) not null;
  name            : String(100) not null;
  description     : String(500);
}

annotate Projects with @(
Capabilities: {
	FilterRestrictions : {FilterExpressionRestrictions : [{
		Property	: 'startDate',
		AllowedExpressions: 'SingleRange'
	},
	{
		Property	: 'endDate',
		AllowedExpressions: 'SingleRange'
	}]}
});