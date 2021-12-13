The google-java-format step of `./gradlew spotlessJava` fails to pick-up the correct jvm args when combining the
`gradle.properties` file with the `GRADLE_OPTS` environment variable.

From the [Gradle docs](https://docs.gradle.org/current/userguide/build_environment.html):
> When configuring Gradle behavior you can use these methods, listed in order of highest to lowest precedence (first one wins):
> * Command-line flags such as --build-cache. These have precedence over properties and environment variables.
> * System properties such as systemProp.http.proxyHost=somehost.org stored in a gradle.properties file.
> * Gradle properties such as org.gradle.caching=true that are typically stored in a gradle.properties file in a project root directory or GRADLE_USER_HOME environment variable.
> * Environment variables such as GRADLE_OPTS sourced by the environment that executes Gradle.

Based on that, I would expect that my jvmargs added in `gradle.properties` still apply when also using `GRADLE_OPTS`
and I could confirm that this happens on compile. However somehow the formatter step drops the jvmargs from
`gradle.properties`.

### To Reproduce

Running both scripts using Java 17:

1. Just running the `spotlessJava` task picks up the jvmArgs added in `gradle.properties` and works:
    ```bash
    ./gradlew spotlessJava
    ```

2. When also adding jvmArgs through `GRADLE_OPTS` however, the jvmArgs added in `gradle.properties` are not getting picked up:
    ```bash
    GRADLE_OPTS="-Dorg.gradle.jvmargs='-Xmx1g'" ./gradlew spotlessJava
    ```
    This fails with:
    ```
    Execution failed for task ':spotlessJava'.
    > java.lang.reflect.InvocationTargetException
    ```

See `works.sh` and `fails.sh`.
