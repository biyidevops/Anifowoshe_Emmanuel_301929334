# Alliance Chemicals Global IT Procurement Database Design

## 1. Entities
I chose six entities to fully support the system's operations while keeping the architecture minimal.

* **Staff:** Employees who receive IT hardware.
* **Vendor:** Suppliers who provide the IT hardware.
* **ProcurementOrder:** Records of hardware purchases made from vendors.
* **Asset:** Physical hardware items purchased in an order.
* **AssetAssignment:** Records of when a staff member receives and returns a physical asset.
* **ScriptExecutionLog:** Immutable records of automated IT infrastructure script runs.

## 2. Attributes and keys
* **Staff:** `staff_id` (Primary Key, integer), `name` (varchar, required), `email` (varchar, required, unique).
* **Vendor:** `vendor_id` (Primary Key, integer), `name` (varchar, required), `email` (varchar, required, unique).
* **ProcurementOrder:** `order_id` (Primary Key, integer), `vendor_id` (Foreign Key, integer, required), `order_date` (date, required).
* **Asset:** `asset_id` (Primary Key, integer), `serial_number` (varchar, required, unique), `category_name` (varchar, required), `status` (varchar, required), `order_id` (Foreign Key, integer, required).
* **AssetAssignment:** `assignment_id` (Primary Key, integer), `staff_id` (Foreign Key, integer, required), `asset_id` (Foreign Key, integer, required), `assigned_date` (date, required), `return_date` (date, optional).
* **ScriptExecutionLog:** `log_id` (Primary Key, integer), `script_name` (varchar, required), `execution_timestamp` (timestamp, required), `output_result` (text, required).

## 3. Relationships
* **Vendor and ProcurementOrder (1:N):** A vendor can have zero or many procurement orders on record. Every procurement order must belong to exactly one vendor.
* **ProcurementOrder and Asset (1:N):** A procurement order can contain one or many physical assets. Every asset must originate from exactly one procurement order.
* **Staff and AssetAssignment (1:N):** A staff member can have zero or many assignment history records, but each assignment record belongs to exactly one staff member.
* **Asset and AssetAssignment (1:N):** A physical asset can have zero or many historical assignments, but each assignment targets exactly one physical asset.
* **ScriptExecutionLog:** This entity stands alone and does not relate to any other table, acting purely as an independent append-only ledger.

## 4. Business rules and constraints
* **Rule 1 (Unique staff and vendor details):** Enforced using Primary Keys for the system IDs and a `UNIQUE` constraint on the email columns for both the Staff and Vendor tables.
* **Rule 2 (Order references one vendor and asset category):** The `vendor_id` Foreign Key enforces the single vendor. To ensure at least one asset category, an application-level check or database trigger ensures a ProcurementOrder cannot exist without at least one linked Asset (which contains the `category_name`).
* **Rule 3 (Unique serial and single category):** Enforced by placing a `UNIQUE` constraint on the `serial_number` column. The `category_name` is a single text field, naturally restricting the asset to one category.
* **Rule 4 (Asset assigned to at most one staff at a time):** A partial unique index on the AssetAssignment table (checking rows where `return_date IS NULL`) prevents concurrent open assignments for the same `asset_id`.
* **Rule 5 (Staff can have multiple different assigned assets):** Handled natively by the one-to-many relationship between Staff and AssetAssignment.
* **Rule 6 (Assignment/Return date logic):** Enforced using a `CHECK` constraint ensuring `assigned_date <= CURRENT_DATE`. A second `CHECK` constraint ensures that if a `return_date` is provided, `return_date >= assigned_date`. The `return_date` allows empty (null) values.
* **Rule 7 (Cannot assign deployed/lost/repair asset):** A database trigger runs before a new assignment is inserted to verify the underlying asset's status. For example, if a staff member requests a laptop, the database checks if its status is 'Available' before allowing the assignment.
* **Rule 8 (Immutable script log timestamp):** The `execution_timestamp` uses a required timestamp data type. Table-level security permissions (`REVOKE UPDATE, DELETE`) ensure records cannot be modified once written.

## 5. Design assumptions
* To keep the design minimal (six entities) while fulfilling Rule 2, I chose to store the asset category as a direct attribute within the Asset table rather than creating a standalone AssetCategory entity.
* I chose not to link ScriptExecutionLog to the Staff table, assuming these scripts are triggered automatically by system schedulers rather than manually by individual staff members.
