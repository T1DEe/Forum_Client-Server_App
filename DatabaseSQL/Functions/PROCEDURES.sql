-- REGISTER USER --
CREATE OR REPLACE PROCEDURE REGISTERUSER (i_username IN ADMIN.USERS.USERNAME%TYPE, i_password IN ADMIN.USERS.PASSWORD%TYPE,
    i_sex IN ADMIN.users_info.sex%TYPE, i_location IN ADMIN.users_info.location%TYPE, o_reg OUT NUMBER)
AS
    user_exists NUMBER;
    newuser_id NUMBER;
    nowdate DATE;
BEGIN
    SELECT COUNT(*) INTO user_exists
        FROM   ADMIN.USERS
        WHERE  USERNAME = i_username;
    
    IF user_exists = 0 THEN
        INSERT INTO ADMIN.USERS (username, password) VALUES (i_username, i_password);
        SELECT ID INTO newuser_id FROM ADMIN.USERS WHERE USERNAME = i_username;
        SELECT sysdate INTO nowdate from dual; 
        INSERT INTO ADMIN.USERS_INFO (user_id, sex, location, reg_date) VALUES (newuser_id, i_sex, i_location, nowdate);
        o_reg := 1;
        
        COMMIT;
    ELSE
        o_reg := 0;
    END IF;
END;


-- AUTH USER --
CREATE OR REPLACE PROCEDURE AUTHUSER (i_username IN ADMIN.USERS.USERNAME%TYPE, i_password IN ADMIN.USERS.PASSWORD%TYPE, auth OUT NUMBER)
AS
BEGIN
    SELECT COUNT(*) INTO auth
        FROM   ADMIN.USERS
        WHERE  USERNAME = i_username AND PASSWORD = i_password;
END;


-- GET THREADS --
CREATE OR REPLACE PROCEDURE GETTHREADS (p_threadsset OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_threadsset FOR
      SELECT * FROM ADMIN.THREADS;
END;

-- CREATE THREAD --
CREATE OR REPLACE PROCEDURE CREATETHREAD (i_title IN ADMIN.THREADS.TITLE%TYPE, i_description IN ADMIN.THREADS.DESCRIPTION%TYPE,
i_creator_id IN ADMIN.USERS.ID%TYPE, o_create OUT NUMBER)
AS
    thread_exists NUMBER;
    newthread_id NUMBER;
BEGIN
    SELECT COUNT(*) INTO thread_exists
        FROM   ADMIN.THREADS
        WHERE TITLE = i_title;
    
    IF thread_exists = 0 THEN
        INSERT INTO ADMIN.THREADS (title, description) VALUES (i_title, i_description);
        SELECT ID INTO newthread_id FROM ADMIN.THREADS WHERE title = i_title;
        INSERT INTO ADMIN.ADMINISTRATORS (thread_id, user_id, adminright_id) VALUES (newthread_id, i_creator_id, 0);
        o_create := 1;
        
        COMMIT;
    ELSE
        o_create := 0;
    END IF;
END;

-- GET POSTS --
CREATE OR REPLACE PROCEDURE GETPOSTS(i_threadid IN ADMIN.THREADS.ID%TYPE, p_postsset OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_postsset FOR SELECT ADMIN.POSTS.ID, ADMIN.USERS.ID AS USER_ID, USERNAME, PROFILE_PHOTO_PATH, CONTENT, CREATED_TIME, TO_POST_ID 
        FROM ADMIN.POSTS 
            INNER JOIN ADMIN.USERS ON ADMIN.POSTS.USER_ID = ADMIN.USERS.ID 
            INNER JOIN ADMIN.USERS_INFO ON ADMIN.USERS.ID = ADMIN.USERS_INFO.USER_ID 
            WHERE THREAD_ID = i_threadid;
END GETPOSTS;


-- GET USER_INFO --
CREATE OR REPLACE PROCEDURE GETUSERINFO (i_userid IN NUMBER, p_userinfoset OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_userinfoset FOR
      SELECT * FROM ADMIN.USERS_INFO WHERE USER_ID = i_userid;
END;