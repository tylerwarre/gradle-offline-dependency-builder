# Instructions
1. Run `discover_dependencies.sh` from a system with an internet conneciton
2. Run `prep_maven_repo.sh` on the offline system where you want the repo to be created
3. Run `get_libs.sh` from a system with an internet connection
4. Update `settings.gradle` with the following settings. Update the `file://` url to reflect your directory
```
...
pluginManagement {
    repositories {
        maven {
            url 'file:///tmp/gradle-test/mavenLocal'
        }
        gradlePluginPortal()
    }
}
...
```
5. Update `build.gradle` with the following settings. Update the `file://` url to reflect your directory
```
...
repositories {
    // Use Maven Central for resolving dependencies.
    /*maven {
        url 'file:///tmp/gradle-test/mavenLocal'
    }*/
    mavenCentral()
}
...
```
