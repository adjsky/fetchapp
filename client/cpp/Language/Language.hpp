#ifndef LANGUAGE_H
#define LANGUAGE_H

#include <QObject>
#include <QQmlEngine>
#include <QTranslator>

class Language : public QObject
{
    Q_OBJECT
public:
    explicit Language(QQmlEngine& engine);

    Q_INVOKABLE void set(const QString& language);

private:
    QTranslator* ruTranslator_;
    QTranslator* installedTranslator_;
    QQmlEngine& engine_;
};

#endif // LANGUAGE_H
