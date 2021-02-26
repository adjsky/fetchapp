#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QQmlEngine>
#include <QJSEngine>

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);

    // this function is used only to provide new singleton instance that'll be owned by qml engine
    static QObject* singletonProvider(QQmlEngine* engine, QJSEngine* scriptEngine);

    Q_INVOKABLE void test();

private:
    QNetworkAccessManager* manager_;
};

#endif // NETWORKMANAGER_H
