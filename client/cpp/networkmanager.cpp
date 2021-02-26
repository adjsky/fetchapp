#include <QNetworkReply>

#include "networkmanager.h"

NetworkManager::NetworkManager(QObject *parent) :
    QObject{ parent }
{
    manager_ = new QNetworkAccessManager{ this };
}

QObject* NetworkManager::singletonProvider(QQmlEngine* engine, QJSEngine* scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    return new NetworkManager();
}


void NetworkManager::test() {
    QNetworkRequest request{};
    request.setUrl(QUrl{ "https://localhost:8080" });

    QNetworkReply* reply{ manager_->get(request) };
    connect(reply, &QIODevice::readyRead, this, [reply]() {
        qDebug() << reply->readAll();
        reply->deleteLater();
    });

    connect(reply, &QNetworkReply::sslErrors, this, [reply](const QList<QSslError>&) {
        reply->ignoreSslErrors();
    });

    connect(reply, &QNetworkReply::errorOccurred, this, [reply](QNetworkReply::NetworkError code) {
        if (code == QNetworkReply::ConnectionRefusedError) {
            reply->deleteLater();
        }
    });
}
