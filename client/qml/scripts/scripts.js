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
