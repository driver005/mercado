-- Your SQL goes here
CREATE TYPE "ProcessTrackerStatus" AS ENUM (
    'processing',
    'new',
    'pending',
    'process_started',
    'finish'
);

CREATE TABLE process_tracker (
    id VARCHAR(127) PRIMARY KEY,
    NAME VARCHAR(255),
    tag TEXT [ ] NOT NULL DEFAULT '{}' :: TEXT [ ],
    runner VARCHAR(255),
    retry_count INTEGER NOT NULL,
    schedule_time TIMESTAMP,
    rule VARCHAR(255) NOT NULL,
    tracking_data JSON NOT NULL,
    business_status VARCHAR(255) NOT NULL,
    status "ProcessTrackerStatus" NOT NULL,
    event TEXT [ ] NOT NULL DEFAULT '{}' :: TEXT [ ],
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);