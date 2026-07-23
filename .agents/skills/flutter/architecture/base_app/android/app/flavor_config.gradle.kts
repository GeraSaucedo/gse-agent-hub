import com.android.build.api.dsl.ApplicationExtension

val appName = "Gse Base App"

configure<ApplicationExtension> {
    flavorDimensions += "environment"

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = ".dev"
            resValue("string", "app_name", "[DEV] $appName")
        }

        create("stg") {
            dimension = "environment"
            applicationIdSuffix = ".stg"
            versionNameSuffix = ".stg"
            resValue("string", "app_name", "[STG] $appName")
        }

        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", appName)
        }

    }
}
