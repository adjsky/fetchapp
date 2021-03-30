#include "catch.hpp"
#include "../cpp/UserManager/UserManager.hpp"

TEST_CASE("UserManager") {
    UserManager userManager{ };

    SECTION("Manager should return the same token after saving") {
        QString tokenToBeSaved{ "asd" };
        userManager.saveToken(tokenToBeSaved, true);
        const QString& token{ userManager.getToken() };
        REQUIRE(token == tokenToBeSaved);
    }

    SECTION("getToken when there's no saved token returns an empty string") {
        UserManager::remove();
        const QString& token{ userManager.getToken() };
        REQUIRE(token == "");
    }

    SECTION("Can get token from a file") {
        UserManager::remove();
        QString tokenToSave{ "asd" };
        userManager.saveToken(tokenToSave, true);
        UserManager newUserManager{};
        const QString& token{ newUserManager.getToken() };
        REQUIRE(token == tokenToSave);
    }
}
