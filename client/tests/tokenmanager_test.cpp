#include "catch.hpp"
#include "../cpp/TokenManager/tokenmanager.hpp"

TEST_CASE("TokenManager") {
    TokenManager tokenManager{ TokenManager{} };

    SECTION("Can get token after saving") {
        QString tokenToBeSaved{ "asd" };
        tokenManager.saveToken(tokenToBeSaved);
        const QString& token{ tokenManager.getToken() };
        REQUIRE(token == tokenToBeSaved);
    }
}
