-- Valid sample data for Alliance Chemicals IT Procurement
BEGIN;

-- Add the staff
INSERT INTO public.staff (name, email) VALUES 
('Emmanuel Anifowoshe', 'e.ani@alliancechemicals.org'),
('James Babalola', 'j.baba@alliancechemicals.org');

-- Add a vendor
INSERT INTO public.vendor (name, email) VALUES 
('God Pass', 'contact@godpass.com');

-- Add a procurement order
INSERT INTO public.procurementorder (vendor_id, order_date) VALUES 
((SELECT vendor_id FROM public.vendor WHERE name = 'God Pass'), '2026-01-10');

-- Add three physical assets
INSERT INTO public.asset (serial_number, category_name, status, order_id) VALUES 
('SN123', 'Laptop', 'Available', (SELECT order_id FROM public.procurementorder WHERE order_date = '2026-01-10')),
('SN456', 'Toner', 'Available', (SELECT order_id FROM public.procurementorder WHERE order_date = '2026-01-10')),
('SN789', 'Router', 'Available', (SELECT order_id FROM public.procurementorder WHERE order_date = '2026-01-10'));

-- Add a returned assignment (Emmanuel borrowed SN123 and returned it)
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date, return_date) VALUES (
    (SELECT staff_id FROM public.staff WHERE email = 'e.ani@alliancechemicals.org'),
    (SELECT asset_id FROM public.asset WHERE serial_number = 'SN123'),
    '2026-01-15', '2026-02-15'
);

-- Add two open assignments (James borrows SN123; Emmanuel borrows SN456)
INSERT INTO public.assetassignment (staff_id, asset_id, assigned_date, return_date) VALUES (
    (SELECT staff_id FROM public.staff WHERE email = 'j.baba@alliancechemicals.org'),
    (SELECT asset_id FROM public.asset WHERE serial_number = 'SN123'),
    '2026-03-20', NULL
), (
    (SELECT staff_id FROM public.staff WHERE email = 'e.ani@alliancechemicals.org'),
    (SELECT asset_id FROM public.asset WHERE serial_number = 'SN456'),
    '2026-03-22', NULL
);

-- Add one script execution log
INSERT INTO public.scriptexecutionlog (script_name, execution_timestamp, output_result) VALUES 
('Set-OutlookDefaultFont', '2026-04-01 10:00:00', 'Success: 50 mailboxes updated.');

COMMIT;