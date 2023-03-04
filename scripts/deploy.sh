#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=Test01-Springboot

echo "> copy build-file"
cp $REPOSITORY/zip/*.jar $REPOSITORY

echo "> check app id"
CURRENT_PID=$(pgrep -fl ${PROJECT_NAME}*.jar | grep jar | awk '{print $1}')
echo "> current pid is $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
	echo "> There are no running app"
else
	echo "> kill -15 $CURRENT_PID"
	kill -15 $CURRENT_PID
	sleep 5
fi

echo "> deploy new application"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)
echo "> JAR NAME: $JAR_NAME"

echo "> add new 실행권한"
chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

nohup java -jar \
	-Dspring.config.location=classpath:/application.properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties \
	-Dspring.profiles.active=real \
	$JAR_NAME > $REPOSITORY/nohup.out 2>&1 &
