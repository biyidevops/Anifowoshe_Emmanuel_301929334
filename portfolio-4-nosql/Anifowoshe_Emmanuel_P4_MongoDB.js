// 1. Select the database for Alliance Chemicals IT events
db = db.getSiblingDB("it_events")

// 2. Verify the collection is empty before inserting
print("Initial document count:", db.asset_events.countDocuments())

// 3. Insert four fictional asset assignment and return events
db.asset_events.insertMany([
  {
    _id: "EVT001", event_type: "assigned",
    occurred_at: ISODate("2026-10-01T09:00:00Z"),
    staff: { staff_id: 1, full_name: "Chukwudi Okafor" },
    asset: { serial_number: "SN001", category_name: "Laptop" },
    details: { location: "Lagos HQ" }
  },
  {
    _id: "EVT002", event_type: "returned",
    occurred_at: ISODate("2026-10-15T12:00:00Z"),
    staff: { staff_id: 1, full_name: "Chukwudi Okafor" },
    asset: { serial_number: "SN001", category_name: "Laptop" },
    details: { condition: "requires maintenance" }
  },
  {
    _id: "EVT003", event_type: "assigned",
    occurred_at: ISODate("2026-10-16T14:00:00Z"),
    staff: { staff_id: 2, full_name: "Kiprono Mutai" },
    asset: { serial_number: "SN002", category_name: "Monitor" },
    details: { location: "Nairobi Branch" }
  },
  {
    _id: "EVT004", event_type: "assigned",
    occurred_at: ISODate("2026-10-20T09:00:00Z"),
    staff: { staff_id: 2, full_name: "Kiprono Mutai" },
    asset: { serial_number: "SN001", category_name: "Laptop" },
    details: { location: "Nairobi Branch" }
  }
])

// 4. Query: Count total documents
print("Total documents:", db.asset_events.countDocuments())

// 5. Query: Read the event history for Laptop SN001, sorted by date
printjson(
  db.asset_events.find(
    { "asset.serial_number": "SN001" },
    { _id: 1, event_type: 1, occurred_at: 1, details: 1 }
  ).sort({ occurred_at: 1, _id: 1 }).toArray()
)

// 6. Query: Find all returns marked as requiring maintenance
printjson(
  db.asset_events.find({ "details.condition": "requires maintenance" }).toArray()
)