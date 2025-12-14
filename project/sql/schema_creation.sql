-- drops existing tables to reset schema
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS locker_assignment CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS class_schedule CASCADE;
DROP TABLE IF EXISTS class CASCADE;
DROP TABLE IF EXISTS trainer CASCADE;
DROP TABLE IF EXISTS subscription CASCADE;
DROP TABLE IF EXISTS membership_plan CASCADE;
DROP TABLE IF EXISTS member CASCADE;

-- table: member (stores gym members)
CREATE TABLE member (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'active'
);

-- table: membership_plan (available plans)
CREATE TABLE membership_plan (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    duration_months INTEGER NOT NULL,
    visit_limit INTEGER,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- table: subscription (member plan enrollments)
CREATE TABLE subscription (
    subscription_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL,
    plan_id INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (plan_id) REFERENCES membership_plan(plan_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE (member_id, plan_id, start_date),
    CHECK (end_date > start_date)
);

-- table: trainer (instructors)
CREATE TABLE trainer (
    trainer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

-- table: class (class types)
CREATE TABLE class (
    class_id SERIAL PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    difficulty VARCHAR(20),
    description TEXT
);

-- table: class_schedule (scheduled class sessions)
CREATE TABLE class_schedule (
    schedule_id SERIAL PRIMARY KEY,
    class_id INTEGER NOT NULL,
    trainer_id INTEGER NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    room VARCHAR(50),
    capacity INTEGER NOT NULL,
    FOREIGN KEY (class_id) REFERENCES class(class_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (end_time > start_time),
    CHECK (capacity > 0)
);

-- table: attendance (member check-ins to classes)
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    check_in_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (schedule_id, member_id)
);

-- table: payment (member payments)
CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL,
    subscription_id INTEGER NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'completed',
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (subscription_id) REFERENCES subscription(subscription_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (amount > 0)
);

-- table: locker_assignment (locker usage by members)
CREATE TABLE locker_assignment (
    locker_id SERIAL PRIMARY KEY,
    locker_number VARCHAR(10) NOT NULL UNIQUE,
    member_id INTEGER UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON UPDATE CASCADE ON DELETE SET NULL,
    CHECK (end_date IS NULL OR end_date >= start_date)
);
