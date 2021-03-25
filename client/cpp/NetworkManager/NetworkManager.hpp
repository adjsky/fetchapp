#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE explicit NetworkManager(const QString& url);

    Q_INVOKABLE void makeRequest(const QByteArray& method,
                                 const QByteArray& data);
    Q_INVOKABLE void makeMultipartRequest(const QByteArray& method,
                                          const QList<QVariantMap>& multipartData);
    Q_INVOKABLE void setAuthToken(const QString& token);

    signals:
        void finished(const QString& error, const QByteArray& data
    );

private:
    void responseReceived(QNetworkReply* reply);

    QNetworkAccessManager* manager_;
    QUrl url_;
    QString authToken_;
};

#endif // NETWORKMANAGER_H
