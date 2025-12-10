# Living CV/Portfolio

An interactive portfolio application built with SAP Cloud Application Programming Model (CAP) and SAP Fiori Elements.

## Overview

This project showcases my professional experience through a working SAP application rather than a traditional static CV. The application demonstrates real-world SAP development skills including CAP backend development, CDS modeling, Fiori Elements UI, and analytical capabilities.

## What's Inside

- **Interactive Project Portfolio**: Browse through 8 detailed project implementations covering greenfield, brownfield, hybrid implementations, and more
- **Skills Analytics**: Visual representation of technical competencies and proficiency levels
- **Certifications Timeline**: Track professional certifications and academic achievements
- **Technology Mapping**: See which technologies were used across different projects

## Technical Stack

- **Backend**: SAP Cloud Application Programming Model (Node.js)
- **Database**: SQLite (development) / SAP HANA Cloud (production-ready)
- **Frontend**: SAP Fiori Elements (Analytical List Page + Object Page)
- **Data Modeling**: Core Data Services (CDS)
- **API**: OData V4

## Project Structure

```
cv-portfolio/
├── db/                 # Database schema and data models
├── srv/                # Service definitions and business logic
├── app/                # Fiori Elements UI applications
├── package.json        # Project dependencies and configuration
└── README.md
```

## Getting Started

### Prerequisites

- Node.js (version 20 or higher)
- npm

### Installation

```bash
npm install
```

### Run Locally

```bash
npm run watch
```

The application will be available at `http://localhost:4004`

### Deploy Database

```bash
npm run deploy
```

## Development Scripts

- `npm run watch` - Start development server with live reload
- `npm run build` - Build for production
- `npm run deploy` - Deploy database schema
- `npm run clean` - Clean dependencies and generated files

## Features

### Analytical List Page
- Filter projects by type, industry, technologies used
- Visual KPIs showing years of experience, project count, skill distribution
- Interactive charts for technology usage and project timelines
- Responsive table view with detailed project information

### Project Object Pages
- Detailed project descriptions with company context and goals
- Task breakdowns showing specific technical contributions
- Technology tags and architecture diagrams
- Direct links to relevant technical documentation

## Why This Approach?

Building my portfolio as an actual SAP application serves multiple purposes:

1. **Demonstrates Technical Capability**: The application itself showcases proficiency in modern SAP development
2. **Interactive Experience**: Recruiters and stakeholders can explore my experience dynamically rather than reading a static document
3. **Clean Core Principles**: Built following SAP's recommended practices for cloud-native development
4. **Portfolio Piece**: The application is both the portfolio and a portfolio piece

## Contact

**Denada Rama**
Email: denadaramatech@gmail.com
LinkedIn: [denadarama](https://linkedin.com/in/denadarama)
Location: Tirana, Albania
