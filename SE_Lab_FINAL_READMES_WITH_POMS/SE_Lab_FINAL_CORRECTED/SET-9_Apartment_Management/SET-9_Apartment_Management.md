# SET-9 — Apartment Management System

> **Exam order:** Git/GitHub → Maven → Docker.\
**Actual question name (short):** Apartment Management
> Repository:
> `https://github.com/sarasrija/ApartmentManagementSystem.git`

## PART I --- GIT & GITHUB (40M)

### 1. Set up local codebase

``` bash
git clone https://github.com/sarasrija/ApartmentManagementSystem.git
cd ApartmentManagementSystem
```

### 2. Verify remote fetch/push connections

``` bash
git remote -v
```

### 3. Inspect staged, unstaged and untracked changes

``` bash
git status
```

### 4. Create and switch to feature branch

``` bash
git switch -c feature/tenant-registration
```

### 5. Show all branches + current branch

``` bash
git branch -a
git branch --show-current
```

### 6. Commit `TenantServlet.java`

``` bash
git add src/main/java/com/apartment/servlet/TenantServlet.java
git commit -m "Add tenant registration servlet"
```

### 7. Add forgotten `web.xml` to previous commit without changing message

``` bash
git add src/main/webapp/WEB-INF/web.xml
git commit --amend --no-edit
```

### 8. Fetch remote changes without modifying working files

``` bash
git fetch origin
```

### 9. Merge latest remote main into current branch

``` bash
git merge origin/main
```

### 10. Rebase feature onto updated main

``` bash
git rebase origin/main
```

### 11. Cancel rebase

``` bash
git rebase --abort
```

### 12. Safely undo faulty validation commit

``` bash
git revert <BAD_COMMIT_HASH>
```

### 13. Undo last commit but keep changes staged

``` bash
git reset --soft HEAD~1
```

### 14. Remove `db-config.env` from Git but keep it locally

``` bash
git rm --cached src/main/resources/db-config.env
```

Then add it to `.gitignore`.

### 15. Stash unfinished `complaints.jsp`

``` bash
git stash
```

### 16. View and restore stash

``` bash
git stash list
git stash pop
```

### 17. Compare feature and main for `index.jsp`

``` bash
git diff main...feature/tenant-registration -- src/main/webapp/index.jsp
```

### 18. Compact branch timeline

``` bash
git log --oneline --graph --decorate --all
```

### 19. Merge feature into main

``` bash
git switch main
git merge feature/tenant-registration
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

### Q1. POM validation

Run:

``` bash
mvn validate
```

If project model parsing fails, inspect the XML structure of `pom.xml`,
especially the dependency declaration and its required elements.

### Q1(b). `tomcat7:run` plugin

The paper asks for a complete corrected plugin block. Use the exact
plugin coordinates/version expected by the supplied POM/question.

Then:

``` bash
mvn tomcat7:run
```

### Q2. Database dependency resolution

Run:

``` bash
mvn dependency:tree
```

Check the MySQL dependency:

``` text
groupId
artifactId
version
```

Then:

``` bash
mvn clean compile
```

### Q2(b). Incomplete test dependency

Check the dependency in `<dependencies>` and add its missing required
element, commonly `<version>`.

Then:

``` bash
mvn test-compile
```

### Q3. Exact WAR filename

Run:

``` bash
mvn clean package
dir target
```

The filename is governed by Maven's artifact naming and any configured:

``` xml
<build>
    <finalName>...</finalName>
</build>
```

### Q3(b). Context path

Use the context path configured by the embedded web-server plugin. If no
custom context path is configured, it normally follows the deployed
application/WAR name.

### Q4. `pluginManagement` vs `plugins`

``` text
pluginManagement → provides plugin configuration/defaults.
plugins           → declares the plugin for actual build use.
```

### Q4(b). SNAPSHOT

``` xml
<version>0.0.1-SNAPSHOT</version>
```

means development snapshot.

A release such as:

``` xml
<version>0.0.1</version>
```

is treated as a released/stable artifact.

### Q5. JDK used by Maven

``` bash
mvn -version
```

### Q5(b). Clean + package + full debug output

``` bash
mvn clean package -X
```

### Q6. Install vendor JAR

The question says to use the coordinates specified in the POM.
Substitute those exact coordinates:

``` bash
mvn install:install-file -Dfile=apartment-analytics.jar -DgroupId=<groupId> -DartifactId=<artifactId> -Dversion=<version> -Dpackaging=jar
```

### Q6(b). Full dependency tree

``` bash
mvn dependency:tree
```

### Q7. Maven test output

Compiled test classes:

``` text
target/test-classes/
```

JUnit/Surefire reports:

``` text
target/surefire-reports/
```

Run only `MaintenanceBillingTest`:

``` bash
mvn -Dtest=MaintenanceBillingTest test
```

Package despite test failures:

``` bash
mvn package -DskipTests
```

### Q8. Analyze dependency usage

``` bash
mvn dependency:analyze
```

### Q8(b). `javax.servlet-api` scope

Use:

``` xml
<scope>provided</scope>
```

Tomcat provides the Servlet API at runtime.

------------------------------------------------------------------------

## PART III --- DOCKER

### 1. Download working copy + inspect

``` bash
git clone https://github.com/sarasrija/ApartmentManagementSystem.git
cd ApartmentManagementSystem
dir
```

### 2. Dockerfile

For the JAR artifact specified by the paper:

``` dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/apartment-management.jar .

CMD ["java", "-jar", "apartment-management.jar"]
```

If the project produces a WAR instead, use the appropriate Tomcat
runtime and copy the WAR to Tomcat's `webapps/`.

### 3. Build image

``` bash
docker build -t apartmentapp-image .
```

### 4. Run named container on port 8080

``` bash
docker run -d --name apartment-app-container -p 8080:8080 apartmentapp-image
```

### 5. Running containers

``` bash
docker ps
```

### 6. All containers

``` bash
docker ps -a
```

### 7. Interactive shell

``` bash
docker exec -it apartment-app-container /bin/bash
```

### 8. Stop and restart

``` bash
docker stop apartment-app-container
docker start apartment-app-container
```

### 9. Commit container state as image

``` bash
docker commit 0e993d2009a1 <dockerhub-username>/apartmentapp:v1
```

### 10. Docker Hub login

``` bash
docker login
```

### 11. Push image

``` bash
docker push <dockerhub-username>/apartmentapp:v1
```

### 12. Logout / remove stored credentials

``` bash
docker logout
```

------------------------------------------------------------------------

# QUICK EXAM ORDER

``` bash
git clone https://github.com/sarasrija/ApartmentManagementSystem.git
cd ApartmentManagementSystem

git status
git branch -a

mvn validate
mvn dependency:tree
mvn clean package

docker build -t apartmentapp-image .
docker run -d --name apartment-app-container -p 8080:8080 apartmentapp-image
docker ps
docker logs apartment-app-container
docker login
docker push <username>/apartmentapp:v1
docker logout
```


**POM FILE NOTE:** No complete/corrected `pom.xml` was supplied for this set in the source material.
