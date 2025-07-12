-- Replace the values below with actual ones:
-- :framework_id, :industry_id, :pillar_names (array), and recommendation fields

WITH

selected_pillars AS (

  SELECT id
  FROM framework_pillars
  WHERE framework_id = '3704c4b7-4d17-4e19-9976-34c24ab8d10d'
    -- AND name IN ('profile', 'expertise', 'experience', 'trustworthiness', 'authoritativeness') -- 👈 choose your desired pillar names
    AND name IN ('experience', 'expertise', 'trustworthiness', 'authoritativeness') 
),

new_recommendation AS (

  INSERT INTO recommendations (
    industry_id, name, description, category, cadence, effort, reward
  )
  VALUES (
    '18ce17a7-9299-4a2d-b086-a14979aec235', -- Real Estate
    'Case studies', -- name
    'Create a case study on a recent good performance success story with key data to support the story.', -- description
    'non-tech',        -- or 'non-tech'
    'month',     -- assumes valid cadence enum
    2,             -- effort (integer)
    3              -- reward (integer)
  )
  RETURNING id

)
-- Link the new recommendation to the selected framework pillars
INSERT INTO recommendation_framework_pillars (recommendation_id, framework_pillar_id)
SELECT
  nr.id,
  sp.id
FROM new_recommendation nr, selected_pillars sp;
