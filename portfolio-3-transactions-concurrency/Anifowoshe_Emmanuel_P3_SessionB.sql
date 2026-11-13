-- 1. Verify default isolation level
SHOW transaction_isolation;

-- 2. Begin Session B's transaction
BEGIN;

-- 3. Session B attempts to assign the exact same Keyboard (SN999) to staff_id 2.
-- Because Session A has not committed, Session B will hang and wait here.
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date) 
VALUES (2, (SELECT asset_id FROM public.asset WHERE serial_number = 'SN999'), '2026-11-11');

-- STOP HERE! THE TERMINAL IS HANGING. SWITCH BACK TO SESSION A TO RUN COMMIT.

-- 4. Rollback after the unique constraint error occurs (once A commits)
ROLLBACK;

-- 5. Final check to prove only Session A's assignment succeeded
SELECT assignment_id, staff_id, asset_id, assigned_date 
FROM public.assetassignment 
WHERE asset_id = (SELECT asset_id FROM public.asset WHERE serial_number = 'SN999') 
AND return_date IS NULL;