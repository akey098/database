INSERT INTO membership_plan (plan_name, description, price, duration_months, visit_limit)
VALUES
  ('Monthly Unlimited', 'Unlimited visits for one month', 50.00, 1, NULL),
  ('10 Visits', '10 entrance visits', 35.00, 3, 10),
  ('Annual Unlimited', 'Unlimited visits for one year', 400.00, 12, NULL);

INSERT INTO member (first_name, last_name, date_of_birth, phone, email, status)
VALUES
  ('Anna', 'Petrova', '1998-03-15', '+996700000001', 'anna@example.com', 'active'),
  ('Ivan', 'Kovalenko', '2000-11-02', '+996700000002', 'ivan@example.com', 'active'),
  ('Mira', 'Sokolova', '1995-06-18', '+996700000003', 'mira@example.com', 'frozen'),
  ('Mark', 'Lebedev', '1992-01-25', '+996700000004', 'mark@example.com', 'active');

INSERT INTO trainer (first_name, last_name, specialization, phone, email)
VALUES
  ('Elena', 'Morozova', 'Yoga', '+996700000010', 'elena@yoga.com'),
  ('Pavel', 'Grigoriev', 'CrossFit', '+996700000011', 'pavel@crossfit.com'),
  ('Svetlana', 'Kim', 'Pilates', '+996700000012', 'svetlana@pilates.com');

INSERT INTO class (class_name, difficulty, description)
VALUES
  ('Morning Yoga', 'beginner', 'Relaxing morning yoga'),
  ('CrossFit WOD', 'advanced', 'High-intensity workout'),
  ('Pilates Core', 'intermediate', 'Core strengthening session');

INSERT INTO subscription (member_id, plan_id, start_date, end_date, status)
VALUES
  (1, 1, '2025-12-01', '2026-01-01', 'active'),
  (2, 2, '2025-12-05', '2026-03-05', 'active'),
  (3, 1, '2025-10-01', '2025-11-01', 'expired'),
  (4, 3, '2025-01-01', '2026-01-01', 'active');

INSERT INTO payment (member_id, subscription_id, amount, payment_method, status)
VALUES
  (1, 1, 50.00, 'card', 'completed'),
  (2, 2, 35.00, 'cash', 'completed'),
  (3, 3, 50.00, 'online', 'completed'),
  (4, 4, 400.00, 'card', 'completed');

INSERT INTO class_schedule (class_id, trainer_id, start_time, end_time, room, capacity)
VALUES
  (1, 1, '2025-12-11 08:00', '2025-12-11 09:00', 'Room A', 15),
  (2, 2, '2025-12-11 18:00', '2025-12-11 19:00', 'Room B', 10),
  (3, 3, '2025-12-12 10:00', '2025-12-12 11:00', 'Room C', 12),
  (1, 1, '2025-12-13 08:00', '2025-12-13 09:00', 'Room A', 15);

INSERT INTO attendance (schedule_id, member_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 2),
  (2, 4),
  (3, 1),
  (4, 1),
  (4, 3);

INSERT INTO locker_assignment (locker_number, member_id, start_date, end_date_
