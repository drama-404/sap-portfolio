using { cuid, managed } from '@sap/cds/common';

namespace portfolio;

/* ============================
   VALUE LISTS (tags/lookups)
   ============================ */
entity Industry            { key code : String(40); text : String(255); }
entity ProcessArea         { key code : String(40); text : String(255); }
entity TechStack           { key code : String(40); text : String(255); icon : String(80); }
entity ExtensionType       { key code : String(40); text : String(255); }         // on-stack, side-by-side, API
entity ProcessType         { key code : String(40); text : String(255); }         // e.g., L2C, S2P, D2O, R2R
entity ImplementationStatus{ key code : String(40); text : String(255); criticality : Integer; } // 1=Neg,2=Crit,3=Warn,4=Good
entity ComplexityLevel     { key code : String(40); text : String(255); weight : Integer; }      // for sorting/weights
entity ArtifactType        { key code : String(40); text : String(255); media : String(40); }    // image, diagram, code, pdf
entity SkillArea           { key code : String(40); text : String(255); }          // Frontend/Backend/Integration/Functional
entity ProficiencyLevel    { key code : String(40); text : String(255); level : Integer; }       // 1..5

/* ============================
   CORE ENTITIES
   ============================ */
entity Projects : cuid, managed {
  title         : String(120);
  description   : String(2000);
  startDate     : Date;
  endDate       : Date;
  kpiHighlight  : String(255);
  repoUrl       : String(255);
  heroImage     : String(255);                     // media path

  // M:N tags via compositions (so they appear nested in OData, and cascade on delete)
  industries    : Composition of many ProjectIndustries   on industries.project   = $self;
  processAreas  : Composition of many ProjectProcessAreas on processAreas.project = $self;
  techStacks    : Composition of many ProjectTechStacks   on techStacks.project   = $self;

  // Child tasks
  tasks         : Composition of many Tasks on tasks.project = $self;
}

entity ProjectIndustries : cuid {
  project  : Association to Projects;
  industry : Association to Industry;
}
entity ProjectProcessAreas : cuid {
  project     : Association to Projects;
  processArea : Association to ProcessArea;
}
entity ProjectTechStacks : cuid {
  project  : Association to Projects;
  techStack: Association to TechStack;
}

entity Tasks : cuid, managed {
  project            : Association to Projects;

  title              : String(140);
  businessProblem    : String(2000);
  solutionSummary    : String(4000);

  // SD/MM/FI classification etc.
  processType        : Association to ProcessType;
  extensionType      : Association to ExtensionType;        // on-stack/side-by-side/API
  implementationStatus : Association to ImplementationStatus;
  complexityLevel    : Association to ComplexityLevel;

  kpiImpact          : String(255);                         // short “value” statement
  demoRoute          : String(255);                         // deep link/route in UI

  // Optional per-task tech tags 
  taskTechStacks     : Composition of many TaskTechStacks on taskTechStacks.task = $self;

  // Artifacts (images, diagrams, code, pdfs)
  artifacts          : Composition of many Artifacts on artifacts.task = $self;
}

entity TaskTechStacks : cuid {
  task     : Association to Tasks;
  techStack: Association to TechStack;
}

entity Artifacts : cuid, managed {
  task        : Association to Tasks;
  type        : Association to ArtifactType;
  title       : String(140);
  description : String(2000);
  mediaPath   : String(255);    // /webapp/media/... or CDN
  sourceCode  : LargeString;    // optional code blob for display
}

/* ============================
   CERTS & SKILLS (optional tabs)
   ============================ */
entity Certifications : cuid, managed {
  title      : String(140);
  authority  : String(140);
  issueDate  : Date;
  topic      : String(140);
  badgeUrl   : String(255);
}

entity Skills : cuid, managed {
  name        : String(120);
  area        : Association to SkillArea;
  proficiency : Association to ProficiencyLevel;
  notes       : String(500);
}
