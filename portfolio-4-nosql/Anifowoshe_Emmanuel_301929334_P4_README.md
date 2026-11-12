# Portfolio 4 NoSQL and Advanced Data Models

## Document model
The `it_events` database contains an `asset_events` collection. Each document records one hardware deployment or return event for Alliance Chemicals Global. Its fields are `_id`, `event_type`, `occurred_at`, `staff`, `asset`, and `details`. Staff identification (ID and full name) and hardware data (serial number and category) are embedded directly within the event. Assignment details contain a deployment location (e.g., Lagos HQ or Nairobi Branch), while return details contain the hardware's condition.

Example return document:

```javascript
{
  _id: "EVT002", event_type: "returned",
  occurred_at: ISODate("2026-10-15T12:00:00Z"),
  staff: { staff_id: 1, full_name: "Chukwudi Okafor" },
  asset: { serial_number: "SN001", category_name: "Laptop" },
  details: { condition: "requires maintenance" }
}
```

## Implementation and results
Four fictional lifecycle events were successfully inserted using `mongosh`, yielding a document count of 4. The event history query for Laptop `SN001` successfully tracked its movement, returning `EVT001` (assigned), `EVT002` (returned), and `EVT004` (assigned). Searching for the nested `details.condition` field successfully filtered the database to return `EVT002`, Chukwudi Okafor's laptop return. These events were entered separately as a standalone NoSQL model; the underlying PostgreSQL relational database was not altered.

## Why MongoDB fits
A document-based model allows a single event record to keep its associated staff member, hardware details, and event-specific context entirely self-contained. Assignment events and return events can utilize the `details` sub-document flexibly without forcing the entire collection to adopt empty columns for irrelevant fields. By storing individual events rather than constantly updating a central row, an immutable hardware audit history can grow indefinitely. The embedded names and categories are snapshots and do not automatically track SQL changes. PostgreSQL still handles the concurrency rules; this example does not enforce SQL foreign keys in MongoDB or synchronize the two databases.

## Files
| File | Contents |
| :--- | :--- |
| [Anifowoshe_Emmanuel_301929334_P4_Setup.md](Anifowoshe_Emmanuel_301929334_P4_Setup.md) | Local MongoDB Codespaces setup documentation |
| [Anifowoshe_Emmanuel_301929334_P4_MongoDB.js](Anifowoshe_Emmanuel_301929334_P4_MongoDB.js) | The MongoDB data insertion and query script |
| [screenshots/Anifowoshe_Emmanuel_301929334_P4_MongoDBConnection.png](screenshots/Anifowoshe_Emmanuel_301929334_P4_MongoDBConnection.png) | Screenshot proving successful local database connection |
| [screenshots/Anifowoshe_Emmanuel_301929334_P4_EventsAndQueries.png](screenshots/Anifowoshe_Emmanuel_301929334_P4_EventsAndQueries.png) | Screenshot of the NoSQL query results |

## References
* [MongoDB query embedded documents](https://www.mongodb.com/docs/manual/tutorial/query-embedded-documents/)
* [MongoDB data modeling introduction](https://www.mongodb.com/docs/manual/core/data-modeling-introduction/)