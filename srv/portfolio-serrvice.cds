using sap.portfolio as p from '../db/schema';


service PortfolioService @(path:'/portfolio') {
entity Projects as projection on p.Projects;
entity Tasks as projection on p.Tasks;
entity Artifacts as projection on p.Artifacts;
entity Skills as projection on p.Skills;
entity Certifications as projection on p.Certifications;
entity Industries as projection on p.Industries;
entity ProcessAreas as projection on p.ProcessAreas;
entity ArtifactTypes as projection on p.ArtifactTypes;
entity SkillCategories as projection on p.SkillCategories;
entity ProjectStatuses as projection on p.ProjectStatuses;
entity TaskStatuses as projection on p.TaskStatuses;
}