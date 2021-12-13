Combining jvm args added through the `gradle.properties` file and the `GRADLE_OPTS` environment variable results in the
jvm args declared in `gradle.properties` getting ignored.

From the [Gradle docs](https://docs.gradle.org/current/userguide/build_environment.html):
> When configuring Gradle behavior you can use these methods, listed in order of highest to lowest precedence (first one wins):
> * Command-line flags such as --build-cache. These have precedence over properties and environment variables.
> * System properties such as systemProp.http.proxyHost=somehost.org stored in a gradle.properties file.
> * Gradle properties such as org.gradle.caching=true that are typically stored in a gradle.properties file in a project root directory or GRADLE_USER_HOME environment variable.
> * Environment variables such as GRADLE_OPTS sourced by the environment that executes Gradle.

Based on that, I would expect that my jvm args added in `gradle.properties` still apply when also using `GRADLE_OPTS`.
However, it looks like that jvm args added in `gradle.properties` get dropped when also supplying args through `GADLE_OPTS`.

### To Reproduce

Running both scripts using Java 17:

1. Just running the `printArgs` task picks up the jvmArgs added in `gradle.properties`:
    ```bash
   ./gradlew printArgs          
   > Task :printArgs
   Args: [
      --add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED,
      --add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED,
      --add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED,
      --add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED,
      --add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED,
      --add-opens=java.base/java.util=ALL-UNNAMED,
      --add-opens=java.base/java.lang=ALL-UNNAMED,
      --add-opens=java.base/java.lang.invoke=ALL-UNNAMED,
      --add-opens=java.base/java.util=ALL-UNNAMED,
      --add-opens=java.prefs/java.util.prefs=ALL-UNNAMED,
      --add-opens=java.prefs/java.util.prefs=ALL-UNNAMED,
      --add-opens=java.base/java.nio.charset=ALL-UNNAMED,
      --add-opens=java.base/java.net=ALL-UNNAMED,
      --add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED,
      -Dfile.encoding=UTF-8, -Duser.country=US, -Duser.language=en, -Duser.variant
    ]
    ```

2. When also adding jvmArgs through `GRADLE_OPTS` however, the jvmArgs added in `gradle.properties` are not getting picked up:
    ```bash
   GRADLE_OPTS="-Dorg.gradle.jvmargs='-Xmx1g'" ./gradlew printArgs
   > Task :printArgs
   Args: [
      --add-opens=java.base/java.util=ALL-UNNAMED,
      --add-opens=java.base/java.lang=ALL-UNNAMED,
      --add-opens=java.base/java.lang.invoke=ALL-UNNAMED,
      --add-opens=java.base/java.util=ALL-UNNAMED,
      --add-opens=java.prefs/java.util.prefs=ALL-UNNAMED,
      --add-opens=java.prefs/java.util.prefs=ALL-UNNAMED,
      --add-opens=java.base/java.nio.charset=ALL-UNNAMED,
      --add-opens=java.base/java.net=ALL-UNNAMED,
      --add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED,
      -Xmx1g,
      -Dfile.encoding=UTF-8, -Duser.country=US, -Duser.language=en, -Duser.variant]
    ```
