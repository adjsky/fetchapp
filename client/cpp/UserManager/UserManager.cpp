#include <QDebug>
#include <QFile>
#include <QTextStream>

#include "UserManager.hpp"

QString UserManager::filePath_{ "token.txt" };

UserManager::UserManager(QObject* parent) :
    QObject{ parent },
    cachedToken_{ }
{
}

void UserManager::saveToken(const QString& token,
                            bool saveToFile)
{
    cachedToken_ = token;
    if (saveToFile) {
        QFile tokenFile{ filePath_ };
        if (!tokenFile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
            return; // todo
        }
        QTextStream stream{ &tokenFile };
        stream << token;
    }
}

QString UserManager::getToken()
{
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

void UserManager::removeToken()
{
    return QFile::remove(filePath_);
}
