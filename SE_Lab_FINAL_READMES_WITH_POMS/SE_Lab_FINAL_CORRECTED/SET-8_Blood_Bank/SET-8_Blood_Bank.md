# SET-8 — Blood Bank Management System

> **Exam order:** Git/GitHub → Maven → Docker.\
**Actual question name (short):** Blood Bank
> Repository:
> `https://github.com/sarasrija/Blood-Bank-Management-system.git`

## PART I --- GIT & GITHUB (40M)

### 1. Clone

``` bash
git clone https://github.com/sarasrija/Blood-Bank-Management-system.git
cd Blood-Bank-Management-system
```

### 2. Verify remote

``` bash
git remote -v
```

### 3. Inspect changes

``` bash
git status
```

### 4. Create/switch feature branch

``` bash
git switch -c feature/donor-registration
```

### 5. Branch list + current branch

``` bash
git branch -a
git branch --show-current
```

### 6. Commit `DonorServlet.java`

``` bash
git add src/main/java/com/bloodbank/servlet/DonorServlet.java
git commit -m "Add donor registration servlet"
```

### 7. Add forgotten `web.xml` to previous commit

``` bash
git add src/main/webapp/WEB-INF/web.xml
git commit --amend --no-edit
```

### 8. Fetch without changing working files

``` bash
git fetch origin
```

### 9. Merge latest main into current branch

``` bash
git merge origin/main
```

### 10. Rebase feature onto updated main

``` bash
git rebase origin/main
```

### 11. Abort rebase

``` bash
git rebase --abort
```

### 12. Revert bad test commit

``` bash
git revert <BAD_COMMIT_HASH>
```

### 13. Undo last commit but keep changes staged

``` bash
git reset --soft HEAD~1
```

### 14. Remove `db-config.env` from Git but keep file

``` bash
git rm --cached src/main/resources/db-config.env
```

### 15. Stash unfinished `inventory.jsp`

``` bash
git stash
```

### 16. List and restore stash

``` bash
git stash list
git stash pop
```

### 17. Compare feature and main `index.jsp`

``` bash
git diff main...feature/donor-registration -- src/main/webapp/index.jsp
```

### 18. Graphical compact log

``` bash
git log --oneline --graph --decorate --all
```

### 19. Merge feature into main

``` bash
git switch main
git merge feature/donor-registration
```

### 20. Push and verify same commit

``` bash
git push origin main
git fetch origin
git rev-parse HEAD
git rev-parse origin/main
```

------------------------------------------------------------------------

## PART II --- MAVEN

### 1. Validate POM



### 1. Check `pom.xml` — COMPLETE CORRECTED POM

**File name:** `pom.xml`  
**Set:** SET-8 — Blood Bank Management System  
**Short question name:** Blood Bank

Copy/replace the contents of the project's `pom.xml` with the following corrected code:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.bloodbank</groupId>
    <artifactId>BloodBankManagementSystem</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>

    <name>Blood Bank Management System</name>

    <dependencies>

        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>4.0.1</version>
            <scope>provided</scope>
        </dependency>

        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.33</version>
        </dependency>

        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>

    </dependencies>

    <build>
        <finalName>BloodBankManagementSystem</finalName>

        <plugins>
            <plugin>
                <groupId>org.apache.tomcat.maven</groupId>
                <artifactId>tomcat7-maven-plugin</artifactId>
                <version>2.2</version>
                <configuration>
                    <path>/</path>
                    <port>8080</port>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>
```

``` bash
mvn validate
```

Fix malformed XML/dependency configuration in `pom.xml`.

### 2. Run Tomcat plugin

The question asks for a corrected `tomcat7:run` plugin block. Use the
exact coordinates/version supplied or expected by the provided
POM/question.

Then:

``` bash
mvn tomcat7:run
```

### 3. MySQL dependency resolution

Inspect:

``` bash
mvn dependency:tree
```

Fix:

``` text
groupId
artifactId
version
```

Then:

``` bash
mvn clean compile
```

### 4. Test dependency

Ensure the required dependency element(s), especially `<version>`, are
present.

``` bash
mvn test-compile
```

### 5. WAR filename

Check:

``` bash
mvn clean package
dir target
```

The exact filename depends on `artifactId`, `version`, and any
`<finalName>` in the POM.

### 6. Context path

Use the context path defined by the embedded web-server plugin
configuration. If no custom context is configured, it generally follows
the deployed application/WAR name.

### 7. `pluginManagement` vs `plugins`

``` text
pluginManagement → configuration/defaults only until plugin is declared under plugins.
plugins           → activates the plugin for the build.
```

### 8. SNAPSHOT

``` text
0.0.1-SNAPSHOT → development snapshot
0.0.1          → release version
```

### 9. Maven JDK

``` bash
mvn -version
```

### 10. Clean + package + debug

``` bash
mvn clean package -X
```

### 11. Install vendor JAR

Use the exact coordinates specified in the POM:

``` bash
mvn install:install-file -Dfile=blood-analytics.jar -DgroupId=<groupId> -DartifactId=<artifactId> -Dversion=<version> -Dpackaging=jar
```

### 12. Dependency tree

``` bash
mvn dependency:tree
```

### 13. Test paths

``` text
target/test-classes/
target/surefire-reports/
```

### 14. Run `BloodInventoryTest`

``` bash
mvn -Dtest=BloodInventoryTest test
```

### 15. Package despite test failures

``` bash
mvn package -DskipTests
```

### 16. Analyze unused dependencies

``` bash
mvn dependency:analyze
```

### 17. Servlet API scope

``` xml
<scope>provided</scope>
```

------------------------------------------------------------------------

## PART III --- DOCKER

### 1. Clone / inspect

``` bash
git clone https://github.com/sarasrija/Blood-Bank-Management-system.git
cd Blood-Bank-Management-system
dir
```

### 2. Dockerfile

For the JAR path named in the question:

``` dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/Blood-managent.jar .

CMD ["java", "-jar", "Blood-managent.jar"]
```

If the generated artifact is actually a WAR, use a Tomcat runtime and
copy the WAR into Tomcat's `webapps/`.

### 3. Build image

``` bash
docker build -t Bloodbankapp-image .
```

### 4. Run container

``` bash
docker run -d --name Bloodbank-app-container -p 8080:8080 Bloodbankapp-image
```

### 5. Running containers

``` bash
docker ps
```

### 6. All containers

``` bash
docker ps -a
```

### 7. Enter container

``` bash
docker exec -it Bloodbank-app-container /bin/bash
```

### 8. Stop and restart

``` bash
docker stop Bloodbank-app-container
docker start Bloodbank-app-container
```

### 9. Commit container as new image

``` bash
docker commit 0e993d2009a1 <dockerhub-username>/Bloodbankapp:v1
```

### 10. Login

``` bash
docker login
```

### 11. Push

``` bash
docker push <dockerhub-username>/Bloodbankapp:v1
```

### 12. Logout

``` bash
docker logout
```

------------------------------------------------------------------------

# QUICK EXAM ORDER

``` bash
git clone https://github.com/sarasrija/Blood-Bank-Management-system.git
cd Blood-Bank-Management-system

git status
git branch -a

mvn validate
mvn dependency:tree
mvn clean package

docker build -t Bloodbankapp-image .
docker run -d --name Bloodbank-app-container -p 8080:8080 Bloodbankapp-image
docker ps
docker logs Bloodbank-app-container
```
