#ifndef CONFIG_HPP
#define CONFIG_HPP

#include <QObject>
#include <QDir>
#include "../Utility/json.hpp"

using nlohmann::json;

namespace serializable
{
struct ConfigData
{
    Q_GADGET
    Q_PROPERTY(QString language MEMBER language)
public:
    QString language;

    bool operator!=(const ConfigData& other)
    {
        return other.language != language;
    }
};

void to_json(json& j, const ConfigData& cfg);

void from_json(const json& j, ConfigData& cfg);
}

class Config : public QObject
{
    Q_OBJECT
    Q_PROPERTY(serializable::ConfigData settings MEMBER data_)
public:
    Config();
    ~Config();

    void load();
    void save();
    void setSavePath(const QString& path);

private:
    serializable::ConfigData data_;
    QDir savePath_;
};

#endif // CONFIG_HPP
