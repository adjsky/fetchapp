#include <QApplication>

#include "Language.hpp"

Language::Language(QQmlEngine& engine) :
    QObject{ },
    installedTranslator_{ nullptr },
    engine_{ engine }
{
    const QString& appName{ qApp->applicationName() };
    ruTranslator_ = new QTranslator{ this };
    ruTranslator_->load(appName + "_ru");
}

void Language::set(const QString& language)
{
    if (language == "ru") {
        qApp->installTranslator(ruTranslator_);
        installedTranslator_ = ruTranslator_;
    }
    else {
        if (installedTranslator_) {
            qApp->removeTranslator(installedTranslator_);
            installedTranslator_ = nullptr;
        }
    }

    engine_.retranslate();
}
