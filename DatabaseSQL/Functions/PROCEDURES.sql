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
CREATE OR REPLACE PROCEDURE AUTHUSER (i_username IN ADMIN.USERS.USERNAME%TYPE, i_password IN ADMIN.USERS.PASSWORD%TYPE, o_authset OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN o_authset FOR
        SELECT * FROM   ADMIN.USERS
            WHERE  USERNAME = i_username AND PASSWORD = i_password;
END;
--============================================================================================================--
--============================================================================================================--
-- GET THREADS --
CREATE OR REPLACE PROCEDURE GETTHREADS (o_threadsset OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN o_threadsset FOR
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

-- EDIT THREAD --
CREATE OR REPLACE PROCEDURE EDITTHREAD (i_thread_id IN ADMIN.THREADS.ID%TYPE, i_title IN ADMIN.THREADS.TITLE%TYPE, 
    i_description IN ADMIN.THREADS.DESCRIPTION%TYPE, o_edit OUT NUMBER)
AS
BEGIN
    UPDATE ADMIN.THREADS 
        SET    title = i_title, 
                description = i_description
        WHERE id = i_thread_id;
    COMMIT;
    o_edit := 1;
END;
--============================================================================================================--
--============================================================================================================--
-- GET POSTS --
CREATE OR REPLACE PROCEDURE GETPOSTS(i_thread_id IN ADMIN.THREADS.ID%TYPE, o_postsset OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN o_postsset FOR SELECT ADMIN.POSTS.ID, ADMIN.USERS.ID AS USER_ID, USERNAME, PROFILE_PHOTO_PATH, CONTENT, CREATED_TIME, TO_POST_ID 
        FROM ADMIN.POSTS 
            INNER JOIN ADMIN.USERS ON ADMIN.POSTS.USER_ID = ADMIN.USERS.ID 
            INNER JOIN ADMIN.USERS_INFO ON ADMIN.USERS.ID = ADMIN.USERS_INFO.USER_ID 
            WHERE THREAD_ID = i_thread_id;
END GETPOSTS;

-- CREATE POST --
CREATE OR REPLACE PROCEDURE CREATEPOST (i_thread_id IN ADMIN.THREADS.ID%TYPE, i_user_id IN ADMIN.USERS.ID%TYPE,
    i_content IN ADMIN.POSTS.CONTENT%TYPE, i_to_id IN NUMBER, o_create OUT NUMBER)
AS
    nowdate DATE;
BEGIN
    IF i_to_id = -1 THEN 
        SELECT sysdate INTO nowdate from dual; 
        INSERT INTO ADMIN.POSTS (thread_id, user_id, content, created_time, to_post_id) VALUES (i_thread_id, i_user_id, i_content, nowdate, null);
    ELSE 
        SELECT sysdate INTO nowdate from dual; 
        INSERT INTO ADMIN.POSTS (thread_id, user_id, content, created_time, to_post_id) VALUES (i_thread_id, i_user_id, i_content, nowdate, i_to_id);
    END IF;
    COMMIT;
    o_create := 1;
END;

-- EDIT POST --
CREATE OR REPLACE PROCEDURE EDITPOST (i_thread_id IN ADMIN.THREADS.ID%TYPE, i_user_id IN ADMIN.USERS.ID%TYPE,
    i_content IN ADMIN.POSTS.CONTENT%TYPE,  o_edit OUT NUMBER)
AS
BEGIN
    UPDATE ADMIN.POSTS 
        SET    content = i_content
        WHERE thread_id = i_thread_id AND user_id = i_user_id;
    COMMIT;
    o_edit := 1;
END;

-- DELETE POST --
CREATE OR REPLACE PROCEDURE DELETEPOST (i_post_id IN ADMIN.POSTS.ID%TYPE, o_delete OUT NUMBER)
AS
BEGIN
    DELETE FROM ADMIN.POSTS WHERE id = i_post_id;
    DELETE FROM ADMIN.POSTS WHERE to_post_id = i_post_id;
    COMMIT;
    o_delete := 1;
END;
--============================================================================================================--
--============================================================================================================--
-- GET USER_INFO --
CREATE OR REPLACE PROCEDURE GETUSERINFO (i_userid IN NUMBER, o_userinfoset OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN o_userinfoset FOR
      SELECT * FROM ADMIN.USERS_INFO WHERE USER_ID = i_userid;
END;

-- EDIT USER_INFO --
CREATE OR REPLACE PROCEDURE EDITUSERINFO (i_user_id IN ADMIN.USERS.ID%TYPE, i_sex IN ADMIN.USERS_INFO.SEX%TYPE,
    i_location IN ADMIN.USERS_INFO.LOCATION%TYPE,  o_edit OUT NUMBER)
AS
BEGIN
    UPDATE ADMIN.USERS_INFO 
        SET    sex = i_sex,
                location = i_location
        WHERE user_id = i_user_id;
    COMMIT;
    o_edit := 1;
END;
--============================================================================================================--
--============================================================================================================--
-- GET ADMINS --
CREATE OR REPLACE PROCEDURE GETADMINS (i_thread_id IN ADMIN.THREADS.ID%TYPE, o_adminsset OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN o_adminsset FOR
      SELECT * FROM ADMIN.ADMINISTRATORS WHERE THREAD_ID =i_thread_id;
END;

-- CREATE ADMIN --
CREATE OR REPLACE PROCEDURE SETADMIN (i_thread_id IN ADMIN.THREADS.ID%TYPE, i_user_id IN ADMIN.USERS.ID%TYPE,
    i_rights_id IN ADMIN.ADMINISTRATORS.ADMINRIGHT_ID%TYPE, o_create OUT NUMBER)
AS
BEGIN
    INSERT INTO ADMIN.ADMINISTRATORS (thread_id, user_id, adminright_id) VALUES (i_thread_id, i_user_id, i_rights_id);
    COMMIT;
    o_create := 1;
END;

-- EDIT ADMIN --
CREATE OR REPLACE PROCEDURE EDITADMIN (i_thread_id IN ADMIN.THREADS.ID%TYPE, i_user_id IN ADMIN.USERS.ID%TYPE,
    i_rights_id IN ADMIN.ADMINISTRATORS.ADMINRIGHT_ID%TYPE, o_edit OUT NUMBER)
AS
BEGIN
    UPDATE ADMIN.ADMINISTRATORS 
        SET    adminright_id = i_rights_id
        WHERE thread_id = i_thread_id AND user_id = i_user_id;
    COMMIT;
    o_edit := 1;
END;

-- DELETE ADMIN --
CREATE OR REPLACE PROCEDURE DELETEADMIN (i_thread_id IN ADMIN.THREADS.ID%TYPE, i_user_id IN ADMIN.USERS.ID%TYPE, o_delete OUT NUMBER)
AS
BEGIN
    DELETE FROM ADMIN.ADMINISTRATORS WHERE thread_id = i_thread_id AND user_id = i_user_id;
    COMMIT;
    o_delete := 1;
END;