let dataName;
let dataPass;

const usernameData = document.getElementById("username_input");
const passwordData = document.getElementById("password");

const btnForDelete = document.getElementById("deleteButton");
if (btnForDelete) {
    btnForDelete.addEventListener("click", (event) => {
        (async () => {
            const res = await getDeleteUser();
            if (res.message === "account deleted") {
                window.location.href = "./index.html";
            } else {
                console.log(res.message);
                alert("error occured!");
            }
        })();
    });
}

const btnForChange = document.getElementById("changeButton");
if (btnForChange) {
    btnForChange.addEventListener("click", (event) => {
        dataName = getDataFromUsernameInput(event);
        dataPass = getDataFromPasswordInput(event);
        console.log(dataName, dataPass);
        let body = `{"username": "${dataName}", "password": "${dataPass}"}`;
        (async () => {
            const res = await postDataUpdate(body);
            console.log(res);
            if (res.message === "update success") {
                alert("User updated!");
                window.location.href = "./index.html";
            } else {
                alert("error occured!");
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

async function getDeleteUser() {
    try {
        const response = await fetch("http://localhost:8080/api/deleteAcc");
        const rs = await response.json();
        return rs;
    } catch (error) {
        console.log(error);
    }
}

async function postDataUpdate(data) {
    try {
        const response = await fetch(
            "http://localhost:8080/api/changeUsername", {
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