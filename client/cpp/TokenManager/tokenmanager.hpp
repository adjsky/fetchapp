#ifndef TOKENMANAGER_H
#define TOKENMANAGER_H

#include <QObject>

class TokenManager : public QObject
{
    Q_OBJECT
public:
    explicit TokenManager(QObject *parent = nullptr);

public:
    Q_INVOKABLE void saveToken(const QString& token);
    Q_INVOKABLE const QString& getToken();

    Q_INVOKABLE static bool remove();

private:
    QString cachedToken_;
    static QString filePath_;
};

#endif // TOKENMANAGER_H
