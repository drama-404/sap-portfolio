using { portfolio } from '../db/schema.cds';
using { kpi } from '../db/kpis.cds';

@path : '/service/portfolio_service'
service portfolio_service {

  // Core
  @cds.redirection.target: true
  entity Projects               as projection on portfolio.Projects;
  @cds.redirection.target: true
  entity Tasks                  as projection on portfolio.Tasks;
  entity Artifacts              as projection on portfolio.Artifacts;

  // M:N join helper entities (auto-exposed for tag maintenance & $expand)
  entity ProjectIndustries      as projection on portfolio.ProjectIndustries;
  @cds.redirection.target: false      // KPIs/aggregation projections must NOT be redirects
  entity ProjectProcessAreas    as projection on portfolio.ProjectProcessAreas;
  @cds.redirection.target: false
  entity ProjectTechStacks      as projection on portfolio.ProjectTechStacks;
  entity TaskTechStacks         as projection on portfolio.TaskTechStacks;

  // Lookups / value lists
  entity Industries             as projection on portfolio.Industry;
  entity ProcessAreas           as projection on portfolio.ProcessArea;
  entity TechStacks             as projection on portfolio.TechStack;
  entity ExtensionTypes         as projection on portfolio.ExtensionType;
  entity ProcessTypes           as projection on portfolio.ProcessType;
  entity ImplementationStatuses as projection on portfolio.ImplementationStatus;
  entity ComplexityLevels       as projection on portfolio.ComplexityLevel;
  entity ArtifactTypes          as projection on portfolio.ArtifactType;
  entity SkillAreas             as projection on portfolio.SkillArea;
  entity ProficiencyLevels      as projection on portfolio.ProficiencyLevel;

  // Optional tabs
  entity Certifications         as projection on portfolio.Certifications;
  entity Skills                 as projection on portfolio.Skills;

/* Portfolio-level KPIs (from your kpis.cds) */
  entity PortfolioTotals                as projection on kpi.PortfolioTotals;
  entity PortfolioTaskTotals            as projection on kpi.PortfolioTaskTotals;
  entity PortfolioCompletion            as projection on kpi.PortfolioCompletion;
  entity PortfolioExtensionMix          as projection on kpi.PortfolioExtensionMix;
  entity ProjectProcessCoverage         as projection on kpi.ProjectProcessCoverage;
  @cds.redirection.target: false
  entity ProjectTechDiversity           as projection on kpi.ProjectTechDiversity;
  @cds.redirection.target: false
  entity PortfolioTechDiversitySummary  as projection on kpi.PortfolioTechDiversitySummary;
  @cds.redirection.target: false
  entity PortfolioDemoReadiness         as projection on kpi.PortfolioDemoReadiness;

   /* Project-level KPI projections (these are metric feeds; not redirect targets) */
  @cds.redirection.target : false
  entity ProjectTaskStatusAgg as projection on kpi.ProjectTaskStatusAgg;

  @cds.redirection.target : false
  entity ProjectComplexityWeighted as projection on kpi.ProjectComplexityWeighted;

  @cds.redirection.target : false
  entity ProjectProcessFootprint as projection on kpi.ProjectProcessFootprint;

  @cds.redirection.target : false
  entity ProjectStackDepth as projection on kpi.ProjectStackDepth;

  // /* Optional: expose navigations from Projects to KPI feeds (read-only helper assocs) */
  // entity ProjectsWithKPIs as projection on Projects {
  //   *,
  //   taskStatus : Association to many ProjectTaskStatusAgg
  //     on taskStatus.project = $self,

  //   complexityKpi : Association to one ProjectComplexityWeighted
  //     on complexityKpi.project = $self,

  //   processFootprint : Association to many ProjectProcessFootprint
  //     on processFootprint.project = $self,

  //   stackDepthKpi : Association to one ProjectStackDepth
  //     on stackDepthKpi.project = $self
  // };
}


annotate portfolio_service with @requires :
[
    'authenticated-user'
];
