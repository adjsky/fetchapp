#include <fstream>
#include <QDebug>
#include <QString>

#include "Config.hpp"

const QString configFileName{ QStringLiteral("config.json") };

void serializable::to_json(json& j, const ConfigData& cfg)
{
    j = json{{ "language", cfg.language.toStdString() }};
}

void serializable::from_json(const json& j, ConfigData& cfg)
{
    cfg.language = QString::fromStdString(j.at("language").get<std::string>());
}

Config::Config() :
    QObject{ },
    data_{ },
    savePath_{ }
{
}

Config::~Config()
{
    save();
}

void Config::load()
{
    std::ifstream file{ savePath_.filePath(configFileName).toStdString() };
    if (file.is_open()) {
        json j{ };
        try {
            file >> j;
        }
        catch (const nlohmann::detail::parse_error& err) {
            qDebug() << err.what();
        }
        try {
            j.get_to(data_);
        }
        catch (const nlohmann::json::exception& err) {
            qDebug() << err.what();
        }
    }
}

void Config::save()
{
    json j{ data_ };
    std::ofstream file{ savePath_.filePath(configFileName).toStdString(),
                        std::ios::out | std::ios::trunc };
    file << j.at(0).dump(4) << std::endl;
}

void Config::setSavePath(const QString& path)
{
    savePath_.setPath(path);
}
