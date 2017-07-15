export CATALINA_OPTS="$CATALINA_OPTS -Xms512m"
export CATALINA_OPTS="$CATALINA_OPTS -Xmx2048m"
export MAVEN_OPTS="-Xmx512m"
export JAVA_OPTS="-Xmx512M -Xms64M -Dfile.encoding=UTF-8 -Djava.awt.headless=true -Xmx768M -XX:MaxPermSize=256M -XX:+UseParallelGC -XX:MaxGCPauseMillis=1500 -XX:GCTimeRatio=9 -server -XX:+DisableExplicitGC"

# Check for application specific parameters at startup
if [ -r "$CATALINA_BASE/bin/appenv.sh" ]; then
  . "$CATALINA_BASE/bin/appenv.sh"
fi

echo "Using CATALINA_OPTS:"
for arg in $CATALINA_OPTS
do
    echo ">> " $arg
done
echo ""

echo "Using JAVA_OPTS:"
for arg in $JAVA_OPTS
do
    echo ">> " $arg
done
echo ""

echo "Using MAVEN_OPTS:"
for arg in $MAVEN_OPTS
do
    echo ">> " $arg
done
echo "_______________________________________________"
echo ""
