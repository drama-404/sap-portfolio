# SAP Portfolio (CAP + Fiori Elements) — Phase 0–1

Portfolio backend ready in CAP with SQLite and OData V4. UI generation comes in Phase 3.

## What this phase includes

* CAP project bootstrapped with `cds init`
* Local runtime with `cds watch`
* Domain skeleton (Projects, Tasks, Artifacts, Skills, Certifications, codelists)
* OData service `PortfolioService` at `/portfolio`
* CSV sample data (comma separated)

## Prerequisites

* Node.js 18.x or 20.x
* BAS or local VS Code with SAP CDS extension
* `@sap/cds` installed in the project

## Create the project

```bash
# in BAS terminal
cd ~ && mkdir sap-portfolio && cd sap-portfolio
cds init
npm install
```

The server restarts on file changes. Default URL: [http://localhost:4004](http://localhost:4004)

## Add a service and schema (skeleton)

Create files:

```
db/schema.cds
srv/portfolio-service.cds
```

**db/schema.cds** (example skeleton)

```cds
namespace sap.portfolio;
using { cuid, managed } from '@sap/cds/common';

entity Projects : cuid, managed {
  title           : String(200);
  subTitle        : String(400);
  startDate       : Date;
  endDate         : Date;
  summary         : LargeString;
}

entity Tasks : cuid, managed { project: Association to Projects; title: String(200); }
```

**srv/portfolio-service.cds**

```cds
using sap.portfolio as p from '../db/schema';
service PortfolioService @(path:'/portfolio') {
  entity Projects as projection on p.Projects;
  entity Tasks    as projection on p.Tasks;
}
```

> Extend these entities as needed. Keep fields minimal for Phase 0–1.

## Seed data (comma-separated CSV)

Create `db/data` and CSV files that match your entity names. Use commas, not semicolons.

Example `db/data/sap.portfolio-Projects.csv`:

```csv
ID,title,subTitle,startDate,endDate,summary
11111111-1111-1111-1111-111111111111,Balocco S/4HANA Greenfield,End-to-end rollout,2024-01-01,2024-06-30,High-level summary
```

Example `db/data/sap.portfolio-Tasks.csv`:

```csv
ID,project_ID,title
22222222-2222-2222-2222-222222222222,11111111-1111-1111-1111-111111111111,Initial Assessment
```

> Tip: If your CLI supports it, `cds add data` can scaffold the data folder. If not available in your version, create `db/data` manually.

## Start in watch mode (recommended)

```bash
cds watch
```

## Verify the service

Open:

* **Metadata:** `GET http://localhost:4004/portfolio/$metadata`
* **Projects:** `GET http://localhost:4004/portfolio/Projects`

## Project layout (minimum)

```
.
├─ db/
│  ├─ schema.cds
│  └─ data/
│     ├─ sap.portfolio-Projects.csv
│     └─ sap.portfolio-Tasks.csv
├─ srv/
│  └─ portfolio-service.cds
├─ package.json
└─ README.md
```

## Next phases

* Phase 2: enrich model and seed realistic data from your portfolio PDFs
* Phase 3: generate a Fiori elements V4 List Report/Object Page for `Projects`
