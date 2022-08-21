CREATE OR REPLACE VIEW modules_with_context AS
    SELECT
        modules.id as moduleID, modules.task as taskID, modules.type, modules.name, modules.max_points, modules.autocorrect, modules.order, modules.bonus, modules.custom, modules.action, modules.data,
        tasks.title, tasks.author, tasks.co_author, tasks.wave as waveID, tasks.prerequisite, tasks.time_created, tasks.time_deadline,
        waves.year as yearID, waves.index as xTaVlna, waves.caption, waves.garant, waves.time_published,
        years.year, years.sealed, years.point_pad 
    FROM modules
    INNER JOIN tasks on tasks.id = modules.task
    INNER JOIN waves on waves.id = tasks.wave
    INNER JOIN years on years.id = waves.year
;

CREATE OR REPLACE VIEW evaluations_with_context AS
    SELECT
        users.id as user, users.sex, users.role, users.enabled, users.registered,
        evaluations.id as evaluationID, evaluations.module as module, evaluations.evaluator, evaluations.points, evaluations.ok, evaluations.cheat, evaluations.full_report, evaluations.time, 
        modules_with_context.*
    FROM `users`
    INNER JOIN evaluations on evaluations.user = users.id
    INNER JOIN modules_with_context on modules_with_context.moduleID = evaluations.module
;


CREATE OR REPLACE VIEW evaluations_participants_with_context AS
    SELECT *
    FROM evaluations_with_context
    WHERE role = 'participant'
;


CREATE OR REPLACE VIEW evaluations_ok_or_bonus_participants_with_context AS
    SELECT *
    FROM evaluations_participants_with_context
    WHERE 
        cheat = 0 -- AND
        -- (bonus = 1 OR ok = 1) -- why can exist solution with points, but without ok?
;


CREATE OR REPLACE VIEW points_per_module_participants AS
    SELECT user, module, `year`, max(points) as points_per_module
    FROM evaluations_ok_or_bonus_participants_with_context
    GROUP BY user, module, `year`
;

CREATE OR REPLACE VIEW points_per_year_participants AS
    SELECT user, `year`, sum(points_per_module) as points_per_year
    -- this includes points from not published corrections
    FROM points_per_module_participants
    GROUP BY user, `year`
;


CREATE OR REPLACE VIEW users_failing_on_modules AS
    SELECT
        user, module, `year`,
        `name` as module_name, title as task_name,
        min(ok) as min_ok, max(ok) as max_ok,
        count(*) as number_of_tries
    FROM evaluations_participants_with_context
    GROUP BY user, module
    HAVING
        min_ok = 0 AND
        max_ok = 0
;


CREATE OR REPLACE VIEW users_and_profiles AS
    SELECT *
    FROM users
    JOIN profiles ON users.id = profiles.user_id
;


CREATE OR REPLACE VIEW years_max_points AS
    SELECT year, sum(max_points) as max_points
    FROM `modules_with_context`
    WHERE bonus = 0
    GROUP BY year
;

CREATE OR REPLACE VIEW successful_users AS
    SELECT points_per_year_participants.user, points_per_year_participants.year as successful_year
    FROM points_per_year_participants
    JOIN years_max_points on points_per_year_participants.year = years_max_points.year
    WHERE
        points_per_year >= 0.6 * max_points
;

CREATE OR REPLACE VIEW users_and_points_and_max AS
    SELECT points_per_year_participants.*, years_max_points.max_points, users_and_profiles.*
    FROM users_and_profiles
    JOIN points_per_year_participants ON users_and_profiles.id = points_per_year_participants.user
    JOIN years_max_points ON years_max_points.year = points_per_year_participants.year
;

CREATE OR REPLACE VIEW number_of_users_failing_on_module AS
SELECT year, module, module_name, task_name, count(user) as failing_users
FROM `users_failing_on_modules`
GROUP BY module
ORDER BY failing_users DESC;
