using { portfolio as P } from './schema';

namespace kpi;

/* ────────────────────────────────────────────────────────────────────────────
   Portfolio-level KPIs for ALP KPI tags & visual filters
   Why: ALP KPI tags/cards & visual filters expect numeric measures from OData
   services (counts, sums, percentages) that the UI can bind to.              */
/* ALP reference: KPI tags & visual filters. */
entity PortfolioTotals as select from P.Projects {
  count(*) as projectsTotal : Integer
};
/* KPI tag: total tasks */
entity PortfolioTaskTotals as select from P.Tasks {
  count(*) as tasksTotal : Integer
};

/* Completion Rate = (DEMO|PUB)/All * 100
   - Guard division by zero with nullif(count(*),0)
   - Provide both raw counts (for cards) and % (for radial micro-chart) */
entity PortfolioCompletion as select from P.Tasks {
  count(*) as totalTasks    : Integer,
  sum(case when implementationStatus.code in ('DEMO','PUB') then 1 else 0 end)
      as doneTasks          : Integer,
  cast(100.0 *
       sum(case when implementationStatus.code in ('DEMO','PUB') then 1 else 0 end)
       / nullif(count(*),0) as Decimal(5,2)) as completionPct
};

/* Extension Mix (donut visual filter): dimension + count */
entity PortfolioExtensionMix as select from P.Tasks {
  extensionType.code as extType,
  count(*)           as cnt : Integer
} group by extensionType.code;

/* Process Coverage (stacked bar): one row per (project, processArea)
   - UI can SUM(covered) by processArea to show footprint */
entity ProjectProcessCoverage as select from P.ProjectProcessAreas {
  project,
  processArea,
  1 as covered : Integer
};

/* Tech Diversity: distinct tech stacks per project (key metric for “depth”) */
entity ProjectTechDiversity as select from P.ProjectTechStacks {
  project,
  count(distinct techStack.code) as techCount : Integer
} group by project;

/* Optional: portfolio overview of tech diversity (avg & max for header card) */
entity PortfolioTechDiversitySummary as select from kpi.ProjectTechDiversity {
  avg(techCount) as avgTechsPerProject : Decimal(9,2),
  max(techCount) as maxTechsInProject  : Integer
};

/* Demo Readiness % = same logic as completion (for a separate KPI tag if desired) */
entity PortfolioDemoReadiness as select from P.Tasks {
  cast(100.0 *
       sum(case when implementationStatus.code in ('DEMO','PUB') then 1 else 0 end)
       / nullif(count(*),0) as Decimal(5,2)) as readinessPct
};

/* ────────────────────────────────────────────────────────────────────────────
   PROJECT-LEVEL KPIs (bindable in Object Page header facets / sections)
   Notes:
   - Use grouped numeric measures so FE can render KPIs and micro charts.
   - Association paths like implementationStatus.code are fine in CAP CDL;
     grouping happens by the referenced scalar path.  */
/* refs: CAP CDL & associations; conditional aggregation patterns. 
   See: CAP docs on CDL + managed associations; conditional SUM/CASE. 
*/

/* 1) Task Count by Status — for header chips or small bar */
entity ProjectTaskStatusAgg as select from P.Tasks {
  project,                                      // dimension (per project)
  implementationStatus.code as status,          // dimension (status)
  count(*)                        as cnt : Integer
} group by project, implementationStatus.code;

/* 2) Weighted Complexity Score — for bullet/micro chart in header
      HIGH=3, MED=2, LOW=1 (others=0) then SUM per project */
entity ProjectComplexityWeighted as select from P.Tasks {
  project,
  sum(
    case
      when complexityLevel.code = 'HIGH' then 3
      when complexityLevel.code = 'MED'  then 2
      when complexityLevel.code = 'LOW'  then 1
      else 0
    end
  ) as complexityScore : Integer
} group by project;

/* 3) Process Area Footprint — counts per process area per project
      (use in stacked bars or matrix lists) */
entity ProjectProcessFootprint as select from P.ProjectProcessAreas {
  project,
  processArea.code               as processArea,
  count(*)                       as cnt : Integer
} group by project, processArea.code;

/* 4) Stack Depth — distinct tech stacks per project (key value facet) */
entity ProjectStackDepth as select from P.ProjectTechStacks {
  project,
  count(distinct techStack.code) as techCount : Integer
} group by project;

/* ────────────────────────────────────────────────────────────────────────────
   TASK-LEVEL KPIs
 * Artifact Mix per Task
 * - Purpose: drive mini-bars/Harvey balls on Task Object Page (counts by type).
 * - Pattern: group by (task, artifactType.code) and COUNT(*).
 * - Why codes? Chart dimensions prefer stable, filterable codes/labels.
 *   (Fiori Elements charts & micro charts bind to dimensions + measures). 
 */
entity TaskArtifactMix as select from P.Artifacts {
  task,                              // backlink to Tasks (association)
  type.code as typeCode,     // dimension (e.g., IMG/DIAG/CODE/PDF)
  count(*)              as cnt : Integer
} group by task, type.code;
