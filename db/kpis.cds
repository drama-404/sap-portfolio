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

// /* Tech Diversity: distinct tech stacks per project (key metric for “depth”) */
// entity ProjectTechDiversity as select from P.ProjectTechStacks {
//   project,
//   count(distinct techStack) as techCount : Integer
// } group by project;

// /* Optional: portfolio overview of tech diversity (avg & max for header card) */
// entity PortfolioTechDiversitySummary as select from kpi.ProjectTechDiversity {
//   avg(techCount) as avgTechsPerProject : Decimal(9,2),
//   max(techCount) as maxTechsInProject  : Integer
// };

// /* Demo Readiness % = same logic as completion (for a separate KPI tag if desired) */
// entity PortfolioDemoReadiness as select from P.Tasks {
//   cast(100.0 *
//        sum(case when implementationStatus.code in ('DEMO','PUB') then 1 else 0 end)
//        / nullif(count(*),0) as Decimal(5,2)) as readinessPct
// };
