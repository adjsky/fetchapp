#ifndef TOKENMANAGER_H
#define TOKENMANAGER_H

#include <QObject>

class UserManager : public QObject
{
    Q_OBJECT
public:
    explicit UserManager(QObject* parent = nullptr);

public:
    Q_INVOKABLE void saveToken(const QString& token,
                               bool saveToFile);
    Q_INVOKABLE QString getToken();

    Q_INVOKABLE static bool remove();

private:
    QString cachedToken_;
    static QString filePath_;
};

#endif // TOKENMANAGER_H
