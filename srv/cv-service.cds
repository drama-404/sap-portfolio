using cv.portfolio from '../db/schema';

/**
 * CV Portfolio Service
 * Exposes portfolio entities for Fiori Elements List Report + Object Page
 */
service CVPortfolioService {

  /**
   * Projects - Main entity for List Report + Object Page
   * Displays project portfolio with full CRUD capabilities
   */
  entity Projects as projection on portfolio.Projects;

  /**
   * Tasks - Composition child of Projects
   * Displayed as a table section in the Object Page
   */
  entity Tasks as projection on portfolio.Tasks;

  /**
   * Skills - Skills and competencies
   * For separate skills management (optional future use)
   */
  entity Skills as projection on portfolio.Skills;

  /**
   * Certifications - Professional certifications
   * For separate certifications display (optional future use)
   */
  entity Certifications as projection on portfolio.Certifications;

  /**
   * Technologies - Technology master data
   * For value help and reference data
   */
  entity Technologies as projection on portfolio.Technologies;

  /**
   * ProjectTechnologies - Project-Technology association
   * Links projects to technologies with usage details
   * Displayed as a table section in the Object Page
   */
  entity ProjectTechnologies as projection on portfolio.ProjectTechnologies;

  /**
   * Profile - Personal profile information
   * Singleton entity for CV owner details
   */
  @odata.singleton
  entity Profile as projection on portfolio.Profile;

  /**
   * Industries - Code list for industries
   * Used for value help in project industry field
   */
  entity Industries as projection on portfolio.Industries;

  /**
   * ProjectTypes - Code list for project types
   * Used for value help in project type field
   */
  entity ProjectTypes as projection on portfolio.ProjectTypes;
}
