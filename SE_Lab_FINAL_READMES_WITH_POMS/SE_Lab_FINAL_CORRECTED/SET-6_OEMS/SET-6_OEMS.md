# SET-6 — Online Event Management System (OEMS)

> **Exam order:** Maven → Git/GitHub → Docker.\
**Actual question name (short):** OEMS
> Repository: `https://github.com/haleema91/Internal-1-OEMS.git`

## PART I --- MAVEN WEB APPLICATION

### 1. Clone

``` bash
git clone https://github.com/haleema91/Internal-1-OEMS.git
cd Internal-1-OEMS
```

### 2. Inspect/fix `pom.xml`

Check:

``` text
groupId
artifactId
version
packaging
Servlet API dependency
JSTL dependency
Maven Compiler Plugin
plugin versions/configuration
```


### 2. Check `pom.xml` — COMPLETE CORRECTED POM

**File name:** `pom.xml`  
**Set:** SET-6 — Online Event Management System (OEMS)  
**Short question name:** OEMS

Copy/replace the contents of the project's `pom.xml` with the following corrected code:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>kmitlab1</groupId>
    <artifactId>LOEMS-WEB</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>war</packaging>

    <name>OEMS Maven Webapp</name>
    <url>http://www.example.com</url>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <finalName>OEMS</finalName>

        <pluginManagement>
            <plugins>
                <plugin>
                    <artifactId>maven-clean-plugin</artifactId>
                    <version>3.4.0</version>
                </plugin>
                <plugin>
                    <artifactId>maven-resources-plugin</artifactId>
                    <version>3.3.1</version>
                </plugin>
                <plugin>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.13.0</version>
                </plugin>
                <plugin>
                    <artifactId>maven-surefire-plugin</artifactId>
                    <version>3.3.0</version>
                </plugin>
                <plugin>
                    <artifactId>maven-war-plugin</artifactId>
                    <version>3.4.0</version>
                </plugin>
                <plugin>
                    <artifactId>maven-install-plugin</artifactId>
                    <version>3.1.2</version>
                </plugin>
                <plugin>
                    <artifactId>maven-deploy-plugin</artifactId>
                    <version>3.1.2</version>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>

</project>
```


### 3. Generate WAR

``` bash
mvn clean package
```

Verify:

``` bash
dir target
```

The WAR should be under:

``` text
target/
```

### 4. Tomcat requires WAR

Use:

``` xml
<packaging>war</packaging>
```

### 5. Servlet API + JSTL

Add the dependencies required by the project's Java/Tomcat version.
Then:

``` bash
mvn dependency:tree
mvn clean package
```

### 6. Configure Java version with Maven Compiler Plugin

For Java 17:

``` xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
</properties>
```

or configure the Maven Compiler Plugin explicitly.

Check:

``` bash
java -version
javac -version
mvn -version
```

### 7. Port 8080 already in use

Windows:

``` bash
netstat -ano | findstr :8080
```

Then identify the process:

``` bash
tasklist | findstr <PID>
```

Either stop the process if appropriate, or change Tomcat's connector
port.

### 8. Clean old artifacts

``` bash
mvn clean
mvn package
```

### 9. Project requires Java 17 but machine has Java 21

First inspect Maven's JDK:

``` bash
mvn -version
```

Then configure Maven/compiler for Java 17 and ensure a Java 17 JDK is
installed and selected.

Rebuild:

``` bash
mvn clean package
```

### 10. Push project

``` bash
git init
git add .
git commit -m "Initial commit"
git remote add origin <GITHUB_URL>
git branch -M main
git push -u origin main
```

------------------------------------------------------------------------

## PART II --- GIT

### 1. Initialize and first commit

``` bash
git init
git add .
git commit -m "Initial commit"
```

### 2. Inspect `Event.java` + `Registration.java`

``` bash
git status
git diff
```

### 3. Create registration branch

``` bash
git switch -c registration
```

### 4. Merge registration into main

``` bash
git switch main
git merge registration
```

Push:

``` bash
git push origin main
```

### 5. Resolve merge conflict

``` bash
git status
```

Open `Registration.java`, resolve conflict markers, then:

``` bash
git add Registration.java
git commit -m "Resolve registration merge conflict"
```

Push:

``` bash
git push origin main
```

### 6. Create patch from Event.java

``` bash
git diff Event.java > event-availability.patch
```

### 7. Apply patch

``` bash
git apply event-availability.patch
```

Check:

``` bash
git diff
```

### 8. Revert bad pushed commit

``` bash
git revert <BAD_COMMIT_HASH>
git push origin main
```

### 9. Discard uncommitted `EventServlet.java`

``` bash
git restore EventServlet.java
```

### 10. Unstage `Registration.java`

``` bash
git restore --staged Registration.java
```

### 11. Update registration branch from main

``` bash
git fetch origin
git switch registration
git rebase origin/main
```

### 12. Switch to main

``` bash
git switch main
```

------------------------------------------------------------------------

## PART III --- DOCKER

### 1. Dockerfile

``` dockerfile
FROM tomcat:9

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

### 2. Build and run on host port 7070

``` bash
docker build -t oems-web .
docker run -d --name oems-container -p 7070:8080 oems-web
```

Browser:

``` text
http://localhost:7070
```

### 3. Enter container

``` bash
docker exec -it oems-container /bin/bash
```

Check WAR:

``` bash
ls /usr/local/tomcat/webapps
```

### 4. Logs

``` bash
docker logs oems-container
```

### 5. Run in background

``` bash
docker run -d --name oems-container -p 7070:8080 oems-web
```

### 6. Ubuntu + Git

Pull:

``` bash
docker pull ubuntu
```

Run:

``` bash
docker run -it ubuntu
```

Inside Ubuntu:

``` bash
apt update
apt install git -y
git --version
git status
```

Exit:

``` text
exit
```

### 7. Tag and push

``` bash
docker login
docker tag oems-web <dockerhub-username>/oems-web:latest
docker push <dockerhub-username>/oems-web:latest
```

------------------------------------------------------------------------

# QUICK EXAM ORDER

``` bash
git clone https://github.com/haleema91/Internal-1-OEMS.git
cd Internal-1-OEMS

mvn clean package
dir target

git init
git add .
git commit -m "Initial commit"
git remote add origin <URL>
git push -u origin main

docker build -t oems-web .
docker run -d --name oems-container -p 7070:8080 oems-web
docker ps
docker logs oems-container
```
