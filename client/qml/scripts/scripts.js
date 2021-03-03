function makeLoginRequest(email, password, callback) {
    let xhr = new XMLHttpRequest()
    xhr.responseType = 'json'

    xhr.open("POST", "http://localhost:8080/login")

    xhr.onload = function() {
        callback(xhr)
    }

    xhr.onerror = function() {
        callback(xhr)
    }

    let request = {
        "email": email,
        "password": password
    }

    xhr.send(JSON.stringify(request))
}

function makeSignupRequest(email, password, callback) {
    let xhr = new XMLHttpRequest()
    xhr.responseType = 'json'

    xhr.open("POST", "http://localhost:8080/signup")

    xhr.onload = function() {
        callback(xhr)
    }

    xhr.onerror = function() {
        callback(xhr)
    }

    let request = {
        "email": email,
        "password": password
    }

    xhr.send(JSON.stringify(request))
}

function validateEmail(email) {
    let emails = /^\S+@\S+$/.exec(email)
    if (emails === null) {
        return ""
    } else {
        return emails[0]
    }
}
