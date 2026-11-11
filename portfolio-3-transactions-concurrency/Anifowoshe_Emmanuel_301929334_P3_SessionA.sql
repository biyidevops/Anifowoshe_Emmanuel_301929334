-- 1. Check starting state: The new keyboard (SN999) has no active assignments.
SELECT assignment_id, staff_id, return_date 
FROM public.assetassignment 
WHERE asset_id = (SELECT asset_id FROM public.asset WHERE serial_number = 'SN999') 
AND return_date IS NULL;

-- 2. Verify default isolation level
SHOW transaction_isolation;

-- 3. Begin Session A's transaction
BEGIN;

-- 4. Session A claims the new Keyboard (SN999) for staff_id 1.
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date) 
VALUES (1, (SELECT asset_id FROM public.asset WHERE serial_number = 'SN999'), '2026-11-11');

-- STOP HERE! SWITCH TO SESSION B TO START ITS TRANSACTION.
-- DO NOT RUN COMMIT UNTIL SESSION B IS WAITING.

-- 5. Commit Session A's transaction
COMMIT;

-- SWITCH BACK TO SESSION B TO OBSERVE THE ERROR AND ROLLBACK.