-- user добавляется пост в POSTS, USERS_INFO увеличивает message_count 
-- user добавляется пост в POSTS, THREADS увеличивает  post_count 
CREATE OR REPLACE TRIGGER  POSTS_INSERT
  AFTER INSERT ON POSTS              
  for each row  
DECLARE
   OLD_MSG_COUNT ADMIN.users_info.message_count%TYPE;
   NEW_MSG_COUNT ADMIN.users_info.message_count%TYPE;
   OLD_PST_COUNT ADMIN.threads.posts_count%TYPE;
   NEW_PST_COUNT ADMIN.threads.posts_count%TYPE;
BEGIN   
    SELECT message_count INTO OLD_MSG_COUNT FROM ADMIN.users_info WHERE USER_ID = :NEW.USER_ID;
    NEW_MSG_COUNT := OLD_MSG_COUNT + 1;
    
    SELECT posts_count INTO OLD_PST_COUNT FROM ADMIN.THREADS WHERE ID = :NEW.THREAD_ID;
    NEW_PST_COUNT := OLD_PST_COUNT + 1;
    

    UPDATE THREADS
        SET POSTS_COUNT = NEW_PST_COUNT
        WHERE ID = :NEW.THREAD_ID;
        
    UPDATE USERS_INFO
        SET MESSAGE_COUNT = NEW_MSG_COUNT
        WHERE USER_ID = :NEW.USER_ID;
END; 

-- user удаляет пост из POSTS, USERS_INFO уменьшает  message_count 
-- user удаляет пост из POSTS, THREADS уменьшает  post_count 
CREATE OR REPLACE TRIGGER  POSTS_DELETE
  AFTER DELETE ON POSTS              
  for each row  
DECLARE
   OLD_MSG_COUNT ADMIN.users_info.message_count%TYPE;
   NEW_MSG_COUNT ADMIN.users_info.message_count%TYPE;
   OLD_PST_COUNT ADMIN.threads.posts_count%TYPE;
   NEW_PST_COUNT ADMIN.threads.posts_count%TYPE;
BEGIN   
    SELECT message_count INTO OLD_MSG_COUNT FROM ADMIN.users_info WHERE USER_ID = :OLD.USER_ID;
    NEW_MSG_COUNT := OLD_MSG_COUNT - 1;
    
    SELECT posts_count INTO OLD_PST_COUNT FROM ADMIN.THREADS WHERE ID = :OLD.THREAD_ID;
    NEW_PST_COUNT := OLD_PST_COUNT - 1;
    

    UPDATE THREADS
        SET POSTS_COUNT = NEW_PST_COUNT
        WHERE ID = :OLD.THREAD_ID;
        
    UPDATE USERS_INFO
        SET MESSAGE_COUNT = NEW_MSG_COUNT
        WHERE USER_ID = :OLD.USER_ID;
END; 

