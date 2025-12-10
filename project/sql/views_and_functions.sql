CREATE VIEW view_active_members AS
SELECT member_id,
       first_name,
       last_name,
       email,
       phone,
       registration_date
FROM member
WHERE status = 'active';

CREATE VIEW view_active_subscriptions AS
SELECT s.subscription_id,
       s.member_id,
       m.first_name,
       m.last_name,
       s.plan_id,
       mp.plan_name,
       s.start_date,
       s.end_date,
       s.status
FROM subscription s
JOIN member m ON s.member_id = m.member_id
JOIN membership_plan mp ON s.plan_id = mp.plan_id
WHERE s.status = 'active'
  AND CURRENT_DATE BETWEEN s.start_date AND s.end_date;

CREATE VIEW view_class_occupancy AS
SELECT cs.schedule_id,
       c.class_name,
       cs.start_time,
       cs.end_time,
       cs.capacity,
       COUNT(a.attendance_id) AS attendees,
       ROUND(100.0 * COUNT(a.attendance_id) / cs.capacity, 2) AS occupancy_percent
FROM class_schedule cs
JOIN class c ON cs.class_id = c.class_id
LEFT JOIN attendance a ON cs.schedule_id = a.schedule_id
GROUP BY cs.schedule_id, c.class_name, cs.start_time, cs.end_time, cs.capacity;

CREATE VIEW view_payments_summary AS
SELECT m.member_id,
       m.first_name || ' ' || m.last_name AS member_name,
       SUM(p.amount) AS total_paid,
       COUNT(p.payment_id) AS payments_count
FROM member m
LEFT JOIN payment p ON m.member_id = p.member_id
GROUP BY m.member_id, member_name;

CREATE VIEW view_members_without_attendance AS
SELECT m.member_id,
       m.first_name,
       m.last_name,
       m.email
FROM member m
LEFT JOIN attendance a ON m.member_id = a.member_id
WHERE a.attendance_id IS NULL;

CREATE VIEW view_trainer_classes AS
SELECT t.trainer_id,
       t.first_name || ' ' || t.last_name AS trainer_name,
       c.class_name,
       cs.schedule_id,
       cs.start_time,
       cs.end_time,
       cs.room
FROM trainer t
JOIN class_schedule cs ON t.trainer_id = cs.trainer_id
JOIN class c ON cs.class_id = c.class_id;

CREATE VIEW view_expired_subscriptions AS
SELECT s.subscription_id,
       s.member_id,
       m.first_name,
       m.last_name,
       s.plan_id,
       mp.plan_name,
       s.start_date,
       s.end_date
FROM subscription s
JOIN member m ON s.member_id = m.member_id
JOIN membership_plan mp ON s.plan_id = mp.plan_id
WHERE s.end_date < CURRENT_DATE
  AND s.status = 'active';

CREATE OR REPLACE FUNCTION fn_get_member_fullname(mid INTEGER)
RETURNS TEXT AS $$
SELECT first_name || ' ' || last_name
FROM member
WHERE member_id = mid;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_extend_subscription(sub_id INTEGER, extra_days INTEGER)
RETURNS VOID AS $$
UPDATE subscription
SET end_date = end_date + extra_days
WHERE subscription_id = sub_id;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fn_register_attendance(m_id INTEGER, sched_id INTEGER)
RETURNS INTEGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM attendance WHERE member_id = m_id AND schedule_id = sched_id) THEN
        RETURN NULL;
    END IF;

    INSERT INTO attendance (schedule_id, member_id)
    VALUES (sched_id, m_id)
    RETURNING attendance_id INTO STRICT m_id;

    RETURN m_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_member_total_payments(m_id INTEGER)
RETURNS NUMERIC AS $$
SELECT COALESCE(SUM(amount), 0)
FROM payment
WHERE member_id = m_id
  AND status = 'completed';
$$ LANGUAGE SQL;
