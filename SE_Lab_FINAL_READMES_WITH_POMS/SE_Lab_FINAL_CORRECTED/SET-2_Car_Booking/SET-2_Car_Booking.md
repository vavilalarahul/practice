# SET-2 — Car Booking System

> **Exam order:** Maven → Git/GitHub → Docker.\
**Actual question name (short):** Car Booking
> Repository: `https://github.com/anujyog1/carrepo.git`

## PART I --- MAVEN

### 1. Clone

``` bash
git clone https://github.com/anujyog1/carrepo.git
cd carrepo
```

### 2. Resolve dependencies

Open `pom.xml` and check dependency coordinates:

``` xml
<groupId>...</groupId>
<artifactId>...</artifactId>
<version>...</version>
```

Inspect the tree:

``` bash
mvn dependency:tree
```

### 2. Check `pom.xml` — COMPLETE CORRECTED POM

**File name:** `pom.xml`  
**Set:** SET-2 — Car Booking System  
**Short question name:** Car Booking

Copy/replace the contents of the project's `pom.xml` with the following corrected code:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>SEGroup.bookcar</groupId>
    <artifactId>bcar</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>war</packaging>

    <name>bookcar Maven Webapp</name>
    <url>http://maven.apache.org</url>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>3.8.1</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <finalName>bookcar</finalName>
    </build>

</project>
```


### 3. Apply a `.patch` file before the Maven build

From the project root:

``` bash
git apply <patch-file>.patch
```

Verify:

``` bash
git diff
```

Then build:

``` bash
mvn clean package
```

### 4. Change Maven output directory

Inside `<build>`:

``` xml
<directory>build_output</directory>
```

Then:

``` bash
mvn clean package
```

The generated output is now under:

``` text
build_output/
```

### 5. Dependency conflicts

Display the full tree:

``` bash
mvn dependency:tree
```

If you need to exclude an unwanted transitive dependency:

``` xml
<exclusions>
    <exclusion>
        <groupId>...</groupId>
        <artifactId>...</artifactId>
    </exclusion>
</exclusions>
```

Then explicitly declare the version you want:

``` xml
<dependency>
    <groupId>...</groupId>
    <artifactId>...</artifactId>
    <version>...</version>
</dependency>
```

### 6. Build a WAR

``` bash
mvn clean package
```

WAR location:

``` text
target/<artifact-name>.war
```

Deploy to Tomcat by copying the WAR into Tomcat's `webapps/` directory,
then start Tomcat.

### 7. Executable JAR

Set:

``` xml
<packaging>jar</packaging>
```

For an executable JAR, configure a suitable Maven plugin such as the
Maven Shade or Spring Boot plugin depending on the project.

The project must contain a valid `main()` method.

### 8. Skip tests

``` bash
mvn package -DskipTests
```

### 9. Dependency tree

``` bash
mvn dependency:tree
```

### 10. Define Java version once

Inside `<properties>`:

``` xml
<properties>
    <java.version>17</java.version>
</properties>
```

Then reference the property where required:

``` xml
<source>${java.version}</source>
<target>${java.version}</target>
```

### 11. Servlet API scope

Use:

``` xml
<scope>provided</scope>
```

Reason: Tomcat supplies the Servlet API at runtime, so it should not be
packaged inside the WAR.

### 12. Maven local repository

Default location on Windows:

``` text
C:\Users\<username>\.m2\repository
```

If a cached dependency is corrupted, remove the affected dependency
directory and rebuild, or use:

``` bash
mvn clean
mvn package
```

------------------------------------------------------------------------

## PART II --- GIT

### 1. Initialize

``` bash
git init
git add .
git commit -m "Initial commit"
```

### 2. Configure Git and push

``` bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

git remote add origin <GITHUB_URL>
git branch -M main
git push -u origin main
```

### 3. Create and push tracking feature branch

``` bash
git switch -c feature/engine-update
git push -u origin feature/engine-update
```

### 4. Save incomplete work and handle hotfix

``` bash
git stash
git switch main
```

Fix hotfix:

``` bash
git add .
git commit -m "Fix critical bug"
git push origin main
```

Return:

``` bash
git switch feature/engine-update
git stash pop
```

### 5(a). Include forgotten file + correct previous commit message

``` bash
git add <forgotten-file>
git commit --amend --no-edit
```

### 5(b). Move uncommitted work to `feature-login`

If the changes are uncommitted and you want to create the destination
branch:

``` bash
git switch -c feature-login
```

The working changes move with you.

### 5(c). Merge conflict

``` bash
git status
```

Resolve the conflict markers in `login.jsp`, then:

``` bash
git add login.jsp
git commit -m "Resolve login merge conflict"
```

### 5(d). Discard file changes

``` bash
git restore app.js
```

### 5(e). Unstage `secret.env`

``` bash
git restore --staged secret.env
```

### 5(f). See exact changes

``` bash
git diff
```

For staged changes:

``` bash
git diff --staged
```

### 5(g). Check current branch and go to main

``` bash
git branch --show-current
git switch main
```

### 5(h). Last 4 commits

``` bash
git log --oneline -4
```

### 5(i). Get remote updates, integrate, work, push

``` bash
git fetch origin
git switch main
git merge origin/main

# make changes
git add .
git commit -m "Update project"
git push origin main
```

### 5(j). Delete local bugfix branch

``` bash
git branch -d bugfix
```

Force delete:

``` bash
git branch -D bugfix
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
docker build -t car_app .
docker run -d --name car_app_container -p 8080:8080 car_app
```

### 3. Logs + shell

``` bash
docker logs car_app_container
docker exec -it car_app_container /bin/bash
```

### 4. Clean unused Docker resources

``` bash
docker system prune
```

### 5. Redis container

``` bash
docker run -d --name my-redis redis
```

Open Redis CLI:

``` bash
docker exec -it my-redis redis-cli
```

Exit:

``` text
exit
```

### 6. Check running containers

``` bash
docker ps
```

### 7. Host 8080 → container 5000

``` bash
docker run -d --name car_app -p 8080:5000 car_app
```

### 8. Tag an existing image

``` bash
docker tag car_app <dockerhub-username>/car_app:latest
```

### 9. Push

``` bash
docker login
docker push <dockerhub-username>/car_app:latest
```

### 10. RAM limit

Example:

``` bash
docker run -d --memory="512m" --name car_app car_app
```

------------------------------------------------------------------------

# QUICK EXAM ORDER

``` bash
git clone https://github.com/anujyog1/carrepo.git
cd carrepo

mvn dependency:tree
mvn clean package

git init
git add .
git commit -m "Initial commit"
git remote add origin <URL>
git push -u origin main

docker build -t car_app .
docker run -d --name car_app_container -p 8080:8080 car_app
docker ps
docker logs car_app_container
```
