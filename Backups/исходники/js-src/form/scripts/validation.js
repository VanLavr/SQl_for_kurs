let dataName;
let dataPass;

const usernameData = document.getElementById("username_input"); 
const passwordData = document.getElementById("password"); 

const btnForLogin = document.getElementById("Login_button");
if (btnForLogin) {
    btnForLogin.addEventListener("click", (event) => {
        dataName = getDataFromUsernameInput(event);
        dataPass = getDataFromPasswordInput(event);
        let body = `{"username": "${dataName}", "password": "${dataPass}"}`;
        (async () => {
            const res = await postDataAuth(body);
            console.log(res);
            if (res.message[1] === "authentication failed" || res.message === "user not found") {
                alert("authentication failed");
            } else if (res.message[1] === "authentication success") {
                window.location.href = "./Home.html";
            } else if (res.message === "Admin authenticated") {
                window.location.href = "./Admin/AirplanesSettings.html";
                console.log("PENIS");
            }
        })();
    });
}

const btnForCreate = document.getElementById("Create_button");
if (btnForCreate) {
    btnForCreate.addEventListener("click", (event) => {
        dataName = getDataFromUsernameInput(event);
        dataPass = getDataFromPasswordInput(event);
        let body = `{"username": "${dataName}", "password": "${dataPass}"}`;
        (async () => {
            const res = await postDataCreate(body);
            console.log(res);
            if (res.message.name === "error") {
                alert("This username already exists!");
            } else {
                alert("User created!");
            }
        })();
    });
}

function getDataFromUsernameInput(event) { 
    event.preventDefault(); 
    if (usernameData) { 
        const usernameDatavalue = usernameData.value;
        console.log(usernameDatavalue);
        return usernameDatavalue;
    } else {
        console.log("null");
    }
}

function getDataFromPasswordInput(event) {
    event.preventDefault(); 
    if (passwordData) { 
        const passwordDataValue = passwordData.value;
        console.log(passwordDataValue);
        return passwordDataValue;
    } else {
        console.log("null");
    }
}

async function postDataAuth(data) {
    try {
        const response = await fetch(
            "http://localhost:8080/api/auth", {
                method: "POST",
                cache: "no-cache",
                credentials: "same-origin", 
                headers: {
                    "Content-Type": "application/json",
                }, 
                body: data,
            }
        );
        
        const rs = await response.json();
        return rs;
    } catch (error) {
        console.log(error);
    }
}

async function postDataCreate(data) {
    try {
        const response = await fetch(
            "http://localhost:8080/api/create", {
                method: "POST",
                cache: "no-cache",
                credentials: "same-origin", 
                headers: {
                    "Content-Type": "application/json",
                }, 
                body: data,
            }
        );
        
        const rs = await response.json();
        return rs;
    } catch (error) {
        console.log(error);
    }
}