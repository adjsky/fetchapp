#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>

#include "TokenManager/tokenmanager.hpp"
#include "NetworkManager/NetworkManager.hpp"

int main(int argc, char* argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

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
    app.setOrganizationName("adjsky");

    // add c++ classes to qml
    QJSValue netManagerMeta{ engine.newQMetaObject(&NetworkManager::staticMetaObject) };
    engine.globalObject().setProperty("NetworkManager", netManagerMeta);
    qmlRegisterSingletonType<TokenManager>("TokenManager", 1, 0, "TokenManager",
                                           [](QQmlEngine* engine,
                                              QJSEngine* scriptEngine)
                                           {
                                               Q_UNUSED(engine)
                                               Q_UNUSED(scriptEngine)
                                               return new TokenManager{ };
                                           });

    engine.load(url);

    return app.exec();
}
