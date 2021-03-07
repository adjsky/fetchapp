#include <QDebug>
#include <QFile>
#include <QTextStream>

#include "tokenmanager.hpp"

QString TokenManager::filePath_{ "token.txt" };

TokenManager::TokenManager(QObject *parent) :
    QObject{ parent },
    cachedToken_{ }
{
}

void TokenManager::saveToken(const QString &token) {
    cachedToken_ = token;
    QFile tokenFile{ filePath_ };
    if (!tokenFile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        return; // todo
    }
    QTextStream stream{ &tokenFile };
    stream << token;
}

const QString& TokenManager::getToken() {
    if (cachedToken_ == "") {
        QFile tokenFile{ filePath_ };
        if (!tokenFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
            return cachedToken_;
        }
        QTextStream stream{ &tokenFile };
        cachedToken_ = stream.readLine();
    }
    return cachedToken_;
}

bool TokenManager::remove() {
    return QFile::remove(filePath_);
}
