CREATE TABLE user_account (
    user_id NUMBER PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
    CONSTRAINT chk_full_name
    CHECK (REGEXP_LIKE(full_name, '^[A-Z][a-z]+([ ][A-Z][a-z]+)*$')),
    contact_info VARCHAR(150)
    CONSTRAINT chk_contact_info
    CHECK (
        REGEXP_LIKE(
            contact_info,
            '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
        )
    ),
    preferred_contact_time VARCHAR(50)
);

CREATE TABLE security_specialist (
    specialist_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL
    REFERENCES user_account (user_id),
    full_name VARCHAR(100) NOT NULL,
    competencies VARCHAR(255) NOT NULL,
    availability VARCHAR(100)
);

CREATE TABLE consultation_request (
    request_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL
    REFERENCES user_account (user_id),
    addressed_specialist_id NUMBER REFERENCES security_specialist (
        specialist_id
    ),
    request_text VARCHAR(500) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    preferred_datetime TIMESTAMP
);

CREATE TABLE consultation (
    consultation_id NUMBER PRIMARY KEY,
    request_id NUMBER REFERENCES consultation_request (request_id),
    specialist_id NUMBER REFERENCES security_specialist (specialist_id),
    user_id NUMBER REFERENCES user_account (user_id),
    recommendations VARCHAR(1000),
    scheduled_datetime TIMESTAMP NOT NULL,
    duration VARCHAR(50)
);

CREATE TABLE list_request (
    list_request_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL
    REFERENCES user_account (user_id),
    criteria VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    request_status VARCHAR(50) DEFAULT 'pending'
);

CREATE TABLE specialist_list (
    list_id NUMBER PRIMARY KEY,
    list_request_id NUMBER REFERENCES list_request (list_request_id),
    generated_at TIMESTAMP NOT NULL,
    specialties_included VARCHAR(255),
    specialists_count NUMBER
    CONSTRAINT chk_specialists_count
    CHECK (specialists_count >= 0)
);

CREATE TABLE specialist_list_specialist (
    id NUMBER PRIMARY KEY,
    list_id NUMBER REFERENCES specialist_list (list_id),
    specialist_id NUMBER REFERENCES security_specialist (specialist_id)

);
