#include "catch.hpp"
#include "../cpp/TokenManager/tokenmanager.hpp"

TEST_CASE("TokenManager") {
    TokenManager tokenManager{ };

    SECTION("Manager returns the same token after saving") {
        QString tokenToBeSaved{ "asd" };
        tokenManager.saveToken(tokenToBeSaved);
        const QString& token{ tokenManager.getToken() };
        REQUIRE(token == tokenToBeSaved);
        TokenManager::remove();
    }

    SECTION("Getting token when there's no saved token returns empty string") {
        TokenManager::remove();
        const QString& token{ tokenManager.getToken() };
        REQUIRE(token == "");
    }

    SECTION("Can get token from file") {
        TokenManager::remove();
        QString tokenToSave{ "asd" };
        tokenManager.saveToken(tokenToSave);
        TokenManager newTokenManager{};
        const QString& token{ newTokenManager.getToken() };
        REQUIRE(token == tokenToSave);
    }
}
