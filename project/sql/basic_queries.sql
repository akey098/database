-- Get all members
SELECT member_id, first_name, last_name, email, phone, status
FROM member
ORDER BY member_id;

-- Get all membership plans
SELECT plan_id, plan_name, price, duration_months, visit_limit
FROM membership_plan
WHERE is_active = TRUE
ORDER BY price;

-- Get all trainers
SELECT trainer_id, first_name, last_name, specialization, email
FROM trainer
ORDER BY last_name;

-- Get all classes
SELECT class_id, class_name, difficulty, description
FROM class
ORDER BY class_name;

-- Get members with active subscriptions
SELECT m.member_id,
       m.first_name,
       m.last_name,
       mp.plan_name,
       s.start_date,
       s.end_date
FROM member m
JOIN subscription s ON m.member_id = s.member_id
JOIN membership_plan mp ON s.plan_id = mp.plan_id
WHERE s.status = 'active'
ORDER BY m.last_name;

-- Get class schedules for the next 7 days
SELECT cs.schedule_id,
       c.class_name,
       t.first_name || ' ' || t.last_name AS trainer_name,
       cs.start_time,
       cs.end_time,
       cs.room,
       cs.capacity
FROM class_schedule cs
JOIN class c ON cs.class_id = c.class_id
JOIN trainer t ON cs.trainer_id = t.trainer_id
WHERE cs.start_time >= CURRENT_DATE
  AND cs.start_time < CURRENT_DATE + INTERVAL '7 days'
ORDER BY cs.start_time;

-- Count active members
SELECT COUNT(*) AS total_active_members
FROM member
WHERE status = 'active';

-- Count active subscriptions
SELECT COUNT(*) AS total_active_subscriptions
FROM subscription
WHERE status = 'active'
  AND CURRENT_DATE BETWEEN start_date AND end_date;

-- Get total revenue from payments
SELECT SUM(amount) AS total_revenue
FROM payment
WHERE status = 'completed';

-- Get attendance for a specific class (example with class_id = 1)
SELECT a.attendance_id,
       m.first_name || ' ' || m.last_name AS member_name,
       c.class_name,
       a.check_in_time
FROM attendance a
JOIN member m ON a.member_id = m.member_id
JOIN class_schedule cs ON a.schedule_id = cs.schedule_id
JOIN class c ON cs.class_id = c.class_id
WHERE c.class_id = 1
ORDER BY a.check_in_time DESC;

-- Get members by registration month
SELECT DATE_TRUNC('month', registration_date) AS registration_month,
       COUNT(*) AS members_registered
FROM member
GROUP BY DATE_TRUNC('month', registration_date)
ORDER BY registration_month DESC;

-- Get locker assignments for active members
SELECT la.locker_id,
       la.locker_number,
       m.first_name || ' ' || m.last_name AS member_name,
       la.assignment_date
FROM locker_assignment la
JOIN member m ON la.member_id = m.member_id
WHERE m.status = 'active'
ORDER BY la.locker_number;

-- Get payment history for a specific member (example with member_id = 1)
SELECT p.payment_id,
       mp.plan_name,
       p.amount,
       p.payment_date,
       p.payment_method,
       p.status
FROM payment p
JOIN subscription s ON p.subscription_id = s.subscription_id
JOIN membership_plan mp ON s.plan_id = mp.plan_id
WHERE p.member_id = 1
ORDER BY p.payment_date DESC;

-- Get member email addresses
SELECT member_id, first_name, last_name, email
FROM member
WHERE email IS NOT NULL
ORDER BY last_name;

-- Get classes with their assigned trainers
SELECT c.class_id,
       c.class_name,
       c.difficulty,
       t.first_name || ' ' || t.last_name AS trainer_name,
       t.specialization
FROM class c
LEFT JOIN class_schedule cs ON c.class_id = cs.class_id
LEFT JOIN trainer t ON cs.trainer_id = t.trainer_id
GROUP BY c.class_id, c.class_name, c.difficulty, t.first_name, t.last_name, t.specialization
ORDER BY c.class_name;
