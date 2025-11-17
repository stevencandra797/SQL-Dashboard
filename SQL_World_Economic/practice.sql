create database ds;
USE ds;

select*from ds_salaries;

-- 1. apakah ada data yang NULL
select * from ds_salaries where work_year IS NULL;

-- Jawabanya tidak ada

-- 2. melihat data job title apa saja
select distinct job_title from ds_salaries order by job_title;
-- ada 50 pekerjaan yang ada

-- 3. job title apa saja yang berkaitan data analyst
 select distinct job_title from ds_salaries where job_title like '%Data Analyst%' order by job_title;
 
 -- 4. gaji data analyst rata rata
 select (avg(salary_in_usd) * 16500 /12) AS avg_sal_rp_month from ds_salaries;
 
 -- 4.1 berapa rata rata gaji data analis berdasarkan experience levelnya
  select experience_level, (avg(salary_in_usd) * 16500 /12) AS avg_sal_rp_month from ds_salaries group by experience_level;
  
  -- 4.2 berapa rata rata gaji data analis berdasarkan jenis experience level dan jenis employement
  select experience_level, employment_type, (avg(salary_in_usd) * 16500 /12) AS avg_sal_rp_month from ds_salaries group by experience_level, employment_type order by experience_level, employment_type;
  
  -- 5. negara dengan gaji yang menarik untuk posisi data analyst, full time
  SELECT company_location, AVG(salary_in_usd) avg_sal_in_usd FROM ds_salaries WHERE job_title LIKE '%data analyst%' AND employment_type = 'FT' AND experience_level IN ('MI', 'EN') GROUP BY company_location having avg_sal_in_usd >= 20000;
  
  -- having v\berfungsi untuk filter diatas 20.000
  
  -- 6. tahun berapa kenaikan gaji dari mid ke senior itu memiliki kenaikkan yang tertinggi (untuk pekerjaan yang berkaitan dengandata analis yang penuh waktu)
  -- cek tanggal saja
select distinct work_year from ds_salaries;
  --
WITH ds_1 AS (
	SELECT
		work_year,
		AVG(salary_in_usd) sal_in_usd_ex
	FROM
		ds_salaries
	WHERE
		employment_type = 'FT'
		AND experience_level = 'EX'
		AND job_title LIKE '%data analyst%'
	GROUP BY
		work_year
),
ds_2 AS (
	SELECT
		work_year,
		AVG(salary_in_usd) sal_in_usd_mi
	FROM
		ds_salaries
	WHERE
		employment_type = 'FT'
		AND experience_level = 'MI'
		AND job_title LIKE '%data analyst%'
	GROUP BY
		work_year
),
t_year AS (
	SELECT
		DISTINCT work_year
	FROM
		ds_salaries
)
SELECT
	t_year.work_year,
	ds_1.sal_in_usd_ex,
	ds_2.sal_in_usd_mi,
	ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi differences
FROM
	t_year
	LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
	LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;
  