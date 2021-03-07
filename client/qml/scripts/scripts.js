function validateEmail(email) {
    let emails = /^\S+@\S+$/.exec(email)
    if (emails === null) {
        return ""
    } else {
        return emails[0]
    }
}
