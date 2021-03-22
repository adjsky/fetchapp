#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class NetworkManager : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE explicit NetworkManager(const QString& url, const QString& authToken = QString{});

    Q_INVOKABLE void makeRequest(const QByteArray& method, const QByteArray& data = QByteArray{});
    Q_INVOKABLE void makeMultipartRequest(const QByteArray& method, const QList<QVariantMap>& multipartData);

signals:
    void finished(const QString& error, const QByteArray& data);

private:
    void responseReceived(QNetworkReply *reply);

    QNetworkAccessManager* manager_;
    QUrl url_;
    QString authToken_;
};
