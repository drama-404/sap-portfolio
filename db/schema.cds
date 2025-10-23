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

// --- Add simple per-row computed properties ---

extend Projects with {
  durationDays : Integer @title:'Duration (days)' =
    case
      when startDate is null or endDate is null then null
      when days_between(startDate, endDate) < 0 then 0         // clamp
      else days_between(startDate, endDate)                    // correct order: start, end
    end;
}

extend Tasks with {

  /** 
   * SOLUTION IMPACT as a clean 0–100 number (drives Radial Micro Chart).
   * If you store a human string like '90%' in kpiImpact, we strip '%' and cast.
   * Works in CAP calculated elements (on-read), forwarded to SQL (SQLite/HANA).
   * Ref: CAP calculated elements (on-read semantics), CXN expressions. 

     1) Strip spaces/%/± (incl. Unicode U+2212), plus and minus
     2) CAST to Decimal
     3) ABS to drop any leftover sign
     4) Clamp to 0..100 (CASE for SQLite/HANA portability)
  */
  solutionImpactPct : Decimal(5,2) @title:'Solution Impact %' =
    case
      when abs(
             cast(
               replace(
                 replace(
                   replace(
                     replace(
                       replace( ifnull(kpiImpact,'0'), ' ', ''),  /* trim spaces   */
                     '%',''),                                     /* drop percent  */
                   '−',''),                                       /* Unicode minus */
                 '+',''),                                         /* plus sign     */
               '-','')                                            /* ASCII minus   */
             as Decimal(5,2))
           ) > 100
      then 100
      else abs(
             cast(
               replace(
                 replace(
                   replace(
                     replace(
                       replace( ifnull(kpiImpact,'0'), ' ', '' ),
                     '%',''),
                   '−',''),
                 '+',''),
               '-','')
             as Decimal(5,2))
           )
    end;

  /**
   * READINESS as % (simple, status-based) — also handy for a radial or progress bar.
   */
  readinessPct : Decimal(5,2)
    @title : 'Readiness %'
    = case
         when implementationStatus.code in ('DEMO','PUB') then 100
         when implementationStatus.code =  'WIP'          then 60
         when implementationStatus.code =  'MOCK'         then 30
         else 0
       end;

  /**
   * READINESS semantic color (Criticality) for Fiori Elements.
   * UI criticality codes commonly used: 0/NULL=Neutral, 1=Negative, 2=Critical, 3=Positive (5=New). 
   * We mark completed (DEMO/PUB) as Positive, WIP/MOCK as Critical, others as Negative.
   */
  readinessCriticality : Integer
    @title : 'Readiness Criticality'
    = case
         when implementationStatus.code in ('DEMO','PUB') then 3  /* Positive  */
         when implementationStatus.code in ('WIP','MOCK') then 2  /* Critical  */
         else 1                                                  /* Negative  */
       end;

     /**
   * Cycle Time (days)
   *
   * This calculated element returns the difference between a task’s
   * `modifiedAt` and `createdAt` timestamps in days.  CAP’s
   * `seconds_between()` function computes the difference in seconds;
   * dividing by 86 400 converts seconds to days.  The `round()`
   * function limits the result to two decimal places.  If either
   * timestamp is null the expression evaluates to null.
   */
  cycleTimeDays : Decimal(9,2) 
  @title:'Cycle Time (days)'
    = case
        when createdAt is not null and modifiedAt is not null
          then round(seconds_between(modifiedAt, createdAt) / 86400, 2)
        else null
      end;
    }