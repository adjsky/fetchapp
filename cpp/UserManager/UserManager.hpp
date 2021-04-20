#ifndef TOKENMANAGER_H
#define TOKENMANAGER_H

#include <QObject>
#include <QDir>

class UserManager : public QObject
{
    Q_OBJECT
public:
    explicit UserManager(QObject* parent = nullptr);

public:
    Q_INVOKABLE void saveToken(const QString& token,
                               bool saveToFile = true);
    Q_INVOKABLE QString getToken();

    Q_INVOKABLE void removeToken();

    void setSavePath(const QString& path);

private:
    QString cachedToken_;
    QDir savePath_;
};

#endif // TOKENMANAGER_H
