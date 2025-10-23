using { portfolio } from '../db/schema.cds';
using { kpi } from '../db/kpis.cds';

@path : '/service/portfolio_service'
service portfolio_service {

  /* Core */
   @cds.redirection.target : true
  entity Projects               as projection on portfolio.Projects;
  @cds.redirection.target:true
  entity Tasks                  as projection on portfolio.Tasks;
  entity Artifacts              as projection on portfolio.Artifacts;

  /* Tag helpers */
  entity ProjectIndustries      as projection on portfolio.ProjectIndustries;
  @cds.redirection.target:true
  entity ProjectProcessAreas    as projection on portfolio.ProjectProcessAreas;
  @cds.redirection.target:true
  entity ProjectTechStacks      as projection on portfolio.ProjectTechStacks;
  entity TaskTechStacks         as projection on portfolio.TaskTechStacks;

  /* Lookups */
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

  /* Optional tabs */
  entity Certifications         as projection on portfolio.Certifications;
  entity Skills                 as projection on portfolio.Skills;

/* Portfolio KPI feeds */
  entity PortfolioTotals                as projection on kpi.PortfolioTotals;
  entity PortfolioTaskTotals            as projection on kpi.PortfolioTaskTotals;
  entity PortfolioCompletion            as projection on kpi.PortfolioCompletion;
  entity PortfolioExtensionMix          as projection on kpi.PortfolioExtensionMix;
  entity ProjectProcessCoverage         as projection on kpi.ProjectProcessCoverage;
  entity ProjectTechDiversity           as projection on kpi.ProjectTechDiversity;
  entity PortfolioTechDiversitySummary  as projection on kpi.PortfolioTechDiversitySummary;
  entity PortfolioDemoReadiness         as projection on kpi.PortfolioDemoReadiness;

   /* Project-level KPI projections (these are metric feeds; not redirect targets) */
  entity ProjectTaskStatusAgg as projection on kpi.ProjectTaskStatusAgg;
  entity ProjectComplexityWeighted as projection on kpi.ProjectComplexityWeighted;
  entity ProjectProcessFootprint as projection on kpi.ProjectProcessFootprint;
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


// annotate portfolio_service with @requires :
// [
//     'authenticated-user'
// ];
