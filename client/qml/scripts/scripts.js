function validateEmail(email) {
    let emails = /^\S+@\S+$/.exec(email)
    if (emails === null) {
        return false
    }
    return true
}

function validateTextFile(filepath) {
    let filepaths = /\.(txt)$/i.exec(filepath)
    if (filepaths === null) {
        return false
    }
    return true
}

function dropScheme(filepath) {
    let res = filepath.split("//")
    if (res.length === 1)  {
        return res
    }
    return res[1]
}
