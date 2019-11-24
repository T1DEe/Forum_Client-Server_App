
-- USERS INSERT --
INSERT INTO ADMIN.USERS (USERNAME, PASSWORD) VALUES ('testuser1', 'test1');
INSERT INTO ADMIN.USERS (USERNAME, PASSWORD) VALUES ('testuser2', 'test2');
INSERT INTO ADMIN.USERS (USERNAME, PASSWORD) VALUES ('testuser3', 'test3');
INSERT INTO ADMIN.USERS (USERNAME, PASSWORD) VALUES ('testuser4', 'test4');


-- FORUM_RANKS INSERT --
INSERT INTO forum_ranks (NAME) VALUES ('Beginner');
INSERT INTO forum_ranks (NAME) VALUES ('Student');
INSERT INTO forum_ranks (NAME) VALUES ('Connoisseur');

-- USERS_INFO INSERT --
-- 0 --
INSERT INTO USERS_INFO (USER_ID, SEX, BIRTH_DATE, LOCATION, REG_DATE, MESSAGE_COUNT, FORUM_RANK_ID, PROFILE_PHOTO_PATH) 
    VALUES (20, 
            0, 
            to_date('1998/05/10', 'yyyy/mm/dd:hh'), 
            'Russia' , 
            to_date('2019/06/12', 'yyyy/mm/dd'),
            0,
            0,
            NULL
);
-- 1 --
INSERT INTO USERS_INFO (USER_ID, SEX, BIRTH_DATE, LOCATION, REG_DATE, MESSAGE_COUNT, FORUM_RANK_ID, PROFILE_PHOTO_PATH) 
    VALUES (21, 
            1, 
            to_date('1983/05/10', 'yyyy/mm/dd'), 
            'Belarus' , 
            to_date('2018/03/08', 'yyyy/mm/dd'),
            0,
            2,
            '/test1Path'
);
-- 2 --
INSERT INTO USERS_INFO (USER_ID, SEX, BIRTH_DATE, LOCATION, REG_DATE, MESSAGE_COUNT, FORUM_RANK_ID, PROFILE_PHOTO_PATH) 
    VALUES (22, 
            0, 
            to_date('1999/11/11', 'yyyy/mm/dd'), 
            'France' , 
            to_date('2017/01/01', 'yyyy/mm/dd'),
            1,
            0,
            '/test2Path'
);
-- 3 --
INSERT INTO USERS_INFO (USER_ID, SEX, BIRTH_DATE, LOCATION, REG_DATE, MESSAGE_COUNT, FORUM_RANK_ID, PROFILE_PHOTO_PATH) 
    VALUES (23, 
            0, 
            to_date('1970/05/10', 'yyyy/mm/dd'), 
            'England' , 
            to_date('2019/08/30', 'yyyy/mm/dd'),
            0,
            2,
            '/test3Path'
);

-- THREADS INSERT --
INSERT INTO THREADS (TITLE, DESCRIPTION) VALUES ('iOS Mobile Development', 'Thread about iOS mobile development world');
INSERT INTO THREADS (TITLE, DESCRIPTION) VALUES ('Android Mobile Development', 'Thread about Android mobile development world');
INSERT INTO THREADS (TITLE, DESCRIPTION) VALUES ('Oracle database help', 'Post your questions about oracle database');
INSERT INTO THREADS (TITLE, DESCRIPTION) VALUES ('NodeJS samples', 'Little codebase with task samples');

-- POSTS INSERT --
INSERT INTO POSTS (THREAD_ID, USER_ID, CONTENT, CREATED_TIME, TO_POST_ID) 
    VALUES (22,
            20,
            'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
            to_date('2019/11/23', 'yyyy/mm/dd'),
            NULL
);
INSERT INTO POSTS (THREAD_ID, USER_ID, CONTENT, CREATED_TIME, TO_POST_ID) 
    VALUES (22,
            20,
            'aaaaaaaaaaaaaaaaaaaaaaaaaaaa',
            to_date('2019/11/24', 'yyyy/mm/dd'),
            NULL
);
INSERT INTO POSTS (THREAD_ID, USER_ID, CONTENT, CREATED_TIME, TO_POST_ID) 
    VALUES (22,
            21,
            'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
            to_date('2019/11/24', 'yyyy/mm/dd'),
            NULL
);
INSERT INTO POSTS (THREAD_ID, USER_ID, CONTENT, CREATED_TIME, TO_POST_ID) 
    VALUES (22,
            22,
            'cccccccccccccccccccccccccccccccccccc',
            to_date('2019/11/24', 'yyyy/mm/dd'),
            NULL
);

INSERT INTO POSTS (THREAD_ID, USER_ID, CONTENT, CREATED_TIME, TO_POST_ID) 
    VALUES (22,
            22,
            'CCCCCCCCCCCCCCCCCCCCC',
            to_date('2019/11/25', 'yyyy/mm/dd'),
            NULL
);

INSERT INTO POSTS (THREAD_ID, USER_ID, CONTENT, CREATED_TIME, TO_POST_ID) 
    VALUES (22,
            22,
            'CACACACACAC',
            to_date('2019/11/26', 'yyyy/mm/dd'),
            NULL
);

-- ADMIN_RIGHTS INSERT
INSERT INTO admin_rights (NAME) VALUES ('Administrator');
INSERT INTO admin_rights (NAME) VALUES ('Editor');

-- ADMINISTRATORS INSERT --
INSERT INTO administrators (THREAD_ID, USER_ID, adminright_id) VALUES (20, 20, 0);
INSERT INTO administrators (THREAD_ID, USER_ID, adminright_id) VALUES (20, 21, 1);
INSERT INTO administrators (THREAD_ID, USER_ID, adminright_id) VALUES (21, 21, 0);
INSERT INTO administrators (THREAD_ID, USER_ID, adminright_id) VALUES (21, 20, 1);

INSERT INTO administrators (THREAD_ID, USER_ID, adminright_id) VALUES (22, 20, 1);
INSERT INTO administrators (THREAD_ID, USER_ID, adminright_id) VALUES (22, 22, 0);
INSERT INTO administrators (THREAD_ID, USER_ID, adminright_id) VALUES (23, 23, 0);


select * from threads;
select * from posts;
select * from admin_rights;
select * from administrators;
select * from forum_ranks;
select * from users_info;
select * from users;


--delete from threads;
--delete from posts;
--delete from admin_rights;
--delete from administrators;
--delete from forum_ranks;
--delete from users_info;
--delete from users;



