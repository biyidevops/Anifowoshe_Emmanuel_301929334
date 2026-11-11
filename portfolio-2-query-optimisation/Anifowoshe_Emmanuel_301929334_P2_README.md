# Portfolio 2 Query Processing and Optimisation

## Queries and results

The Active Asset Assignments query returned two current deployments: James Babalola borrowing a Laptop and Emmanuel Anifowoshe borrowing a Toner. The Available IT Assets query successfully identified one Router (SN789 from God Pass) that has no active assignment record. Finally, the Total Asset Assignments query returned counts for all staff, showing Emmanuel Anifowoshe with 2 historical/active assignments and James Babalola with 1.

## Index comparison

| State | Scan Type | Run 1 | Run 2 | Run 3 | Median Time | Buffer Hits (Run 3) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Before Index | Sequential Scan | 226.917 ms | 5.336 ms | 5.850 ms | 5.850 ms | 736 |
| After Index | Bitmap Heap Scan | 0.616 ms | 0.459 ms | 0.415 ms | 0.459 ms | 70 |

## Performance analysis

Before indexing, the planner used a Sequential Scan to read all 100,000 rows to find the 1,674 matches, resulting in 736 shared buffer hits and a median execution time of 5.850 ms. After creating a B-tree index on `assigned_date`, the planner switched to a Bitmap Index Scan followed by a Bitmap Heap Scan, which drastically reduced the necessary buffer hits to 70 and lowered the median execution time to 0.459 ms. The first run in both tests was noticeably slower due to initial disk I/O and data loading into memory (caching). While this specific date-range query was much faster, adding an index does not automatically guarantee faster queries across the board, and it introduces permanent storage costs and write overhead whenever new asset assignments are inserted or updated.

## Files

| File | Contents |
| :--- | :--- |
| [Anifowoshe_Emmanuel_301929334_P2_Queries.sql](Anifowoshe_Emmanuel_301929334_P2_Queries.sql) | The three Portfolio 2 queries and the benchmarking SQL |
| [screenshots/Anifowoshe_Emmanuel_301929334_P2_QueryResults.txt](screenshots/Anifowoshe_Emmanuel_301929334_P2_QueryResults.txt) | Terminal output of the three query results |
| [screenshots/Anifowoshe_Emmanuel_301929334_P2_BeforeIndex.png](screenshots/Anifowoshe_Emmanuel_301929334_P2_BeforeIndex.png) | Screenshot of the EXPLAIN ANALYZE execution plan before indexing |
| [screenshots/Anifowoshe_Emmanuel_301929334_P2_AfterIndex.png](screenshots/Anifowoshe_Emmanuel_301929334_P2_AfterIndex.png) | Screenshot of the EXPLAIN ANALYZE execution plan after indexing |

## Reference

[PostgreSQL 16 EXPLAIN](https://www.postgresql.org/docs/16/sql-explain.html)