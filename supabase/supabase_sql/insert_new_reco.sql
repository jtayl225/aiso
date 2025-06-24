-- 1. Define your inputs
-- You can replace these inline or parameterize them in an SQL function
WITH input_data AS (
  SELECT
    '18ce17a7-9299-4a2d-b086-a14979aec235'::uuid AS industry_id,
    '3704c4b7-4d17-4e19-9976-34c24ab8d10d'::uuid AS framework_id,
    ARRAY['trustworthiness']::text[] AS pillar_names
),

-- ('experience','expertise','authoritativeness','trustworthiness','profile')

-- 2. Insert the new recommendation
new_recommendation AS (
  INSERT INTO recommendations (
    industry_id, name, description, category, cadence, effort, reward
  )
  SELECT
    industry_id,
    'Verified reviews and ratings',
    'Ask happy clients for reviews.',
    'non-tech',
    'week',
    3, -- effort:
    3 -- reward
  FROM input_data
  RETURNING id
),

-- 3. Select matching framework_pillars by name + framework_id
matched_pillars AS (
  SELECT fp.id AS framework_pillar_id, nr.id AS recommendation_id
  FROM framework_pillars fp
  JOIN input_data i ON fp.framework_id = i.framework_id
  JOIN new_recommendation nr ON true
  WHERE fp.name = ANY(i.pillar_names)
)

-- 4. Insert into the many:many join table
INSERT INTO recommendation_framework_pillars (recommendation_id, framework_pillar_id)
SELECT recommendation_id, framework_pillar_id
FROM matched_pillars;
