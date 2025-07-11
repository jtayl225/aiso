INSERT INTO search_targets (industry_id, type, name, description, url)
VALUES 
	(
		(SELECT id AS industry_id FROM industries WHERE name ILIKE '%real estate%'  LIMIT 1),
		'business',
		'O''Brien Real Estate (Frankston)', 
		'A real estate agency in Frankston VIC Australia.', 
		NULL
	)
;

INSERT INTO reports (user_id, search_target_id, title, cadence)
VALUES
	(
		'4623530d-d37d-48d0-8664-d7d6bf14e1de',
		(SELECT id AS search_target_id FROM search_targets ORDER BY created_at DESC LIMIT 1),
		'O''Brien Real Estate (Frankston)',
		'month'
	)
;

INSERT INTO prompts (prompt)
VALUES ('Top 10 real estate agents in Frankston VIC Australia.')
;

INSERT INTO report_prompts (report_id, prompt_id)
VALUES 
	(
		(SELECT id AS report_id FROM reports ORDER BY created_at DESC LIMIT 1),
		(SELECT id AS prompt_id FROM prompts WHERE prompt_hash = 'e3541dd96ab9ce99be85f7881e807d606d4b7cf511d7032bcc0965db3e8169f0' LIMIT 1)
	)
;


-- run report for (report_id, prompt_id)