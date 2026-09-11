# SET-3 — Train Booking System

> **Exam order:** Maven → Git/GitHub → Docker.\
**Actual question name (short):** Train Booking
> Repository: `https://github.com/anujyog1/trainrepo.git`

## PART I --- MAVEN

### 1. Clone

``` bash
git clone https://github.com/anujyog1/trainrepo.git
cd trainrepo
```

### 2. Resolve dependencies

Check:

``` text
pom.xml
```

### 2. Check `pom.xml` — COMPLETE CORRECTED POM

**File name:** `pom.xml`  
**Set:** SET-3 — Train Booking System  
**Short question name:** Train Booking

Copy/replace the contents of the project's `pom.xml` with the following corrected code:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>SEGroup</groupId>
    <artifactId>booktrain</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>war</packaging>

    <name>booktrain Maven Webapp</name>
    <url>http://www.example.com</url>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>18</maven.compiler.source>
        <maven.compiler.target>18</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>3.8.1</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <finalName>booktrain</finalName>

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

Then:

``` bash
mvn dependency:tree
```

### 3. First Maven build after cloning

``` bash
mvn test
```

This compiles the source and runs unit tests.

### 4. Clean generated artifacts

``` bash
mvn clean
```

### 5. Package and install locally

``` bash
mvn clean install
```

### 6. Verify generated artifact

``` bash
dir target
```

Typical locations:

``` text
target/classes/
target/test-classes/
target/<artifact>.jar
target/<artifact>.war
```

### 7. Skip tests

``` bash
mvn package -DskipTests
```

### 8. Generate Maven site report

The standard command is:

``` bash
mvn site
```

The generated site is normally under:

``` text
target/site/
```

Coverage/dependency reports depend on the reporting plugins configured
in the POM.

### 9. JUnit test

Place test classes under:

``` text
src/test/java/
```

Run:

``` bash
mvn test
```

Compiled tests:

``` text
target/test-classes/
```

Surefire reports:

``` text
target/surefire-reports/
```

Run one test class:

``` bash
mvn -Dtest=TestClassName test
```

### 10. Rerun only failed tests

A simple approach is to inspect:

``` text
target/surefire-reports/
```

and run the failed test class directly:

``` bash
mvn -Dtest=FailedTestClass test
```

### 11. Install a custom third-party JAR

Use the coordinates required by the POM:

``` bash
mvn install:install-file -Dfile=<library.jar> -DgroupId=<groupId> -DartifactId=<artifactId> -Dversion=<version> -Dpackaging=jar
```

Then add the same coordinates to `pom.xml`.

Confirm:

``` bash
mvn dependency:tree
mvn clean package
```

### 12. Missing dependency

Check dependencies in:

``` text
pom.xml
```

Then:

``` bash
mvn dependency:tree
mvn clean compile
```

------------------------------------------------------------------------

## PART II --- GIT

### 1. Initialize and add Maven project

``` bash
git init
git add .
git commit -m "Initial commit"
```

### 2. Global configuration + push

``` bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

git remote add origin <GITHUB_URL>
git branch -M main
git push -u origin main
```

### 3(a). Pause feature → hotfix main → resume feature

``` bash
git stash
git switch main

# create hotfix
git add .
git commit -m "Fix hot issue"
git push origin main

git switch <feature-branch>
git stash pop
```

### 3(b). Merge conflict in `routes.json`

``` bash
git status
```

Open `routes.json` and keep both required arrival and departure changes.

``` bash
git add routes.json
git commit -m "Resolve route timing conflict"
```

### 3(c/d). Fetch remote main, merge, work, push

``` bash
git fetch origin
git switch main
git merge origin/main

# make changes
git add .
git commit -m "Update train project"
git push origin main
```

### 3(e). Rebase local commit on remote main

``` bash
git fetch origin
git rebase origin/main
git push --force-with-lease origin main
```

### 3(f). Add forgotten file to previous commit

``` bash
git add booking_controller.js
git commit --amend --no-edit
```

### 3(g). Discard changes to `train_schedules.json`

``` bash
git restore train_schedules.json
```

### 3(h). Move uncommitted work to new feature branch

``` bash
git switch -c feature-train-search
```

### 3(i). Last 5 commits, one line each

``` bash
git log --oneline -5
```

### 3(j). Download all remote updates without merging

``` bash
git fetch --all --tags
```

### 3(k). Use another developer's private project

If you have permission, obtain access and clone using the repository
URL:

``` bash
git clone <PRIVATE_REPOSITORY_URL>
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

### 2. Build and run

``` bash
docker build -t train-app .
docker run -d --name train-app -p 8080:8080 train-app
```

### 3. Diagnose crashed container

``` bash
docker ps -a
docker logs train-app
```

### 4. Temporary Ubuntu command without leaving a stopped container

Use:

``` bash
docker run --rm -it ubuntu bash
```

### 5. Logs of stopped container

``` bash
docker logs <container-name-or-id>
```

### 6. Host port 80 → container port 8082

``` bash
docker run -d --name train-app -p 80:8082 train-app
```

### 7. Background container

``` bash
docker run -d --name train-app train-app
```

### 8. Find container using port 3000

First inspect published ports:

``` bash
docker ps
```

For all containers:

``` bash
docker ps -a
```

### 9. Tag image

``` bash
docker tag my-api <dockerhub-username>/my-api:latest
```

### 10. Updated code → rebuild image

``` bash
docker build -t my-api .
docker stop my-api-container
docker rm my-api-container
docker run -d --name my-api-container -p 8080:8080 my-api
```

------------------------------------------------------------------------

# QUICK EXAM ORDER

``` bash
git clone https://github.com/anujyog1/trainrepo.git
cd trainrepo

mvn test
mvn clean
mvn clean install
dir target

git init
git add .
git commit -m "Initial commit"
git remote add origin <URL>
git push -u origin main

docker build -t train-app .
docker run -d --name train-app -p 8080:8080 train-app
docker ps
docker logs train-app
```
