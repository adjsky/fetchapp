#include <fstream>
#include <QDebug>

#include "Config.hpp"

const char* config_path{ "config.json" };

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
    data_{ }
{
    std::ifstream file{ config_path };
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

Config::~Config()
{
    save();
}

void Config::save()
{
    json j{ data_ };
    std::ofstream file{ config_path, std::ios::out | std::ios::trunc };
    file << j.at(0).dump(4) << std::endl;
}
