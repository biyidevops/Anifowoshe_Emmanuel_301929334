# Alliance Chemicals Global IT Procurement Normalisation

Normalisation separates information into related tables to reduce repeated details and avoid inconsistent updates. The same four assignments are used below. Only the fields needed to explain the changes are shown; the full design keeps the other fields from the design document.

Dates are shortened for readability. assigned_date represents the full assignment date. Names and emails are fictional.

## Starting assignment list

| staff_id | name | email | Assigned assets |
| --- | --- | --- | --- |
| 1 | Emmanuel Anifowoshe | e.ani@alliancechemicals.org | Asset 10: Laptop, order 101, vendor 50, God Pass, assigned 2026-01-15; Asset 11: Toner, order 101, vendor 50, God Pass, assigned 2026-01-15 |
| 2 | James Babalola | j.baba@alliancechemicals.org | Asset 10: Laptop, order 101, vendor 50, God Pass, assigned 2026-03-20 |
| 3 | Chioma Phillips | c.phillips@alliancechemicals.org | Asset 12: Router, order 102, vendor 60, Dozzytech, assigned 2026-04-10 |

The first row contains two assignments in one cell. Finding one assignment or recording its return is awkward. Asset 10's first assignment ends before it is assigned again to James.

## 1NF: One value per cell

Each assignment has its own row. The repeated list is removed.

| asset_id | assigned_date | staff_id | name | email | category_name | order_id | vendor_id | vendor_name |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 10 | 2026-01-15 | 1 | Emmanuel Anifowoshe | e.ani@alliancechemicals.org | Laptop | 101 | 50 | God Pass |
| 11 | 2026-01-15 | 1 | Emmanuel Anifowoshe | e.ani@alliancechemicals.org | Toner | 101 | 50 | God Pass |
| 10 | 2026-03-20 | 2 | James Babalola | j.baba@alliancechemicals.org | Laptop | 101 | 50 | God Pass |
| 12 | 2026-04-10 | 3 | Chioma Phillips | c.phillips@alliancechemicals.org | Router | 102 | 60 | Dozzytech |

For this example, the key is **(asset_id, assigned_date)**. Both values together identify one assignment, assuming an asset cannot be assigned twice at the exact same instant. asset_id alone is not enough: asset 10 appears twice.

The rows are in 1NF, but the vendor name is repeated. Correcting its spelling requires changing every related row.

## 2NF: Details depend on the whole key

2NF includes 1NF. A non-key field must not depend on only part of a combined key.

Here, **asset_id alone determines category_name, order_id, vendor_id, and vendor_name**. Those details belong to the physical hardware, regardless of when it is assigned. They move into a separate table.

### Asset details

Key: **asset_id**.

| asset_id | category_name | order_id | vendor_id | vendor_name |
| --- | --- | --- | --- | --- |
| 10 | Laptop | 101 | 50 | God Pass |
| 11 | Toner | 101 | 50 | God Pass |
| 12 | Router | 102 | 60 | Dozzytech |

### Assignment details

Key: **(asset_id, assigned_date)**. asset_id links to Asset details.

| asset_id | assigned_date | staff_id | name | email |
| --- | --- | --- | --- | --- |
| 10 | 2026-01-15 | 1 | Emmanuel Anifowoshe | e.ani@alliancechemicals.org |
| 11 | 2026-01-15 | 1 | Emmanuel Anifowoshe | e.ani@alliancechemicals.org |
| 10 | 2026-03-20 | 2 | James Babalola | j.baba@alliancechemicals.org |
| 12 | 2026-04-10 | 3 | Chioma Phillips | c.phillips@alliancechemicals.org |

The asset details no longer repeat for every assignment of an item. However, the vendor name still repeats across assets from the same supplier, and Emmanuel's email still repeats across his assignments.

## 3NF: Keep details with the thing they describe

3NF includes 2NF. Non-key fields must not depend on another non-key field. Two remaining links explain the next split:

- **order_id determines vendor_id, and vendor_id determines vendor_name**: the vendor name describes the supplier, not the individual hardware asset.
- **staff_id determines name and email**: these describe the staff member, not the assignment itself.

### Vendor

Key: **vendor_id**.

| vendor_id | vendor_name |
| --- | --- |
| 50 | God Pass |
| 60 | Dozzytech |

### ProcurementOrder

Key: **order_id**. vendor_id is a foreign key to Vendor.

| order_id | vendor_id |
| --- | --- |
| 101 | 50 |
| 102 | 60 |

### Asset

Key: **asset_id**. order_id is a foreign key to ProcurementOrder.

| asset_id | category_name | order_id |
| --- | --- | --- |
| 10 | Laptop | 101 |
| 11 | Toner | 101 |
| 12 | Router | 102 |

### Staff

Key: **staff_id**.

| staff_id | name | email |
| --- | --- | --- |
| 1 | Emmanuel Anifowoshe | e.ani@alliancechemicals.org |
| 2 | James Babalola | j.baba@alliancechemicals.org |
| 3 | Chioma Phillips | c.phillips@alliancechemicals.org |

### AssetAssignment

The final design uses **assignment_id** as its primary key, rather than relying on an assignment date to identify a record. staff_id and asset_id are foreign keys. Adding an ID is a design choice, not what makes a table 3NF.

| assignment_id | staff_id | asset_id | assigned_date |
| --- | --- | --- | --- |
| 100 | 1 | 10 | 2026-01-15 |
| 101 | 1 | 11 | 2026-01-15 |
| 102 | 2 | 10 | 2026-03-20 |
| 103 | 3 | 12 | 2026-04-10 |

Now Emmanuel's email is stored once in Staff, and the vendor name is stored once in Vendor. The IDs preserve the links, so the assignment details can still be brought together when needed.

These are five of the tables in the ER diagram (ScriptExecutionLog stands independently). The complete schema also includes serial_number, order_date, status, and return_date. Unique values, date checks, and the one-open-assignment rule remain necessary; normalisation does not enforce those rules by itself.