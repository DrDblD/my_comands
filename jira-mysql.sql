SELECT d.directory_name AS "Directory",
    u.user_name AS "Username",
    u.display_name AS "ФИО",
    from_unixtime((cast(attribute_value AS UNSIGNED)/1000)) AS "Last Login"
FROM cwd_user u
JOIN (
    SELECT DISTINCT child_name
    FROM cwd_membership m
    JOIN licenserolesgroup gp ON m.lower_parent_name = gp.GROUP_ID
    ) AS m ON m.child_name = u.user_name
JOIN (
    SELECT *
    FROM cwd_user_attributes 
    WHERE attribute_name = 'login.lastLoginMillis' AND FROM_UNIXTIME(ROUND(attribute_value/1000)) <= (current_date - interval 4 year)
    ) AS a ON a.user_id = u.id
JOIN (
    SELECT *
    FROM cwd_directory
    WHERE id = 1
) AS d ON u.directory_id = d.id
WHERE u.active = 1
ORDER BY attribute_value DESC
INTO OUTFILE '/var/lib/mysql-files/myoutput.txt';


SELECT d.directory_name AS "Directory", 
    u.user_name AS "Username",
    FROM_UNIXTIME((CAST(attribute_value AS UNSIGNED)/1000)) AS "Last Login"
FROM cwd_user u
    JOIN (
        SELECT *
        FROM cwd_directory
        WHERE id = 1
    ) AS d ON u.directory_id = d.id
    LEFT JOIN cwd_user_attributes ca ON u.id = ca.user_id AND ca.attribute_name = 'login.lastLoginMillis'
WHERE u.active = 1
    AND d.active = 1
    AND u.lower_user_name IN (
            SELECT DISTINCT lower_child_name
            FROM cwd_membership m
            JOIN licenserolesgroup gp ON m.parent_name = gp.GROUP_ID)
    AND (u.id IN (
            SELECT ca.user_id
            FROM cwd_user_attributes ca
            WHERE attribute_name = 'login.lastLoginMillis' AND FROM_UNIXTIME(ROUND(ca.attribute_value/1000)) <= (current_date - interval 4 year))
        OR u.id NOT IN (
            SELECT ca.user_id
            FROM cwd_user_attributes ca
            WHERE attribute_name = 'login.lastLoginMillis')
        )
ORDER BY attribute_value DESC
INTO OUTFILE '/var/lib/mysql-files/myoutput.txt';

SELECT user_name, active, directory_id 
FROM cwd_user
WHERE active = 1 AND directory_id = 1;

SELECT * FROM cwd_directory;

SELECT ID, user_id, directory_id, FROM_UNIXTIME((CAST(attribute_value AS UNSIGNED)/1000)) AS "Last Login" FROM cwd_user_attributes WHERE attribute_name = 'login.lastLoginMillis' and user_id = 10174;

select user_name, active, directory_id from cwd_user where directory_id = 1 and active = 0 and lower_user_name not like 'adm%' and lower_user_name <> 'sujira';

update cwd_user set active = 1 where directory_id = 1 and lower_user_name = atab;