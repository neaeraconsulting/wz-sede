CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SEQUENCE IF NOT EXISTS public.projects_id_seq
   INCREMENT 1
   START 1
   MINVALUE 1
   MAXVALUE 2147483647
   CACHE 1;

CREATE TABLE IF NOT EXISTS public.projects (
    id integer NOT NULL DEFAULT nextval('projects_id_seq'::regclass),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    tmc_notes TEXT,
    active_status VARCHAR(255) NOT NULL,
    hyperlink TEXT,
    start_date BIGINT,
    end_date BIGINT,
    districts TEXT[],
    wydot_contact VARCHAR(255),
    project_update_contact VARCHAR(255),
    traffic_control_contact VARCHAR(255),
    emergency_contact VARCHAR(255),
    contractor VARCHAR(255),
    selected_towns TEXT[],
    geometry GEOMETRY(LineString, 4326) NOT NULL, -- Storing as LineString
    bbox FLOAT8[][],
    CONSTRAINT project_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE IF NOT EXISTS public.road_sections_id_seq
   INCREMENT 1
   START 1
   MINVALUE 1
   MAXVALUE 2147483647
   CACHE 1;

CREATE TABLE IF NOT EXISTS public.road_sections (
    id integer NOT NULL DEFAULT nextval('road_sections_id_seq'::regclass),
    project_id INT NOT NULL,
    segment_id INT NOT NULL,
    segment_name VARCHAR(255),
    reference_type VARCHAR(255) NOT NULL,
    start_mm VARCHAR(255) NOT NULL,
    end_mm VARCHAR(255) NOT NULL,
    direction VARCHAR(255) NOT NULL,
    surface_type VARCHAR(255) NOT NULL,
    start_date BIGINT,
    end_date BIGINT,
    armed_status VARCHAR(255) NOT NULL,
    geometry GEOMETRY(LineString, 4326) NOT NULL, -- Storing as LineString
    bbox FLOAT8[][],
    CONSTRAINT road_section_pkey PRIMARY KEY (id),
    CONSTRAINT road_section_project_segment UNIQUE (project_id, id)
);

CREATE SEQUENCE IF NOT EXISTS public.activity_areas_id_seq
   INCREMENT 1
   START 1
   MINVALUE 1
   MAXVALUE 2147483647
   CACHE 1;

CREATE TABLE IF NOT EXISTS public.activity_areas (
    id integer NOT NULL DEFAULT nextval('activity_areas_id_seq'::regclass),
    segment_id INT NOT NULL,
    area_name VARCHAR(255) NOT NULL,
    description TEXT,
    creation_date BIGINT NOT NULL,
    update_date BIGINT NOT NULL,
    start_date BIGINT NOT NULL,
    end_date BIGINT NOT NULL,
    start_date_verified BOOLEAN,
    end_date_verified BOOLEAN,
    area_type VARCHAR(255) NOT NULL,
    location_method VARCHAR(255) NOT NULL,
    vehicle_impact VARCHAR(255) NOT NULL,
    impacted_cds_curb_zones JSONB, -- Storing as JSONB
    lanes JSONB, -- Storing as JSONB
    beginning_cross_street VARCHAR(255),
    ending_cross_street VARCHAR(255),
    beginning_milepost VARCHAR(255),
    ending_milepost VARCHAR(255),
    types_of_work JSONB NOT NULL, -- Storing as JSONB
    worker_presence JSONB, -- Storing as JSONB
    reduced_speed_limit_kph FLOAT,
    restrictions JSONB, -- Storing as JSONB
    geometry GEOMETRY(LineString, 4326) NOT NULL, -- Storing as LineString
    bbox FLOAT8[][],
    CONSTRAINT activity_area_pkey PRIMARY KEY (id),
    CONSTRAINT activity_area_segment_area UNIQUE (segment_id, id)
);

CREATE SEQUENCE IF NOT EXISTS public.reports_id_seq
   INCREMENT 1
   START 1
   MINVALUE 1
   MAXVALUE 2147483647
   CACHE 1;

CREATE TABLE IF NOT EXISTS public.reports (
    id INTEGER NOT NULL DEFAULT nextval('reports_id_seq'::regclass),
    project_id INT,
    segment_id INT,
    area_id INT,
    report_name VARCHAR(255) NOT NULL,
    types_of_work JSONB NOT NULL, -- Storing as JSONB
    workers_present BOOLEAN NOT NULL,
    start_date BIGINT,
    end_date BIGINT,
    report_date BIGINT NOT NULL,
    area_type VARCHAR(255) NOT NULL, -- Assuming WorkZoneType is a VARCHAR
    mobility_speed_mph FLOAT,
    geometry_type VARCHAR(255) NOT NULL,
    geometry GEOMETRY(MultiPoint, 4326) NOT NULL,
    geometry_line_width FLOAT,
    license_plate VARCHAR(255),
    surface_type VARCHAR(255),
    CONSTRAINT reports_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE IF NOT EXISTS public.recordings_id_seq
   INCREMENT 1
   START 1
   MINVALUE 1
   MAXVALUE 2147483647
   CACHE 1;

CREATE TABLE IF NOT EXISTS public.recordings (
    id INTEGER NOT NULL DEFAULT nextval('recordings_id_seq'::regclass),
    project_id INT,
    segment_id INT,
    area_id INT,
    recording_name VARCHAR(255) NOT NULL,
    types_of_work JSONB NOT NULL, -- Storing as JSONB
    start_date BIGINT,
    end_date BIGINT,
    recording_date BIGINT NOT NULL,
    area_type VARCHAR(255) NOT NULL,
    mobility_speed_mph FLOAT,
    surface_type VARCHAR(255),
    points JSONB, -- Storing as JSONB
    CONSTRAINT recordings_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE IF NOT EXISTS public.wzdx_recordings_id_seq
   INCREMENT 1
   START 1
   MINVALUE 1
   MAXVALUE 2147483647
   CACHE 1;

CREATE TABLE IF NOT EXISTS public.wzdx_recordings (
    id INTEGER NOT NULL DEFAULT nextval('wzdx_recordings_id_seq'::regclass),
    project_id INT,
    segment_id INT,
    area_id INT,
    features JSONB NOT NULL, -- Storing features array as JSONB
    types_of_work JSONB NOT NULL, -- Storing as JSONB
    start_date BIGINT,
    end_date BIGINT,
    creation_date BIGINT NOT NULL,
    area_type VARCHAR(255) NOT NULL,
    CONSTRAINT wzdx_recordings_pkey PRIMARY KEY (id)
);