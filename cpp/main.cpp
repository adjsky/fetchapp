#include <QApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QIcon>

#include "UserManager/UserManager.hpp"
#include "NetworkManager/NetworkManager.hpp"
#include "Language/Language.hpp"
#include "Config/Config.hpp"

int main(int argc, char* argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:///main.qml"));
    QObject::connect(&engine,
                     &QQmlApplicationEngine::objectCreated,
                     &app,
                     [url](QObject* obj, const QUrl& objUrl)
                     {
                         if (!obj && url == objUrl) {
                             QCoreApplication::exit(-1);
                         }
                     },
                     Qt::QueuedConnection);

    // initialization
    QFontDatabase::addApplicationFont(QStringLiteral(":/fonts/Roboto-Medium.ttf"));
    QFontDatabase::addApplicationFont(QStringLiteral(":/fonts/NotoSans-Regular.ttf"));
    QFont font{ QStringLiteral("Noto Sans"), 10 };
    app.setWindowIcon(QIcon{ ":/images/icon.png" });
    app.setFont(font);
    app.setOrganizationName(QStringLiteral("adjsky"));
    app.setApplicationName(QStringLiteral("fetchapp"));

    // add c++ classes to qml
    QJSValue netManagerMeta{ engine.newQMetaObject(&NetworkManager::staticMetaObject) };
    engine.globalObject().setProperty("NetworkManager", netManagerMeta);
    qmlRegisterSingletonType<UserManager>("UserManager", 1, 0, "UserManager",
                                          [](QQmlEngine* engine,
                                             QJSEngine* scriptEngine)
                                          {
                                              Q_UNUSED(engine)
                                              Q_UNUSED(scriptEngine)
                                              return new UserManager{ };
                                          });
    qmlRegisterSingletonType<UserManager>("Language", 1, 0, "Language",
                                          [](QQmlEngine* engine,
                                             QJSEngine* scriptEngine)
                                          {
                                              Q_UNUSED(scriptEngine)
                                              return new Language{ *engine };
                                          });
    qmlRegisterSingletonType<Config>("Config", 1, 0, "Config",
                                          [](QQmlEngine* engine,
                                             QJSEngine* scriptEngine)
                                          {
                                              Q_UNUSED(engine)
                                              Q_UNUSED(scriptEngine)
                                              return new Config{ };
                                          });
    qRegisterMetaType<serializable::ConfigData>();

    engine.load(url);

    return app.exec();
}
