import com.android.build.api.dsl.ApplicationExtension

val appName = "Gse Base App"

configure<ApplicationExtension> {
    flavorDimensions += "environment"

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = ".dev"
            manifestPlaceholders["appName"] = "[DEV] $appName"
        }

        create("stg") {
            dimension = "environment"
            applicationIdSuffix = ".stg"
            versionNameSuffix = ".stg"
            manifestPlaceholders["appName"] = "[STG] $appName"
        }

        create("prod") {
            dimension = "environment"
            manifestPlaceholders["appName"] = appName
        }

    }
}
