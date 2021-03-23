#include "catch.hpp"
#include "../cpp/TokenManager/tokenmanager.hpp"

TEST_CASE("TokenManager") {
    TokenManager tokenManager{ };

    SECTION("Manager should return the same token after saving") {
        QString tokenToBeSaved{ "asd" };
        tokenManager.saveToken(tokenToBeSaved, true);
        const QString& token{ tokenManager.getToken() };
        REQUIRE(token == tokenToBeSaved);
    }

    SECTION("getToken when there's no saved token returns an empty string") {
        TokenManager::remove();
        const QString& token{ tokenManager.getToken() };
        REQUIRE(token == "");
    }

    SECTION("Can get token from a file") {
        TokenManager::remove();
        QString tokenToSave{ "asd" };
        tokenManager.saveToken(tokenToSave, true);
        TokenManager newTokenManager{};
        const QString& token{ newTokenManager.getToken() };
        REQUIRE(token == tokenToSave);
    }
}
