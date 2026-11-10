# Alliance Chemicals Global IT Procurement ER Diagram

```mermaid
erDiagram
    direction LR

    Staff {
        integer staff_id PK
        varchar name
        varchar email UK
    }

    Vendor {
        integer vendor_id PK
        varchar name
        varchar email UK
    }

    ProcurementOrder {
        integer order_id PK
        integer vendor_id FK
        date order_date
    }

    Asset {
        integer asset_id PK
        varchar serial_number UK
        varchar category_name
        varchar status
        integer order_id FK
    }

    AssetAssignment {
        integer assignment_id PK
        integer staff_id FK
        integer asset_id FK
        date assigned_date
        date return_date
    }

    ScriptExecutionLog {
        integer log_id PK
        varchar script_name
        timestamp execution_timestamp
        text output_result
    }

    Vendor ||--o{ ProcurementOrder : "places"
    ProcurementOrder ||--|{ Asset : "contains"
    Staff ||--o{ AssetAssignment : "has"
    Asset ||--o{ AssetAssignment : "assigned via"


## Reading the diagram

PK (Primary Key): A unique identifier for every single record in a table. It ensures no duplicate rows exist.

FK (Foreign Key): A field that links to the primary key of another table, creating a relational bridge between two entities.

UK (Unique Key): A constraint ensuring all values in a specific field are distinct across the table, such as ensuring no two employees share the same email address.

Relationship Symbols
The diagram uses standard crow's foot notation to illustrate how records connect:

|| represents exactly one.

o{ represents zero or many.

|{ represents one or many.

Example: The relationship Vendor ||--o{ ProcurementOrder means that every procurement order must reference exactly one registered vendor. However, a vendor can exist in the system with zero, one, or many associated procurement orders over time.

Optional Fields and Additional Logic
The return_date in the AssetAssignment table is the only optional field in this design, as an asset may be currently in use and not yet returned.

While the keys define the structure, several business rules require additional logic beyond simple table relationships:

CHECK Constraints: Ensuring the assigned_date is not in the future requires a table-level check.

Triggers and Transaction Logic: Verifying an asset's availability status before allowing a new assignment, ensuring an order contains at least one asset category, and maintaining the immutability of the ScriptExecutionLog all require application-level transaction blocks, database triggers, or strictly managed role permissions.