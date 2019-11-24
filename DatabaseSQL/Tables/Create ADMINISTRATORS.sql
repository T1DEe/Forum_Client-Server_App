CREATE TABLE ADMINISTRATORS  (
    ID NUMBER(8, 0) GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 MINVALUE 0 NOT NULL,
    THREAD_ID NUMBER(7,0) NOT NULL,
    USER_ID NUMBER(10, 0) NOT NULL,
    ADMINRIGHT_ID NUMBER(4,0) NOT NULL,
    
    CONSTRAINT ADMINISTRATORS_ID_PK PRIMARY KEY (ID),
    CONSTRAINT ADMINISTRATORS_UNIQUE UNIQUE (THREAD_ID, USER_ID)
);


-- foreign keys -- 

ALTER TABLE ADMINISTRATORS
ADD CONSTRAINT TO_ADMIN_RIGHT_ID_FK FOREIGN KEY (ADMINRIGHT_ID)
    REFERENCES ADMIN_RIGHTS (ID)
ENABLE;

ALTER TABLE ADMINISTRATORS 
ADD CONSTRAINT TO_THREADS_ID_FK FOREIGN KEY (THREAD_ID)
    REFERENCES THREADS (ID)
ENABLE;

ALTER TABLE ADMINISTRATORS 
ADD CONSTRAINT TO_USERS_ID_FK FOREIGN KEY (USER_ID)
    REFERENCES USERS (ID)
ENABLE;