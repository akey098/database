-- add new member, subscription, and payment
BEGIN;

WITH new_member AS (
    INSERT INTO member (first_name, last_name, date_of_birth, phone, email, status)
    VALUES ('Timofey', 'Smirnov', '2002-07-10', '+996700000099', 'timofey@example.com', 'active')
    RETURNING member_id
),
new_subscription AS (
    INSERT INTO subscription (member_id, plan_id, start_date, end_date, status)
    SELECT member_id,
           1,
           CURRENT_DATE,
           CURRENT_DATE + INTERVAL '1 month',
           'active'
    FROM new_member
    RETURNING subscription_id, member_id
)
INSERT INTO payment (member_id, subscription_id, amount, payment_method, status)
SELECT member_id, subscription_id, 50.00, 'card', 'completed'
FROM new_subscription;

COMMIT;

-- demonstrate rollback for invalid payment (negative amount)
BEGIN;

INSERT INTO payment (member_id, subscription_id, amount, payment_method, status)
VALUES (1, 1, -10.00, 'card', 'completed');

ROLLBACK;

-- transfer locker assignment to another member
BEGIN;

UPDATE locker_assignment
SET end_date = CURRENT_DATE
WHERE locker_number = 'A101'
  AND end_date IS NULL;

INSERT INTO locker_assignment (locker_number, member_id, start_date, end_date)
VALUES ('A101', 3, CURRENT_DATE, NULL);

COMMIT;

CREATE INDEX idx_member_last_name ON member(last_name);
CREATE INDEX idx_member_email ON member(email);
CREATE INDEX idx_subscription_member_status ON subscription(member_id, status);
CREATE INDEX idx_class_schedule_start_time ON class_schedule(start_time);
CREATE INDEX idx_attendance_member ON attendance(member_id);
CREATE INDEX idx_payment_member ON payment(member_id);
CREATE INDEX idx_payment_subscription ON payment(subscription_id);
