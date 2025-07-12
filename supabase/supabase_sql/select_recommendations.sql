select
	a.*,
	array_agg(c.name order by c.name) as framework_pillar
from recommendations as a
inner join recommendation_framework_pillars as b
	on a.id = b.recommendation_id
inner join framework_pillars as c
	on b.framework_pillar_id = c.id
group by a.id
;