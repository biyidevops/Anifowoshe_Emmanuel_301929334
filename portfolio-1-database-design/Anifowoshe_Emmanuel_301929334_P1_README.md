# Portfolio 1 Database Design and Modelling

## Case study
Alliance Chemicals Global IT Procurement and Infrastructure Management System which tracks hardware lifecycles, manage vendor procurements, and log configuration script executions. It serves operating nodes in Nigeria and Kenya by centralising inventory and distributed IT operations data.

## Users
Central IT Administrators manage cross-node infrastructure scripts and system-wide asset tracking. Regional IT Support Staff allocate hardware to local employees, while IT Procurement Officers manage vendor transactions and restock inventory.

## Main operations
Register a new IT vendor; log a new hardware procurement order; add new physical assets to the inventory; assign an asset to a staff member; record the execution output of a Microsoft 365 configuration script; view current stock levels; retrieve a staff member's active asset assignment history.

## Business rules
1.Each staff member and IT vendor must have a uniquely identifiable system ID and email address.

2.A procurement order must reference one valid IT vendor and one specific asset category.

3.Each physical hardware asset has a unique serial number and belongs to one asset category.

4.A physical asset can only be assigned to one staff member at a time.

5.A staff member can have multiple assigned assets, provided they are different physical items.

6.An asset assignment date cannot be in the future, and the return date remains empty until the asset is handed back.

7.An asset cannot be assigned if its status is already marked as deployed or under repair.

8.A script execution log must include a valid timestamp and cannot be modified once recorded in the system.

## Scope
The scope includes tracking IT hardware inventory, basic vendor procurement, staff asset assignments, and logging automated script executions across two regional nodes using fictional data. Financial accounting integrations, automated vendor payments, software licensing costs, and real-time network monitoring telemetry are excluded.