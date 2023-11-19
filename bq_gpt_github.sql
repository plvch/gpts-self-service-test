-- Query 1 (contributor activity)
WITH 
  contents AS (SELECT * FROM `bigquery-public-data.github_repos.sample_contents`)
, files AS (SELECT * FROM `bigquery-public-data.github_repos.sample_files`) 
, commits AS (SELECT * FROM `bigquery-public-data.github_repos.sample_commits`) 

SELECT 
    author.name AS AuthorName,
    COUNT(commit) AS TotalCommits,
    MIN(author.date) AS FirstCommitDate,
    MAX(author.date) AS LastCommitDate
FROM 
    Commits
GROUP BY 
    author.name
ORDER BY 
    TotalCommits DESC;


-- Query 2 (file size distribution - Erroneous)
/*
WITH 
  contents AS (SELECT * FROM `bigquery-public-data.github_repos.sample_contents`)
, files AS (SELECT * FROM `bigquery-public-data.github_repos.sample_files`) 
, commits AS (SELECT * FROM `bigquery-public-data.github_repos.sample_commits`) 

SELECT 
    size,
    COUNT(*) AS NumberOfFiles
FROM 
    Files -- It confused Files/Contents metadata, so using `Contents` would work
GROUP BY 
    size
ORDER BY 
    NumberOfFiles DESC;
*/

-- Query 3 (unification)

WITH 
  contents AS (SELECT * FROM `bigquery-public-data.github_repos.sample_contents`)
, files AS (SELECT * FROM `bigquery-public-data.github_repos.sample_files`) 
, commits AS (SELECT * FROM `bigquery-public-data.github_repos.sample_commits`) 

SELECT 
    c.repo_name AS RepositoryName,
    COUNT(DISTINCT c.commit) AS TotalCommits,
    COUNT(DISTINCT f.id) AS TotalFilesModified,
    AVG(co.size) AS AverageFileSize
FROM 
    Commits c
JOIN 
    Files f ON c.repo_name = f.repo_name
LEFT JOIN 
    Contents co ON f.id = co.id
GROUP BY 
    c.repo_name;
