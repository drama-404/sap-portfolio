import cds from '@sap/cds';

export default async function () {
  const { Projects } = this.entities;

  this.after('READ', Projects, each => {
    // compute number of tasks per project
    if (each.tasks) each.taskCount = each.tasks.length;
  });
};

