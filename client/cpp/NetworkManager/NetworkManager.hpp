#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class NetworkManager : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE explicit NetworkManager(QString url);

    Q_INVOKABLE void makeRequest(const QByteArray& method, const QByteArray& data = "");

signals:
    void finished(const QString& error, const QByteArray& data);

private:
    QNetworkAccessManager* manager_;
    QUrl url_;
};
