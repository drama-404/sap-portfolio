using { portfolio } from '../db/schema.cds';

@path : '/service/portfolio_service'
service portfolio_service {

  // Core
  entity Projects               as projection on portfolio.Projects;
  entity Tasks                  as projection on portfolio.Tasks;
  entity Artifacts              as projection on portfolio.Artifacts;

  // M:N join helper entities (auto-exposed for tag maintenance & $expand)
  entity ProjectIndustries      as projection on portfolio.ProjectIndustries;
  entity ProjectProcessAreas    as projection on portfolio.ProjectProcessAreas;
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
}


annotate portfolio_service with @requires :
[
    'authenticated-user'
];
