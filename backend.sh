#Backend service is responsible for adding the given values to database. Backend service is written in NodeJS, Hence we need to install NodeJS.

#HINT
#Developer has chosen NodeJs, Check with developer which version of NodeJS is needed. Developer has set a context that it can work with NodeJS >20

#Install NodeJS, By default NodeJS 16 is available, We would like to enable 20 version and install this.

#HINT
#You can list modules by using dnf module list
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y

#Configure the application.

#INFO
#Our application developed by the developer of our org and it is not having any RPM software just like other softwares. So we need to configure every step manually

#RECAP
#We already discussed in Linux basics section that applications should run as nonroot user.

#Add application User
useradd expense

#INFO
#User expense is a function / daemon user to run the application. Apart from that we dont use this user to login to server.

#Also, username expense has been picked because it more suits to our project name.

#INFO
#We keep application in one standard location. This is a usual practice that runs in the organization.
#Lets setup an app directory.
mkdir /app
#Download the application code to created app directory.
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip
cd /app
unzip /tmp/backend.zip
#Every application is developed by development team will have some common softwares that they use as libraries. This application also have the same way of defined dependencies in the application configuration.
#Lets download the dependencies.
cd /app
npm install

#We need to setup a new service in systemd so systemctl can manage this service

#INFO
#We already discussed in linux basics that advantages of systemctl managing services, Hence we are taking that approach. Which is also a standard way in the OS.

#Setup SystemD Expense Backend Service

/etc/systemd/system/backend.service
[Unit]
Description = Backend Service

[Service]
User=expense
Environment=DB_HOST="<MYSQL-SERVER-IPADDRESS>"
ExecStart=/bin/node /app/index.js
SyslogIdentifier=backend

[Install]
WantedBy=multi-user.target

#INFO
#Hint! You can create file by using vim /etc/systemd/system/backend.service

#NOTE
#Ensure you replace <MYSQL-SERVER-IPADDRESS> with IP address

#Load the service.
systemctl daemon-reload

#INFO
#This above command is because we added a new service, We are telling systemd to reload so it will detect new service.

#Start the service.
systemctl enable backend
systemctl start backend

#For this application to work fully functional we need to load schema to the Database.

#INFO
#Schemas are usually part of application code and developer will provide them as part of development.

#We need to load the schema. To load schema we need to install mysql client.

#To have it installed we can use
dnf install mysql -y

#Load Schema

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql



