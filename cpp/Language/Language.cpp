#include <QApplication>

#include "Language.hpp"

Language::Language(QQmlEngine& engine) :
    QObject{ },
    translators_{ },
    installedTranslator_{ nullptr },
    engine_{ engine }
{
    const QString& appName{ qApp->applicationName() };
    QTranslator* ruTranslator_ = new QTranslator{ this };
    ruTranslator_->load(":/translations/" + appName + "_ru");
    translators_["ru"] = ruTranslator_;
}

void Language::set(const QString& language)
{
    QString lowerLanguage{ language.toLower() };
    if (installedTranslator_ != nullptr) {
        qApp->removeTranslator(installedTranslator_);
    }
    if (!lowerLanguage.startsWith("en")) {
        auto it{ translators_.find(lowerLanguage.left(2)) };
        if (it != translators_.end()) {
            qApp->installTranslator(*it);
            installedTranslator_ = *it;
        }
    }

    engine_.retranslate();
}
