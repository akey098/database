SELECT m.member_id,
       m.first_name || ' ' || m.last_name AS member_name,
       SUM(p.amount) AS total_paid
FROM member m
JOIN payment p ON m.member_id = p.member_id
WHERE p.status = 'completed'
GROUP BY m.member_id, member_name
HAVING SUM(p.amount) > 40
ORDER BY total_paid DESC;

SELECT m.member_id,
       m.first_name,
       m.last_name,
       s.subscription_id,
       s.start_date,
       s.end_date
FROM subscription s
JOIN member m ON s.member_id = m.member_id
WHERE CURRENT_DATE BETWEEN s.start_date AND s.end_date
  AND s.status = 'active';

SELECT cs.schedule_id,
       c.class_name,
       cs.start_time,
       COUNT(a.attendance_id) AS attendees
FROM class_schedule cs
JOIN class c ON cs.class_id = c.class_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY cs.schedule_id, c.class_name, cs.start_time
ORDER BY cs.start_time;

SELECT m.member_id,
       m.first_name || ' ' || m.last_name AS member_name,
       COUNT(a.attendance_id) AS total_visits,
       RANK() OVER (ORDER BY COUNT(a.attendance_id) DESC) AS visit_rank
FROM member m
LEFT JOIN attendance a ON m.member_id = a.member_id
GROUP BY m.member_id, member_name
ORDER BY visit_rank;

WITH stats AS (
    SELECT cs.schedule_id,
           cs.capacity,
           COUNT(a.attendance_id) AS attendees
    FROM class_schedule cs
    LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
    GROUP BY cs.schedule_id, cs.capacity
)
SELECT cs.schedule_id,
       c.class_name,
       cs.start_time,
       s.attendees,
       cs.capacity,
       ROUND(100.0 * s.attendees / cs.capacity, 2) AS occupancy_percent
FROM stats s
JOIN class_schedule cs ON s.schedule_id = cs.schedule_id
JOIN class c ON cs.class_id = c.class_id
ORDER BY occupancy_percent DESC;

SELECT mp.plan_id,
       mp.plan_name,
       SUM(p.amount) AS total_revenue,
       COUNT(DISTINCT s.subscription_id) AS subscriptions_count
FROM membership_plan mp
LEFT JOIN subscription s ON mp.plan_id = s.plan_id
LEFT JOIN payment p ON s.subscription_id = p.subscription_id
                      AND p.status = 'completed'
GROUP BY mp.plan_id, mp.plan_name
ORDER BY total_revenue DESC NULLS LAST;

SELECT m.member_id,
       m.first_name,
       m.last_name
FROM member m
LEFT JOIN attendance a ON m.member_id = a.member_id
WHERE a.attendance_id IS NULL;

SELECT m.member_id,
       m.first_name,
       m.last_name,
       s.subscription_id,
       s.start_date,
       s.end_date
FROM subscription s
JOIN member m ON s.member_id = m.member_id
WHERE s.end_date < CURRENT_DATE
  AND s.status = 'active';

SELECT t.trainer_id,
       t.first_name || ' ' || t.last_name AS trainer_name,
       COUNT(cs.schedule_id) AS classes_count
FROM trainer t
LEFT JOIN class_schedule cs ON t.trainer_id = cs.trainer_id
GROUP BY t.trainer_id, trainer_name
ORDER BY classes_count DESC;

SELECT cs.schedule_id,
       c.class_name,
       cs.start_time,
       COUNT(a.attendance_id) AS attendees,
       CASE
           WHEN COUNT(a.attendance_id) = 0 THEN 'empty'
           WHEN COUNT(a.attendance_id) < cs.capacity / 2 THEN 'low'
           WHEN COUNT(a.attendance_id) < cs.capacity THEN 'medium'
           ELSE 'full'
       END AS load_category
FROM class_schedule cs
JOIN class c ON cs.class_id = c.class_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY cs.schedule_id, c.class_name, cs.start_time, cs.capacity
ORDER BY cs.start_time;
