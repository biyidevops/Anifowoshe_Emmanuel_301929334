# Portfolio 3 Transactions and Concurrency

## Commit and rollback

The transaction management test successfully demonstrated PostgreSQL's ACID compliance using standard COMMIT and ROLLBACK controls. During the exercise, an active IT asset assignment (assignment_id 2) was successfully returned by updating its `return_date` inside a committed transaction block. When a subsequent transaction block attempted to insert a valid assignment followed by an assignment that deliberately violated a constraint, the database successfully aborted the entire transaction. A ROLLBACK command successfully cleared the aborted state, and final queries confirmed that the invalid assignment was rejected while the previously committed return remained intact.

## Isolation and concurrency control

A two-session concurrency test was conducted under PostgreSQL's default `Read Committed` isolation level. Session A successfully started a transaction and inserted an active assignment for a newly added Keyboard (asset_id 5) without committing. Because of the isolation level, Session B could not read Session A's uncommitted row and attempted to assign the same hardware. Session B was forced to wait. Once Session A executed a COMMIT, Session B re-evaluated its insert, recognized that the newly committed row violated the `asset_one_open_assignment` unique partial index, and threw a duplicate key violation error, proving the system successfully prevents double-assignments of physical hardware.

## Conclusion

The database design successfully manages the critical operational rules of the Alliance Chemicals Global IT Procurement system. By combining standard transaction blocks (BEGIN, COMMIT, ROLLBACK) with targeted unique partial indexes, the schema guarantees that physical hardware cannot be assigned to multiple staff members simultaneously, even when concurrent system users attempt conflicting deployments at the exact same moment. While isolation levels dictate what concurrent sessions can see, it is the underlying structural constraints that definitively enforce the business logic.

## Files

| File | Contents |
| :--- | :--- |
| [Anifowoshe_Emmanuel_301929334_P3_Transactions.sql](Anifowoshe_Emmanuel_301929334_P3_Transactions.sql) | The single-session commit and rollback exercise |
| [Anifowoshe_Emmanuel_301929334_P3_SessionA.sql](Anifowoshe_Emmanuel_301929334_P3_SessionA.sql) | The concurrency script for the first database connection |
| [Anifowoshe_Emmanuel_301929334_P3_SessionB.sql](Anifowoshe_Emmanuel_301929334_P3_SessionB.sql) | The concurrency script for the second database connection |
| [screenshots/Anifowoshe_Emmanuel_301929334_P3_Transactions.png](screenshots/Anifowoshe_Emmanuel_301929334_P3_Transactions.png) | Screenshot of the commit and rollback output |
| [screenshots/Anifowoshe_Emmanuel_301929334_P3_ConcurrencyResult.png)](screenshots/Anifowoshe_Emmanuel_301929334_P3_SessionsWaiting.png) | Screenshot showing Session B waiting on Session A |
| [screenshots/Anifowoshe_Emmanuel_301929334_P3_Outcome.png](screenshots/Anifowoshe_Emmanuel_301929334_P3_Outcome.png) | Screenshot of Session B's error and the final table state |

## References

[PostgreSQL 16 Transaction Isolation](https://www.postgresql.org/docs/16/transaction-iso.html)