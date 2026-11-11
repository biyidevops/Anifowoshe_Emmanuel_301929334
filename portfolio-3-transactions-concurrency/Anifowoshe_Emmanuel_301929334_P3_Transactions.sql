-- 1. Starting-data check: verify the active assignment we plan to return.
-- Expected result: 1 row showing assignment_id 2 with no return_date.
SELECT assignment_id, asset_id, assigned_date, return_date 
FROM public.assetassignment 
WHERE assignment_id = 2;


-- 2. BEGIN, a meaningful update, and COMMIT.
BEGIN;

-- We return the laptop (asset_id 1) by setting its return date to a valid date after its assignment.
-- The WHERE clause ensures this only updates if the asset hasn't already been returned.
UPDATE public.assetassignment 
SET return_date = '2026-11-11' 
WHERE assignment_id = 2 AND return_date IS NULL;

COMMIT;

-- Repeat check: running the update again will affect 0 rows because return_date is no longer NULL.
UPDATE public.assetassignment 
SET return_date = '2026-11-11' 
WHERE assignment_id = 2 AND return_date IS NULL;


-- 3. BEGIN, a valid change, a constraint violation, and ROLLBACK.
BEGIN;

-- A valid insert: Assign the available router (asset_id 3) to staff_id 1.
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date) 
VALUES (1, 3, '2026-11-11');

-- A deliberate violation: Try to assign the router (asset_id 3) a second time while it is currently deployed.
-- Expected result: ERROR: duplicate key value violates unique constraint "asset_one_open_assignment"
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date) 
VALUES (2, 3, '2026-11-11');

-- The transaction is now in an aborted state due to the error, so we roll it back.
ROLLBACK;


-- 4. Final queries proving the final state.
-- Prove the committed change remains: assignment_id 2 now has a return_date of 2026-11-11.
SELECT assignment_id, asset_id, return_date 
FROM public.assetassignment 
WHERE assignment_id = 2;

-- Prove the rolled-back change is gone: no active assignment exists for asset_id 3.
SELECT assignment_id, staff_id, asset_id 
FROM public.assetassignment 
WHERE asset_id = 3;