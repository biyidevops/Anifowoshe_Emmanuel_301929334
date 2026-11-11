-- Query 1: Active Asset Assignments
-- This query joins the staff, asset, and assignment tables to list all physical hardware 
-- currently deployed to staff members (where the return date is empty).
SELECT 
    s.name AS staff_name, 
    a.category_name, 
    a.serial_number, 
    aa.assigned_date
FROM 
    public.assetassignment aa
JOIN 
    public.staff s ON aa.staff_id = s.staff_id
JOIN 
    public.asset a ON aa.asset_id = a.asset_id
WHERE 
    aa.return_date IS NULL
ORDER BY 
    aa.assigned_date ASC;

-- Expected result based on sample data:
-- 1. staff_name: James Babalola, category_name: Laptop, serial_number: SN123, assigned_date: 2026-03-20
-- 2. staff_name: Emmanuel Anifowoshe, category_name: Toner, serial_number: SN456, assigned_date: 2026-03-22


-- Query 2: Available IT Assets
-- This query checks for physical hardware in the inventory that is NOT currently 
-- actively assigned to any staff member, making it available for immediate deployment.
SELECT 
    a.category_name, 
    a.serial_number, 
    v.name AS vendor_name
FROM 
    public.asset a
JOIN 
    public.procurementorder po ON a.order_id = po.order_id
JOIN 
    public.vendor v ON po.vendor_id = v.vendor_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM public.assetassignment aa 
    WHERE aa.asset_id = a.asset_id 
    AND aa.return_date IS NULL
)
ORDER BY 
    a.category_name ASC;

-- Expected result based on sample data:
-- 1. category_name: Router, serial_number: SN789, vendor_name: God Pass


-- Query 3: Total Asset Assignments per Staff Member
-- This query counts the total number of historical and active asset assignments 
-- for every staff member. A LEFT JOIN ensures staff with zero assignments are still listed.
SELECT 
    s.name AS staff_name, 
    COUNT(aa.assignment_id) AS total_assignments
FROM 
    public.staff s
LEFT JOIN 
    public.assetassignment aa ON s.staff_id = aa.staff_id
GROUP BY 
    s.staff_id, 
    s.name
ORDER BY 
    total_assignments DESC, 
    staff_name ASC;

-- Expected result based on sample data:
-- 1. staff_name: Emmanuel Anifowoshe, total_assignments: 2 (borrowed SN123 then SN456)
-- 2. staff_name: James Babalola, total_assignments: 1 (borrowing SN123)