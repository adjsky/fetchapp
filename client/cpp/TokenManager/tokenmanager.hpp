#ifndef TOKENMANAGER_H
#define TOKENMANAGER_H

#include <QObject>

class TokenManager : public QObject
{
    Q_OBJECT
public:
    explicit TokenManager(QObject *parent = nullptr);

    Q_INVOKABLE void saveToken(const QString& token);
    Q_INVOKABLE const QString& getToken();

private:
    QString cachedToken;
};

#endif // TOKENMANAGER_H
