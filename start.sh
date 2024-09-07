#!/bin/bash

if type -p java; then
    echo "found java executable in PATH"
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    echo "found java executable in JAVA_HOME"     
    _java="$JAVA_HOME/bin/java"
else
    echo "ERROR: No Java executable was found"
    exit 1
fi

if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "version: $version"
    if [[ "$version" < "1.8" ]]; then
        echo "Java version is less than 1.8"
        exit 1
    fi
fi

if ! [ -f "spigot-1.20.6.jar" ]; then
    "$_java" -jar BuildTools.jar &
    wait $!
fi

java -Xmx4G -XX:+UseG1GC -jar spigot-1.20.6.jar nogui
