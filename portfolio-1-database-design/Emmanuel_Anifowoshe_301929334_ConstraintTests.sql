-- Deliberately invalid INSERT statements to test constraints

-- Expected Error: null value in column "name" violates not-null constraint
INSERT INTO public.staff (name, email) 
VALUES (NULL, 'missing@alliancechemicals.org');

-- Expected Error: duplicate key value violates unique constraint "staff_email_key"
INSERT INTO public.staff (name, email) 
VALUES ('Test Member', 'e.ani@alliancechemicals.org');

-- Expected Error: insert or update on table "procurementorder" violates foreign key constraint
INSERT INTO public.procurementorder (vendor_id, order_date) 
VALUES (-1, '2026-04-01');

-- Expected Error: new row for relation "assetassignment" violates check constraint "assignment_date_past_or_present"
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date, return_date) VALUES (
    (SELECT staff_id FROM public.staff WHERE email = 'e.ani@alliancechemicals.org'),
    (SELECT asset_id FROM public.asset WHERE serial_number = 'SN789'),
    '2030-01-01', NULL
);

-- Expected Error: new row for relation "assetassignment" violates check constraint "return_after_assignment"
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date, return_date) VALUES (
    (SELECT staff_id FROM public.staff WHERE email = 'e.ani@alliancechemicals.org'),
    (SELECT asset_id FROM public.asset WHERE serial_number = 'SN789'),
    '2026-05-10', '2026-05-01'
);

-- Expected Error: duplicate key value violates unique constraint "asset_one_open_assignment"
-- SN123 is already actively assigned to James Babalola
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date, return_date) VALUES (
    (SELECT staff_id FROM public.staff WHERE email = 'e.ani@alliancechemicals.org'),
    (SELECT asset_id FROM public.asset WHERE serial_number = 'SN123'),
    '2026-05-01', NULL
);