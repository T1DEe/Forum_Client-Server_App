// ============ Import ============
const http = require('http');
const url = require('url');
const oracledb = require('oracledb');

// // ============ Global variables ============
 oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
 const maxRows = 100000;
 const orclPass = "root"

 let clientConnect;
 let adminConnect;

 // ============ Server creation and setup ============
const server = http.createServer().listen(5000, () => {
    connectDatabase();
});

// ============ Server events ============
server.on('request', (request, response) => {
    console.log('request');
    
    if (request.method == 'GET') {
        switch (url.parse(request.url).pathname) {
            
            case '/getThreads' : {
                try {
                    getThreads( (resultSet) => {
                        response.writeHead(200, {'Content-Type':'application/json'} );
                        response.end(JSON.stringify(resultSet));
                    });
                } catch (err) {
                    console.log(err);
                }
                break;
            }
            
            case '/getPosts' : {
                let queryParams = url.parse(request.url, true).query
                console.log(queryParams);
                const threadId = Number.parseInt(queryParams.threadId);
                console.log(threadId);
                try {
                    getPosts(threadId, (sqlResult) => {
                        response.writeHead(200, {'Content-Type':'application/json'} );
                        response.end(JSON.stringify(sqlResult));
                    });
                } catch (err) {
                    console.log(err);
                }
                break;
            }
            
            case '/getUserInfo' : {
                let queryParams = url.parse(request.url, true).query
                console.log(queryParams);
                const userId = Number.parseInt(queryParams.userId);
                console.log(userId);
                try {
                    getUserInfo(userId, (resultSet) => {
                        response.writeHead(200, {'Content-Type':'application/json'} );
                        response.end(JSON.stringify(resultSet));
                    });
                } catch (err) {
                    console.log(err);
                }
                break;
            }
        }
    } else if (request.method == 'POST') {
        switch (url.parse(request.url).pathname) {
            case '/authUser' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const userCreds = JSON.parse(data);
                
                    try {
                        authUser(userCreds.username, userCreds.password, (authUser) => {
                            response.writeHead(200, {'Content-Type':'application/json'} );
                            response.end(JSON.stringify(authUser));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/registerUser' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const userCreds = JSON.parse(data);
                    try {
                        registerUser(userCreds.username, userCreds.password, userCreds.sex, 
                            userCreds.location, (regConfirm) => {
                            response.writeHead(200, {'Content-Type':'application/json'} );
                            response.end(JSON.stringify(regConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                        response.writeHead(500, {'Content-Type':'text/plain'} );
                        response.end("Server error.");
                    }
                });
                break;
            }
            case '/createThread' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const threadData = JSON.parse(data);
                    try {
                        createThread(threadData.title, threadData.description, threadData.creator_id, 
                            (createConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(createConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/createPost' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const postData = JSON.parse(data);
                    try {
                        createPost(postData.thread_id, postData.user_id, postData.content, postData.to_post_id, 
                            (createConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(createConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/deletePost' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const postData = JSON.parse(data);
                    try {
                        deletePost(postData.post_id, (deleteConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(deleteConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/editThread' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const threadData = JSON.parse(data);
                    try {
                        editThread(threadData.thread_id, threadData.title, threadData.description, (editConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(editConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/editPost' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const PostData = JSON.parse(data);
                    try {
                        editPost(PostData.thread_id, PostData.user_id, PostData.content, (editConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(editConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/editUserInfo' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const userData = JSON.parse(data);
                    try {
                        editUserInfo(userData.user_id, userData.sex, userData.location, (editConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(editConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/getAdmins' : {
                let queryParams = url.parse(request.url, true).query
                console.log(queryParams);
                const threadId = Number.parseInt(queryParams.threadId);
                console.log(threadId);
                try {
                    getAdmins(threadId, (sqlResult) => {
                        response.writeHead(200, {'Content-Type':'application/json'} );
                        response.end(JSON.stringify(sqlResult));
                    });
                } catch (err) {
                    console.log(err);
                }
                break;
            }
            case '/setAdmin' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const adminData = JSON.parse(data);
                    try {
                        setAdmin(adminData.thread_id, adminData.user_id, adminData.rights_id, (createConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(createConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/editAdmin' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const adminData = JSON.parse(data);
                    try {
                        editAdmin(adminData.thread_id, adminData.user_id, adminData.rights_id, (editConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(editConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
            case '/deleteAdmin' : {
                let data = ''
                request.on('data', chunk => {
                    data += chunk;
                })
                request.on('end', () => {
                    const adminData = JSON.parse(data);
                    try {
                        deleteAdmin(adminData.thread_id, adminData.user_id, (deleteConfirm) => {
                                response.writeHead(200, {'Content-Type':'application/json'} );
                                response.end(JSON.stringify(deleteConfirm));
                        });
                    } catch (err) {
                        console.log(err);
                    }
                });
                break;
            }
        }
    }
});

// ==========================================================================
// ==========================================================================
// ==========================================================================

server.on('close', () => {
    disconnectDatabase();
});
server.on('connection', () => {
    console.log('connect');
})


// ============ SQL executions ============
async function authUser(username, password, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.AUTHUSER(:username, :password, :authUser);
         END;`,
        {
            username: { dir: oracledb.BIND_IN, val: username, type: oracledb.STRING, maxSize: 20 },
            password: { dir: oracledb.BIND_IN, val: password, type: oracledb.STRING, maxSize: 20 },
            authUser: { type: oracledb.CURSOR, dir : oracledb.BIND_OUT }
        }
    );

    const resultSet = result.outBinds.authUser;
    let rows = await resultSet.getRows(maxRows);
    if (rows.length > 1 || rows.length == 0) {
        console.log("authUser(): auth error");
        callback(false)
    } else {
        console.log("authUser(): Got " + rows.length + " rows");
        console.log(rows);
        callback(rows[0])
    }
  
    await resultSet.close();
}

async function registerUser(username, password, sex, location, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.REGISTERUSER(:username, :password, :sex, :location, :regconfirm);
         END;`,
        {
            username: { dir: oracledb.BIND_IN, val: username, type: oracledb.STRING, maxSize: 20 },
            password: { dir: oracledb.BIND_IN, val: password, type: oracledb.STRING, maxSize: 20 },
            sex: { dir: oracledb.BIND_IN, val: sex, type: oracledb.NUMBER },
            location: { dir: oracledb.BIND_IN, val: location, type: oracledb.STRING, maxSize: 20 },
            regconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );
    const regObj = result.outBinds;
    console.log(regObj);
    if (regObj.regconfirm == 1) {
        console.log("regiterUser(): user registered.");
        callback(true);
    } else {
        console.log("regiterUser(): registration denied.");
        callback(false);
    }
}

async function getThreads(callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.GETTHREADS(:cursor);
         END;`,
        {
          cursor: { type: oracledb.CURSOR, dir : oracledb.BIND_OUT }
        }
    );
  
    const resultSet = result.outBinds.cursor;
    let rows = await resultSet.getRows(maxRows);
    if (rows.length > 0) {
        console.log("getRows(): Got " + rows.length + " rows");
        console.log(rows);
    } else {
        console.log("getRows(): RESULT SET IS EMPTY");
    }
  
    await resultSet.close();
    callback(rows)
}

async function createThread(title, description, creator_id, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.CREATETHREAD(:title, :description, :creator_id, :createconfirm);
        END;`,
        {
            title: { dir: oracledb.BIND_IN, val: title, type: oracledb.STRING, maxSize: 30 },
            description: { dir: oracledb.BIND_IN, val: description, type: oracledb.STRING, maxSize: 200 },
            creator_id: { dir: oracledb.BIND_IN, val: creator_id, type: oracledb.NUMBER },
            createconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );
    const createObj = result.outBinds;
    console.log(createObj);
    if (createObj.createconfirm == 1) {
        console.log("createThread(): thread created.");
        callback(true);
    } else {
        console.log("createThread(): thread creation denied.");
        callback(false);
    }
}

async function editThread(threadId, title, description, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.EDITTHREAD(:thread_id, :title, :description, :editconfirm);
        END;`,
        {
            thread_id: { dir: oracledb.BIND_IN, val: threadId, type: oracledb.NUMBER },
            title: { dir: oracledb.BIND_IN, val: title, type: oracledb.STRING, maxSize: 30 },
            description: { dir: oracledb.BIND_IN, val: description, type: oracledb.STRING, maxSize: 200 },
            editconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );
    const editObj = result.outBinds;
    console.log(editObj);
    if (editObj.editconfirm == 1) {
        console.log("editThread(): thread edited.");
        callback(true);
    } else {
        console.log("editThread(): thread edition denied.");
        callback(false);
    }
}

async function getPosts(threadId, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.GETPOSTS(:threadid, :cursor);
         END;`,
        {
            threadid: { dir: oracledb.BIND_IN, val: threadId, type: oracledb.NUMBER },
            cursor: { type: oracledb.CURSOR, dir : oracledb.BIND_OUT }
        }
    );
  
    const resultSet = result.outBinds.cursor;
    let rows = await resultSet.getRows(maxRows);
    if (rows.length > 0) {
        console.log("getPosts(): Got " + rows.length + " rows");
        console.log(rows);
    } else {
        console.log("getPosts(): RESULT SET IS EMPTY");
    }
  
    await resultSet.close();
    callback(rows)
}

async function createPost(threadId, userId, content, toPostId, callback) {
    const result = await clientConnect.execute(
        `BEGIN
            ADMIN.CREATEPOST(:threadid, :userid, :content, :topostid, :createconfirm);
        END;`,
        {
            threadid: { dir: oracledb.BIND_IN, val: threadId, type: oracledb.NUMBER },
            userid: { dir: oracledb.BIND_IN, val: userId, type: oracledb.NUMBER },
            content: { dir: oracledb.BIND_IN, val: content, type: oracledb.STRING, maxSize: 2000 },
            topostid: { dir: oracledb.BIND_IN, val: toPostId, type: oracledb.NUMBER },
            createconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );

    const createObj = result.outBinds;
    console.log(createObj);
    if (createObj.createconfirm == 1) {
        console.log("createPost(): post created.");
        callback(true);
    } else {
        console.log("createPost(): post creation denied.");
        callback(false);
    }
}

async function editPost(threadId, userId, content, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.EDITPOST(:thread_id, :user_id, :content, :editconfirm);
        END;`,
        {
            thread_id: { dir: oracledb.BIND_IN, val: threadId, type: oracledb.NUMBER },
            user_id: { dir: oracledb.BIND_IN, val: threadId, type: oracledb.NUMBER },
            content: { dir: oracledb.BIND_IN, val: title, type: oracledb.STRING, maxSize: 2000 },
            editconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );
    const editObj = result.outBinds;
    console.log(editObj);
    if (editObj.editconfirm == 1) {
        console.log("editPost(): post edited.");
        callback(true);
    } else {
        console.log("editPost(): post edition denied.");
        callback(false);
    }
}

async function deletePost(postId, callback) {
    const result = await clientConnect.execute(
        `BEGIN
            ADMIN.DELETEPOST(:postid, :deleteconfirm);
        END;`,
        {
            postid: { dir: oracledb.BIND_IN, val: postId, type: oracledb.NUMBER },
            deleteconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );

    const deleteObj = result.outBinds;
    console.log(deleteObj);
    if (deleteObj.deleteconfirm == 1) {
        console.log("deletePost(): post deleted.");
        callback(true);
    } else {
        console.log("deletePost(): post removing denied.");
        callback(false);
    }
}

async function getUserInfo(userId, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.GETUSERINFO(:userid, :cursor);
         END;`,
        {
            userid: { dir: oracledb.BIND_IN, val: userId, type: oracledb.NUMBER },
            cursor: { type: oracledb.CURSOR, dir : oracledb.BIND_OUT }
        }
    );
  
    const resultSet = result.outBinds.cursor;
    let rows = await resultSet.getRows(maxRows);
    if (rows.length > 0) {
        console.log("getUserInfo(): Got " + rows.length + " rows");
        console.log(rows);
    } else {
        console.log("getUserInfo(): RESULT SET IS EMPTY");
    }
  
    await resultSet.close();
    callback(rows)
}

async function editUserInfo(userId, sex, location, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.EDITUSERINFO(:user_id, :sex, :location, :editconfirm);
        END;`,
        {
            user_id: { dir: oracledb.BIND_IN, val: userId, type: oracledb.NUMBER },
            sex: { dir: oracledb.BIND_IN, val: sex, type: oracledb.NUMBER },
            location: { dir: oracledb.BIND_IN, val: location, type: oracledb.STRING, maxSize: 20 },
            editconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );
    const editObj = result.outBinds;
    console.log(editObj);
    if (editObj.editconfirm == 1) {
        console.log("editUserInfo(): user edited.");
        callback(true);
    } else {
        console.log("editUserInfo(): user edition denied.");
        callback(false);
    }
}

async function getAdmins(threadId, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.GETADMINS(:threadId, :cursor);
         END;`,
        {
            threadId: { dir: oracledb.BIND_IN, val: threadId, type: oracledb.NUMBER },
            cursor: { type: oracledb.CURSOR, dir : oracledb.BIND_OUT }
        }
    );
  
    const resultSet = result.outBinds.cursor;
    let rows = await resultSet.getRows(maxRows);
    if (rows.length > 0) {
        console.log("getAdmins(): Got " + rows.length + " rows");
        console.log(rows);
    } else {
        console.log("getAdmins(): RESULT SET IS EMPTY");
    }
  
    await resultSet.close();
    callback(rows)
}

async function setAdmin(threadId, userId, rightsId, callback) {
    const result = await clientConnect.execute(
        `BEGIN
            ADMIN.SETADMIN(:thread_id, :user_id, :rights_id, :createconfirm);
        END;`,
        {
            thread_id: { dir: oracledb.BIND_IN, val: threadId, type: oracledb.NUMBER },
            user_id: { dir: oracledb.BIND_IN, val: userId, type: oracledb.NUMBER },
            rights_id: { dir: oracledb.BIND_IN, val: rightsId, type: oracledb.NUMBER },
            createconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );

    const createObj = result.outBinds;
    console.log(createObj);
    if (createObj.createconfirm == 1) {
        console.log("setAdmin(): admin created.");
        callback(true);
    } else {
        console.log("setAdmin(): admin creation denied.");
        callback(false);
    }
}

async function editAdmin(threadId, userId, rightId, callback) {
    const result = await clientConnect.execute(
        `BEGIN
           ADMIN.EDITADMIN(:thread_id, :user_id, :rights_id, :editconfirm);
        END;`,
        {
            thread_id: { dir: oracledb.BIND_IN, val: threadId, type: oracledb.NUMBER },
            user_id: { dir: oracledb.BIND_IN, val: userId, type: oracledb.NUMBER },
            rights_id: { dir: oracledb.BIND_IN, val: rightId, type: oracledb.NUMBER },
            editconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );
    const editObj = result.outBinds;
    console.log(editObj);
    if (editObj.editconfirm == 1) {
        console.log("editAdmin(): admin edited.");
        callback(true);
    } else {
        console.log("editAdmin(): admin edition denied.");
        callback(false);
    }
}

async function deleteAdmin(thread_id, user_id, callback) {
    const result = await clientConnect.execute(
        `BEGIN
            ADMIN.DELETEADMIN(:thread_id, :user_id, :deleteconfirm);
        END;`,
        {
            thread_id: { dir: oracledb.BIND_IN, val: thread_id, type: oracledb.NUMBER },
            user_id: { dir: oracledb.BIND_IN, val: user_id, type: oracledb.NUMBER },
            deleteconfirm: { type: oracledb.NUMBER, dir : oracledb.BIND_OUT }
        }
    );

    const deleteObj = result.outBinds;
    console.log(deleteObj);
    if (deleteObj.deleteconfirm == 1) {
        console.log("deleteAdmin(): admin removed.");
        callback(true);
    } else {
        console.log("deleteAdmin(): admin removing denied.");
        callback(false);
    }
}

// ============ DB connection ============
async function connectDatabase() {
    try {
        clientConnect = await oracledb.getConnection({
            user          : "APPCLIENT",
            password      : orclPass,
            connectString : "localhost/ORCLCDB.localdomain"
        });
        adminConnect = await oracledb.getConnection({
            user          : "ADMIN",
            password      : orclPass,
            connectString : "localhost/ORCLCDB.localdomain"
        });
        await console.log('Connected to database.')
    } catch (err) {
        console.error(err);
    }
}

async function disconnectDatabase() {
    try {
        await clientConnect.close();
        await adminConnect.close();
        await console.log('Connections closed.')
    } catch (err) {
        console.error(err);
    }
}