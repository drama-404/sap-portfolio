namespace sap.portfolio;


using {
    cuid,
    managed
} from '@sap/cds/common';

// Read-only defaults for now (UI will be public). Adjust on a per-entity basis later.
@Capabilities.InsertRestrictions.Insertable: false
@Capabilities.DeleteRestrictions.Deletable : false
@Capabilities.UpdateRestrictions.Updatable : false
entity Projects : cuid, managed {
    title         : String(200);
    subTitle      : String(400);
    industry      : Association to Industries;
    status        : Association to ProjectStatuses;
    startDate     : Date;
    endDate       : Date;
    summary       : LargeString;
    githubUrl     : String(500);
    demoUrl       : String(500);
    coverImageUrl : String(500);
    processAreas  : Association to many ProcessAreas;
    skills        : Association to many Skills;
    artifacts     : Association to many Artifacts
                        on artifacts.project = $self;
    tasks         : Composition of many Tasks
                        on tasks.project = $self;
}


entity Tasks : cuid, managed {
    project         : Association to Projects;
    sequence        : Integer;
    title           : String(200);
    businessProblem : LargeString;
    solutionSummary : LargeString;
    status          : Association to TaskStatuses;
    startDate       : Date;
    endDate         : Date;
    artifacts       : Association to many Artifacts
                          on artifacts.task = $self;
}


entity Artifacts : cuid, managed {
    project     : Association to Projects;
    task        : Association to Tasks;
    type        : Association to ArtifactTypes;
    title       : String(200);
    url         : String(500);
    description : LargeString;
}


entity Skills : cuid, managed {
    name        : String(120);
    category    : Association to SkillCategories;
    level       : Integer @assert.range: [
        1,
        5
    ];
    description : LargeString;
}


entity Certifications : cuid, managed {
    name         : String(200);
    vendor       : String(120);
    issuedOn     : Date;
    credentialId : String(120);
    url          : String(500);
}

// Code lists
entity Industries : managed {
    key code : String(10);
        name : localized String(120);
}

entity ProcessAreas : managed {
    key code : String(20);
        name : localized String(120);
}

entity ArtifactTypes : managed {
    key code : String(20);
        name : localized String(120);
}

entity SkillCategories : managed {
    key code : String(20);
        name : localized String(120);
}

entity ProjectStatuses : managed {
    key code : String(10);
        name : localized String(120);
}

entity TaskStatuses : managed {
    key code : String(10);
        name : localized String(120);
}


// // Junctions
// entity ProjectProcessAreas : managed {
//     key project     : Association to Projects;
//     key processArea : Association to ProcessAreas;
// }


// entity ProjectSkills : managed {
//     key project     : Association to Projects;
//     key skill       : Association to Skills;
//         proficiency : Integer @assert.range: [
//             1,
//             5
//         ];
// }
