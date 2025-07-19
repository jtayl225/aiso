--------------------
-- countries
--------------------
CREATE TABLE countries (
  alpha2 CHAR(2) PRIMARY KEY CHECK (alpha2 ~ '^[A-Z]{2}$'),  -- ISO 3166-1 alpha-2, e.g., 'AU'
  alpha3 CHAR(3) UNIQUE CHECK (alpha3 ~ '^[A-Z]{3}$'),  -- ISO 3166-1 alpha-3, e.g., 'AUS'
  name TEXT NOT NULL                                       -- e.g., 'Australia'
);

--------------------
-- regions
--------------------
CREATE TABLE regions (
  code TEXT PRIMARY KEY CHECK (code ~ '^[A-Z]{2,4}$'),             -- 'VIC'
  name TEXT NOT NULL,                   -- 'Victoria'
  country_code CHAR(2) REFERENCES countries(alpha2) ON DELETE CASCADE,
  iso_code TEXT GENERATED ALWAYS AS (
    country_code || '-' || code
  ) STORED , -- 'AU-VIC'

  UNIQUE (iso_code)                  
);

--------------------
-- localities
--------------------
-- Enable PostGIS extension
create extension if not exists postgis;

-- dont need post code
CREATE TABLE localities (

  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  region_iso_code TEXT NOT NULL REFERENCES regions(iso_code) ON DELETE CASCADE,
  name TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,

  iana_timezone TEXT CHECK (iana_timezone ~ '^[A-Za-z]+(?:/[A-Za-z_\-]+)+$'), -- add this column

  -- automatically generated hash of normalised prompt
  locality_hash TEXT, -- Populate via trigger

  -- locality_hash text GENERATED ALWAYS AS (
  --   encode(digest(lower(trim(concat(region_iso_code,name))), 'sha256'), 'hex')
  -- ) STORED,

  location geography(Point, 4326), -- Populate via trigger

  UNIQUE (region_iso_code, name)
);

CREATE INDEX ON localities USING GIST (location);

--------------------
-- localities - function
--------------------
CREATE OR REPLACE FUNCTION set_locality_fields() RETURNS trigger AS $$
BEGIN
  -- Set the geospatial point from longitude/latitude
  NEW.location := ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326);

  -- Set the deterministic hash of region_iso_code + name
  NEW.locality_hash := encode(
    digest(lower(trim(NEW.region_iso_code || NEW.name)), 'sha256'),
    'hex'
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--------------------
-- localities - trigger
--------------------
CREATE TRIGGER trigger_set_locality_fields
BEFORE INSERT OR UPDATE ON localities
FOR EACH ROW EXECUTE FUNCTION set_locality_fields();

--------------------
-- find_nearby_localities - function
--------------------
CREATE OR REPLACE FUNCTION find_nearby_localities(
  lat DOUBLE PRECISION,
  lon DOUBLE PRECISION,
  radius INTEGER DEFAULT 5000,
  result_limit INTEGER DEFAULT 10
)
RETURNS TABLE (
  id UUID,
  region_iso_code TEXT,
  name TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  iana_timezone TEXT,
  locality_hash TEXT,
  location GEOGRAPHY,
  distance_meters DOUBLE PRECISION
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    l.id,
    l.region_iso_code,
    l.name,
    l.latitude,
    l.longitude,
    l.iana_timezone,
    l.locality_hash,
    l.location,
    ST_Distance(
      l.location,
      ST_SetSRID(ST_MakePoint(lon, lat), 4326)
    ) AS distance_meters
  FROM localities l
  WHERE ST_DWithin(
    l.location,
    ST_SetSRID(ST_MakePoint(lon, lat), 4326),
    radius
  )
  ORDER BY distance_meters ASC
  LIMIT result_limit;
END;
$$ LANGUAGE plpgsql STABLE;

-- SELECT * FROM find_nearby_localities(-38.148, 145.146, 5000, 10);

-- final response = await supabase.rpc('find_nearby_localities', params: {
--   'lat': -38.148,
--   'lon': 145.146,
--   'radius': 5000,
--   'result_limit': 10,
-- });

--------------------
-- insert data
--------------------
-- countries
INSERT INTO countries (alpha2, alpha3, name)
VALUES ('AU', 'AUS', 'Australia')
ON CONFLICT (alpha2) DO NOTHING;


-- regions
INSERT INTO regions (code, name, country_code)
VALUES 
  ('NSW', 'New South Wales', 'AU'),
  ('VIC', 'Victoria', 'AU'),
  ('QLD', 'Queensland', 'AU'),
  ('WA',  'Western Australia', 'AU'),
  ('SA',  'South Australia', 'AU'),
  ('TAS', 'Tasmania', 'AU'),
  ('ACT', 'Australian Capital Territory', 'AU'),
  ('NT',  'Northern Territory', 'AU')
ON CONFLICT (code) DO NOTHING;

-- localities
INSERT INTO localities (region_iso_code, name, latitude, longitude)
VALUES
  ('AU-VIC', 'Frankston', -38.148005, 145.146311),
  ('AU-VIC', 'Frankston South', -38.17745, 145.12996),
  ('AU-VIC', 'Seaford', -38.107561, 145.138821),
  ('AU-VIC', 'Mount Eliza', -38.195063, 145.093401),
  ('AU-VIC', 'Mornington', -38.232579, 145.060829)
ON CONFLICT (region_iso_code, name) DO NOTHING;


SELECT * FROM regions WHERE country_code = 'AU';
SELECT * FROM localities WHERE region_iso_code = 'AU-VIC';




-- --------------------
-- -- admin_areas
-- --------------------
-- CREATE TABLE admin_areas (
--   country_code CHAR(2) REFERENCES countries(code) ON DELETE CASCADE ,
--   code TEXT PRIMARY KEY NOT NULL CHECK (code ~ '^[A-Z]{2}-[A-Z0-9]{1,3}$'),         -- ISO 3166-2 code, e.g. 'AU-VIC'
--   name TEXT NOT NULL ,                                                  -- e.g., 'Victoria'
-- );

-- --------------------
-- -- post_codes
-- --------------------
-- CREATE TABLE post_codes (
--   code PRIMARY KEY TEXT NOT NULL,
--   admin_area_code TEXT NOT NULL REFERENCES admin_areas(code),
--   UNIQUE(code, admin_area_code)
-- );

-- --------------------
-- -- localities
-- --------------------
-- CREATE TABLE localities (

--   admin_area_code TEXT NOT NULL REFERENCES admin_areas(code),
--   post_code TEXT NOT NULL, -- REFERENCES post_codes(code) ON DELETE CASCADE,
--   name TEXT NOT NULL,

--   -- automatically generated hash of normalised prompt
--   locality_hash text GENERATED ALWAYS AS (
--     encode(digest(lower(trim(concat(admin_area_code,post_code,name))), 'sha256'), 'hex')
--   ) STORED PRIMARY KEY,

--   latitude DOUBLE PRECISION,
--   longitude DOUBLE PRECISION,

--   UNIQUE (admin_area_code, post_code, name)
-- );

-- --------------------
-- -- locations
-- --------------------
-- CREATE TABLE locations (
--   id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

--   -- ISO 3166-1 alpha-2 country code, exactly 2 uppercase letters
--   country_code text NOT NULL CHECK (country_code ~ '^[A-Z]{2}$'),

--   -- ISO 3166-2 subdivision, e.g., 'AU-VIC', admin_area_level_1
--   admin_area_code text NOT NULL CHECK (admin_area_code ~ '^[A-Z]{2}-[A-Z0-9]{1,3}$'),

--   -- Local geographic info
--   postal_code text NOT NULL,
--   locality text NOT NULL,

--   created_at timestamp with time zone DEFAULT now(),
--   updated_at timestamp with time zone DEFAULT now(),
--   deleted_at timestamp with time zone

--   -- Unique index for lookups
--   UNIQUE(country_code, admin_area_code, locality, postal_code)
-- );
