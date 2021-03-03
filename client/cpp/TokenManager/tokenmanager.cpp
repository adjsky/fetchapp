#include <QDebug>

#include "tokenmanager.hpp"

TokenManager::TokenManager(QObject *parent) :
    QObject(parent)
{
}

void TokenManager::saveToken(const QString &token) {
    qDebug() << token;
    cachedToken = token;
}

const QString& TokenManager::getToken() {
    if (cachedToken == "") {
        return cachedToken;
    } else {
        return cachedToken;
    }
}
