// handlers.js – extended service handlers for the SAP Portfolio CAP project
//
// This handler enriches Projects with dynamic KPI information that cannot be
// derived via static CDS calculated fields alone.  For performance reasons
// CAP recommends using calculated fields for simple row‑level expressions
// and GROUP BY views for aggregated KPIs; only when those options are
// insufficient should you use an on‑read handler.
//
// The enrichment here adds four values per project:
//  • taskCount – total number of tasks belonging to the project.
//  • tasksByStatus – a dictionary summarising tasks by their implementation status.
//  • artifactRichness – counts of artifacts by type across all tasks in the project.
//  • latestActivity – the most recent modifiedAt timestamp from any task, falling
//    back to the project’s own modifiedAt/createdAt when no tasks exist.
//
// The code uses CAP’s query API (SELECT) to aggregate data in a single round
// trip per read request and then attaches the results to each project row.  The
// transaction context (cds.transaction(req)) is used to ensure the queries
// participate in the same unit of work as the original read.

import cds from '@sap/cds';

export default async function () {
  const { Projects, Tasks, Artifacts } = this.entities;

  this.on('READ', Projects, async (req, next) => {
    const result = await next();
    if (!result) return result;
    const rows = Array.isArray(result) ? result : [result];

    const projectIDs = rows.map(r => r.ID);
    if (!projectIDs.length) return result;

    // Run aggregate queries within the same transaction.
    const tx = cds.transaction(req);

    // Aggregate tasks by project and status.
    const taskAgg = await tx.run(
      SELECT.from(Tasks)
        .columns(
          'project_ID as project',
          'implementationStatus_code as status',
          { count: 1, as: 'cnt' }
        )
        .where({ project_ID: { in: projectIDs } })
        .groupBy('project_ID', 'implementationStatus_code')
    );

    // Get the latest modifiedAt per project.
    const lastMod = await tx.run(
      SELECT.from(Tasks)
        .columns(
          'project_ID as project',
          { max: 'modifiedAt', as: 'last' }
        )
        .where({ project_ID: { in: projectIDs } })
        .groupBy('project_ID')
    );

    // Aggregate artifacts by project and type.
    const artAgg = await tx.run(
      SELECT.from(Artifacts)
        .columns(
          'task.project_ID as project',
          'type_code as type',
          { count: 1, as: 'cnt' }
        )
        .where({ 'task.project_ID': { in: projectIDs } })
        .groupBy('task.project_ID', 'type_code')
    );

    // Helper to group rows by project.
    const groupByProject = (arr) => {
      const map = {};
      for (const rec of arr) {
        (map[rec.project] ??= []).push(rec);
      }
      return map;
    };

    const tasksByProj = groupByProject(taskAgg);
    const artsByProj  = groupByProject(artAgg);
    const lastByProj  = {};
    for (const rec of lastMod) {
      lastByProj[rec.project] = rec.last;
    }

    // Enrich each project row.
    for (const row of rows) {
      const pid = row.ID;

      // Build tasksByStatus and taskCount.
      const taskStats = tasksByProj[pid] ?? [];
      const statusMap = {};
      let totalTasks = 0;
      for (const rec of taskStats) {
        statusMap[rec.status] = rec.cnt;
        totalTasks += rec.cnt;
      }
      row.tasksByStatus = statusMap;
      row.taskCount     = totalTasks;

      // Build artifactRichness.
      const artStats = artsByProj[pid] ?? [];
      const artMap = {};
      for (const rec of artStats) {
        artMap[rec.type] = rec.cnt;
      }
      row.artifactRichness = artMap;

      // Set latestActivity, falling back to the project timestamps.
      row.latestActivity = lastByProj[pid] || row.modifiedAt || row.createdAt;
    }

    return result;
  });
}
