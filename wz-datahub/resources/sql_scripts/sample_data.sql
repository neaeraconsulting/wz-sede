-- Insert sample data into the projects table
INSERT INTO public.projects (
    name, description, tmc_notes, active_status, hyperlink, start_date, end_date, districts, 
    wydot_contact, project_update_contact, traffic_control_contact, emergency_contact, contractor, 
    selected_towns, geometry, bbox
) VALUES (
    'Sample Project', 'This is a sample project description.', 'Sample TMC Notes', 'active', 
    'http://example.com', 1622505600000, 1625097600000, ARRAY['District 1', 'District 2'], 
    'John Doe', 'Jane Smith', 'Mike Johnson', 'Emily Davis', 'ABC Contractors', 
    ARRAY['Town 1', 'Town 2'], 
    ST_GeomFromText('LINESTRING(-104.99154242056323 40.48666396485348, -104.99141989037105 40.49613935541723, -104.99150158529784 40.50334545500456, -104.99150158529784 40.511482447125246, -104.99231850345427 40.523169905512134, -104.99240019838105 40.5279514233317, -104.99362562228382 40.533198280829055, -104.99766946775554 40.5466720687468, -105.00016116302476 40.555021048726616, -105.00117383639547 40.56023523479891, -105.0012963787859 40.563803905738155)', 4326), 
    ARRAY[[-104.99154242056323, 40.48666396485348], [-105.0012963787859, 40.563803905738155]]
);

-- Insert sample data into the road_sections table
INSERT INTO public.road_sections (
    project_id, segment_id, segment_name, reference_type, start_mm, end_mm, direction, 
    surface_type, start_date, end_date, armed_status, geometry, bbox
) VALUES (
    1, 1, 'Sample Segment', 'highway', '0.0', '10.0', 'northbound', 
    'paved', 1622505600000, 1625097600000, 'armed', 
    ST_GeomFromText('LINESTRING(-104.991340868648 40.50899145506651, -104.99145231091025 40.51031574054292, -104.99156655675004 40.51219934648688, -104.99173741037231 40.51495127440782, -104.99181394857744 40.516976156121245)', 4326), 
    ARRAY[[-104.991340868648, 40.50899145506651], [-104.99181394857744, 40.516976156121245]]
);

-- Insert sample data into the activity_areas table
INSERT INTO public.activity_areas (
    segment_id, area_name, description, creation_date, update_date, start_date, end_date, 
    start_date_verified, end_date_verified, area_type, location_method, vehicle_impact, 
    impacted_cds_curb_zones, lanes, beginning_cross_street, ending_cross_street, 
    beginning_milepost, ending_milepost, types_of_work, worker_presence, reduced_speed_limit_kph, 
    restrictions, geometry, bbox
) VALUES (
    1, 'Sample Activity Area', 'This is a sample activity area description.', 1622505600000, 
    1625097600000, 1622505600000, 1625097600000, true, true, 'static', 'channel_device_method', 
    'some-lanes-closed', '[]', '[]', 'Cross Street 1', 
    'Cross Street 2', '0.0', '10.0', '[{"type_name": "maintenance", "is_architectural_change": true}]', 
    '{"are_workers_present": true, "definition": "workers-in-work-zone-working", "method": "check-in-app", "worker_presence_last_confirmed_date": 1622505600000, "confidence": "low"}', 
    45.0, '[]', 
    ST_GeomFromText('LINESTRING(-104.99169590366942 40.51455663740333, -104.99164259403933 40.5136650118813)', 4326), 
    ARRAY[[-104.99169590366942, 40.51455663740333], [-104.99164259403933, 40.5136650118813]]
);