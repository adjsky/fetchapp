#include <QHttpMultiPart>
#include <QFile>
#include <fmt/core.h>

#include "NetworkManager.hpp"

NetworkManager::NetworkManager(const QString& url) :
    QObject{ },
    url_{ url },
    authToken_{ }
{
    manager_ = new QNetworkAccessManager{ this };
}

void NetworkManager::makeRequest(const QByteArray& method,
                                 const QByteArray& data)
{
    QNetworkRequest request{ };
    request.setUrl(url_);
    request.setRawHeader("Content-Type", "application/json");
    request.setRawHeader("Authorization",
                         fmt::format("Bearer {}", authToken_.toStdString()).c_str());
    QNetworkReply* reply{ manager_->sendCustomRequest(request, method, data) };

    connect(reply, &QNetworkReply::finished, this, [this, reply]()
    {
        reply->deleteLater();
        responseReceived(reply);
    });
}

void NetworkManager::makeMultipartRequest(const QByteArray& method,
                                          const QList<QVariantMap>& multipartData)
{
    QNetworkRequest request{ };
    request.setUrl(url_);
    request.setRawHeader("Authorization",
                         fmt::format("Bearer {}", authToken_.toStdString()).c_str());
    auto* multipart = new QHttpMultiPart{ QHttpMultiPart::RelatedType };
    for (const auto& data : multipartData) {
        QHttpPart part{ };
        if (data["Body"].canConvert(QMetaType::QString)) {
            part.setHeader(QNetworkRequest::ContentTypeHeader,
                           data["Content-Type"]);
            QString dataString{ data["Body"].toString() };
            if (dataString.startsWith("file://")) {
                auto* file{ new QFile{ dataString.remove("file://") }};
                file->setParent(multipart);
                if (file->open(QIODevice::ReadOnly)) {
                    part.setBodyDevice(file);
                }
            }
            else {
                part.setBody(data["Body"].toByteArray());
            }
        }
        multipart->append(part);
    }
    QNetworkReply* reply{ manager_->sendCustomRequest(request, method, multipart) };
    QObject::connect(reply, &QNetworkReply::finished, this, [this, reply, multipart]()
    {
        delete multipart;
        reply->deleteLater();
        responseReceived(reply);
    });
}

void NetworkManager::setAuthToken(const QString& token)
{
    authToken_ = token;
}

void NetworkManager::responseReceived(QNetworkReply* reply)
{
    if (reply->error() == QNetworkReply::ConnectionRefusedError) {
        emit finished("Server is not available", "");
    }
    else if (reply->error() == QNetworkReply::ContentOperationNotPermittedError) {
        emit finished("Method is not allowed", "");
    }
    else if (reply->error() == QNetworkReply::AuthenticationRequiredError) {
        emit finished("No auth token provided", reply->readAll());
    }
    else {
        emit finished("", reply->readAll());
    }
}
