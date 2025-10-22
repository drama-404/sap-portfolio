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

  entity PortfolioTotals                as projection on kpi.PortfolioTotals;
  entity PortfolioTaskTotals            as projection on kpi.PortfolioTaskTotals;
  entity PortfolioCompletion            as projection on kpi.PortfolioCompletion;
  entity PortfolioExtensionMix          as projection on kpi.PortfolioExtensionMix;
  // entity ProjectProcessCoverage         as projection on kpi.ProjectProcessCoverage;
  // @cds.redirection.target: false
  // entity ProjectTechDiversity           as projection on kpi.ProjectTechDiversity;
  // @cds.redirection.target: false
  // entity PortfolioTechDiversitySummary  as projection on kpi.PortfolioTechDiversitySummary;
  // @cds.redirection.target: false
  // entity PortfolioDemoReadiness         as projection on kpi.PortfolioDemoReadiness;
}


annotate portfolio_service with @requires :
[
    'authenticated-user'
];
