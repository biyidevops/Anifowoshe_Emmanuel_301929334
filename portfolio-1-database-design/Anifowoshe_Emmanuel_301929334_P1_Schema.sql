-- Alliance Chemicals Global IT Procurement System
-- Note: Limits to assigning deployed hardware and script immutability
-- require later transaction logic/triggers and are not enforced by these definitions alone.
BEGIN;

-- 1. Create Staff table
CREATE TABLE public.staff (
    staff_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE
);

-- 2. Create Vendor table
CREATE TABLE public.vendor (
    vendor_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE
);

-- 3. Create ProcurementOrder table
CREATE TABLE public.procurementorder (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vendor_id BIGINT NOT NULL,
    order_date DATE NOT NULL,
    CONSTRAINT order_vendor_fk
        FOREIGN KEY (vendor_id) REFERENCES public.vendor (vendor_id)
);

-- 4. Create Asset table
CREATE TABLE public.asset (
    asset_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    serial_number VARCHAR(100) NOT NULL UNIQUE,
    category_name VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    order_id BIGINT NOT NULL,
    CONSTRAINT asset_order_fk
        FOREIGN KEY (order_id) REFERENCES public.procurementorder (order_id)
);

-- 5. Create AssetAssignment table
CREATE TABLE public.assetassignment (
    assignment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staff_id BIGINT NOT NULL,
    asset_id BIGINT NOT NULL,
    assigned_date DATE NOT NULL,
    return_date DATE,
    CONSTRAINT assignment_staff_fk
        FOREIGN KEY (staff_id) REFERENCES public.staff (staff_id),
    CONSTRAINT assignment_asset_fk
        FOREIGN KEY (asset_id) REFERENCES public.asset (asset_id),
    CONSTRAINT assignment_date_past_or_present
        CHECK (assigned_date <= CURRENT_DATE),
    CONSTRAINT return_after_assignment
        CHECK (return_date IS NULL OR return_date >= assigned_date)
);

-- 6. Create ScriptExecutionLog table
CREATE TABLE public.scriptexecutionlog (
    log_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    script_name VARCHAR(150) NOT NULL,
    execution_timestamp TIMESTAMP NOT NULL,
    output_result TEXT NOT NULL
);

-- 7. Add partial unique index for Rule 4 (Asset assigned to at most one staff at a time)
CREATE UNIQUE INDEX asset_one_open_assignment
    ON public.assetassignment (asset_id)
    WHERE return_date IS NULL;

COMMIT;