"""
Mobile target-environment guard — DEV BRANCH VERSION (FKSS Beta).

On `dev` this pins the BETA target (felegekidusan.arkeonethiopia.com,
com.arkeonethiopia.fkss.beta, "FKSS Beta"). The `main` version of this file
pins production, so merging dev into main conflicts here on purpose.

`main` (production for BOTH remotes) must always build the PRODUCTION app:
felegekidusan.com API, package com.arkeonethiopia.fkss, label "FKSS".
The FKSS Beta build lives ONLY on the `dev` branch of suraman21/SSMS
(owner rule 2026-10-20: beta settings must never sync to the production
repo). If a dev-branch commit is ever merged into main, this test fails
before any APK can be built.
"""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
M = ROOT / "Mobile/wbws_flutter_app"

BETA_API = "https://felegekidusan.arkeonethiopia.com/api/v1"
BETA_PACKAGE = "com.arkeonethiopia.fkss.beta"


def read(rel):
    return (M / rel).read_text(encoding="utf-8")


class MobileTargetEnvironmentGuard(unittest.TestCase):
    def test_beta_api_and_identity(self):
        config = read("lib/utils/config.dart")
        self.assertIn(f"static const String apiBaseUrl = '{BETA_API}';", config)
        self.assertIn("static const String appName = 'FKSS Beta';", config)
        self.assertIn("static const bool isBeta = true;", config)
        self.assertNotIn("'https://felegekidusan.com/api/v1'", config)
        gradle = read("android/app/build.gradle")
        self.assertIn(f'applicationId = "{BETA_PACKAGE}"', gradle)
        manifest = read("android/app/src/main/AndroidManifest.xml")
        self.assertIn('android:label="FKSS Beta"', manifest)
        for rel in ("android/app/src/main/res/xml/network_security_config.xml",
                    "android/app/src/debug/res/xml/network_security_config.xml"):
            self.assertIn('<domain includeSubdomains="true">arkeonethiopia.com</domain>', read(rel))
        self.assertIn("AppConfig.isBeta", read("lib/screens/auth/login_screen.dart"))


if __name__ == "__main__":
    unittest.main()
