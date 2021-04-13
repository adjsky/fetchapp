const fileScheme = "file://"

function validateEmail(email) {
    return /^\S+@\S+$/.exec(email) !== null
}

function validateTextFile(filePath) {
    return /\.(txt)$/i.exec(filePath) !== null
}

function dropScheme(filePath) {
    if (filePath.startsWith(fileScheme)) {
        filePath = filePath.substring(fileScheme.length)
        if (filePath[2] === ":") {
            filePath = filePath.substring(1)
        }
    }
    return filePath
}

function splitByIndex(string, index) {
    return [string.substring(0, index), string.substring(index + 1)]
}

function capitalize(string) {
    return string[0].toUpperCase() + string.substr(1, string.length)
}
