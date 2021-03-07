#include "NetworkManager.hpp"

NetworkManager::NetworkManager(QString url) :
    QObject{ },
    url_{ std::move(url) }
{
    manager_ = new QNetworkAccessManager{ this };
}

void NetworkManager::makeRequest(const QByteArray& method, const QByteArray& data) {
    QNetworkRequest request;
    request.setUrl(url_);
    request.setRawHeader("Content-Type", "application/json");
    QNetworkReply* reply{ manager_->sendCustomRequest(request, method, data) };

    connect(reply, &QNetworkReply::finished, this, [reply, this]() {
        reply->deleteLater();
        if (reply->error() == QNetworkReply::ConnectionRefusedError) {
            emit finished("Server is not available", "");
        }
        else {
            emit finished("", reply->readAll());
        }
    });
}


