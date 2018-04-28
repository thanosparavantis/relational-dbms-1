-- Zitaei kai einai ta montela, oxi poia ienai to montela ton pelaton pou exoun erthei perissoteres fores gia services
-- model_id, onoma, poses fores exei erthei auto to montelo gia service
-- 44,	Vanquish,	59

DROP VIEW IF EXISTS COUNT_MODELS;
CREATE VIEW COUNT_MODELS AS (
  SELECT car_models.id, car_models.title, count(car_models.id) AS num_of_model
  FROM car_warehouse INNER JOIN car_models ON car_warehouse.model_id = car_models.id
  GROUP BY car_models.id, car_models.title
);

SELECT * FROM COUNT_MODELS
WHERE COUNT_MODELS.num_of_model = (SELECT max(num_of_model) AS maximum FROM COUNT_MODELS);

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
SELECT results.title,MAX(results.total_count) maxResults
FROM(
	SELECT car_models.title, COUNT(*) total_count 
	FROM(
		SELECT public.service_history.car_id AS cars
		FROM public.service_history
		INNER JOIN car_warehouse ON public.service_history.car_id=public.car_warehouse.id)y
	INNER JOIN car_models ON y.cars = public.car_models.id
	GROUP BY title
	ORDER BY COUNT(*) DESC)results
WHERE  results.total_count = (SELECT MAX(results.total_count) FROM(
				SELECT car_models.title, COUNT(*) total_count 
				FROM(
				SELECT public.service_history.car_id AS cars
				FROM public.service_history
				INNER JOIN car_warehouse ON public.service_history.car_id=public.car_warehouse.id)y
				INNER JOIN car_models ON y.cars = public.car_models.id
				GROUP BY title
				ORDER BY COUNT(*) DESC)results)
GROUP BY title
