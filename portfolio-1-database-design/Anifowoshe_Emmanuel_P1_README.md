# Portfolio 1 Database Design and Modelling

## Case study

Alliance Chemicals Global IT Procurement and Infrastructure Management System which tracks hardware lifecycles, manage vendor procurements, and log configuration script executions. It serves operating nodes in Nigeria and Kenya by centralising inventory and distributed IT operations data.

## Users

Central IT Administrators manage cross-node infrastructure scripts and system-wide asset tracking. Regional IT Support Staff allocate hardware to local employees, while IT Procurement Officers manage vendor transactions and restock inventory.

## Main operations

Register a new IT vendor; log a new hardware procurement order; add new physical assets to the inventory; assign an asset to a staff member; record the execution output of a Microsoft 365 configuration script; view current stock levels; retrieve a staff member's active asset assignment history.

## Business rules

1. Each staff member and IT vendor must have a uniquely identifiable system ID and email address.
2. A procurement order must reference one valid IT vendor and one specific asset category.
3. Each physical hardware asset has a unique serial number and belongs to one asset category.
4. A physical asset can only be assigned to one staff member at a time.
5. A staff member can have multiple assigned assets, provided they are different physical items.
6. An asset assignment date cannot be in the future, and the return date remains empty until the asset is handed back.
7. An asset cannot be assigned if its status is already marked as deployed or under repair.
8. A script execution log must include a valid timestamp and cannot be modified once recorded in the system.

## Scope

The scope includes tracking IT hardware inventory, basic vendor procurement, staff asset assignments, and logging automated script executions across two regional nodes using fictional data. Financial accounting integrations, automated vendor payments, software licensing costs, and real-time network monitoring telemetry are excluded.

## Design and implementation files

| File | Contents |
| --- | --- |
| [Anifowoshe_Emmanuel_P1_Design.md](Anifowoshe_Emmanuel_P1_Design.md) | Database design and business rules |
| [Anifowoshe_Emmanuel_P1_ERDiagram.md](Anifowoshe_Emmanuel_P1_ERDiagram.md) | Entity-Relationship diagram |
| [Anifowoshe_Emmanuel_P1_Normalisation.md](Anifowoshe_Emmanuel_P1_Normalisation.md) | Normalisation explanation with example tables |
| [Anifowoshe_Emmanuel_P1_Schema.sql](Anifowoshe_Emmanuel_P1_Schema.sql) | PostgreSQL table creation script |
| [Anifowoshe_Emmanuel_SampleData.sql](Anifowoshe_Emmanuel_SampleData.sql) | Valid sample records |
| [Anifowoshe_Emmanuel_ConstraintTests.sql](Anifowoshe_Emmanuel_ConstraintTests.sql) | Invalid records for constraint testing |
| [screenshots/](screenshots/) | Terminal execution and test result screenshots |

## Implementation

The database runs on PostgreSQL in a GitHub Codespaces environment. Its name is `alliance_it_portfolio`. The schema creates `staff`, `vendor`, `procurementorder`, `asset`, `assetassignment`, and `scriptexecutionlog`. Each table has an automatically generated primary key. Foreign keys link orders to vendors, assets to orders, and assignments to both staff and assets.

Staff and vendor emails and asset serial numbers are unique. Assignment date checks prevent an assignment in the future and a return before the assignment date. The `asset_one_open_assignment` index allows at most one active assignment per physical asset while retaining historical closed assignments.

The schema and sample statements were executed in order and committed. The invalid inserts were then run separately, outside a transaction block, to check each rule independently.

## Test results

All six invalid inserts were rejected by the intended rule: a missing staff name, repeated staff email, nonexistent vendor link, assignment date in the future, return before assignment, and second open assignment for an already deployed asset. The screenshots show the corresponding errors.

After the tests, the database contains 2 staff members, 1 vendor, 1 procurement order, 3 assets, 3 asset assignments, and 1 script execution log. The failed inserts added no rows.

These tests cover the listed constraints. The rules preventing the assignment of already deployed hardware and ensuring script log immutability still require application-level transaction logic and role permissions; the table definitions alone do not enforce them.

Reference: [PostgreSQL 16 constraints](https://www.postgresql.org/docs/16/ddl-constraints.html).
